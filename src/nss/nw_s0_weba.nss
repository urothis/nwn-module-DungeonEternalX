//::///////////////////////////////////////////////
//:: Web: On Enter
//:: NW_S0_WebA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creates a mass of sticky webs that cling to
   and entangle targets who fail a Reflex Save
   Those caught can make a new save every
   round.  Movement in the web is 1/5 normal.
   The higher the creatures Strength the faster
   they move within the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "pure_caster_inc"

void main() {

   //Declare major variables
   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   effect eWeb = EffectEntangle();
   effect eVis = EffectVisualEffect(VFX_DUR_WEB);
   effect eLink = EffectLinkEffects(eWeb, eVis);
   object oTarget = GetEnteringObject();
   if (GetHasSpellEffect(SPELL_WEB, oTarget)) return;
   effect eSlow = EffectMovementSpeedDecrease(GetSlowRate(oTarget));

   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
   {
      if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL)!= TRUE))
      {
         SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WEB));
         if (!MyResistSpell(oCaster, oTarget))
         {
            if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_NONE, oCaster))
            {
               //Entangle effect and Web VFX impact
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
            }
            //Slow down the creature within the Web
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(1));
         }
      }
   }
}

//::///////////////////////////////////////////////
//:: Web: Heartbeat
//:: NW_S0_WebC.nss
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

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "_functions"

void main() {

   object oCaster = GetAreaOfEffectCreator();
   if (!GetIsObjectValid(oCaster)) { // CASTER GONE, KILL AOE
      Insured_Destroy(OBJECT_SELF);
      return;
   }

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   effect eWeb = EffectEntangle();
   effect eVis = EffectVisualEffect(VFX_DUR_WEB);
   object oTarget;
   //Spell resistance check
   oTarget = GetFirstInPersistentObject();
   while(GetIsObjectValid(oTarget))
   {
      if (!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL)!=TRUE))
      {
         if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
         {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WEB));
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WEB));
            if (!MyResistSpell(oCaster, oTarget))
            {
               if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_NONE, oCaster))
               {
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeb, oTarget, 6.0);
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0);
               }
            }
         }
      }
      oTarget = GetNextInPersistentObject();
   }
}

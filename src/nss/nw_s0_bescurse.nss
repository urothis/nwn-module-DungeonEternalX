//::///////////////////////////////////////////////
//:: Bestow Curse
//:: NW_S0_BesCurse.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Afflicted creature must save or suffer a -2 penalty
   to all ability scores. This is a supernatural effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Bob McCabe
//:: Created On: March 6, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 20, 2001

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   int nAmount = 2 + nPureBonus/2;
   object oTarget = GetSpellTargetObject();
   effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
   effect eCurse = EffectCurse(nAmount, nAmount, nAmount, nAmount, nAmount, nAmount);

   //Make sure that curse is of type supernatural not magical
   eCurse = SupernaturalEffect(eCurse);
   if (!GetIsReactionTypeFriendly(oTarget))
   {
      //Signal spell cast at event
      SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_BESTOW_CURSE));
      //Make SR Check
      if (!MyResistSpell(OBJECT_SELF, oTarget))
      {
         if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC))
         {
            //Apply Effect and VFX
            if (GetIsEncounterCreature(OBJECT_SELF)) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurse, oTarget, RoundsToSeconds(2));
            else ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         }
      }
   }
}

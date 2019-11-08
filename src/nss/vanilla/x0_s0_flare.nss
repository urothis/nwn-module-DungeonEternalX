//::///////////////////////////////////////////////
//:: Flare
//:: [X0_S0_Flare.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature hit by ray loses 1 to attack rolls.

    DURATION: 10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;


   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nCasterLevel = GetCasterLevel(OBJECT_SELF);
   effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
   if (!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 416));
      // * Apply the hit effect so player knows something happened
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
      //Make SR Check
      if ((!MyResistSpell(OBJECT_SELF, oTarget)) && (MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC) == FALSE)) {
         //Set damage effect
         effect eBad = EffectAttackDecrease(1 + nPureBonus/4);
         //Apply the VFX impact and damage effect
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds(10 + nPureBonus));
      }
    }
}



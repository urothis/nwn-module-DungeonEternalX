//::///////////////////////////////////////////////
//:: Owl's Insight
//:: x0_S0_OwlIns
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Target's widsom bonus becomes equal to half caster's level
   Duration: 1 hr/ caster level
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect eRaise;
   effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);


   int nMetaMagic = GetMetaMagicFeat();
   int nRaise = nPureLevel / 2;
   int nDuration = nPureLevel;

   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   //Set Adjust Ability Score effect
   eRaise = EffectAbilityIncrease(ABILITY_WISDOM, nRaise);
   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 438, FALSE));
   //Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRaise, oTarget, HoursToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

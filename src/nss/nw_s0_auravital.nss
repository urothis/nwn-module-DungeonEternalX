//::///////////////////////////////////////////////
//:: Aura of Vitality
//:: NW_S0_AuraVital
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All allies within the AOE gain +4 Str, Con, Dex
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget;
   effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4 + nPureBonus);
   effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 4 + nPureBonus);
   effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4 + nPureBonus);

   effect eLink = EffectLinkEffects(eStr, eDex);
   eLink = EffectLinkEffects(eLink, eCon);

   effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
   effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
   int nDuration = nPureLevel;
   float fDelay;

   int nMetaMagic = GetMetaMagicFeat();
   //Enter Metamagic conditions
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
   oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
   while(GetIsObjectValid(oTarget)) {
      if (GetFactionEqual(oTarget) || GetIsReactionTypeFriendly(oTarget)) {
         fDelay = GetRandomDelay(0.4, 1.1);
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_AURA_OF_VITALITY, FALSE));
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
   }
}

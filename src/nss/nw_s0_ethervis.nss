//::///////////////////////////////////////////////
//:: Ethereal Visage
//:: NW_S0_EtherVis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Caster gains 20/+3 Damage reduction and is immune
   to 2 level spells and lower.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREAL_VISAGE, FALSE));

   effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);

   int nPower = DAMAGE_POWER_PLUS_THREE;
   if      (nPureBonus < 3) nPower = DAMAGE_POWER_PLUS_THREE;
   else if (nPureBonus < 5) nPower = DAMAGE_POWER_PLUS_FOUR;
   else if (nPureBonus < 7) nPower = DAMAGE_POWER_PLUS_FIVE;
   else if (nPureBonus < 9) nPower = DAMAGE_POWER_PLUS_SIX;

   effect eDam = EffectDamageReduction(20 + nPureBonus, nPower);
   effect eSpell = EffectSpellLevelAbsorption(2 + nPureBonus/4);
   effect eConceal = EffectConcealment(25 +  nPureBonus);

   effect eLink = EffectLinkEffects(eDam, eVis);
   eLink = EffectLinkEffects(eLink, eSpell);
   eLink = EffectLinkEffects(eLink, eConceal);

   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = nPureLevel;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

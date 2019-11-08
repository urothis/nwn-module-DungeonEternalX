//::///////////////////////////////////////////////
//:: Energy Buffer
//:: NW_S0_EneBuffer
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The caster is protected from all five energy
   types for up to 3 per caster level. When
   one element type is spent all five are
   removed.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   int nDuration = nPureLevel;
   int nAmount;
   int nResistance;

   int nSpellID = GetSpellId();
   if (nSpellID==SPELL_ENDURE_ELEMENTS) {
      nDuration   = 24;
      nAmount     = 20;
      nResistance = 2;
   } else if (nSpellID==SPELL_RESIST_ELEMENTS) {
      nAmount     = 30;
      nResistance = 3;
   } else if (nSpellID==SPELL_PROTECTION_FROM_ELEMENTS) {
      nAmount     = 40;
      nResistance = 4;
   } else if (nSpellID==SPELL_ENERGY_BUFFER) {
      nAmount     = 50;
      nResistance = 5;
   }
      /*if (nSpellID==SPELL_ENDURE_ELEMENTS) {
      nDuration   = 24;
      nAmount     = 20 + nPureBonus;
      nResistance = 10 + nPureBonus / 2;
   } else if (nSpellID==SPELL_RESIST_ELEMENTS) {
      nAmount     = 30 + nPureBonus * 2;
      nResistance = 20 + nPureBonus;
   } else if (nSpellID==SPELL_PROTECTION_FROM_ELEMENTS) {
      nAmount     = 40 + nPureBonus * 3;
      nResistance = 30 + nPureBonus * 2;
   } else if (nSpellID==SPELL_ENERGY_BUFFER) {
      nAmount     = 60 + nPureBonus * 4;
      nResistance = 40 + nPureBonus * 3;
   }*/

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   object oTarget = GetSpellTargetObject();
   effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, nAmount);
   effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, nAmount);
   effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, nAmount);
   effect eSoni = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, nAmount);
   effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, nAmount);
   effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
   effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));

   //Link Effects
   effect eLink = EffectLinkEffects(eCold, eFire);
   eLink = EffectLinkEffects(eLink, eAcid);
   eLink = EffectLinkEffects(eLink, eSoni);
   eLink = EffectLinkEffects(eLink, eElec);
   eLink = EffectLinkEffects(eLink, eDur);

   RemoveEffectsFromSpell(oTarget, GetSpellId());

   //Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


//::///////////////////////////////////////////////
//:: Mestil's Acid Sheath
//:: X2_S0_AcidShth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   This spell creates an acid shield around your
   person. Any creature striking you with its body
   does normal damage, but at the same time the
   attacker takes 1d6 points +2 points per caster
   level of acid damage. Weapons with exceptional
   reach do not endanger thier uses in this way.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   if (HasShield(SPELL_ELEMENTAL_SHIELD, "Elemental", "Acid")) return;
   if (HasShield(SPELL_DEATH_ARMOR, "Death Armor", "Acid")) return;
   if (HasShield(SPELL_WOUNDING_WHISPERS, "Wounding Whispers", "Acid")) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eVis = EffectVisualEffect(448);
   int nDamage = GetMin(15, nPureLevel / 2) + 2 * nPureBonus;
   int nDuration = nPureLevel;
   int nDice = DAMAGE_BONUS_1d6;
   if (nPureBonus) {
      nDuration *= 2;
      nDice = DAMAGE_BONUS_2d6;
   }
   if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   object oTarget = OBJECT_SELF;
   effect eShield = EffectDamageShield(nDamage, nDice, DAMAGE_TYPE_ACID);
   effect eLink = EffectLinkEffects(eShield, eVis);
   if (nPureBonus) {
      effect eAcid = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 5 * nPureBonus);
      eLink = EffectLinkEffects(eLink, eAcid);
   }
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

   // 2003-07-07: Stacking Spell Pass, Georg
   RemoveEffectsFromSpell(oTarget, GetSpellId());

   //Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}


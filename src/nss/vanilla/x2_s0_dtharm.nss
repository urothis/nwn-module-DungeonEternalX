//::///////////////////////////////////////////////
//:: Death Armor
//:: X2_S0_DthArm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You are surrounded with a magical aura that injures
    creatures that contact it. Any creature striking
    you with its body or handheld weapon takes 1d4 points
    of damage +1 point per 2 caster levels (maximum +5).
*/

#include "x0_i0_spells"
#include "pure_caster_inc"

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   if (HasShield(SPELL_ELEMENTAL_SHIELD, "Elemental", "Death Armor")) return;
   if (HasShield(SPELL_MESTILS_ACID_SHEATH, "Acid", "Death Armor")) return;
   if (HasShield(SPELL_WOUNDING_WHISPERS, "Wounding Whispers", "Death Armor")) return;

   object oTarget = GetSpellTargetObject();

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;

   int nDamage = GetMin(15, nPureLevel / 2) + 2 * nPureBonus;
   int nDuration = nPureLevel;
   int nDice = DAMAGE_BONUS_1d6;
   if (nPureBonus) {
      nDuration *= 2;
      nDice = DAMAGE_BONUS_2d6;
   }

   if (GetMetaMagicFeat()==METAMAGIC_EXTEND) nDuration *= 2;

   effect eShield = EffectDamageShield(nDamage, nDice, DAMAGE_TYPE_NEGATIVE);
   effect eVis = EffectVisualEffect(463);
   effect eLink = EffectLinkEffects(eShield, eVis);
   if (nPureBonus)
   {
        effect eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 5 * nPureBonus);
        eLink = EffectLinkEffects(eLink, eNeg);
   }

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

   RemoveEffectsFromSpell(oTarget, GetSpellId());

   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

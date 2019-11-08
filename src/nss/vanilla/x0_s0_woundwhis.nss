//::///////////////////////////////////////////////
//:: Wounding Whispers
//:: x0_s0_WoundWhis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Magical whispers cause 1d8 sonic damage to attackers who hit you.
   Made the damage slightly more than the book says because we cannot
   do the +1 per level.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   if (HasShield(SPELL_MESTILS_ACID_SHEATH, "Acid", "Wounding Whispers")) return;
   if (HasShield(SPELL_DEATH_ARMOR, "Death Armor", "Wounding Whispers")) return;
   if (HasShield(SPELL_ELEMENTAL_SHIELD, "Elemental", "Wounding Whispers")) return;

   int nCasterLvl = GetCasterLevel(OBJECT_SELF);
   int nDamage = GetMin(15, nCasterLvl / 2);
   int nDuration = nCasterLvl;
   int nDice = DAMAGE_BONUS_1d6;

   if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   //Declare major variables
   effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
   object oTarget = OBJECT_SELF;
   effect eShield = EffectDamageShield(nDamage, nDice, DAMAGE_TYPE_SONIC);

   //Link effects
   effect eLink = EffectLinkEffects(eShield, eVis);

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 441, FALSE));

   if (GetHasSpellEffect(GetSpellId(),oTarget)) RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);

   //Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

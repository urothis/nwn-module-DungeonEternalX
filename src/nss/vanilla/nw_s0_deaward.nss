//::///////////////////////////////////////////////
//:: Death Ward
//:: NW_S0_DeaWard.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The target creature is protected from the instant
   death effects for the duration of the spell
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DEATH_WARD, FALSE));

   effect eDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
   effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
   effect eLink = EffectLinkEffects(eDeath, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;

   int nDuration = nPureLevel;
   if (nPureBonus) nDuration *= 2;

   if (GetMetaMagicFeat()==METAMAGIC_EXTEND) nDuration = nDuration *2;

   //Apply VFX impact and death immunity effect
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


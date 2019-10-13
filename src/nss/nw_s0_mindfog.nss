//::///////////////////////////////////////////////
//:: Mind Fog
//:: NW_S0_MindFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creates a bank of fog that lowers the Will save
   of all creatures within who fail a Will Save by
   -10.  Affect lasts for 2d6 rounds after leaving
   the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables including Area of Effect Object
   effect eAOE = EffectAreaOfEffect(AOE_PER_FOGMIND);
   location lTarget = GetSpellTargetLocation();
   int nDuration = GetMin(10, 2 + nPureLevel / 2);
   effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
   int nMetaMagic = GetMetaMagicFeat();
   //Check Extend metamagic feat.
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;
   //Create an instance of the AOE Object using the Apply Effect function
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}


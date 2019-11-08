//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Person within the AoE take 4d6 fire damage
   per round.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables, including the Area of Effect object.
   effect eAOE = EffectAreaOfEffect(AOE_PER_FOGFIRE);
   //Capture the spell target location so that the AoE object can be created.
   location lTarget = GetSpellTargetLocation();
   int nDuration = 1+GetMin(9, nPureLevel/3);
   effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
   //Create the object at the location so that the objects scripts will start working.
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}


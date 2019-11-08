//::///////////////////////////////////////////////
//:: Spike Growth
//:: x0_s0_spikegro.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All creatures within the AoE take 1d4 points of damage
   every round.
   If you are in the area of the effect, you also get a 24 hour slow
   effect on you (will only add one)

   Lasts 1 hour/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////

#include "pure_caster_inc"

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables including Area of Effect Object
   effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE, "x0_s0_spikegroEN", "x0_s0_spikegroHB", "");
   location lTarget = GetSpellTargetLocation();
   effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
   int nDuration = 1+GetMin(9, nPureLevel/3);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
   //Create an instance of the AOE Object using the Apply Effect function
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}
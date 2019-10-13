//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewld
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   A cone of noxious air goes forth from the caster.
   Enemies in the area of effect are stunned and blinded
   1d6 rounds. Foritude save negates effect.
*/

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eAOE = EffectAreaOfEffect(AOE_PER_FOG_OF_BEWILDERMENT);
   location lTarget = GetSpellTargetLocation();
   int nDuration = 1+GetMin(9, nPureLevel/3);
   effect eImpact = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
   //Create the AOE object at the selected location
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}


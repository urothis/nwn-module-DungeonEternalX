//::///////////////////////////////////////////////
//:: Stinking Cloud
//:: NW_S0_StinkCld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Those within the area of effect must make a
    fortitude save or be dazed.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eAOE      = EffectAreaOfEffect(AOE_PER_FOGSTINK);
   location lTarget = GetSpellTargetLocation();
   effect eImpact   = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
   int nDuration    = 1+GetMin(9, nPureLevel/3);
   int nMetaMagic   = GetMetaMagicFeat();

   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
   //Apply the AOE object to the specified location
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

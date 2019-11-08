//::///////////////////////////////////////////////
//:: Vine Mine, Entangle
//:: X2_S0_VineMEnt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Area of effect spell that places the entangled
  effect on enemies if they fail a saving throw
  each round.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE, "x2_s0_vinementer", "x2_s0_vinembeat", "x2_s0_vinemexit");
   location lTarget = GetSpellTargetLocation();
   int nDuration = 1+GetMin(9, nPureLevel/3);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
   //Apply the AOE object to the specified location
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

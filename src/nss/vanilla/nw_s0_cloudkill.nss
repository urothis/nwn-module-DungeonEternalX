//::///////////////////////////////////////////////
//:: Cloudkill
//:: NW_S0_CloudKill.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All creatures with 3 or less HD die, those with
   4 to 6 HD must make a save Fortitude Save or die.
   Those with more than 6 HD take 1d10 Poison damage
   every round.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eAOE = EffectAreaOfEffect(AOE_PER_FOGKILL);
   float nDuration = 2.5;
   location lTarget = GetSpellTargetLocation();
   effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
   //Apply the AOE object to the specified location
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, nDuration);
}

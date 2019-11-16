//::///////////////////////////////////////////////
//:: Mass Blindness and Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = nPureLevel;
   effect eBlind =  EffectBlindness();
   effect eDeaf = EffectDeaf();

   //Link the blindness and deafness effects
   effect eLink = EffectLinkEffects(eBlind, eDeaf);
   effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
   effect eXpl = EffectVisualEffect(VFX_FNF_BLINDDEAF);
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   //Play area impact VFX
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eXpl, GetSpellTargetLocation());
   //Get the first target in the spell area
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF)) {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_BLINDNESS_AND_DEAFNESS));
         if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC)) {
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
         }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
   }
}

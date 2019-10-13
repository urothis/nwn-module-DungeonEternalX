//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All creatures within the AoE take 2d6 acid damage
   per round and upon entering if they fail a Fort Save
   their movement is halved.
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"

void main() {

   //Declare major variables
   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetEnteringObject();
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   effect eDam;
   effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
   effect eVis2 = EffectVisualEffect(VFX_IMP_DAZED_S);
   effect eDaze = EffectDazed();
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

   //Link effects
   effect eLink = EffectLinkEffects(eMind, eDaze);


   float fDelay = GetRandomDelay(1.0, 2.2);
   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
      //Fire cast spell at event for the target
      SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ACID_FOG));
      //Spell resistance check
      if (!MyResistSpell(oCaster, oTarget))
      {
         nDamage = d6(4 + nPureBonus);
         if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * (4 + nPureBonus);//Damage is at max
         if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%
         //Make a Fortitude Save to avoid the effects of the movement hit.
         if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay) && oTarget != oCaster) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
         }
         if (MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_ACID, oCaster, fDelay))
            nDamage /= 2;
         //Set Damage Effect with the modified damage
         eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
         //Apply damage and visuals
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
      }
   }
}

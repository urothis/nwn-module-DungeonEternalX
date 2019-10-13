//::///////////////////////////////////////////////
//:: Evards Black Tentacles: On Enter
//:: NW_S0_EvardsA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Upon entering the mass of rubbery tentacles the
   target is struck by 1d4 +1/lvl tentacles.  Each
   makes a grapple check. If it succeeds then
   it does 1d6+4damage and the target must make
   a Fortitude Save versus paralysis or be paralyzed
   for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book

#include "X0_I0_SPELLS"
#include "pure_caster_inc"

void main() {

   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetEnteringObject();
   effect eParal = EffectParalyze();
   effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
   effect eLink = EffectLinkEffects(eDur, eParal);
   effect eDam;

   int nMetaMagic = GetMetaMagicFeat();
   int nDamage = 0;
   int nHits;
   float fDelay;
   int nNumberTargets = 0;
   int nMinimumTargets = 2;
   int nDieDam;
   int nTargetSize;
   int nTentacleGrappleCheck;
   int nOpposedGrappleCheck;
   int nOppossedGrappleCheckModifiers;

   if (GetCreatureSize(oTarget) < CREATURE_SIZE_MEDIUM) {
      effect eFail = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
      fDelay = GetRandomDelay(0.75, 1.5);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFail, oTarget,fDelay);
      return;
   }

   int nCasterLevel = nPureLevel;
   if (nCasterLevel > 20 + nPureBonus) nCasterLevel = 20 + nPureBonus;

   int nTentaclesPerTarget = d4();
   if (nMetaMagic == METAMAGIC_MAXIMIZE) nTentaclesPerTarget = 4;
   nTentaclesPerTarget = nTentaclesPerTarget + nCasterLevel;
//   if (nMetaMagic == METAMAGIC_EMPOWER) nTentaclesPerTarget += (nTentaclesPerTarget/2); //Number of variable tentacles is +50%

   oTarget = GetFirstInPersistentObject();
   while(GetIsObjectValid(oTarget)) {
      if (GetCreatureSize(oTarget) >= CREATURE_SIZE_MEDIUM) {
         if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) nNumberTargets++;
      }
      oTarget = GetNextInPersistentObject();
   }

   oTarget = GetEnteringObject();
   if (nNumberTargets >= 0) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EVARDS_BLACK_TENTACLES));
         // Distribute the tentacle between all valid targets.
         if (nNumberTargets < nMinimumTargets) {
            nTentaclesPerTarget = nTentaclesPerTarget/nMinimumTargets;
         } else {
            nTentaclesPerTarget = nTentaclesPerTarget/nNumberTargets;
         }
         nOppossedGrappleCheckModifiers = GetBaseAttackBonus(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget);
         nTargetSize = GetCreatureSize(oTarget);
         if (nTargetSize == CREATURE_SIZE_LARGE) nOppossedGrappleCheckModifiers += 4;
         if (nTargetSize == CREATURE_SIZE_HUGE) nOppossedGrappleCheckModifiers += 8;
         for (nHits = nTentaclesPerTarget; nHits > 0; nHits--) {
            // Grapple Check.
            nTentacleGrappleCheck = d20() + nCasterLevel + 8; // Str(4) + Large Tentacle(4)
            nOpposedGrappleCheck = d20() + nOppossedGrappleCheckModifiers;
            if (nTentacleGrappleCheck >= nOpposedGrappleCheck) {
               nDieDam = d6() + 4;
               if (nMetaMagic == METAMAGIC_MAXIMIZE) nDieDam = 10;//Damage is at max
               if (nMetaMagic == METAMAGIC_EMPOWER) nDieDam += (nDieDam/2); //Damage/Healing is +50%
               nDieDam = GetMax(nDieDam, nPureBonus);
               nDamage += nDieDam;
               fDelay = GetRandomDelay(1.0, 2.2);
               eDam = EffectDamage(nDieDam, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            }
         }
         if (nDamage > 0) {
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay)) {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
            }
         }
      }
   }
}

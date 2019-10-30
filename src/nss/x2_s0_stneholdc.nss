//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_StneholdC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creates an area of effect that will cover the
   creature with a stone shell holding them in
   place.
*/

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {

   object oCaster = GetAreaOfEffectCreator();
   if (!GetIsObjectValid(oCaster)) { // CASTER GONE, KILL AOE
      DestroyObject(OBJECT_SELF);
      return;
   }

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   int nRounds;
   int nMetaMagic = GetMetaMagicFeat();
   effect eHold = EffectParalyze();
   effect eDur = EffectVisualEffect(VFX_DUR_STONEHOLD);
   eHold = EffectLinkEffects(eDur, eHold);
   object oTarget;
   float fDelay;

   oTarget = GetFirstInPersistentObject();
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))  {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONEHOLD));
         if (!GetHasSpellEffect(SPELL_STONEHOLD,oTarget)) {
            if (!MyResistSpell(oCaster, oTarget)) {
               if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster))  {
                  nRounds = MaximizeOrEmpower(6, 1, nMetaMagic);
                  fDelay = GetRandomDelay(0.75, 1.75);
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, RoundsToSeconds(nRounds)));
               }
            }
         }
      }
      oTarget = GetNextInPersistentObject();
   }
}

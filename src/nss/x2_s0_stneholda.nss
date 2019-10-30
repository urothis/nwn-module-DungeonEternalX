//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_StneholdA
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

   //Declare major variables
   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   int nRounds;
   effect eHold = EffectParalyze();
   effect eDur = EffectVisualEffect(VFX_DUR_STONEHOLD);
   object oTarget;
   float fDelay;

   int nMetaMagic = GetMetaMagicFeat();
   effect eLink = EffectLinkEffects(eDur, eHold);
   oTarget = GetEnteringObject();
   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONEHOLD));
      if(!MyResistSpell(oCaster, oTarget)) {
         if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster)) {
            nRounds = MaximizeOrEmpower(6, 1, nMetaMagic);
            fDelay = GetRandomDelay(0.45, 1.85);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nRounds)));
         }
      }
   }
}

//::///////////////////////////////////////////////
//:: Spike Growth: On Enter
//:: x0_s0_spikegroEN.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All creatures within the AoE take 1d4 acid damage
   per round
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {
   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;
   object oTarget = GetEnteringObject();
   float fDelay = GetRandomDelay(1.0, 2.2);

   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
      SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SPIKE_GROWTH));
      if(!MyResistSpell(oCaster, oTarget, fDelay)) {
         int nMetaMagic = GetMetaMagicFeat();
         int nDam = MaximizeOrEmpower(4, 1 + nPureBonus, nMetaMagic);
         effect eDam = EffectDamage(nDam, DAMAGE_TYPE_PIERCING);
         effect eVis = EffectVisualEffect(VFX_IMP_SPIKE_TRAP); //VFX_IMP_ACID_S
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
         if (GetHasSpellEffect(SPELL_SPIKE_GROWTH, oTarget) == FALSE && NoMonkSpeed(oTarget)) {
            if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_ALL, oCaster, fDelay)) {
               effect eSpeed = EffectMovementSpeedDecrease(30);
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oTarget, HoursToSeconds(24));
            }
         }
      }
   }
}

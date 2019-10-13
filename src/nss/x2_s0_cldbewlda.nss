//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewldA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   A cone of noxious air goes forth from the caster.
   Enemies in the area of effect are stunned and blinded
   1d6 rounds. Foritude save negates effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: November 04, 2002
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {

   object oCaster = GetAreaOfEffectCreator();

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nRounds;
   effect eStun = EffectStunned();
   effect eBlind = EffectBlindness();
   eStun = EffectLinkEffects(eBlind,eStun);
   effect eVis = EffectVisualEffect(VFX_DUR_BLIND);
   effect eFind;
   object oTarget;

   float fDelay;
   //Get the first object in the persistant area
   oTarget = GetEnteringObject();
   if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
   {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CLOUD_OF_BEWILDERMENT));
      //Make a SR check
      if(!MyResistSpell(oCaster, oTarget)) {
         //Make a Fort Save
         if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_POISON)) {
            if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE) {
               nRounds = GetMax(nPureBonus/2, d6(1));
               fDelay = GetRandomDelay(0.75, 1.75);
               //Apply the VFX impact and linked effects
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nRounds)));
            }
         }
      }
   }
}

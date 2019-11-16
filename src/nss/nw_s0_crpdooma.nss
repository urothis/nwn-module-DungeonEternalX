//::///////////////////////////////////////////////
//:: Creeping Doom: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creature caught in the swarm take an initial
   damage of 1d20, but there after they take
   1d4 per swarm counter on the AOE.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {

   //Declare major variables
   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nDamage;
   effect eDam;
   effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
   object oTarget = GetEnteringObject();
   effect eSpeed = EffectMovementSpeedDecrease(GetSlowRate(oTarget));
   float fDelay;
   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
      //Fire cast spell at event for the target
      SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CREEPING_DOOM));
      fDelay = GetRandomDelay(1.0, 1.8);
      //Spell resistance check
      if (!MyResistSpell(oCaster, oTarget)) {
         //Roll Damage
         nDamage = d4(5 + nPureBonus);
         //Set Damage Effect with the modified damage
         eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
         //Apply damage and visuals
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
         if (NoMonkSpeed(oTarget)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);
      }
   }
}

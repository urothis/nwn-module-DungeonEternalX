//::///////////////////////////////////////////////
//:: Grease: Heartbeat
//:: NW_S0_GreaseC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creatures entering the zone of grease must make
   a reflex save or fall down.  Those that make
   their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
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

   //Declare major variables
   object oTarget;
   effect eFall = EffectKnockdown();
   float fDelay;
   //Get first target in spell area
   oTarget = GetFirstInPersistentObject();
   while (GetIsObjectValid(oTarget)) {
      if (!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) ) {
         if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
            fDelay = GetRandomDelay(0.0, 2.0);
            if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay)) {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFall, oTarget, 4.0));
            }
         }
      }
      //Get next target in spell area
      oTarget = GetNextInPersistentObject();
   }
}

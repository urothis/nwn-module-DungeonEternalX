//::///////////////////////////////////////////////
//:: Vine Mine, Heartbeat
//:: X2_S0_VineMBeat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Upon entering the AOE the target must make
   a reflex save or be entangled by vegitation
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

   effect eVis = EffectVisualEffect(VFX_DUR_ENTANGLE);
   effect eEff = EffectEntangle();
   effect eEntangle = EffectLinkEffects(eVis, eEff);

   object oTarget = GetFirstInPersistentObject();
   while (GetIsObjectValid(oTarget)) {
      if (!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL)!= TRUE)) {
         if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_VINE_MINE));
            if (!MyResistSpell(oCaster, oTarget)) {
               if (MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_NONE, oCaster)==0) {
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEntangle, oTarget, 6.0);
               }
            }
         }
      }
      //Get next target in the AOE
      oTarget = GetNextInPersistentObject();
   }
}

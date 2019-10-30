//::///////////////////////////////////////////////
//:: Entangle
//:: NW_S0_EntangleC.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Upon entering the AOE the target must make
   a reflex save or be entangled by vegitation
*/

#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {

   object oCaster = GetAreaOfEffectCreator();
   if (!GetIsObjectValid(oCaster)) { // CASTER GONE, KILL AOE
     DestroyObject(OBJECT_SELF);
     return;
   }

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   effect eHold = EffectEntangle();
   effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
   effect eLink = EffectLinkEffects(eHold, eEntangle);
   object oTarget = GetFirstInPersistentObject();

   while(GetIsObjectValid(oTarget)) {
      if (!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL)!=TRUE)) {
         if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENTANGLE));
            if (!GetHasSpellEffect(SPELL_ENTANGLE, oTarget)) {
               if (!MyResistSpell(oCaster, oTarget)) {
                  if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_NONE, oCaster)) {
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
                  }
               }
            }
         }
      }
      //Get next target in the AOE
      oTarget = GetNextInPersistentObject();
   }
}

//::///////////////////////////////////////////////
//:: Mind Fog: On Enter
//:: NW_S0_MindFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creates a bank of fog that lowers the Will save
   of all creatures within who fail a Will Save by
   -10.  Affect lasts for 2d6 rounds after leaving
   the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "pure_caster_inc"

void main() {

   //Declare major variables
   object oTarget = GetEnteringObject();
   object oCaster = GetAreaOfEffectCreator();

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_ENCHANTMENT);
   if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
   effect eLower = EffectSavingThrowDecrease(SAVING_THROW_WILL, 4+nPureBonus/2);
   effect eLink = EffectLinkEffects(eVis, eLower);
   int bValid = FALSE;
   float fDelay = GetRandomDelay(1.0, 2.2);
   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_FOG));
      //Make SR check
      effect eAOE = GetFirstEffect(oTarget);
      if (GetHasSpellEffect(SPELL_MIND_FOG, oTarget)) {
         while (GetIsEffectValid(eAOE)) {
            //If the effect was created by the Mind_Fog then remove it
            if (GetEffectSpellId(eAOE) == SPELL_MIND_FOG && oCaster == GetEffectCreator(eAOE)) {
               if (GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE) {
                  RemoveEffect(oTarget, eAOE);
                  bValid = TRUE;
               }
            }
            //Get the next effect on the creation
            eAOE = GetNextEffect(oTarget);
         }
      //Check if the effect has been put on the creature already.  If no, then save again. If yes, apply without a save.
      }
      if(bValid == FALSE) {
         if(!MyResistSpell(OBJECT_SELF, oTarget)) {
            //Make Will save to negate
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
               if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) == FALSE) {
                  //Apply VFX impact and lowered save effect
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
               }
            }
         }
      } else {
         if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) == FALSE) {
            //Apply VFX impact and lowered save effect
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
         }
      }
   }
}

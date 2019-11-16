//::///////////////////////////////////////////////
//:: Mind Fog: On Exit
//:: NW_S0_MindFogB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creates a bank of fog that lowers the Will save
   of all creatures within who fail a Will Save by
   -10.  Effect lasts for 2d6 rounds after leaving
   the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "pure_caster_inc"

void main() {

   object oCaster = GetAreaOfEffectCreator();

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_ENCHANTMENT);
   if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 4+nPureBonus/2);
   effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
   effect eLink = EffectLinkEffects(eSave, eVis);

   int nDuration = GetMin(4, 1+nPureBonus/2);
   int nMetaMagic = GetMetaMagicFeat();
   int bValid = FALSE;
   //Get the object that is exiting the AOE
   object oTarget = GetExitingObject();
   //Search through the valid effects on the target.
   effect eAOE = GetFirstEffect(oTarget);
   if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget)) {
      while (GetIsEffectValid(eAOE)) {
         //If the effect was created by the Mind_Fog then remove it
         if (GetEffectCreator(eAOE) == oCaster && GetEffectSpellId(eAOE) == SPELL_MIND_FOG) {
            if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE) {
               RemoveEffect(oTarget, eAOE);
               bValid = TRUE;
            }
         }
         //Get the next effect on the creation
         eAOE = GetNextEffect(oTarget);
       }
   }
   if(bValid == TRUE) {
      //Enter Metamagic conditions
      if (nMetaMagic == METAMAGIC_MAXIMIZE) {
         nDuration = 4;
      }  else if (nMetaMagic == METAMAGIC_EMPOWER) {
         nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
      }  else if (nMetaMagic == METAMAGIC_EXTEND) {
         nDuration = nDuration * 2; //Duration is +100%
      }
      //Apply the new temporary version of the effect
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
   }
}

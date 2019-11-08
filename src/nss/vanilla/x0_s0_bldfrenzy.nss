//::///////////////////////////////////////////////
//:: Blood Frenzy
//:: x0_s0_bldfrenzy.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Similar to Barbarian Rage.
 +2 Strength, Con. +1 morale bonus to Will
 -1 AC
*/
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   if (!GetHasSpellEffect(SPELL_BLOOD_FRENZY)) {
      //Declare major variables
      int nDuration = nPureLevel;
      int nIncrease = 2 + nPureBonus;
      int nSave = 1 + nPureBonus/2;
      int nMetaMagic = GetMetaMagicFeat();
      if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

      PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

      effect eStr = EffectAbilityIncrease(ABILITY_CONSTITUTION, nIncrease);
      effect eCon = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
      effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave);

      effect eLink = EffectLinkEffects(eCon, eStr);
      eLink = EffectLinkEffects(eLink, eSave);
      if (nPureBonus==0) {
         effect eAC = EffectACDecrease(1, AC_DODGE_BONUS);
         eLink = EffectLinkEffects(eLink, eAC);
      }
      SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
      //Make effect extraordinary
      eLink = MagicalEffect(eLink);
      effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); //Change to the Rage VFX

      //Apply the VFX impact and effects
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF) ;
   }
}

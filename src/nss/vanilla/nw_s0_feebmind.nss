//::///////////////////////////////////////////////
//:: Feeblemind
//:: [NW_S0_FeebMind.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Will save or take ability
//:: damage to Intelligence equaling 1d4 per 4 levels.
//:: Duration of 1 rounds per 2 levels.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nDuration = GetMax(1, nPureLevel/2);
   int nLoss = GetMax(1, nPureLevel/4);
   nLoss = d4(nLoss);

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_MAXIMIZE)     nLoss = nLoss * 4;
   else if (nMetaMagic == METAMAGIC_EMPOWER) nLoss = nLoss + (nLoss/2);
   else if (nMetaMagic == METAMAGIC_EXTEND)  nDuration = nDuration * 2;

   int nInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) - 3;
   nLoss = GetMin(nInt, nLoss);

   effect eFeeb;
   effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
   effect eRay = EffectBeam(VFX_BEAM_MIND, OBJECT_SELF, BODY_NODE_HAND);

   if(!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEEBLEMIND));
      //Make SR check
      if (!MyResistSpell(OBJECT_SELF, oTarget)) {
         //Make an will save
         int nWillResult =  WillSave(oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS);
         if (nWillResult == 0) {
              //Set the ability damage
              eFeeb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nLoss);

              //Apply the VFX impact and ability damage effect.
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFeeb, oTarget, RoundsToSeconds(nDuration));
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         } else if (nWillResult == 2) { // * target was immune
            SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
         }
      }
   }
}

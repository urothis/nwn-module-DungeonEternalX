//::///////////////////////////////////////////////
//:: Hold Animal
//:: S_HoldAnim
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: Description: As hold person, except the spell
//:: affects an animal instead. Hold animal does not
//:: work on beasts, magical beasts, or vermin.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On:  Jan 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   effect eParal = EffectStunned();
   effect eDur2 = EffectVisualEffect(VFX_IMP_STUN);

   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = GetMax(1 + nPureLevel/8, nPureBonus) + nPureBonus/2;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

   effect eLink = EffectLinkEffects(eDur2, eDur3);
   eLink = EffectLinkEffects(eLink, eParal);

   // nPureDC += (GetSkillRank(SKILL_ANIMAL_EMPATHY, OBJECT_SELF, TRUE)/10);

   if(!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_ANIMAL));
      //Check racial type
      if (GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL) {
         //Make SR check
         if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            //Make Will Save
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC)) {
               //Apply paralyze and VFX impact
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            }
         }
      }
   }
}

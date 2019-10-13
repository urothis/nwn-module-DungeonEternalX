//::///////////////////////////////////////////////
//:: [Charm Person or Animal]
//:: [NW_S0_DomAni.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   effect eCharm = EffectDazed();
   effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);

   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = GetMax(1 + nPureLevel/8, nPureBonus);
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
   //Link the charm and duration visual effects
   effect eLink = EffectLinkEffects(eMind, eCharm);

   int nRacial = GetRacialType(oTarget);
   if (nRacial == RACIAL_TYPE_ANIMAL) nPureDC += (GetSkillRank(SKILL_ANIMAL_EMPATHY, OBJECT_SELF, TRUE)/10);

   if(!GetIsReactionTypeFriendly(oTarget)) {
      //Fire spell cast at event to fire on the target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON_OR_ANIMAL, FALSE));
      //Make SR Check
      if (!MyResistSpell(OBJECT_SELF, oTarget)) {
         //Make sure the racial type of the target is applicable
         if  ((nRacial == RACIAL_TYPE_DWARF) ||
            (nRacial == RACIAL_TYPE_ANIMAL) ||
            (nRacial == RACIAL_TYPE_ELF) ||
            (nRacial == RACIAL_TYPE_GNOME) ||
            (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
            (nRacial == RACIAL_TYPE_HALFLING) ||
            (nRacial == RACIAL_TYPE_HUMAN) ||
            (nRacial == RACIAL_TYPE_HALFELF) ||
            (nRacial == RACIAL_TYPE_HALFORC) ||
            (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
            (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
            (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
         {
            //Make Will Save
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
               //Apply impact effects and linked duration and charm effect
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
         }
      }
   }
}

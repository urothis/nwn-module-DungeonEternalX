//::///////////////////////////////////////////////
//:: [Dominate Animal]
//:: [NW_S0_DomAn.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();

   effect eDom = EffectDominated();
   effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
   float fDuration = TurnsToSeconds(3 + nPureLevel/2);

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) fDuration = fDuration * 2.0;

   //Declare major variables
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);

   //Link domination and persistant VFX
   effect eLink = EffectLinkEffects(eMind, eDom);

   int nRacial = GetRacialType(oTarget);
   nPureDC += (GetSkillRank(SKILL_ANIMAL_EMPATHY, OBJECT_SELF, TRUE)/10);

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_ANIMAL, FALSE));
   //Make sure the target is an animal
   if(!GetIsReactionTypeFriendly(oTarget)) {
      if ((nRacial == RACIAL_TYPE_ANIMAL)) {
         //Make SR check
         if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            //Will Save for spell negation
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            }
         }
      }
   }
}

//::///////////////////////////////////////////////
//:: [Dominate Person]
//:: [NW_S0_DomPers.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 6, 2001
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();

   effect eDom = EffectDominated();
   effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
   float fDuration = TurnsToSeconds(3 + nPureLevel/2);

   if (GetIsPC(oTarget)) {
      fDuration = RoundsToSeconds(1 + nPureLevel/8);
      eDom = EffectLinkEffects(EffectDazed(), EffectCutsceneParalyze());
   }

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) fDuration = fDuration * 2.0;

   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);

   //Link duration effects
   effect eLink = EffectLinkEffects(eMind, eDom);

   int nRacial = GetRacialType(oTarget);
   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
   //Make sure the target is a humanoid
   if(!GetIsReactionTypeFriendly(oTarget)) {
      if ((nRacial == RACIAL_TYPE_DWARF) || (nRacial == RACIAL_TYPE_ELF) || (nRacial == RACIAL_TYPE_GNOME) ||
         (nRacial == RACIAL_TYPE_HALFLING) || (nRacial == RACIAL_TYPE_HUMAN) || (nRacial == RACIAL_TYPE_HALFELF) ||
         (nRacial == RACIAL_TYPE_HALFORC)) {
         if (!MyResistSpell(OBJECT_SELF, oTarget)) { //Make SR Check
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0)) { //Make Will Save
               if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF)) {
                  DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
               }
            }
         }
      }
   }
}

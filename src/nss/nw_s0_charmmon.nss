//::///////////////////////////////////////////////
//:: [Charm Monster]
//:: [NW_S0_CharmMon.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per 2 caster levels.
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   effect eCharm = EffectDazed();
   effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);

   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = GetMax(1 + nPureLevel/8, nPureBonus);
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

   //Link effects
   effect eLink = EffectLinkEffects(eMind, eCharm);

   if(!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_MONSTER, FALSE));
      // Make SR Check
      if (!MyResistSpell(OBJECT_SELF, oTarget)) {
         // Make Will save vs Mind-Affecting
         if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
            //Apply impact and linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         }
      }
   }
}

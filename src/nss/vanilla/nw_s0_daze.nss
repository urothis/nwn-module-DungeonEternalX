//::///////////////////////////////////////////////
//:: [Daze]
//:: [NW_S0_Daze.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dazed for 1 round
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 15, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 27, 2001

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
   effect eDaze = EffectDazed();

   effect eLink = EffectLinkEffects(eMind, eDaze);

   effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = 2;
   //check meta magic for extend
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration = 4;

   //Make sure the target is a humaniod
   if(GetHitDice(oTarget) <= (5 * nPureBonus)) {
      if(!GetIsReactionTypeFriendly(oTarget)) {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DAZE));
         //Make SR check
         if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            //Make Will Save to negate effect
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
               //Apply VFX Impact and daze effect
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
         }
      }
   }
}

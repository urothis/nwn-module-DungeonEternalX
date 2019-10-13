//::///////////////////////////////////////////////
//:: Acid Splash
//:: [X0_S0_AcidSplash.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
1d3 points of acid damage to one target.
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nCasterLevel = GetCasterLevel(OBJECT_SELF);

   effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
   if (!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 424));
      //Make SR Check
      if (!MyResistSpell(OBJECT_SELF, oTarget)) {
         //Set damage effect
         effect eBad = EffectDamage(MaximizeOrEmpower(3, 1+nPureBonus, GetMetaMagicFeat()), DAMAGE_TYPE_ACID);
         //Apply the VFX impact and damage effect
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget);
      }
   }
}
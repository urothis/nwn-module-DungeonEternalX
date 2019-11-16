//::///////////////////////////////////////////////
//:: Hold Monster
//:: NW_S0_HoldMon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Will hold any monster in place for 1
   round per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();

   effect ePara = EffectParalyze();
   effect eDur  = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
   effect eLink = EffectLinkEffects(ePara, eDur);

   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = GetMax(1 + nPureLevel/8, nPureBonus) + nPureBonus/2;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;

   if(!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_MONSTER));
      //Make SR check
      if (!MyResistSpell(OBJECT_SELF, oTarget)) {
         //Make Will save
         if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC)) {
            //Apply the paralyze effect and the VFX impact
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
         }
      }
   }
}

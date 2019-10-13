//::///////////////////////////////////////////////
//:: Hold Person
//:: NW_S0_HoldPers
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
//:: He is aware and breathes normally but cannot take any physical
//:: actions, even speech. He can, however, execute purely mental actions.
//:: winged creature that is held cannot flap its wings and falls.
//:: A swimmer can't swim and may drown.
*/

#include "NW_I0_SPELLS"
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
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_PERSON));
      //Make sure the target is a humanoid
      if (GetIsPlayableRacialType(oTarget) ||
         GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
         GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
         GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC ||
         GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN) {
         //Make SR Check
         if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            //Make Will save
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC)) {
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            }
         }
      }
   }
}

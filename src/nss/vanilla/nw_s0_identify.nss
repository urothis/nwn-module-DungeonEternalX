//::///////////////////////////////////////////////
//:: Identify
//:: NW_S0_Identify.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Gives the caster a boost to Lore skill of +25
   plus caster level.  Lasts for 2 rounds.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nBonus = 10 + nPureLevel;
   effect eLore = EffectSkillIncrease(SKILL_LORE, nBonus);
   effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
   effect eLink = EffectLinkEffects(eVis, eLore);

   int nMetaMagic = GetMetaMagicFeat();

   int nDuration = 2 + nPureBonus;

   //Meta-Magic checks
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

   //Make sure the spell has not already been applied
   if (!GetHasSpellEffect(SPELL_IDENTIFY, OBJECT_SELF) && !GetHasSpellEffect(SPELL_LEGEND_LORE, OBJECT_SELF)) {
      //Fire cast spell at event for the specified target
      SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_IDENTIFY, FALSE));
      //Apply linked and VFX effects
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
   }
}


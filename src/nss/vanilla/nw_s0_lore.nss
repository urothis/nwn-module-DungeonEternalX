//::///////////////////////////////////////////////
//:: Legend Lore
//:: NW_S0_Lore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Gives the caster a boost to Lore skill of 10
   plus 1 / 2 caster levels.  Lasts for 1 Turn per
   caster level.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nBonus = 10 + nPureLevel;
   effect eLore = EffectSkillIncrease(SKILL_LORE, nBonus);
   effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);

   int nMetaMagic = GetMetaMagicFeat();
   //Meta-Magic checks
   if(nMetaMagic == METAMAGIC_EXTEND) nPureLevel *= 2;

   //Make sure the spell has not already been applied
   if(!GetHasSpellEffect(SPELL_IDENTIFY, oTarget) && !GetHasSpellEffect(SPELL_LEGEND_LORE, oTarget)) {
       SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LEGEND_LORE, FALSE));
       //Apply linked and VFX effects
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLore, oTarget, TurnsToSeconds(nPureLevel));
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   }
}


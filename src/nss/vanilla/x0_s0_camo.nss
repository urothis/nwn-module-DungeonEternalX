//::///////////////////////////////////////////////
//:: Camoflage
//:: x0_s0_camo.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 bonus +10 to Hide checks
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
   int nMetaMagic = GetMetaMagicFeat();
   effect eHide = EffectSkillIncrease(SKILL_HIDE, 10 + nPureBonus * 2);
   int nDuration = nPureLevel;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
   SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHide, OBJECT_SELF, TurnsToSeconds(nDuration));
}

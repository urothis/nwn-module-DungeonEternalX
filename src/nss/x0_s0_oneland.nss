//::///////////////////////////////////////////////
//:: One with the Land
//:: x0_s0_oneland.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 bonus +3: animal empathy, move silently, search, hide
 Duration: 1 hour/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 19, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003
#include "nw_i0_spells"

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = OBJECT_SELF;
   effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
   int nMetaMagic = GetMetaMagicFeat();
   nPureBonus++;
   effect eSkillAnimal = EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, 4 * nPureBonus);
   effect eHide = EffectSkillIncrease(SKILL_HIDE, 4 * nPureBonus);
   effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4 * nPureBonus);
   effect eSearch = EffectSkillIncrease(SKILL_SET_TRAP, 4 * nPureBonus);

   effect eLink = EffectLinkEffects(eSkillAnimal, eMove);
   eLink = EffectLinkEffects(eLink, eHide);
   eLink = EffectLinkEffects(eLink, eSearch);

   int nDuration = GetCasterLevel(OBJECT_SELF); // * Duration 1 hour/level
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

   //Fire spell cast at event for target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 420, FALSE));
   //Apply VFX impact and bonus effects
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));

}






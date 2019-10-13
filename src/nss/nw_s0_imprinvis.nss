///::///////////////////////////////////////////////
//:: Improved Invisibility
//:: NW_S0_ImprInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature can attack and cast spells while
    invisible
*/

// Mod by ScrewTape -
/*
 Idea by Belial Prime. The PHB specifies Greater Invisibility as not being
 canceled by offensive actions, but Bioware wisely did not make Improved
 Invisibility behave this way as unlike in the PnP world, you cannot 'guess'
 and target an invisible character, so Bioware's compromise cancels
 invisibility, but keeps the concealment. This script achieves a closer
 compromise, where invisibility is still canceled by offensive actions, but it
 is re-instated for the remaining spell duration after combat. Big thanks to
 He Who Watches for helping me bulletproof it from reinstating it when it was
 canceled by dispel, rest, etc.
 */
// alter this to adjust the response time  (this is how often the check will be made)
/*const float F_DELAY = 6.0f;

void ReapplyIfCanceled(object oTarget, float fDuration) {
   // determine remaining duration
   float fDurationLeft = fDuration - F_DELAY;
   if (fDurationLeft < F_DELAY) return; // we be done - duration has expired
   if (GetIsInCombat(oTarget)) { // check again later
      DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft));
      return;
   }
   // check for both concealment (doesn't get canceled by anything but resting/dispel) and for invis effect
   effect eEffectLoop = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eEffectLoop)) {
      if (GetEffectType(eEffectLoop) == INVISIBILITY_TYPE_NORMAL) {      // if we find invis, we don't need to do anything yet
         DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft));
         return;
      }
      // if we find concealment, and it was applied by impr invis, we know the spell is still active
      if (GetEffectType(eEffectLoop)==EFFECT_TYPE_CONCEALMENT && GetEffectSpellId(eEffectLoop)==SPELL_IMPROVED_INVISIBILITY) {
         effect eNewInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNewInvis, oTarget, fDurationLeft);
         DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft)); // check again later
         return;
      }
      eEffectLoop = GetNextEffect(oTarget);
   }
}*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"
#include "assn_bonus"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
   effect eInvis  = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
   effect eVis    = EffectVisualEffect(VFX_DUR_INVISIBILITY);

   int nConceal   = 50;
   if (oTarget   == OBJECT_SELF) nConceal += nPureBonus;
   effect eCover  = EffectConcealment(nConceal);
   effect eLink   = EffectLinkEffects(eVis, eCover);

   int nSpell     = GetSpellId();

   if (nSpell == 608) // Cory - Assassin Improved Invisibilty - "Assassinate"
   {
       AssnImpInvis(oTarget);
       return;
   }

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMPROVED_INVISIBILITY, FALSE));
   int nDuration = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   //Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, TurnsToSeconds(nDuration));

   //float fDurationLeft = TurnsToSeconds(nDuration) - F_DELAY;
   //DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft));
}

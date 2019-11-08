//::///////////////////////////////////////////////
//:: Vine Mine: On Enter
//:: X2_S0_VineMEnter
//:://////////////////////////////////////////////
/*
   Creatures entering the zone of Vine Mine, Hamper
   Movement have their movement reduced by 1/2.
*/

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {

   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetEnteringObject();
   effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
   effect eEff = EffectMovementSpeedDecrease(GetSlowRate(oTarget));
   effect eSlow = EffectLinkEffects(eVis, eEff);

   effect eVis2 = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
   effect eHide = EffectSkillIncrease(SKILL_HIDE, 4 + nPureBonus);

   float fDelay = GetRandomDelay(1.0, 2.2);
   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
      if (!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE))  {
         //Fire cast spell at event for the target
         SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
         //Apply reduced movement effect and VFX_Impact
         if (NoMonkSpeed(oTarget)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
      }
   }
   if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) {
      if (!GetHasSpellEffect(GetSpellId(), oTarget)) {
         //Fire cast spell at event for the target
         SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHide, oTarget);
      }
   }
}
//::///////////////////////////////////////////////
//:: [Shadow Daze]
//:: [x0_S2_Daze.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Shadow dancer.
//:: Will save or be dazed for 5 rounds.
//:: Can only daze humanoid-type creatures
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"

void main() {
   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
   effect eDaze = EffectDazed();

   effect eLink = EffectLinkEffects(eMind, eDaze);
   effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
   int nDuration = 5;
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SHADOW_DAZE));

   int nCasterLvl = GetLevelByClass(CLASS_TYPE_SHADOWDANCER);
   int nDC = (14 + nCasterLvl + (GetAbilityModifier(ABILITY_DEXTERITY)));

   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
      if (!MyResistSpell(OBJECT_SELF, oTarget)) {
         if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         }
      }
   }
}

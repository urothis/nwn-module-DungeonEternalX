//::///////////////////////////////////////////////
//:: Monstrous Regeneration
//:: X2_S0_MonRegen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Grants the selected target 3 HP of regeneration
   every round.
*/
#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   effect eRegen = EffectRegenerate(3 + nPureBonus/2, 6.0);
   effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
   int nMeta = GetMetaMagicFeat();
   int nLevel = (nPureLevel/2)+1;
   if (nMeta == METAMAGIC_EXTEND) nLevel *= 2;
   // Stacking Spellpass, 2003-07-07, Georg   ... just in case
   RemoveEffectsFromSpell(oTarget, GetSpellId());
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
   //Apply effects and VFX
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oTarget, RoundsToSeconds(nLevel));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}

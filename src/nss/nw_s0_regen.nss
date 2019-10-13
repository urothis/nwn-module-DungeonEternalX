//::///////////////////////////////////////////////
//:: Regenerate
//:: NW_S0_Regen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Grants the selected target 6 HP of regeneration
   every round.
*/
#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   effect eRegen  = EffectRegenerate(6 + nPureBonus/2, 6.0);
   effect eVis    = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

   int nMeta  = GetMetaMagicFeat();
   int nLevel = (nPureLevel/2)+1;

   if (nMeta == METAMAGIC_EXTEND) nLevel *= 2;

   // Prevent Stacking
   RemoveEffectsFromSpell(oTarget, GetSpellId());

   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

   //Apply effects and VFX
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oTarget, RoundsToSeconds(nLevel));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}

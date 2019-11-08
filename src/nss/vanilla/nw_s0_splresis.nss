//::///////////////////////////////////////////////
//:: Spell Resistance
//:: NW_S0_SplResis
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The target creature gains 12 + Caster Level SR.
*/
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + 2 * nPureBonus; // SR get's caster level + 2 * PureDCBonus
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nMetaMagic = GetMetaMagicFeat();
   int nBonus     = 12 + nPureLevel;

   effect eSR   = EffectSpellResistanceIncrease(nBonus);
   effect eVis  = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
   effect eDur2 = EffectVisualEffect(249);
   effect eLink = EffectLinkEffects(eSR, eDur2);

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPELL_RESISTANCE, FALSE));

   //Check for metamagic extension
   if (nMetaMagic == METAMAGIC_EXTEND) nPureLevel *= 2;

   //Apply VFX impact and SR bonus effect
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nPureLevel));
}

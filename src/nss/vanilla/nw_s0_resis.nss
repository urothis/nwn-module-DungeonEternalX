//::///////////////////////////////////////////////
//:: Resistance
//:: NW_S0_Resis
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: This spell gives the recipiant a +1 bonus to
//:: all saves.  It lasts for 1 Turn.

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect eSave;
   effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

   int nBonus     = 1 + nPureBonus/4; //Saving throw bonus to be applied
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration  = 2 + nPureBonus;

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESISTANCE, FALSE));

   //Check for metamagic extend
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

   //Set the bonus save effect
   eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);

   //Apply the bonus effect and VFX impact
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, TurnsToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

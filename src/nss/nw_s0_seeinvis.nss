//::///////////////////////////////////////////////
//:: See Invisibility
//:: NW_S0_SeeInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Allows the mage to see creatures that are
   invisible
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect eVis    = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
   effect eSight  = EffectSeeInvisible();
   effect eLink   = EffectLinkEffects(eVis, eSight);

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SEE_INVISIBILITY, FALSE));

   int nDuration  = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();

   //Enter Metamagic conditions
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   //Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

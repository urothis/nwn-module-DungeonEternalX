//::///////////////////////////////////////////////
//:: Premonition
//:: NW_S0_Premo
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Gives the gives the creature touched 30/+5
   damage reduction.  This lasts for 1 hour per
   caster level or until 10 * Caster Level
   is dealt to the person.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();

   //Declare major variables
   int nDuration = nPureLevel;
   int nLimit    = nDuration * 10;

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   int nDPPlus = DAMAGE_POWER_PLUS_FIVE;
   if (nPureBonus>6) nDPPlus = DAMAGE_POWER_PLUS_SIX;



   effect eStone = EffectDamageReduction(30, nDPPlus, nLimit);
   effect eVis   = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
   effect eLink  = EffectLinkEffects(eStone, eVis);

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PREMONITION, FALSE));

   RemoveEffectsFromSpell(oTarget, SPELL_PREMONITION);
   //Apply the linked effect


   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
}

//::///////////////////////////////////////////////
//:: Stoneskin
//:: NW_S0_Stoneskin
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Gives the creature touched 10/+5
   damage reduction.  This lasts for 1 hour per
   caster level or until 10 * Caster Level (100 Max)
   is dealt to the person.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nSpell     = GetSpellId();

   if (nSpell == SPELL_SHADES_STONESKIN)
   {
        ExecuteScript("nw_s0_shades", OBJECT_SELF);
        return;
   }

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;



   //Declare major variables
   effect eStone;
   effect eVis  = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
   effect eVis2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

   effect eLink;
   object oTarget = GetSpellTargetObject();
   int nAmount    = GetMin(100 + nPureBonus * 10, nPureLevel * 10);
   int nDuration  = nPureLevel;

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONESKIN, FALSE));

   if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2;

   int nPower = DAMAGE_POWER_PLUS_FIVE;

   //Define the damage reduction effect
   eStone = EffectDamageReduction(10 + nPureBonus, nPower, nAmount);

   //Link the effects
   eLink = EffectLinkEffects(eStone, eVis);

   RemoveEffectsFromSpell(oTarget, SPELL_STONESKIN);

   //Apply the linked effects.
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
}

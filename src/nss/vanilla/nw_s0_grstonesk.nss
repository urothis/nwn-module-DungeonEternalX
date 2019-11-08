//::///////////////////////////////////////////////
//:: Greater Stoneskin
//:: NW_S0_GrStoneSk
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Gives the gives the creature touched 20/+5
   damage reduction.  This lasts for 1 hour per
   caster level or until 10 * Caster Level (150 Max)
   is dealt to the person.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nAmount = nPureLevel;
   int nDuration = nAmount;
   object oTarget = GetSpellTargetObject();

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_STONESKIN, FALSE));

   if (nAmount > 15 + nPureBonus) nAmount = 15 + nPureBonus;
   int nDamage = nAmount * 10;
   if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2;

   int nPower = DAMAGE_POWER_PLUS_FIVE;
   if (nPureBonus>=4) nPower = DAMAGE_POWER_PLUS_SIX;

   effect eVis2 = EffectVisualEffect(VFX_IMP_POLYMORPH);

   effect eStone = EffectDamageReduction(20 + nPureBonus, nPower, nDamage);
   effect eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);

   //Link the texture replacement and the damage reduction effect
   effect eLink = EffectLinkEffects(eVis, eStone);

   //Remove effects from target if they have Greater Stoneskin cast on them already.
   RemoveEffectsFromSpell(oTarget, SPELL_GREATER_STONESKIN);

   //Apply the linked effect
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
}

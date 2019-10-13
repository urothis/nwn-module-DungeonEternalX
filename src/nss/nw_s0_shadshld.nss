//::///////////////////////////////////////////////
//:: Shadow Shield
//:: NW_S0_ShadShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Grants the caster +5 AC and 10 / +3 Damage
   Reduction and immunity to death effects
   and negative energy damage for 3 Turns per level.
   Makes the caster immune Necromancy Spells

*/
#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;


   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nDuration  = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   int nAbsorb = 25;
   if (nPureBonus >= 8) nAbsorb += nPureBonus;
   //Do metamagic extend check
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   int nPower = DAMAGE_POWER_PLUS_THREE;
   if      (nPureBonus < 3) nPower = DAMAGE_POWER_PLUS_THREE;
   else if (nPureBonus < 5) nPower = DAMAGE_POWER_PLUS_FOUR;
   else if (nPureBonus < 7) nPower = DAMAGE_POWER_PLUS_FIVE;
   else if (nPureBonus < 9) nPower = DAMAGE_POWER_PLUS_SIX;

   effect eStone    = EffectDamageReduction(10 + nPureBonus, nPower);
   effect eAC       = EffectACIncrease(5 + nPureBonus/4, AC_ARMOUR_ENCHANTMENT_BONUS);
   effect eVis      = EffectVisualEffect(VFX_IMP_DEATH_WARD);
   effect eShadow   = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
   effect eSpell    = EffectSpellLevelAbsorption(9, 0, SPELL_SCHOOL_NECROMANCY);
   effect eImmDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
   effect eImmNeg   = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, nAbsorb);

   //Link major effects
   effect eLink = EffectLinkEffects(eStone, eAC);
   eLink = EffectLinkEffects(eLink, eVis);
   eLink = EffectLinkEffects(eLink, eShadow);
   eLink = EffectLinkEffects(eLink, eImmDeath);
   eLink = EffectLinkEffects(eLink, eImmNeg);
   eLink = EffectLinkEffects(eLink, eSpell);

   RemoveEffectsFromSpell(oTarget, SPELL_SHADOW_SHIELD); // NO STACKING OF DODGE BONUS

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SHADOW_SHIELD, FALSE));

   //Apply linked effect
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}


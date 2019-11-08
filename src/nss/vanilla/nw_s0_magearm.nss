//::///////////////////////////////////////////////
//:: Mage Armor
//:: [NW_S0_MageArm.nss]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Gives the target +1 AC Bonus to Dodge.
*/

/*
bugfix by Kovi 2002.07.23
- dodge bonus was stacking
*/

#include "nw_i0_spells"

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nSpell     = GetSpellId();
   if (nSpell == SPELL_SHADOW_CONJURATION_MAGE_ARMOR)  // Cory - Checks for Shadow Conj Variant
   {
        ExecuteScript("nw_s0_shades", OBJECT_SELF);
        return;
   }

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;


   if (nSpell == SPELL_SHADOW_CONJURATION_MAGE_ARMOR)
   {
        ExecuteScript("nw_s0_shades", OBJECT_SELF);
        return;
   }

   object oItem = GetSpellCastItem();
   object oTarget = GetSpellTargetObject();
   int nDuration = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
   effect eAC;
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGE_ARMOR, FALSE));
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
   else if (GetTag(GetSpellCastItem()) == "POT_EXT_MA") nDuration *= 2;

   //Set the four unique armor bonuses
   int nAC = 1 + nPureBonus/8;

   eAC = EffectACIncrease(nAC, AC_DODGE_BONUS);

   RemoveEffectsFromSpell(oTarget, SPELL_MAGE_ARMOR);
   RemoveEffectsFromSpell(oTarget, SPELL_SHADOW_CONJURATION_MAGE_ARMOR);

   //Apply the armor bonuses and the VFX impact
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, HoursToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

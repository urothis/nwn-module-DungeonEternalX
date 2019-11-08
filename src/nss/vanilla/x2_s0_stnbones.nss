//::///////////////////////////////////////////////
//:: Stone Bones
//:: X2_S0_StnBones
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Gives the target +3 AC Bonus to Natural Armor.
   Only if target creature is undead.
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
   object oTarget = GetSpellTargetObject();
   int nCasterLvl = nPureLevel;
   int nDuration  = nCasterLvl * 10;
   int nMetaMagic = GetMetaMagicFeat();
   int nRacial = GetRacialType(oTarget);
   effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
   //Check for metamagic extend
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   //Set the one unique armor bonuses
   effect eAC1 = EffectACIncrease(3 + nPureBonus, AC_NATURAL_BONUS);

   //Stacking Spellpass, 2003-07-07, Georg
   RemoveEffectsFromSpell(oTarget, GetSpellId());

   //Apply the armor bonuses and the VFX impact
   if (nRacial == RACIAL_TYPE_UNDEAD) {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC1, oTarget, TurnsToSeconds(nDuration));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   } else {
      FloatingTextStrRefOnCreature(85390,OBJECT_SELF); // only affects undead;
   }
}

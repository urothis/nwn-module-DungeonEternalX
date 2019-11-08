//::///////////////////////////////////////////////
//:: Greater Spell Mantle
//:: NW_S0_GrSpTurn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Grants the caster 1d12 + 10 spell levels of
   absorbtion.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   int nAbsorb;
   int nDice;
   int nAdd;
   int nSpellID = GetSpellId();
   if (nSpellID==SPELL_LESSER_SPELL_MANTLE) { // innate 5
      nAdd = 6;
      nDice = 4;
   } else if (nSpellID==SPELL_SPELL_MANTLE) { // innate 7
      nAdd = 8;
      nDice = 8;
   } else if (nSpellID==SPELL_GREATER_SPELL_MANTLE) { // innate 9
      nAdd = 10;
      nDice = 12;
   }
   nAbsorb = Random(nDice) + 1 + nAdd + nPureBonus;
   int nDuration = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic==METAMAGIC_MAXIMIZE) nAbsorb = nDice + nAdd + nPureBonus;
   if (nMetaMagic==METAMAGIC_EMPOWER) nAbsorb += (nAbsorb/2); //Damage/Healing is +50%
   if (nMetaMagic==METAMAGIC_EXTEND)  nDuration *= 2; //Duration is +100%


   //Link Effects
   effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
   effect eAbs = EffectSpellLevelAbsorption(9, nAbsorb);
   effect eLink = EffectLinkEffects(eVis, eAbs);

   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
   RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);
   RemoveEffectsFromSpell(oTarget, SPELL_LESSER_SPELL_MANTLE);
   RemoveEffectsFromSpell(oTarget, SPELL_SPELL_MANTLE);

   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

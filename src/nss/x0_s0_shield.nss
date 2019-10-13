//::///////////////////////////////////////////////
//:: Shield
//:: x0_s0_shield.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Immune to magic Missile
   +4 general AC
   DIFFERENCES: should be +7 against one opponent
   but this cannot be done.
   Duration: 1 turn/level
*/

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = OBJECT_SELF;
   effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
   int nMetaMagic = GetMetaMagicFeat();

   effect eArmor = EffectACIncrease(4 + nPureBonus/4, AC_DEFLECTION_BONUS);
   effect eSpell = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
   effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);

   effect eLink = EffectLinkEffects(eArmor, eDur);
   eLink = EffectLinkEffects(eLink, eSpell);

   int nDuration = nPureLevel;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
   //Fire spell cast at event for target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 417, FALSE));

   RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());

   //Apply VFX impact and bonus effects
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}




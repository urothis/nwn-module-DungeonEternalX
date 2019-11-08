//::///////////////////////////////////////////////
//:: Ghostly Visage
//:: NW_S0_MirrImage.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Caster gains 5/+1 Damage reduction and immunity
   to 1st level spells.
*/
#include "pure_caster_inc"
#include "x2_inc_spellhook"
#include "assn_bonus"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;
   int nSpell     = GetSpellId();

   object oTarget = GetSpellTargetObject();
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOSTLY_VISAGE, FALSE));

    if (nSpell == 605) // Cory - Assassin Ghostly Visage - "Agility"
    {
        AssnVisage(oTarget);
        return;
    }

   int nPower = DAMAGE_POWER_PLUS_ONE;
   if      (nPureBonus < 3) nPower = DAMAGE_POWER_PLUS_ONE;
   else if (nPureBonus < 5) nPower = DAMAGE_POWER_PLUS_TWO;
   else if (nPureBonus < 7) nPower = DAMAGE_POWER_PLUS_THREE;
   else if (nPureBonus < 9) nPower = DAMAGE_POWER_PLUS_FOUR;
   effect eDam = EffectDamageReduction(5, nPureBonus);
   effect eSpell = EffectSpellLevelAbsorption(1 + nPureBonus/4);
   effect eConceal = EffectConcealment(10 + nPureBonus);
   effect eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
   effect eLink = EffectLinkEffects(eDam, eVis);
   eLink = EffectLinkEffects(eLink, eSpell);
   eLink = EffectLinkEffects(eLink, eConceal);
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = nPureLevel;

   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

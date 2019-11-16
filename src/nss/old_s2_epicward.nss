//::///////////////////////////////////////////////
//:: Epic Ward
//:: X2_S2_EpicWard.
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pure_caster_inc"

void main () {
   if (!X2PreSpellCastCode()) return;
   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    int nReduction = 25;
    int nLimit = 25 * nPureLevel;
    int nDamagePower = DAMAGE_POWER_PLUS_SIX;
    if (nPureBonus > 0) {
        nReduction = 35;
        nLimit = 35 * nPureLevel;
        nDamagePower = DAMAGE_POWER_PLUS_SEVEN;
    }
    effect eDur = EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR);
    effect eProt = EffectDamageReduction(nReduction, nDamagePower, nLimit);
    effect eLink = EffectLinkEffects(eDur, eProt);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = ExtraordinaryEffect(eLink);
    RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration)); // Make it last forever til nLimit absorbed -Arres
}

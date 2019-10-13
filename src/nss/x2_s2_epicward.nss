//::///////////////////////////////////////////////
//:: Epic Ward
//:: X2_S2_EpicWard.
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pure_caster_inc"

void main ()
{
    if (!X2PreSpellCastCode()) return;

    object oTarget = GetSpellTargetObject();
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    int nAbility = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE, TRUE);
    int nCha = GetAbilityScore(oTarget, ABILITY_CHARISMA, TRUE);
    if (nCha > nAbility) nAbility = nCha;

    int nPM = GetLevelByClass(CLASS_TYPE_PALEMASTER, oTarget);
    int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oTarget);

    int nReduction = 10;
    if (nPM >= 10 || nMonk >= 6) nReduction = 5;
    int nDamagePower = DAMAGE_POWER_PLUS_SEVEN;

    effect eDmgImmunity = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, nAbility);
    eDmgImmunity = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, nAbility), eDmgImmunity);
    eDmgImmunity = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, nAbility), eDmgImmunity);

    effect eDur  = EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR);
    effect eProt = EffectDamageReduction(nReduction, nDamagePower, nAbility*10);
    effect eLink = EffectLinkEffects(eDur, eProt);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDmgImmunity);
    eLink = ExtraordinaryEffect(eLink);

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
}

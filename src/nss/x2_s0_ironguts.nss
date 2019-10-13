//::///////////////////////////////////////////////
//:: Ironguts
//:: X2_S0_Ironguts
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: When touched the target creature gains a +4
//:: circumstance bonus on Fortitude saves against
//:: all poisons.

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    object oTarget = GetSpellTargetObject();
    effect eSave;
    effect eLink;
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEAD_ACID);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    int nBonus = 4 + nPureBonus; //Saving throw bonus to be applied
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = nPureLevel * 10; // Turns
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
    //Set the bonus save effect

    object oItem   = GetSpellCastItem();
    if (GetBaseItemType(oItem) == BASE_ITEM_POTIONS)
    {
        if (GetTag(oItem) == "POT_ICYIRONGUTS")
        {
            nBonus += 2; // to make save vs potion +6
            eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 6, SAVING_THROW_TYPE_COLD);
            eLink = EffectLinkEffects(eSave, eLink);
            eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 25), eLink);
            eLink = EffectLinkEffects(EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 25), eLink);
            eLink = EffectLinkEffects(EffectSavingThrowDecrease(SAVING_THROW_ALL, 3, SAVING_THROW_TYPE_FIRE), eLink);
            eVis = EffectVisualEffect(VFX_IMP_HEAD_COLD);
        }
    }

    eLink = EffectLinkEffects(EffectSavingThrowIncrease(SAVING_THROW_FORT, nBonus, SAVING_THROW_TYPE_POISON), eLink);

    //Apply the bonus effect and VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    DelayCommand(0.3,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
}

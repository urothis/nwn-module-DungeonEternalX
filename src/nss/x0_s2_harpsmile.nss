//::///////////////////////////////////////////////
//:: Tymora's Smile
//:: x0_s2_HarpSmile
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "nw_i0_spells"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    if (oTarget != OBJECT_SELF)
    {
        FloatingTextStringOnCreature("Cast only to self allowed", OBJECT_SELF);
        return;
    }

    int nAmount = 5;
    int nMonk   = GetLevelByClass(CLASS_TYPE_MONK, oTarget);
    nAmount    -= nMonk / 3; //-1 Save every 3 monk levels

    SignalEvent(oTarget, EventSpellCastAt(oTarget, 478, FALSE));
    if (nAmount < 1) return;

    effect eSaving = EffectSavingThrowIncrease(SAVING_THROW_ALL, nAmount, SAVING_THROW_TYPE_ALL);
    effect eDur    = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis    = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eLink   = EffectLinkEffects(eSaving, eDur);
    eLink          = ExtraordinaryEffect(eLink);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(10));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

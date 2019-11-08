//::///////////////////////////////////////////////
//:: Sanctuary
//:: NW_S0_Sanctuary.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes the target creature invisible to hostile
    creatures unless they make a Will Save to ignore
    the Sanctuary Effect
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "pure_caster_inc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    object oTarget = GetSpellTargetObject();
    effect eVis    = EffectVisualEffect(VFX_DUR_SANCTUARY);
    effect eSanc   = EffectSanctuary(nPureDC);

    effect eLink = EffectLinkEffects(eVis, eSanc);

    int nDuration  = 2;
    int nMetaMagic = GetMetaMagicFeat();

    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SANCTUARY, FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}


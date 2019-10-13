//::///////////////////////////////////////////////
//:: Invisibility
//:: NW_S0_Invisib.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature becomes invisibility
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "assn_bonus"

void main()
{
    if (!X2PreSpellCastCode()) return;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nSpell     = GetSpellId();

    if (nSpell == 607) // Cory - Assassin Invisibilty - "Mark Target"
    {
        AssnInvis(oTarget);
        return;
    }

    effect eInvis  = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));

    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;



    if (nSpell == 483) // Harper Scout Invisibility
    {
        effect eVis   = EffectVisualEffect(VFX_DUR_INVISIBILITY);
        effect eCover = EffectConcealment(50);
        eCover        = EffectLinkEffects(eVis, eCover);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCover, oTarget, TurnsToSeconds(nDuration));
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, TurnsToSeconds(nDuration));
}


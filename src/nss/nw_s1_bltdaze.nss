//::///////////////////////////////////////////////
//:: Bolt: Daze
//:: NW_S1_BltDaze
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11 , 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    if (GetIsReactionTypeHostile(oTarget) == FALSE) return;
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eBolt = EffectDazed();
    eBolt = GetScaledEffect(eBolt, oTarget);
    effect eLink = EffectLinkEffects(eBolt, eVis);

    int nCount = (nHD + 1) / 2;
    nCount = GetScaledDuration(nCount, oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_DAZE));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
       //Apply the VFX impact and effects
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCount));
    }
}

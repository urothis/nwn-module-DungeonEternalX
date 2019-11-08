//::///////////////////////////////////////////////
//:: Bolt: Stun
//:: NW_S1_BltStun
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

#include "nw_i0_spells"
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    if (GetIsReactionTypeHostile(oTarget) == FALSE) return;
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eBolt = EffectStunned();
    eBolt = GetScaledEffect(eBolt, oTarget);
    int nCount = (nHD + 1) / 2;
    nCount = GetScaledDuration(nCount, oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_STUN));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
       //Apply the VFX impact and effects
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, RoundsToSeconds(nCount));
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}

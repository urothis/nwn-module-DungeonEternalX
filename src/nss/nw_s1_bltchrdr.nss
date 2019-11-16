//::///////////////////////////////////////////////
//:: Bolt: Charisma Drain
//:: NW_S1_BltChrDr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.  Fortitude  save is
    needed to avoid effect.
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
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eBolt;

    int nCount = (nHD /3);
    if (nCount == 0)
    {
        nCount = 1;
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_ABILITY_DRAIN_CHARISMA));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
        eBolt = EffectAbilityDecrease(ABILITY_CHARISMA, nCount);
        eBolt = SupernaturalEffect(eBolt);
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBolt, oTarget, RoundsToSeconds(nHD));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}

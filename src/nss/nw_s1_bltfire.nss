//::///////////////////////////////////////////////
//:: Bolt: Fire
//:: NW_S1_BoltFire
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.  Reflex or Will save is
    needed to halve damage or avoid effect.
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
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eBolt;
    int nCount = nHD / 2;
    if (nCount < 1) nCount = 1;

    int nDamage = d3(nCount);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_FIRE));
    //Make a ranged touch attack
    int nTouch = TouchAttackRanged(oTarget);
    if(nTouch > 0)
    {
        if(nTouch == 2)
        {
            nDamage *= 2;
        }
        //Set damage effect
        eBolt = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
        if(nDamage > 0)
        {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}

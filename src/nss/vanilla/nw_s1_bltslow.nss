//::///////////////////////////////////////////////
//:: Bolt: Slow
//:: NW_S1_BltSlow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 18 , 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////
#include "pure_caster_inc"
#include "nw_i0_spells"
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    if (GetIsReactionTypeHostile(oTarget) == FALSE) return;
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eBolt = EffectSlow();
    int nCount = (nHD + 1) / 2;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_SLOW));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
       float fDuration = RoundsToSeconds(nCount);
       //Apply the VFX impact and effects
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, fDuration);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
       DelayCommand(0.1, ReapplyPermaHaste(oTarget, fDuration + 0.5));
    }
}

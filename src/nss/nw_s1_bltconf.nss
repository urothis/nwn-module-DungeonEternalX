//::///////////////////////////////////////////////
//:: Bolt: Confuse
//:: NW_S1_BltConf
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
    effect eVis2 = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eBolt = EffectConfused();
    effect eLink = EffectLinkEffects(eBolt, eVis);
    int nDC = 20;
    int nCount = (nHD + 1) / 2;
    int nTargetRoll = d20();
    int nWill = GetWillSavingThrow(oTarget);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_CONFUSE));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
       if ((nWill + nTargetRoll) > nDC && nTargetRoll != 1 && nTargetRoll == 20)
       {}
       else if ((nWill + nTargetRoll) < nDC && nTargetRoll == 1 && nTargetRoll != 20)
       {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCount));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
       }
    }
}

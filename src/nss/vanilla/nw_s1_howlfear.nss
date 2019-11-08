//::///////////////////////////////////////////////
//:: Howl: Fear
//:: NW_S1_HowlFear
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A howl emanates from the creature which affects
    all within 10ft unless they make a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 14, 2000
//:://////////////////////////////////////////////
//:: Updated By: Andrew Nobbs
//:: Updated On: FEb 26, 2003
//:: Note: Changed the faction check to GetIsEnemy
//:://////////////////////////////////////////////

#include "nw_i0_spells"
void main()
{
    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eHowl = EffectFrightened();
    effect eDur2 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_MIND);

    effect eLink = EffectLinkEffects(eHowl, eDur2);

    float fDelay;
    int nHD = GetHitDice(OBJECT_SELF);
    int nDC = 13 + (nHD/4);

    int nLevel;
    object oMaster = GetMaster(OBJECT_SELF);
    nLevel = GetLevelByClass(CLASS_TYPE_RANGER, oMaster);
    if (oMaster != OBJECT_INVALID)
    {
       if (nLevel == 40)
        {
            int nDC = 53;
        }
    }

    int nDuration = 1 + (nHD/10);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsEnemy(oTarget) && oTarget != OBJECT_SELF)
        {
            fDelay = GetDistanceToObject(oTarget)/10;
            nDuration = GetScaledDuration(nDuration , oTarget);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_HOWL_FEAR));

            //Make a saving throw check
            if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
            {
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}


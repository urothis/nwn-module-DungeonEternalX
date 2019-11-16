//::///////////////////////////////////////////////
//:: Remove Fear
//:: NW_S0_RmvFear.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within a 10ft radius have their fear
    effects removed and are granted a +4 Save versus
    future fear effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 13, 2001
//:://////////////////////////////////////////////
#include "nw_i0_spells"

#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode()) return;

    // Special Harper Scout item (Harper Scout's Rally Song)
    object oItem = GetSpellCastItem();
    if (GetBaseItemType(oItem) == BASE_ITEM_MISCMEDIUM  && GetTag(oItem) == "item_rallysong")
    {
        if (!GetLevelByClass(CLASS_TYPE_HARPER, OBJECT_SELF))
        {
            FloatingTextStringOnCreature("You do not have the inspiration ability of a Harper Scout", OBJECT_SELF);
            return;
        }
    }

    //Declare major variables
    object oTarget;
    effect eFear;
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = 100;
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
    float fDelay;
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    if(nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration*2;
    }

    //Get first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        //Only remove the fear effect from the people who are friends.
        if(GetIsFriend(oTarget))
        {
            fDelay = GetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REMOVE_FEAR, FALSE));
            eFear = GetFirstEffect(oTarget);
            //Get the first effect on the current target
            while(GetIsEffectValid(eFear))
            {
                if (GetEffectType(eFear) == EFFECT_TYPE_FRIGHTENED)
                {
                    //Remove any fear effects and apply the VFX impact
                    RemoveEffect(oTarget, eFear);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                //Get the next effect on the target
                eFear = GetNextEffect(oTarget);
            }
            //Apply the linked effects
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMind, oTarget, 1.0));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, RoundsToSeconds(nDuration)));
        }
        //Get the next target in the spell area.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    }
}


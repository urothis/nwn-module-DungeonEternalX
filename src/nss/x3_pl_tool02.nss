//::///////////////////////////////////////////////
//:: Player Tool 2 Instant Feat
//:: x3_pl_tool02
//:://////////////////////////////////////////////
/*
    This simply executes the script indicated by
    tk_playertools.2da.
*/
//:://////////////////////////////////////////////
//:: Created By: The Krit
//:: Created On: 2008-10-06
//:://////////////////////////////////////////////


#include "tk_ptool_inc"


void main()
{
    /*
    object oPC = OBJECT_SELF;
    if (GetLocalInt(oPC, "RangerDodgeActive")) return;

    int nValue;
    int nCount; //Counter for max Dodge AC uses/day
    int nUses;
    int nDD = GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER);

    if (GetLevelByClass(CLASS_TYPE_FIGHTER) >= 16 || nDD)
    {
        nValue = GetAbilityModifier(ABILITY_CONSTITUTION);
        nCount = GetLocalInt(oPC, "RangerDodgeCount");
        nUses  = nValue + 3;

        if (nCount >= nUses)
        {
            FloatingTextStringOnCreature("You can't use this ability anymore today", oPC);
            return;
        }
        if (!nCount)
        {
            if ((GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) < 25 && !nDD) || (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < 13 && !nDD) || GetLevelByClass(CLASS_TYPE_MONK) || GetLevelByClass(CLASS_TYPE_PALE_MASTER))
            {
                FloatingTextStringOnCreature("You can't use this ability", oPC);
                return;
            }
        }
    }

    int nAC = nValue;
    int nDur = nValue;

    if (GetLevelByClass(CLASS_TYPE_CLERIC) && nAC > 1) nAC -= 2;
    if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE) && nAC > 1) nAC -= 2;

    if (GetLevelByClass(CLASS_TYPE_RANGER) >= 4)
    {
        nValue = GetAbilityModifier(ABILITY_WISDOM, oPC);
        nCount = GetLocalInt(oPC, "RangerDodgeCount");
        nUses  = nValue + 3;

        if (nCount >= nUses)
        {
            FloatingTextStringOnCreature("You can't use this ability anymore today", oPC);
        }
        else if (!GetLevelByClass(CLASS_TYPE_MONK, oPC))
        {
            nAC += nValue;
            nDur += nValue;
        }
    }

    effect eBonus = ExtraordinaryEffect(EffectACIncrease(nAC));
    effect eVis   = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, RoundsToSeconds(nDur));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    SendMessageToPC(oPC, IntToString(nUses-(nCount+1)) + " Fighter Dodge uses left for today");

    // Set Timer to prevent stacking
    SetLocalInt(oPC, "RangerDodgeActive", TRUE);
    DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oPC, "RangerDodgeActive"));

    //Counter for max Dodge AC uses/day
    SetLocalInt(oPC, "RangerDodgeCount", nCount+1); // Delete this after rest!

    //DoPlayerTool(2);
    */

}


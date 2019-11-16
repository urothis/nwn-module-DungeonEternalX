//::///////////////////////////////////////////////
//:: Player Tool 1 Instant Feat
//:: x3_pl_tool01
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
#include "nw_i0_spells"
#include "inc_traininghall"

void RemoveStanceBonus(object oPC)
{
    RemoveEffectsFromSpell(oPC, 830);
}

void CheckStanceApplyEffect(object oPC, int nLoopCnt, location lLoc)
{
    if (!GetIsObjectValid(oPC)) return;
    if (!GetHasSpellEffect(830, oPC)) // player rested, stop here
    {
        SetLocalInt(oPC, "DD_PULSATING", 0);
        return;
    }
    int nLocalCnt = GetLocalInt(oPC, "DD_PULSATING");
    if (!nLoopCnt) // new stance, check if one is running allready
    {
        if (nLocalCnt) return; // local is not 0, another pulse active
    }
    int nDoEffect;
    int nStance = GetActionMode(oPC, 12);

    if (!nStance) // pc is not in stance but pulse is active, check for radius
    {
        float fDist = GetDistanceBetweenLocations(lLoc, GetLocation(oPC));
        if (fDist > -1.0 && fDist < 10.0) nDoEffect = TRUE;
        nLoopCnt = 0;
    }
    if (!nLoopCnt && nStance) // setting new stance radius, do special effect
    {
        effect eVFX1 = EffectLinkEffects(EffectVisualEffect(VFX_IMP_SUPER_HEROISM), EffectVisualEffect(354));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_STONESKIN), oPC, 1.0);
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX1, oPC));
    }

    nLoopCnt++;

    if (nDoEffect || nStance)
    {
        if (nStance)
        {
            lLoc = GetLocation(oPC);
            int nHeal = GetMaxHitPoints(oPC)/100;
            nHeal = 100 - (GetCurrentHitPoints(oPC)/nHeal);
            if (nHeal > 90)         nHeal = nHeal/3;
            else if (nHeal > 60)    nHeal = nHeal/4;
            else if (nHeal > 30)    nHeal = nHeal/5;
            else                    nHeal = 0;
            if (nHeal)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oPC);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oPC);
            }
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(135), lLoc);

        nLoopCnt++;
        DelayCommand(RoundsToSeconds(2), CheckStanceApplyEffect(oPC, nLoopCnt, lLoc));
        SetLocalInt(oPC, "DEFSTANCE_CNT_ATTEMPTS", 0);
        SetLocalInt(oPC, "DD_PULSATING", nLoopCnt);
        return;
    }
    // player not in stance, check later
    int nCnt = GetLocalInt(oPC, "DEFSTANCE_CNT_ATTEMPTS");
    nCnt++;
    if (nCnt > 3)
    {
        SetLocalInt(oPC, "DD_PULSATING", 0); // stance pulse ended
        RemoveStanceBonus(oPC);
        return;
    }
    SetLocalInt(oPC, "DEFSTANCE_CNT_ATTEMPTS", nCnt);
    DelayCommand(2.0, CheckStanceApplyEffect(oPC, nLoopCnt, lLoc));
}

void main()
{
    object oPC = OBJECT_SELF;
    // if (!GetIsTestChar(oPC)) return;
    /*if (GetActionMode(oPC, 12)) // is in stance
    {
        SetActionMode(oPC, 12, FALSE); // stop it
        return;
    }*/
    if (GetHasSpellEffect(830, oPC)) return;
    // RemoveEffectsFromSpell(oPC, 830);

    int nDD = GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oPC);
    int nAC;
    effect eLink;
    if (GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) >= 25 && nDD >= 6)
    {
        if (!GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC))
        {
            if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) > 21)
            {
                nAC = 6;
                if      (nDD >= 22) nAC = 14;
                else if (nDD >= 18) nAC = 12;
                else if (nDD >= 14) nAC = 10;
                else if (nDD >= 10) nAC = 8;
                eLink = EffectACIncrease(nAC, AC_NATURAL_BONUS);
            }
        }
    }
    int nDisc = 4 + GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    if (nDisc > 20) nDisc = 20;
    eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DISCIPLINE, nDisc));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), oPC);

    effect eVFX1 = EffectLinkEffects(EffectVisualEffect(VFX_IMP_SUPER_HEROISM), EffectVisualEffect(354));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_STONESKIN), oPC, 1.0);
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX1, oPC));
    // SetActionMode(oPC, 12, TRUE);
    // DelayCommand(0.2, CheckStanceApplyEffect(oPC, 0, GetLocation(oPC)));
    // DoPlayerTool(1);
}


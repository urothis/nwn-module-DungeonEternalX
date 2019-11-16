#include "db_inc"
#include "_inc_character"
#include "x2_i0_spells"
#include "arres_inc"
#include "_functions"
#include "enc_inc"
#include "gen_inc_color"

void ItemSoldCheck(object oItem, object oPC)
{
    if (GetIsObjectValid(oItem))
    {
        AssignCommand(oPC, ClearAllActions());
        CopyItem(oItem, oPC, TRUE);
        Insured_Destroy(oItem);
    }
}

int CheckTrap(object oPC, object oTrap)
{
    string sMsg;
    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);
    int nCnt = 1;
    int nType = GetObjectType(oTrap);
    if (nType == OBJECT_TYPE_PLACEABLE)
    {
        sMsg = "Can not set traps on placeables";
    }
    else if (nType == OBJECT_TYPE_DOOR)
    {
        sMsg = "Can not set traps on doors";
    }
    else
    {
        object oNextTrap = GetNearestObject(OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER, oTrap, nCnt);
        float fDist;
        while (GetIsObjectValid(oNextTrap))
        {
            fDist = GetDistanceBetween(oNextTrap, oTrap);
            if (GetIsObjectValid(GetTransitionTarget(oNextTrap)))
            {
                if (fDist < 10.0)
                {
                    sMsg = "To close to transition";
                    break;
                }
            }
            else if (fDist > 3.0) return TRUE;
            else if (GetIsTrapped(oNextTrap))
            {
                sMsg = "To close to other trap";
                break;
            }
            nCnt++;
            oNextTrap = GetNearestObject(OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER, oTrap, nCnt);
        }
    }
    location lLoc = GetLocation(oTrap);
    DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc));
    DelayCommand(2.0, SetTrapDisabled(oTrap));
    DelayCommand(2.0, FloatingTextStringOnCreature(sMsg, oPC));
    return FALSE;
}

void DisableTrap(object oTrap)
{
    if (GetIsObjectValid(oTrap)) SetTrapDisabled(oTrap);
}

void LongswordExploitNOUA(object oItem)
{
    object oNewOwner = GetItemPossessor(oItem);
    string sName;
    if (GetIsPC(oNewOwner)) sName = IntToString(dbGetTRUEID(oNewOwner));
    else sName = GetName(oNewOwner);
    SetLocalString(oItem, "NEW_OWNER", sName);
    dbLogMsg(GetLocalString(oItem, "LAST_OWNER") + " gave " + sName + " illegal Longsword","EXPLOIT",dbGetTRUEID(oNewOwner),dbGetDEXID(oNewOwner),dbGetLIID(oNewOwner),dbGetPLID(oNewOwner));
}

void LongswordExploitUnacquire(object oItem, object oPC)
{
    if (GetTag(oItem) != "NW_WSWLS001") return;

    DelayCommand(0.3, SetLocalString(oItem, "LAST_OWNER", IntToString(dbGetTRUEID(oPC))));
    DelayCommand(0.6, LongswordExploitNOUA(oItem));
}

void main()
{
    object oPC = GetModuleItemLostBy();
    if (!GetIsPC(oPC)) return;

    object oItem = GetModuleItemLost();
    int nBIType = GetBaseItemType(oItem);

    LongswordExploitUnacquire(oItem, oPC);
    if (GetBaseItemType(oItem) == BASE_ITEM_TRAPKIT)
    {
        if (!GetIsObjectValid(GetItemPossessor(oItem)) && !GetIsObjectValid(GetArea(oItem)))
        {
            object oTrap = GetNearestTrapToObject(oPC, FALSE);
            if (GetIsObjectValid(oTrap))
            {
                if (CheckTrap(oPC, oTrap)) AssignCommand(GetArea(oTrap), DelayCommand(900.0, DisableTrap(oTrap)));
            }
        }
    }

    if (GetIsInCombat(oPC))
    {
        if (GetMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            if (!GetStolenFlag(oItem))
            {
                DelayCommand(1.0, ItemSoldCheck(oItem, oPC));
                //disarm
                effect eABLoss    = EffectAttackDecrease(10);
                effect eVis       = EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND);
                effect eSkillLoss = EffectSkillDecrease(SKILL_DISCIPLINE, 5);
                effect eSpeed     = EffectMovementSpeedDecrease(50);
                float fDur        = RoundsToSeconds(5);
                effect eLink = EffectLinkEffects(eABLoss, eVis);
                eLink        = EffectLinkEffects(eLink, eSkillLoss);
                eLink        = EffectLinkEffects(eLink, eSpeed);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
                DelayCommand(fDur, ReapplyPermaHaste(oPC, fDur + 0.5));
                return;
            }
        }
    }
    if (GetStolenFlag(oItem))
    {
        object oFinder = GetItemPossessor(oItem);
        if (GetIsPC(oFinder) && !GetIsDM(oFinder))
        {
            if (GetDroppableFlag(oItem))
            {
                int nPCLvl = GetHitDice(oPC);
                if (GetLocalInt(oPC, "CRAFTER_MAX_LEVEL")) // is a crafter
                {
                    SendMessageToPC(oFinder, "You thief! Stop trying to steal from the crafters.");
                    CursePC(oFinder);
                }
                else if (nPCLvl == 40 || nPCLvl < 12)
                {
                    SendMessageToPC(oFinder, "Pickpocket target only between level 12-39 allowed.");
                }
                else if (GetLocalString(oItem, "OWNER") != "")
                {
                    // It's a bound epic item
                    SendMessageToPC(oFinder, "This item is bound to character, you can not pickpocket it.");
                }
                else
                {
                    int nPPRoll = d20(1);
                    int nDC = FloatToInt(GetHitDice(oPC) * 2.5);
                    int nSkill = GetSkillRank(SKILL_PICK_POCKET, oFinder);
                    int nPPClasses = GetLevelByClass(CLASS_TYPE_ROGUE, oFinder);
                    nPPClasses += GetLevelByClass(CLASS_TYPE_BARD, oFinder);
                    nPPClasses += GetLevelByClass(CLASS_TYPE_ASSASSIN, oFinder);
                    nPPClasses += GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oFinder);
                    nSkill += nPPClasses;

                    if ((nSkill + nPPRoll >= nDC || nPPRoll == 20))
                    {
                        SendMessageToPC(oFinder, "Pick Pocket " + IntToString(nSkill) + " + " + IntToString(nPPRoll) + " = " + IntToString(nPPRoll + nSkill) + " vs DC " + IntToString(nDC) + " *Success*");
                        if (nPPRoll == 1)
                        {
                            ShoutMsg(GetRGB(15,5,1) + GetName(oFinder) + " has stolen " + GetName(oItem) + " from " + GetName(oPC) + " at " + GetName(GetArea(oPC)));
                        }
                        return; // PP success!
                    }
                    else
                    {
                        SendMessageToPC(oFinder, "Pick Pocket " + IntToString(nSkill) + " + " + IntToString(nPPRoll) + " = " + IntToString(nPPRoll + nSkill) + " vs DC " + IntToString(nDC) + " *Failure*");
                    }
                }
                // gives the item back.
                object oItem2 = CopyItem(oItem, oPC, TRUE);
                SetIdentified(oItem2, TRUE);
                SetPlotFlag(oItem, FALSE);
                Insured_Destroy(oItem);
            }
        }
    }

    if (GetLocalString(oItem, "OWNER") == "") DelayCommand(3.0, CheckJunkAssignDestroy(oItem));
}


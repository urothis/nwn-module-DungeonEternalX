#include "nw_i0_plot"
#include "random_loot_inc"
#include "_functions"
#include "quest_inc"
#include "tradeskills_inc"

int nCraftingCountDeleteItem(object oChest, string sTag, int nSeconds, int nDelete = TRUE)
{
    int nCount;
    int nStack;
    int nTotalTime = nSeconds;
    object oItem = GetFirstItemInInventory(oChest);
    int nTimeLeft = (GetLocalInt(GetModule(), SERVER_TIME_LEFT) - 5) * 60;
    if  (nTimeLeft < nTotalTime)
    {
        SpeakString("Aborted, too close to server reset!");
        return 0;
    }

    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == sTag)
        {
            nStack = GetItemStackSize(oItem);
            if (nStack > 1) nCount += nStack;
            else nCount++;
            if (nDelete) DestroyObject(oItem);
            nTotalTime += nSeconds;
            if (nTimeLeft < nTotalTime)
            {
                SetLocalInt(oChest, "SERVER_RESET", TRUE);
                return nCount;
            }
            else if (nTotalTime > 5000) return nCount;

        }
        oItem = GetNextItemInInventory(oChest);
    }
    return nCount;
}

void nCraftingDeleteStacked(object oChest, string sTag, int nDeleteCnt)
{
    int nStack;
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem) && nDeleteCnt)
    {
        if (GetTag(oItem) == sTag)
        {
            nStack = GetItemStackSize(oItem);
            if (nStack < 2)
            {
                DestroyObject(oItem);
                nDeleteCnt--;
            }
            else
            {
                if (nStack >= nDeleteCnt)
                {
                    nStack -= nDeleteCnt;
                    if (nStack > 0) SetItemStackSize(oItem, nStack);
                    else DestroyObject(oItem);
                    return;
                }
                else
                {
                    nDeleteCnt -= nStack;
                    DestroyObject(oItem);
                }
            }
        }
        oItem = GetNextItemInInventory(oChest);
    }
}

void nCraftingStoreItemCharges(object oChest, string sTag, int nCount)
{
    int nCharge;
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem) && nCount)
    {
        if (GetTag(oItem) == sTag)
        {
            nCharge = GetItemCharges(oItem);
            if (!nCharge) nCharge = GetItemStackSize(oItem);
            AddIntElement(nCharge, sTag, oChest);
            nCount--;
        }
        oItem = GetNextItemInInventory(oChest);
    }
}

void CraftingDoPots(object oChest, int nItemCount, int nMultiplyCnt, string sPotTag)
{
    if (nMultiplyCnt) nItemCount = nItemCount * nMultiplyCnt;
    object oPot = LootGetItemByTag(sPotTag);
    object oNewPot;
    while (nItemCount > 0)
    {
        oNewPot = CopyItem(oPot, oChest, TRUE);
        if (nItemCount < 100)
        {
            SetItemStackSize(oNewPot, nItemCount);
            break;
        }
        else
        {
            SetItemStackSize(oNewPot, 99);
            nItemCount = nItemCount - 99;
         }
    }
}

void main()
{
    object oChest = OBJECT_SELF;
    string sChest = GetTag(oChest);
    object oPC = GetLastClosedBy();
    object oItem;
    float fDelay;
    SetLocked(oChest, TRUE);

    if (sChest == "CRAFTING_QUERNSTONE")
    {
        if (HasItem(oChest, "SKELETON_KNUCKLE"))
        {
            int nSeconds = TS_AdjustCraftingTime(oPC, 90 + d3(), "ts_milling");
            int nItemCount = nCraftingCountDeleteItem(oChest, "SKELETON_KNUCKLE", nSeconds);
            TS_IncreaseSkill(oPC, nItemCount, "ts_milling");

            fDelay = IntToFloat(nItemCount*nSeconds);
            while (nItemCount > 0)
            {
                oItem = CreateItemOnObject("crafting_dust", oChest, 1, "DUST_BONE");
                SetItemCharges(oItem, 12+d8());
                SetName(oItem, "Bone Dust");
                nItemCount--;
            }
        }
    }
// #############################################################################
    else if (sChest == "CRAFTING_DISTILLER")
    {
        int nMultiplyCnt;   int nItemCount;
        string sPotTag;

        int nSeconds = TS_AdjustCraftingTime(oPC, 90 + d3(), "ts_brewing");

        if (HasItem(oChest, "DARK_CYPRESS"))
        {
            nItemCount = nCraftingCountDeleteItem(oChest, "DARK_CYPRESS", nSeconds);
            sPotTag = "LOOT_POT_NEP";
        }
        else if (HasItem(oChest, "CORN_FLOWER"))
        {
            nItemCount = nCraftingCountDeleteItem(oChest, "CORN_FLOWER", nSeconds);
            nMultiplyCnt = 5;
            sPotTag = "LOOT_POT_ELEMINOR";
        }
        else if (HasItem(oChest, "SYCAMORE"))
        {
            nItemCount = nCraftingCountDeleteItem(oChest, "SYCAMORE", nSeconds);
            nMultiplyCnt = 5;
            sPotTag = "POT_EXT_AID";
        }
        else if (HasItem(oChest, "TEMPLEPLANT"))
        {
            nItemCount = nCraftingCountDeleteItem(oChest, "TEMPLEPLANT", nSeconds);
            nMultiplyCnt = 5;
            sPotTag = "POT_EXT_BLESS";
        }
        else if (HasItem(oChest, "EPHEDRA"))
        {
            nItemCount = nCraftingCountDeleteItem(oChest, "EPHEDRA", nSeconds);
            nMultiplyCnt = 5;
            sPotTag = "POT_EXT_MA";
        }

        if (nItemCount)
        {
            Q_UpdateQuest(oPC, "14", FALSE, IntToString(Q_GetHasQuest(oPC, "14", FALSE) + nItemCount));
            TS_IncreaseSkill(oPC, nItemCount, "ts_brewing");
            fDelay = IntToFloat(nItemCount*nSeconds);
            DelayCommand(1.0, CraftingDoPots(oChest, nItemCount, nMultiplyCnt, sPotTag));
        }
    }
// #############################################################################
    else if (sChest == "CRAFTING_ALCHEMIST")
    {
        if (HasItem(oChest, "DUST_BONE"))
        {
            if (HasItem(oChest, "LOOT_POT_NEP"))
            {
                int nSeconds = TS_AdjustCraftingTime(oPC, 90 + d3(), "ts_alchemy");
                int nItemCount = GetMin(nCraftingCountDeleteItem(oChest, "DUST_BONE", nSeconds, FALSE), nCraftingCountDeleteItem(oChest, "LOOT_POT_NEP", nSeconds, FALSE));
                TS_IncreaseSkill(oPC, nItemCount, "ts_alchemy");
                fDelay = IntToFloat(nItemCount*nSeconds);

                nCraftingStoreItemCharges(oChest, "DUST_BONE", nItemCount);
                nCraftingDeleteStacked(oChest, "DUST_BONE", nItemCount);
                nCraftingDeleteStacked(oChest, "LOOT_POT_NEP", nItemCount);

                while (nItemCount > 0)
                {
                    oItem = CreateItemOnObject("poison_neg_dmg", oChest, 1, "POISON_NEG_DMG");
                    SetItemCharges(oItem, GetIntElement(nItemCount - 1, "DUST_BONE", oChest));
                    nItemCount--;
                }
                DeleteList("DUST_BONE", oChest);
            }
        }
        else if (HasItem(oChest, "RAW_BULLETS"))
        {
            if (HasItem(oChest, "LOOT_POT_ELEMINOR"))
            {
                int nSeconds = TS_AdjustCraftingTime(oPC, 90 + d3(), "ts_alchemy");
                int nItemCount = GetMin(nCraftingCountDeleteItem(oChest, "RAW_BULLETS", nSeconds, FALSE), nCraftingCountDeleteItem(oChest, "LOOT_POT_ELEMINOR", nSeconds, FALSE));
                TS_IncreaseSkill(oPC, nItemCount, "ts_alchemy");
                fDelay = IntToFloat(nItemCount*nSeconds);

                nCraftingDeleteStacked(oChest, "RAW_BULLETS", nItemCount);
                nCraftingDeleteStacked(oChest, "LOOT_POT_ELEMINOR", nItemCount);

                while (nItemCount > 0)
                {
                    oItem = CreateItemOnObject("onhit_bullets", oChest, 99, "onhit_elecbullet");
                    SetName(oItem, "Lightning Bullets");
                    nItemCount--;
                }
            }
        }
    }
// #############################################################################
    else if (sChest == "CRAFTING_POT")
    {
        if (HasItem(oChest, "YEENOGHU_IDOL"))
        {
            int nSeconds = TS_AdjustCraftingTime(oPC, 90 + d3(), "ts_melting");
            int nItemCount = nCraftingCountDeleteItem(oChest, "YEENOGHU_IDOL", nSeconds);
            TS_IncreaseSkill(oPC, nItemCount, "ts_melting");
            fDelay = IntToFloat(nItemCount*nSeconds);
            while (nItemCount > 0)
            {
                CreateItemOnObject("raw_bullets", oChest, 10, "RAW_BULLETS");
                nItemCount--;
            }
        }
        else if (HasItem(oChest, "BAR_OF_SILVER"))
        {
            int nSeconds = TS_AdjustCraftingTime(oPC, 90 + d3(), "ts_melting");
            int nItemCount = nCraftingCountDeleteItem(oChest, "BAR_OF_SILVER", nSeconds);
            TS_IncreaseSkill(oPC, nItemCount, "ts_melting");
            fDelay = IntToFloat(nItemCount*nSeconds);
            while (nItemCount > 0)
            {
                CreateItemOnObject("raw_bullets", oChest, 3, "RAW_BULLETS");
                nItemCount--;
            }
        }
    }
// #############################################################################
    if (fDelay > 0.0)
    {
        string sResetMsg;
        if (GetLocalInt(GetModule(), SERVER_TIME_LEFT) < 5 || GetLocalInt(oChest, "SERVER_RESET"))
        {
            sResetMsg = " (Close to Server reset!)";
        }
        DeleteLocalString(oChest, "SERVER_RESET");
        int nTime = FloatToInt(fDelay);
        SpeakString("Finished in " + ConvertSecondsToString(nTime) + sResetMsg);
        SetLocalInt(oChest, "TICK", GetTick() + nTime / 120);
    }
    DelayCommand(fDelay + 1.0, SetLocked(oChest, FALSE));
}

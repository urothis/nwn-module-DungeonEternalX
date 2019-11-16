#include "zdlg_include_i"
#include "zdialog_inc"
#include "epic_inc"
#include "db_inc"
#include "dmg_stones_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

const int EPICITEM_SELL_ACTION       = 1;
const int EPICITEM_DESTROY_ACTION    = 2;

const int EPICITEM_ITEM_OPTION_PAGE = 101;

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

string EpicSellFameReturn(string sPaid)
{
    return IntToString(StringToInt(sPaid)/100 * 97);
}

string GetEpicCraftReturn(object oItem)
{
    int nFame = DMGS_GetWeaponFameValue(oItem);
    return IntToString(nFame);
}

void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    string sPlayerFame, sItemName, sPaid, sTag, sFameReturn, sID, sStringLeft, sStatus;
    object oItem, oContainer;
    string sList = GetCurrentList(oHolder);
    int nID, nPlayerFame, nCost, nBound, nSpent;

    switch (nOptionSelected) {
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case EPICITEM_SELL_ACTION:
        oItem = GetObjectElement(GetDlgSelection(), sList + "_SUB", oHolder);
        SetLocalObject(oHolder, "EPIC_SELL_WORKING_ITEM", oItem);

        sTag = GetTag(oItem);
        sStringLeft = GetStringLeft(GetTag(oItem), 8);
        NWNX_SQL_ExecuteQuery("select paid, status from epic_item where plid=" + IntToString(dbGetPLID(oPC)) + " and tag=" + dbQuotes(sTag) + " and eiid=" + GetLocalString(oItem, "EIID") + " limit 1");
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sStatus = NWNX_SQL_ReadDataInActiveRow(1);
            if (sStatus != "active") // trashed or sold
            {
                SetShowMessage(oHolder, "ERROR - This item was " + sStatus + " already");
                return;
            }

            if (sStringLeft == "EPICITEM")
            {
                sPaid = NWNX_SQL_ReadDataInActiveRow(0);
                sFameReturn = EpicSellFameReturn(sPaid);
            }
            else if (sStringLeft == "EPICCRAF")
            {
                sFameReturn = GetEpicCraftReturn(oItem);
            }
            else
            {
                SetShowMessage(oHolder, "ERROR - item tag invalid");
                return;
            }
        }
        else
        {
            SetShowMessage(oHolder, "ERROR - Can not find entry in database, this item does not exist");
            return;
        }

        SetLocalString(oHolder, "EPIC_SELL_WORKING_ITEM_FAME", sFameReturn);

        if (sStringLeft == "EPICITEM")
        {
            SetConfirmAction(oHolder, "You have paid " + sPaid + " fame. Do you really want to sell " + GetName(oItem) + " for " + sFameReturn + " fame?", EPICITEM_DESTROY_ACTION);
        }
        else if (sStringLeft == "EPICCRAF")
        {
            SetConfirmAction(oHolder, "Do you really want to sell " + GetName(oItem) + " for " + sFameReturn + " fame?", EPICITEM_DESTROY_ACTION);
        }
        else
        {
            SetShowMessage(oHolder, "ERROR - item tag invalid");
            return;
        }
        return;
    case EPICITEM_DESTROY_ACTION:
        oItem = GetLocalObject(oHolder, "EPIC_SELL_WORKING_ITEM");
        if (GetItemPossessor(oItem) != oPC || !GetIsObjectValid(oItem))
        {
            SetShowMessage(oHolder, "Your slight of hand has not gone unnoticed. You anger me when you try to steal from me...");
            return;
        }
        sID = GetLocalString(oItem, "EIID");
        sFameReturn = GetLocalString(oHolder, "EPIC_SELL_WORKING_ITEM_FAME");

        nPlayerFame = GetLocalInt(oPC, "PLAYER_FAME") + StringToInt(sFameReturn);
        SetLocalInt(oPC, "PLAYER_FAME", nPlayerFame);

        nSpent = GetLocalInt(oPC, "PLAYER_FAME_SPENT");
        nSpent = nSpent - StringToInt(sFameReturn);
        SetLocalInt(oPC, "PLAYER_FAME_SPENT", nSpent);

        NWNX_SQL_ExecuteQuery("update epic_item set status='sold' where eiid=" + sID);
        Insured_Destroy(oItem);
        NWNX_SQL_ExecuteQuery("update trueid set fame=fame+" + sFameReturn + ", famespent=famespent-" + sFameReturn + " where trueid=" + IntToString(dbGetTRUEID(oPC)));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL), oPC);
        EndDlg();
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    object oHolder = OBJECT_SELF;
    object oItem;
    string sList = GetCurrentList(oHolder);
    string sCategory, sMsg, sBound, sTag;
    object oContainer;
    int nID, i;

    DeleteList(sList, oHolder);
    DeleteList(sList + "_SUB", oHolder);
    switch (nPage) {
    case ZDIALOG_MAIN_MENU:
        DeleteLocalInt(oHolder, sList + "_CONFIRM");
        SetDlgPrompt("Select equipped item:");
        for(i = 0; i < INVENTORY_SLOT_ARROWS; i++)
        {
            oItem = GetItemInSlot(i, oPC);
            if (GetIsObjectValid(oItem))
            {
                string sStringLeft = GetStringLeft(GetTag(oItem), 8);
                if (sStringLeft == "EPICITEM" || sStringLeft == "EPICCRAF")
                {
                    SetMenuOptionInt(InventorySlotString(i) + ": " + GetName(oItem), EPICITEM_SELL_ACTION, oHolder);
                    AddObjectElement(oItem, sList + "_SUB", oHolder);
                }
            }
         }
        return;
    case ZDIALOG_CONFIRM:
        DoConfirmAction(oHolder);
        return;
    case ZDIALOG_SHOW_MESSAGE:
        DoShowMessage(oHolder);
        return;
    }
}

void CleanUp(object oHolder)
{
    string sList = GetCurrentList(oHolder);
    CleanUpInc(oHolder);
    DeleteList(sList + "_SUB", oHolder);
    DeleteLocalObject(oHolder, "EPIC_SELL_WORKING_ITEM");
    DeleteLocalString(oHolder, "EPIC_SELL_WORKING_ITEM_FAME");
}

void main ()
{
    object oPC = GetPcDlgSpeaker();
    object oHolder = OBJECT_SELF;

    int iEvent = GetDlgEventType();
    switch(iEvent) {
    case DLG_INIT:
        SetNextPage(oHolder, ZDIALOG_MAIN_MENU);
        break;
    case DLG_PAGE_INIT:
        BuildPage(GetNextPage(oHolder), oPC);
        SetShowEndSelection(TRUE);
        SetDlgResponseList(GetCurrentList(oHolder), oHolder);
        break;
    case DLG_SELECTION:
        HandleSelection(oPC);
        break;
    case DLG_ABORT:
    case DLG_END:
        CleanUp(oHolder);
    break;
    }
}

#include "zdlg_include_i"
#include "zdialog_inc"
#include "epic_inc"
#include "db_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

const int EPICITEM_EXAMINE_ACTION   = 1;
const int EPICITEM_LIST_ITEM_HANDLE = 2;
const int EPICITEM_BUY_ACTION       = 3;
const int EPICITEM_DESCRIBE_ACTION  = 4;

const int EPICITEM_ITEM_OPTION_PAGE = 101;
const int EPICITEM_LIST_ITEM_PAGE   = 102;

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    string sPlayerFame, sItemName, sCategory, sCurrentItem;
    object oItem, oContainer;
    string sList = GetCurrentList(oHolder);
    int nID, nPlayerFame, nCost, nBound, nDonatedXP, nXPCost;

    switch (nOptionSelected) {
    case ZDIALOG_MAIN_MENU:
    case EPICITEM_LIST_ITEM_PAGE:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case EPICITEM_LIST_ITEM_HANDLE:
        // Store the current picked Category
        SetLocalString(oHolder, "CURRENT_CATEGORY", GetStringElement(GetDlgSelection(), sList + "_SUB", oHolder));
        SetNextPage(oHolder, EPICITEM_LIST_ITEM_PAGE);
        return;
    case EPICITEM_ITEM_OPTION_PAGE:
        // Store the current picked item
        sCategory = GetLocalString(oHolder, "CURRENT_CATEGORY");
        if (sCategory == "Damage Stones") SetLocalString(oHolder, "CURRENT_ITEM", GetStringElement(GetDlgSelection(), sList + "_SUB", oHolder));
        else SetLocalInt(oHolder, "CURRENT_ITEM", GetIntElement(GetDlgSelection(), sList + "_SUB", oHolder));
        SetNextPage(oHolder, nOptionSelected);
        return;
    case EPICITEM_EXAMINE_ACTION:
        oContainer = EI_GetContainer();
        nID = GetLocalInt(oHolder, "CURRENT_ITEM");
        oItem = EI_GetItem(nID, oContainer);
        AssignCommand(oPC, ActionExamine(oItem));
        SetNextPage(oHolder, EPICITEM_ITEM_OPTION_PAGE);
        return;
    case EPICITEM_BUY_ACTION:
        nPlayerFame = GetLocalInt(oPC, "PLAYER_FAME");
        sCategory = GetLocalString(oHolder, "CURRENT_CATEGORY");
        sPlayerFame = IntToString(nPlayerFame);

        if (sCategory == "Damage Stones")
        {
            sCurrentItem = GetLocalString(oHolder, "CURRENT_ITEM"); // stone tag
            sItemName = DMGS_GetStoneName(sCurrentItem);
            nCost = DMGS_GetFameCost(DAMAGE_BONUS_1d4, DMGS_GetStoneDmgType(sCurrentItem));
            nXPCost = GetXPCostPerFameCost(nCost);
            nDonatedXP = dbGetDonatedXP(oPC, TRUE);
            if (nDonatedXP < nXPCost)
            {
                SetShowMessage(oHolder, "Why do you come here with nothing to offer the Master! I should strike you down and offer your carcass to the Master as an offering! (missing " + IntToString(nXPCost - nDonatedXP) + " donated XP)");
                return;
            }
        }
        else
        {
            oContainer   = EI_GetContainer();
            nID          = GetLocalInt(oHolder, "CURRENT_ITEM");
            oItem        = EI_GetItem(nID, oContainer);
            nCost        = EI_GetCost(nID, oContainer);
            sItemName    = EI_GetName(nID, oContainer);
            sCurrentItem = IntToString(nID);
        }
        if (GetLocalInt(oHolder, sList + "_CONFIRM") < 1) // confirm 1st
        {
            if (nPlayerFame < nCost)
            {
                SetShowMessage(oHolder, "Why do you come here with nothing to offer the Master! I should strike you down and offer your carcass to the Master as an offering! (missing " + IntToString(nCost - nPlayerFame) + " fame)");
                return;
            }
            else if (!EI_GetMeetReq(nID, oPC, oContainer))
            {
                SetShowMessage(oHolder, "You are not worthy enough to wear this item. You have to be level 40 and meet the requirements:\n" + EI_GetReqText(nID, oContainer));
                return;
            }
            string sMsg = "That is an excellent item, do you really want " + sItemName + " and pay " + IntToString(nCost) + " fame";
            if (sCategory == "Damage Stones") sMsg += " and " + IntToString(nXPCost) + " donated XP";
            sMsg += "?\n";
            if (EI_GetIsBound(nID, oContainer)) sMsg += GetRGB(15, 15, 1) + "ATTENTION: This item will be bound and only useable by this character.";
            SetConfirmAction(oHolder, sMsg, EPICITEM_BUY_ACTION);
            SetLocalInt(oHolder, sList + "_CONFIRM", 1); // confirmed
            return;
        }
        SetLocalString(oPC, "BUY_ITEM_ID", sCurrentItem);
        SetShowMessage(oHolder, "The Master is pleased! Very, very pleased! Now touch the statue behind me.");
        return;
    case EPICITEM_DESCRIBE_ACTION:
        oContainer = EI_GetContainer();
        SetShowMessage(oHolder, GetDescription(EI_GetItem(GetLocalInt(oHolder, "CURRENT_ITEM"), oHolder)), EPICITEM_ITEM_OPTION_PAGE);
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
    string sCategory, sMsg, sBound, sStackMsg, sReqs, sName, sCurrentItem;
    object oContainer;
    int nID, nCost;
    int nStack;

    DeleteList(sList, oHolder);
    DeleteList(sList + "_SUB", oHolder);
    switch (nPage) {
    case ZDIALOG_MAIN_MENU:
        DeleteLocalInt(oHolder, sList + "_CONFIRM");
        SetDlgPrompt("");
        oContainer = EI_GetContainer();
        sCategory = GetFirstStringElement("EPICITEM_CATEGORY_LIST", oContainer);
        // List all Categories
        while (sCategory != "")
        {
            SetMenuOptionInt(sCategory, EPICITEM_LIST_ITEM_HANDLE, oHolder);
            AddStringElement(sCategory, sList + "_SUB", oHolder);
            sCategory = GetNextStringElement();
        }
        return;
    case EPICITEM_LIST_ITEM_PAGE:
        SetDlgPrompt("");
        oContainer = EI_GetContainer();
        sCategory = GetLocalString(oHolder, "CURRENT_CATEGORY");
        if (sCategory == "Damage Stones")
        {
            SetMenuOptionInt(DMGS_GetStoneName("DMGS_BLUDGE"), EPICITEM_ITEM_OPTION_PAGE, oHolder);
            AddStringElement("DMGS_BLUDGE", sList + "_SUB", oHolder);
            SetMenuOptionInt(DMGS_GetStoneName("DMGS_SLASH"), EPICITEM_ITEM_OPTION_PAGE, oHolder);
            AddStringElement("DMGS_SLASH", sList + "_SUB", oHolder);
            SetMenuOptionInt(DMGS_GetStoneName("DMGS_PIERCE"), EPICITEM_ITEM_OPTION_PAGE, oHolder);
            AddStringElement("DMGS_PIERCE", sList + "_SUB", oHolder);
            SetMenuOptionInt(DMGS_GetStoneName("DMGS_SONIC"), EPICITEM_ITEM_OPTION_PAGE, oHolder);
            AddStringElement("DMGS_SONIC", sList + "_SUB", oHolder);
            SetMenuOptionInt(DMGS_GetStoneName("DMGS_NEGATIVE"), EPICITEM_ITEM_OPTION_PAGE, oHolder);
            AddStringElement("DMGS_NEGATIVE", sList + "_SUB", oHolder);
            SetMenuOptionInt(DMGS_GetStoneName("DMGS_MAGIC"), EPICITEM_ITEM_OPTION_PAGE, oHolder);
            AddStringElement("DMGS_MAGIC", sList + "_SUB", oHolder);
            SetMenuOptionInt(DMGS_GetStoneName("DMGS_DIVINE"), EPICITEM_ITEM_OPTION_PAGE, oHolder);
            AddStringElement("DMGS_DIVINE", sList + "_SUB", oHolder);
            SetMenuOptionInt(DMGS_GetStoneName("DMGS_POSITIVE"), EPICITEM_ITEM_OPTION_PAGE, oHolder);
            AddStringElement("DMGS_POSITIVE", sList + "_SUB", oHolder);
        }
        else
        {
            nID = GetFirstIntElement(sCategory, oContainer);
            // List all items in choosen Category
            while(nID > 0)
            {
                SetMenuOptionInt(EI_GetName(nID, oContainer), EPICITEM_ITEM_OPTION_PAGE, oHolder);
                AddIntElement(nID, sList + "_SUB", oHolder);
                nID = GetNextIntElement();
            }
        }
        SetMenuOptionInt(GetRGB(15,5,1) + "[Back]", ZDIALOG_MAIN_MENU, oHolder);
        return;
    case EPICITEM_ITEM_OPTION_PAGE:
        oContainer = EI_GetContainer();
        sCategory = GetLocalString(oHolder, "CURRENT_CATEGORY");
        sBound = "No";
        if (sCategory == "Damage Stones")
        {
            sCurrentItem = GetLocalString(oHolder, "CURRENT_ITEM"); // stone tag
            sName = DMGS_GetStoneName(sCurrentItem);
            nCost = DMGS_GetFameCost(DAMAGE_BONUS_1d4, DMGS_GetStoneDmgType(sCurrentItem));
            sReqs = "Nothing";
            sMsg = "\nAdditional Cost: " + IntToString(GetXPCostPerFameCost(nCost)) + " donated XP\nYou can donate XP in Loftenwood-Bank";
        }
        else
        {
            nID = GetLocalInt(oHolder, "CURRENT_ITEM");
            oItem = EI_GetItem(nID, oContainer);

            nStack = GetItemCharges(oItem);
            if (!nStack) nStack = GetItemStackSize(oItem);
            if (nStack > 1) sStackMsg = IntToString(nStack) + " x ";

            if (EI_GetIsBound(nID, oContainer)) sBound = "Yes";
            nCost = EI_GetCost(nID, oContainer);
            sReqs = EI_GetReqText(nID, oContainer);
            sName = GetName(oItem) + " (" + GetNameByBaseItemType2da(GetBaseItemType(oItem)) + ")";
        }
        SetDlgPrompt(sStackMsg + sName + "\n\nCost: " + IntToString(nCost) + " Fame\nCharacter Bound: " + sBound + "\nRequirements: " + sReqs + sMsg);
        SetMenuOptionInt("Buy Item", EPICITEM_BUY_ACTION, oHolder);
        if (GetIsObjectValid(oItem)) SetMenuOptionInt("Examine", EPICITEM_EXAMINE_ACTION, oHolder);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Back]", EPICITEM_LIST_ITEM_PAGE, oHolder);
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
    DeleteLocalString(oHolder, "WHICH_CATEGORY");
    DeleteLocalString(oHolder, "CURRENT_ITEM");
    DeleteLocalInt(oHolder, "CURRENT_ITEM");
    DeleteList(sList + "_SUB", oHolder);
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

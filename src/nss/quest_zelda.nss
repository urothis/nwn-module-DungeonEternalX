#include "zdlg_include_i"
#include "zdialog_inc"
#include "seed_faction_inc"
#include "fame_inc"
#include "quest_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);


void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    object oItem;
    int nCount;
    string sMsg;    string sTRUEID;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case 1:
        if (!HasItem(oPC, "YEENOGHU_IDOL"))
        {
            SetShowMessage(oHolder, "Please find it first and then speak to me again.");
            return;
        }
        SetConfirmAction(oHolder, "Do you really want to give it to me? I can tell you what else one could do with it for 1 million gold pieces (1,000,000).", 3, "Here is your gold.", "No just take it.", 2);
        return;
    case 2:
        if (!HasItem(oPC, "YEENOGHU_IDOL"))
        {
            SetShowMessage(oHolder, "Please find it first and then speak to me again.");
            return;
        }
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
            if (GetTag(oItem) == "YEENOGHU_IDOL")
            {
                nCount++;
                DestroyObject(oItem);
            }
            oItem = GetNextItemInInventory(oPC);
        }
        IncFameOnChar(oPC, IntToFloat(nCount) * 2.0);
        DelayCommand(0.1, StoreFameOnDB(oPC, SDB_GetFAID(oPC)));

        Q_UpdateQuest(oPC, "5", FALSE, IntToString(Q_GetHasQuest(oPC, "5", FALSE) + nCount));

        sTRUEID = IntToString(dbGetTRUEID(oPC));
        NWNX_SQL_ExecuteQuery("select st_gnollidol from statistics where st_trueid=" + sTRUEID);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ExecuteQuery("update statistics set st_gnollidol=st_gnollidol+" + IntToString(nCount) + " where st_trueid=" + sTRUEID);
        }
        else
            NWNX_SQL_ExecuteQuery("insert into statistics (st_trueid,st_gnollidol) values (" + sTRUEID + "," + IntToString(nCount) + ")");
        GiveGoldToCreature(oPC, 2000000*nCount);
        SetShowMessage(oHolder, "That was a most honourable deed, thank you.");
        return;
    case 3:
        if (GetGold(oPC) >= 1000000)
        {
            TakeGoldFromCreature(1000000, oPC, TRUE);
            SetShowMessage(oHolder, "The metal from which the idol is made is susceptible to various sources of magic. Find a way to smelt and then combine it with the contents of a minor elemental resistance potion using an alchemist’s apparatus.");
        }
        else SetShowMessage(oHolder, "Please get the gold and then come and speak to me.");
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    object oHolder = OBJECT_SELF;
    string sList   = GetCurrentList(oHolder);
    string sMsg;
    DeleteList(sList, oHolder); // START FRESH PAGE
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        SetDlgPrompt("Excellent! Where is it?");
        if (!HasItem(oPC, "YEENOGHU_IDOL")) sMsg = "uhm...";
        else sMsg = "[Give Yeenoghu Idol]";
        SetMenuOptionInt(sMsg, 1, oHolder);
        return;
   case ZDIALOG_SHOW_MESSAGE:
        DoShowMessage(oHolder);
        return;
   case ZDIALOG_CONFIRM:
        DoConfirmAction(oHolder);
        return;
    }
}

void CleanUp(object oHolder)
{
    CleanUpInc(oHolder);
}

void main ()
{
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    object oHolder = OBJECT_SELF;
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

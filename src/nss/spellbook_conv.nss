#include "zdlg_include_i"
#include "zdialog_inc"
#include "spellbook_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

const int ACTION_CREATESCROLL       = 1;

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

void HandleSelection(object oPC)
{
    object oHolder = GetLocalObject(oPC, "SPELLBOOK");
    int nOptionSelected = GetPageOptionSelected(oHolder);
    string sID, sResRef;
    int nCount, nOldCount;
    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case ACTION_CREATESCROLL:
        sID = IntToString(GetDlgSelection() + 1);
        sResRef = GetLocalString(oHolder, "SCROLL_RES_" + sID);
        nCount = GetLocalInt(oHolder, "SCROLL_CNT_" + sID);
        if (nCount > 99)
        {
            SetLocalInt(oHolder, "SCROLL_CNT_" + sID, nCount - 99);
            nCount = 99;
        }
        else
        {
            DeleteLocalInt(oHolder, "SCROLL_CNT_" + sID);
            DeleteLocalInt(oHolder, "SCROLL_ID_" + sResRef);
            DeleteLocalString(oHolder, "SCROLL_RES_" + sID);
            DeleteLocalString(oHolder, "SCROLL_NAME_" + sID);
        }
        SpellBookDoWeight(oHolder, SpellBookDoDesc(oHolder));
        CreateItemOnObject(sResRef, oPC, nCount);
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    object oHolder = GetLocalObject(oPC, "SPELLBOOK");
    string sList   = GetCurrentList(oHolder);
    string sScrollName, sMsg;
    DeleteList(sList, oHolder); // START FRESH PAGE
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        SetDlgPrompt("Select Scroll");
        int nID = 1; // switch IDs
        while (nID <= 20)
        {
            sScrollName = GetLocalString(oHolder, "SCROLL_NAME_" + IntToString(nID));
            if (sScrollName == "") SetMenuOptionInt(DisabledText("Empty"), ZDIALOG_MAIN_MENU, oHolder);
            else SetMenuOptionInt(IntToString(GetLocalInt(oHolder, "SCROLL_CNT_" + IntToString(nID))) + " * " + sScrollName, ACTION_CREATESCROLL, oHolder);;
            nID++;
        }
        return;
    }
}

void CleanUp(object oHolder, object oPC)
{
    DeleteLocalObject(oPC, "SPELLBOOK");
    CleanUpInc(oHolder);
}

void main ()
{
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    object oHolder = GetLocalObject(oPC, "SPELLBOOK");
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
        CleanUp(oHolder, oPC);
    break;
    }
}

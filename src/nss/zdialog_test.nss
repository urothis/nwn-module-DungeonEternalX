#include "zdlg_include_i"
#include "zdialog_inc"

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
    string sMsg;    string sName;
    object oContainer = GetObjectByTag("LOOT_SCROLLS");
    string sList = GetCurrentList(oHolder);
    int nOptionSelected = GetPageOptionSelected(oHolder);
    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case 1:
        SetNextPage(oHolder, 2);
        SetLocalInt(oHolder, "SELECTED_PAGE", GetIntElement(GetDlgSelection(), sList + "_SUB", oHolder));
        return;
    case 2:
        oItem = GetLocalObject(oContainer, "LOOT_ITEM" + IntToString(GetIntElement(nOptionSelected, sList, oHolder)));
        SetShowMessage(oHolder, GetName(oItem));
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void Init(object oHolder)
{
    if (GetLocalInt(oHolder, "TOTAL_ITEMS") != 0) return; // do this only once
    int nCnt;
    object oContainer = GetObjectByTag("LOOT_SCROLLS");
    object oScroll = GetLocalObject(oContainer, "LOOT_ITEM" + IntToString(nCnt + 1));
    while (GetIsObjectValid(oScroll))
    {
        nCnt++;
        oScroll = GetLocalObject(oContainer, "LOOT_ITEM" + IntToString(nCnt + 1));
    }
    if (!nCnt) nCnt = -1;
    SetLocalInt(oHolder, "TOTAL_ITEMS", nCnt);
}

void BuildPage(int nPage, object oPC)
{
    object oHolder = OBJECT_SELF;
    int nCnt;
    int nMenuePage;
    int nScroll;
    object oScroll;
    object oContainer = GetObjectByTag("LOOT_SCROLLS");
    string sList = GetCurrentList(oHolder);
    string sMsg;
    DeleteList(sList, oHolder); // START FRESH PAGE
    DeleteList(sList + "_SUB", oHolder);
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        nMenuePage = GetLocalInt(oHolder, "TOTAL_ITEMS");
        SetDlgPrompt("total items:" + IntToString(nMenuePage));
        if (nMenuePage % 20 != 0) nMenuePage += 20;
        SpeakString("Pages: " + IntToString(nMenuePage));
        nMenuePage = nMenuePage/20;
        SpeakString("Pages: " + IntToString(nMenuePage));
        while (nCnt < nMenuePage)
        {
            SetMenuOptionInt("Page " + IntToString(nCnt), 1, oHolder);
            AddIntElement(nCnt, sList + "_SUB", oHolder);
            nCnt++;
        }
        return;
    case 2:
        nMenuePage = GetLocalInt(oHolder, "SELECTED_PAGE");
        SetDlgPrompt("Menue:" + IntToString(nMenuePage));
        nCnt = nMenuePage * 20 + 1;
        oScroll = GetLocalObject(oContainer, "LOOT_ITEM" + IntToString(nCnt));
        while (GetIsObjectValid(oScroll) && nScroll <= 20)
        {
            nCnt++;
            nScroll++;
            SetMenuOptionInt(GetName(oScroll), 1, oHolder);
            oScroll = GetLocalObject(oContainer, "LOOT_ITEM" + IntToString(nCnt));
        }
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
    DeleteLocalInt(oHolder, "SELECTED_PAGE");
}

void main ()
{
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    object oHolder = OBJECT_SELF;
    switch(iEvent) {
    case DLG_INIT:
        Init(oHolder);
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

#include "zdlg_include_i"
#include "zdialog_inc"
#include "db_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

void HandleSelection(object oPC)
{
    //string sPCKey       = GetPCPublicCDKey(oPC);
    string sPCName      = GetName(oPC);
    string sPCLogin     = GetPCPlayerName(oPC);
    int nOptionSelected = GetPageOptionSelected(oPC);

    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oPC, nOptionSelected);
        return;
    case 1:
        if (GetHitDice(oPC) < 40)
        {
            SetShowMessage(oPC, "You should train first before asking me about powerfull items");
            FloatingTextStringOnCreature("Character level not 40", oPC);
        }
        else if (dbGetPersistentInt(oPC, "NIBELUNGEN_FIST"))
        {
            SetShowMessage(oPC, "Ask me tomorrow again, I gave you already one of those items");
        }
        else
        {
            dbSetPersistentInt(oPC, "NIBELUNGEN_FIST", 1, 1);
            object oItem = CreateItemOnObject("fistofnibelungen", oPC);
            SetItemCharges(oItem, 10);
            SetShowMessage(oPC, "Use it wise and ask me tomorrow again... if im still around.");
            FloatingTextStringOnCreature("Item aquired: Fist of Nibelungen", oPC);
        }
        SetNextPage(oPC, ZDIALOG_SHOW_MESSAGE);
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    //string sPCKey   = GetPCPublicCDKey(oPC, TRUE);
    string sPCName  = GetName(oPC);
    string sPCLogin = GetPCPlayerName(oPC);
    string sList    = GetCurrentList(oPC);

    DeleteList(sList, oPC); // START FRESH PAGE
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        DeleteLocalInt(oPC, "ZDLG_CONFIRM");
        SetDlgPrompt("Hello, i am on a journey through Loftenwood.");
        SetMenuOptionInt("I heard rumors about a special item, can i have one of them?", 1, oPC);
        return;
   case ZDIALOG_SHOW_MESSAGE:
        DoShowMessage(oPC);
        return;
    }
}

void CleanUp(object oPC)
{
    CleanUpInc(oPC);
}

void main ()
{
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    switch(iEvent) {
    case DLG_INIT:
        SetNextPage(oPC, ZDIALOG_MAIN_MENU);
        break;
    case DLG_PAGE_INIT:
        BuildPage(GetNextPage(oPC), oPC);
        SetShowEndSelection(TRUE);
        SetDlgResponseList(GetCurrentList(oPC), oPC);
        break;
    case DLG_SELECTION:
        HandleSelection(oPC);
        break;
    case DLG_ABORT:
    case DLG_END:
        CleanUp(oPC);
    break;
    }
}

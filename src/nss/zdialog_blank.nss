#include "zdlg_include_i"
#include "zdialog_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

const int BLANK_SOMETHING1       = 1;
const int BLANK_SOMETHING2       = 2;

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
    case BLANK_SOMETHING1:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case BLANK_SOMETHING2:
        if (GetLocalInt(oPC, "ZDLG_CONFIRM") < 1) // CONFIRMED 1ST?
        {
            SetConfirmAction(oHolder, "yes?", nOptionSelected); // CONFIRM QESTION
            SetLocalInt(oHolder, "ZDLG_CONFIRM", 1); // SET CONFIRMED
            return;
        }
        if (GetLocalInt(oHolder, "ZDLG_CONFIRM") < 2) // CONFIRMED  2ND?
        {
            SetConfirmAction(oHolder, "orly?", nOptionSelected, "yarly!", "stfu!");
            SetLocalInt(oHolder, "ZDLG_CONFIRM", 2); // SET CONFIRMED
            return;
        }
        // CONFIRMED, DO SOMETHING HERE
        AssignCommand(oPC, ActionExamine(oPC));
        EndDlg(); // AND THEN END CONVO
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

    DeleteList(sList, oHolder); // START FRESH PAGE
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        DeleteLocalInt(oHolder, "ZDLG_CONFIRM");
        SetDlgPrompt("Hello message");
        SetMenuOptionInt("Say something", BLANK_SOMETHING1, oHolder);
        SetMenuOptionInt("Do some action", BLANK_SOMETHING2, oHolder);
        return;
   case BLANK_SOMETHING1:
        SetDlgPrompt("I am saying something");
        SetMenuOptionInt("Well said...", ZDIALOG_MAIN_MENU, oHolder);
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

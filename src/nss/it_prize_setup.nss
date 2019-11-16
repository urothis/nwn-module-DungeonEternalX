#include "zdlg_include_i"
#include "zdialog_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

const int DM_PRIZE_SETUP_WINNER   = 1;
const int DM_PRIZE_SETUP_LOSER    = 2;

const int DM_PRIZE_SETUP_BLING    = 10;
const int DM_PRIZE_SETUP_TRAIN    = 11;
const int DM_PRIZE_SETUP_FAME     = 12;

const int DM_PRIZE_ADD            = 21;
const int DM_PRIZE_RESET          = 22;

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

string PrizeSetupMsg(object oHolder)
{
    return "----- Winner: -----\nBling: " + IntToString(GetLocalInt(oHolder, "BLING_W")) + "\n" +
           "Trainingtoken: " + IntToString(GetLocalInt(oHolder, "TRAIN_W")) + "\n" +
           "Fame: " + IntToString(GetLocalInt(oHolder, "FAME_W")) + "\n\n" +
           "----- Loser: -----\nBling: " + IntToString(GetLocalInt(oHolder, "BLING_L")) + "\n" +
           "Trainingtoken: " + IntToString(GetLocalInt(oHolder, "TRAIN_L")) + "\n" +
           "Fame: " + IntToString(GetLocalInt(oHolder, "FAME_L")) + "\n";
}

void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    string sList = GetCurrentList(oHolder);
    int nWhichGroup, nWhichAction;
    switch (nOptionSelected) {
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case DM_PRIZE_SETUP_WINNER:
        SetLocalInt(oHolder, "WHICH", DM_PRIZE_SETUP_WINNER);
        SetNextPage(oHolder, nOptionSelected);
        return;
    case DM_PRIZE_SETUP_LOSER:
        SetLocalInt(oHolder, "WHICH", DM_PRIZE_SETUP_LOSER);
        SetNextPage(oHolder, nOptionSelected);
        return;
    case DM_PRIZE_SETUP_BLING:
        nWhichAction = GetIntElement(GetDlgSelection(), sList + "_SUB", oHolder);
        nWhichGroup = GetLocalInt(oHolder, "WHICH");
        if (nWhichAction == DM_PRIZE_ADD)
        {
            if (nWhichGroup == DM_PRIZE_SETUP_WINNER) SetLocalInt(oHolder, "BLING_W", GetLocalInt(oHolder, "BLING_W") + 1);
            else if (nWhichGroup == DM_PRIZE_SETUP_LOSER) SetLocalInt(oHolder, "BLING_L", GetLocalInt(oHolder, "BLING_L") + 1);
        }
        else if (nWhichAction == DM_PRIZE_RESET)
        {
            if (nWhichGroup == DM_PRIZE_SETUP_WINNER) DeleteLocalInt(oHolder, "BLING_W");
            else if (nWhichGroup == DM_PRIZE_SETUP_LOSER) DeleteLocalInt(oHolder, "BLING_L");
        }
        SetNextPage(oHolder, nOptionSelected);
        return;
    case DM_PRIZE_SETUP_TRAIN:
        nWhichAction = GetIntElement(GetDlgSelection(), sList + "_SUB", oHolder);
        nWhichGroup = GetLocalInt(oHolder, "WHICH");
        if (nWhichAction == DM_PRIZE_ADD)
        {
            if (nWhichGroup == DM_PRIZE_SETUP_WINNER) SetLocalInt(oHolder, "TRAIN_W", GetLocalInt(oHolder, "TRAIN_W") + 1);
            else if (nWhichGroup == DM_PRIZE_SETUP_LOSER) SetLocalInt(oHolder, "TRAIN_L", GetLocalInt(oHolder, "TRAIN_L") + 1);
        }
        else if (nWhichAction == DM_PRIZE_RESET)
        {
            if (nWhichGroup == DM_PRIZE_SETUP_WINNER) DeleteLocalInt(oHolder, "TRAIN_W");
            else if (nWhichGroup == DM_PRIZE_SETUP_LOSER) DeleteLocalInt(oHolder, "TRAIN_L");
        }
        SetNextPage(oHolder, nOptionSelected);
        return;
    case DM_PRIZE_SETUP_FAME:
        nWhichAction = GetIntElement(GetDlgSelection(), sList + "_SUB", oHolder);
        nWhichGroup = GetLocalInt(oHolder, "WHICH");
        if (nWhichAction == DM_PRIZE_ADD)
        {
            if (nWhichGroup == DM_PRIZE_SETUP_WINNER) SetLocalInt(oHolder, "FAME_W", GetLocalInt(oHolder, "FAME_W") + 5);
            else if (nWhichGroup == DM_PRIZE_SETUP_LOSER) SetLocalInt(oHolder, "FAME_L", GetLocalInt(oHolder, "FAME_L") + 5);
        }
        else if (nWhichAction == DM_PRIZE_RESET)
        {
            if (nWhichGroup == DM_PRIZE_SETUP_WINNER) DeleteLocalInt(oHolder, "FAME_W");
            else if (nWhichGroup == DM_PRIZE_SETUP_LOSER) DeleteLocalInt(oHolder, "FAME_L");
        }
        SetNextPage(oHolder, nOptionSelected);
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    object oHolder = OBJECT_SELF;
    string sList = GetCurrentList(oHolder);
    DeleteList(sList, oHolder);
    DeleteList(sList + "_SUB", oHolder);
    string sMsg;

    switch (nPage) {
    case ZDIALOG_MAIN_MENU:
        SetDlgPrompt(PrizeSetupMsg(oHolder));
        SetMenuOptionInt("Setup Winner Prize", DM_PRIZE_SETUP_WINNER, oHolder);
        SetMenuOptionInt("Setup Loser Prize", DM_PRIZE_SETUP_LOSER, oHolder);
        return;
    case DM_PRIZE_SETUP_WINNER:
        SetMenuOptionInt("Setup Winner Bling", DM_PRIZE_SETUP_BLING, oHolder);
        SetMenuOptionInt("Setup Winner Training Token", DM_PRIZE_SETUP_TRAIN, oHolder);
        SetMenuOptionInt("Setup Winner Fame", DM_PRIZE_SETUP_FAME, oHolder);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Menue]", ZDIALOG_MAIN_MENU, oHolder);
        return;
    case DM_PRIZE_SETUP_LOSER:
        SetMenuOptionInt("Setup Loser Bling", DM_PRIZE_SETUP_BLING, oHolder);
        SetMenuOptionInt("Setup Loser Training Token", DM_PRIZE_SETUP_TRAIN, oHolder);
        SetMenuOptionInt("Setup Loser Fame", DM_PRIZE_SETUP_FAME, oHolder);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Menue]", ZDIALOG_MAIN_MENU, oHolder);
        return;
    case DM_PRIZE_SETUP_BLING:
        SetDlgPrompt(PrizeSetupMsg(oHolder));
        SetMenuOptionInt("Add 1 Bling", DM_PRIZE_SETUP_BLING, oHolder);
        AddIntElement(DM_PRIZE_ADD, sList + "_SUB", oHolder);
        SetMenuOptionInt("Reset to 0", DM_PRIZE_SETUP_BLING, oHolder);
        AddIntElement(DM_PRIZE_RESET, sList + "_SUB", oHolder);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Menue]", ZDIALOG_MAIN_MENU, oHolder);
        return;
    case DM_PRIZE_SETUP_TRAIN:
        SetDlgPrompt(PrizeSetupMsg(oHolder));
        SetMenuOptionInt("Add 1 Traintoken", DM_PRIZE_SETUP_TRAIN, oHolder);
        AddIntElement(DM_PRIZE_ADD, sList + "_SUB", oHolder);
        SetMenuOptionInt("Reset to 0", DM_PRIZE_SETUP_TRAIN, oHolder);
        AddIntElement(DM_PRIZE_RESET, sList + "_SUB", oHolder);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Menue]", ZDIALOG_MAIN_MENU, oHolder);
        return;
    case DM_PRIZE_SETUP_FAME:
        SetDlgPrompt(PrizeSetupMsg(oHolder));
        SetMenuOptionInt("Add 5 Fame", DM_PRIZE_SETUP_FAME, oHolder);
        AddIntElement(DM_PRIZE_ADD, sList + "_SUB", oHolder);
        SetMenuOptionInt("Reset to 0", DM_PRIZE_SETUP_FAME, oHolder);
        AddIntElement(DM_PRIZE_RESET, sList + "_SUB", oHolder);
        SetMenuOptionInt(GetRGB(15,5,1) + "[Main Menue]", ZDIALOG_MAIN_MENU, oHolder);
        return;
    }
}

void CleanUp(object oHolder)
{
    string sList = GetCurrentList(oHolder);
    CleanUpInc(oHolder);
    DeleteList(sList + "_SUB", oHolder);
    DeleteLocalInt(oHolder, "WHICH");
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

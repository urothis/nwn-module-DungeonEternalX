#include "zdlg_include_i"
#include "zdialog_inc"
#include "db_inc"
#include "seed_faction_inc"
#include "fame_inc"
#include "event_plac_inc"
#include "inc_traininghall"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

const int DM_PRIZE_DO       = 1;
const int DM_PRIZE_WINNER   = 2;
const int DM_PRIZE_LOSER    = 3;

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
    object oPlacard;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    string sPlayerFame, sItemName;
    string sList = GetCurrentList(oHolder);
    string sTeam, sEndung, sToken, sMsg, sName;
    int nTeam, i, nBling, nTrain, nFame, nNew;
    object oPrize, oTarget;
    switch (nOptionSelected) {
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case DM_PRIZE_DO:
        nTeam = GetIntElement(GetDlgSelection(), sList + "_SUB", oHolder);
        if (nTeam == DM_PRIZE_WINNER)
        {
            sTeam = "Winning Team";
            sEndung = "_W";
        }
        else if (nTeam == DM_PRIZE_LOSER)
        {
            sTeam = "Losing Team";
            sEndung = "_L";
        }
        else
        {
            EndDlg();
            return;
        }
        oTarget = GetLocalObject(oPC, "PRIZE_TARGET");
        nBling = GetLocalInt(oHolder, "BLING" + sEndung);
        nTrain = GetLocalInt(oHolder, "TRAIN" + sEndung);
        nFame  = GetLocalInt(oHolder, "FAME" + sEndung);
        sMsg = GetRGB(11,9,11) + "(DM Event) Rewarding " + GetName(oTarget) + " with:" + GetRGB(13,9,13);
        sName = GetName(oPC);
        if (nBling > 0)
        {
            for (i=1 ; i <= nBling; i++)
            {
                sToken = dbGetNextToken(oPC, oTarget, "Awarded by " + sName + " to " + GetName(oTarget));
                oPrize = CreateItemOnObject("bling", oTarget, 1, "BLING_"+sToken);
                SetName(oPrize, "Bling Medallion #"+sToken);
                SetIdentified(oPrize, TRUE);
                SetDroppableFlag(oPrize, TRUE);
            }
            sMsg += " Bling: " + IntToString(nBling);
        }
        if (nTrain > 0)
        {
            CreateTrainingToken(oTarget, nTrain);
            sMsg += " Trainingtoken: " + IntToString(nTrain);
        }
        if (nFame > 0)
        {
            IncFameOnChar(oTarget, IntToFloat(nFame));
            DelayCommand(0.1, StoreFameOnDB(oTarget, SDB_GetFAID(oTarget), FALSE));
            sMsg += " Fame: " + IntToString(nFame);
        }
        ShoutMsg(sMsg);
        DelayCommand(1.0, AssignCommand(oTarget, JumpToLocation(GetStartingLocation())));
        DeleteLocalObject(oPC, "PRIZE_TARGET");

        // Cory - Local Int Cleanup
        DeleteLocalInt(oTarget, "DmEventNoPort");
        DeleteLocalInt(oTarget, "OtmanRingTime");

        oPlacard = GetObjectByTag("EVENT_PLACARD");
        if (GetIsObjectValid(oPlacard))
        {
            if (GetHasTimePassed(oPlacard, 5, sName))
            {
                if (GetLocalInt(GetModule(), SERVER_TIME_LEFT) < 15) SetLocalInt(GetModule(), SERVER_TIME_LEFT, 15);
                DeleteLocalInt(oPlacard, sName);
                AssignCommand(GetModule(), DelayCommand(5*120.0, EventPlacardSaveDB(oPlacard, sName)));
            }
            i = IncLocalInt(oPlacard, sName, 1);
        }
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
    string sList = GetCurrentList(oHolder);
    DeleteList(sList, oHolder);
    DeleteList(sList + "_SUB", oHolder);

    switch (nPage) {
    case ZDIALOG_MAIN_MENU:
        SetDlgPrompt("----- Winner: -----\nBling: " + IntToString(GetLocalInt(oHolder, "BLING_W")) + "\n" +
           "Trainingtoken: " + IntToString(GetLocalInt(oHolder, "TRAIN_W")) + "\n" +
           "Fame: " + IntToString(GetLocalInt(oHolder, "FAME_W")) + "\n\n" +
           "----- Loser: -----\nBling: " + IntToString(GetLocalInt(oHolder, "BLING_L")) + "\n" +
           "Trainingtoken: " + IntToString(GetLocalInt(oHolder, "TRAIN_L")) + "\n" +
           "Fame: " + IntToString(GetLocalInt(oHolder, "FAME_L")) + "\n");
        SetMenuOptionInt("Reward Winner", DM_PRIZE_DO, oHolder);
        AddIntElement(DM_PRIZE_WINNER, sList + "_SUB", oHolder);
        SetMenuOptionInt("Reward Loser", DM_PRIZE_DO, oHolder);
        AddIntElement(DM_PRIZE_LOSER, sList + "_SUB", oHolder);
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

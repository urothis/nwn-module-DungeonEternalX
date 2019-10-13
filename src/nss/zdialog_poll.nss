#include "zdlg_include_i"
#include "zdialog_inc"
#include "_functions"
#include "db_inc"

///////////////////////////////////////////////////////////////////
//  THIS POLL-SYSTEM IS NOT FINISHED. NOT FULLY DYNAMIC... ezramun
///////////////////////////////////////////////////////////////////

const int POLL_VOTE1_ACTION   = 1;
const int POLL_VOTE2_ACTION   = 2;
const int POLL_VOTE3_ACTION   = 3;

const int POLL_RESULTS_PAGE   = 10;

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);
// Do vote and return old voted option.
string PollDoVote(string sKey, string sID, string sOpt);
// Load results from DB to NPC
void PollLoadResults(string sID);
// Calculate results and LocalSet the message on NPC
void PollSetResultMessage(string sID);

string PollDoVote(string sKey, string sID, string sOpt)
{
    string sOldOption;

    NWNX_SQL_ExecuteQuery("select pt_opt from polltrack where pt_key=" + Quotes(sKey) + " and pt_poll_id=" + sID);
    if (NWNX_SQL_ReadyToReadNextRow()) // someone is changing vote
    {
        NWNX_SQL_ReadNextRow();
        // Store the "old" option.
        sOldOption = NWNX_SQL_ReadDataInActiveRow(0);
        // Insert choosen new nOpt into pt_opt
        NWNX_SQL_ExecuteQuery("update polltrack set pt_opt=" + sOpt + " where pt_key=" + Quotes(sKey) + " and pt_poll_id=" + sID);

        // actualize the results
        string sWhichNew = "pr_opt_val" + sOpt;
        string sWhichOld = "pr_opt_val" + sOldOption;
        NWNX_SQL_ExecuteQuery("update pollresults set " + sWhichNew + "=" + sWhichNew + "+1, " + sWhichOld + "=" + sWhichOld + "-1  where pr_poll_id=" + sID);
    }
    else // first time voted
    {
        NWNX_SQL_ExecuteQuery("insert into polltrack (pt_opt, pt_key, pt_poll_id) values (" + sOpt + ", " + Quotes(sKey) + ", " + sID + ")");
        NWNX_SQL_ExecuteQuery("update pollresults set pr_opt_val" + sOpt + "=pr_opt_val" + sOpt + "+1 where pr_poll_id=" + sID);
    }
    SetLocalInt(OBJECT_SELF, "POLL_ID_" + sID + "_CDKEY_" + sKey, TRUE);
    PollLoadResults(sID);
    return sOldOption; // Return the old vote
}

void PollLoadResults(string sID)
{
    string sPollTopic;
    object oHolder = OBJECT_SELF; // The NPC
    NWNX_SQL_ExecuteQuery("select pr_opt1, pr_opt2, pr_opt3, pr_opt4, pr_opt_val1, pr_opt_val2, pr_opt_val3, pr_opt_val4, pr_topic" +
                  " from pollresults where pr_poll_id=" + sID);

    string sMessage = "Current votes for question: ";
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sPollTopic = NWNX_SQL_ReadDataInActiveRow(8);

        string sOpt1 = NWNX_SQL_ReadDataInActiveRow(0);
        string sOpt2 = NWNX_SQL_ReadDataInActiveRow(1);
        string sOpt3 = NWNX_SQL_ReadDataInActiveRow(2);
        string sOpt4 = NWNX_SQL_ReadDataInActiveRow(3);

        float fVal1 = StringToFloat(NWNX_SQL_ReadDataInActiveRow(4));
        float fVal2 = StringToFloat(NWNX_SQL_ReadDataInActiveRow(5));
        float fVal3 = StringToFloat(NWNX_SQL_ReadDataInActiveRow(6));
        float fVal4 = StringToFloat(NWNX_SQL_ReadDataInActiveRow(7));

        float fTotal = fVal1 + fVal2 + fVal3 + fVal4;

        if (fTotal != 0.0)
        {
            fVal1 = (fVal1/fTotal) * 100.0;
            fVal2 = (fVal2/fTotal) * 100.0;
            fVal3 = (fVal3/fTotal) * 100.0;
            fVal4 = (fVal4/fTotal) * 100.0;
        }

        sMessage += sPollTopic + "\n---------------------------------\n";
        if (sOpt1 != "") sMessage += sOpt1 + ": " + FloatToString(fVal1, 0, 1) + "%\n";
        if (sOpt2 != "") sMessage += sOpt2 + ": " + FloatToString(fVal2, 0, 1) + "%\n";
        if (sOpt3 != "") sMessage += sOpt3 + ": " + FloatToString(fVal3, 0, 1) + "%\n";
        if (sOpt4 != "") sMessage += sOpt4 + ": " + FloatToString(fVal4, 0, 1) + "%\n";
        sMessage +="---------------------------------\n";
        sMessage += "Total votes: " + FloatToString(fTotal, 0, 0) + "\n";
    }
    SetLocalString(oHolder, "POLL_TOPIC_ID_" + sID, sPollTopic);
    SetLocalString(oHolder, "POLL_RESULT_ID_" + sID, sMessage);
    SetLocalInt(oHolder, "POLL_RESULT_FIRSTLOADED_ID_" + sID, TRUE);
}

void PollDoShout(string sID)
{
    object oHolder = OBJECT_SELF; // The NPC
    string sMsg = GetLocalString(oHolder, "POLL_TOPIC_ID_" + sID);
    if (sMsg == "") return;
    ShoutMsg(GetRGB(1,1,15) + "Current polls: " + sMsg + ". Please vote in Loftenwood Tavern");
}

void HandleSelection(object oPC)
{
    int nOptionSelected = GetPageOptionSelected(oPC);
    object oItem, oHolder;
    string sList = GetCurrentList(oPC);
    string sID;

    switch (nOptionSelected) {
    case ZDIALOG_MAIN_MENU:
    case POLL_RESULTS_PAGE:
        SetNextPage(oPC, nOptionSelected);
        return;
    case POLL_VOTE1_ACTION:
        if (GetHitDice(oPC) >= 40)
        {
            PollDoVote(GetPCPublicCDKey(oPC), "1", "1");
            SetShowMessage(oPC, GetLocalString(OBJECT_SELF, "POLL_RESULT_ID_1"));
        }
        else
        {
            SpeakString("You can vote with a level 40, or wait in the car");
            EndDlg();
        }
        return;
    case POLL_VOTE2_ACTION:
        if (GetHitDice(oPC) >= 40)
        {
            PollDoVote(GetPCPublicCDKey(oPC), "1", "2");
            SetShowMessage(oPC, GetLocalString(OBJECT_SELF, "POLL_RESULT_ID_1"));
        }
        else
        {
            SpeakString("You can vote with a level 40, or wait in the car");
            EndDlg();
        }
        return;
    case POLL_VOTE3_ACTION:
        if (GetHitDice(oPC) >= 40)
        {
            PollDoVote(GetPCPublicCDKey(oPC), "1", "3");
            SetShowMessage(oPC, GetLocalString(OBJECT_SELF, "POLL_RESULT_ID_1"));
        }
        else
        {
            SpeakString("You can vote with a level 40, or wait in the car");
            EndDlg();
        }
        return;
    case ZDIALOG_SHOW_MESSAGE:
        oHolder = OBJECT_SELF; // The NPC
        sID = GetStringElement(GetDlgSelection(), sList + "_SUB", oPC);
        if (!GetLocalInt(oHolder, "POLL_RESULT_FIRSTLOADED_ID_" + sID))
        {
            PollLoadResults("1");
            SetLocalInt(oHolder, "POLL_RESULT_FIRSTLOADED_ID_" + sID, TRUE);
        }
        /*if (!GetLocalInt(oHolder, "POLL_DID_SHOUT"))
        {
            SetLocalInt(oHolder, "POLL_DID_SHOUT", TRUE);
            AssignCommand(oHolder, DelayCommand(1800.0, DeleteLocalInt(oHolder, "POLL_DID_SHOUT")));
            AssignCommand(oHolder, DelayCommand(6.0, PollDoShout(sID)));
        }*/
        SetShowMessage(oPC, GetLocalString(oHolder, "POLL_RESULT_ID_" + sID));
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    string sList = GetCurrentList(oPC);
    string sTopic;
    DeleteList(sList, oPC);
    switch (nPage) {
    case ZDIALOG_MAIN_MENU:
        DeleteLocalInt(oPC, "ZDLG_CONFIRM");
        SetDlgPrompt("People complaining about bards using scrolls without UMD. Some of these spells are not bard-spells. Change the scrolls and disallow bards to use them without UMD?\n (You can change your vote once per reset)");
        /*if (!GetLocalInt(OBJECT_SELF, "POLL_ID_1" + "_CDKEY_" + GetPCPublicCDKey(oPC, TRUE)))
        {
            SetMenuOptionInt("Yes! This is an exploit and should not be possible.", POLL_VOTE1_ACTION, oPC);
            SetMenuOptionInt("No! This bug is nice, do not fix it!", POLL_VOTE2_ACTION, oPC);
            SetMenuOptionInt("I dont care/know. I will vote later maybe.", POLL_VOTE3_ACTION, oPC);
        }*/
        SetMenuOptionInt("Show me the results please", POLL_RESULTS_PAGE, oPC);
        return;
    case ZDIALOG_SHOW_MESSAGE:
        DoShowMessage(oPC);
        return;
    case POLL_RESULTS_PAGE:
        sTopic = GetLocalString(OBJECT_SELF, "POLL_TOPIC_ID_1");
        if (sTopic == "") sTopic = "Poll ID:1";
        SetMenuOptionInt(sTopic, ZDIALOG_SHOW_MESSAGE, oPC);
        AddStringElement("1", sList + "_SUB", oPC);
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

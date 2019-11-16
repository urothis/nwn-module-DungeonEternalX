#include "zdlg_include_i"
#include "inc_traininghall"
#include "db_inc"
#include "inc_setmaxhps"

//////////////////////////////////////////////////////
//
// See file "inc_traininghall" for more informations
//
//////////////////////////////////////////////////////

const int F40T_MAIN_MENU        = 10;
const int F40T_DELETE           = 11;
const int F40T_CONFIRM          = 12;
const int F40T_LEVELUP          = 13;
const int F40T_SHOW_MESSAGE     = 14;
const int F40T_END_CONVO        = 15;
const int F40T_EXPLAIN          = 16;
const int F40T_TOKEN            = 17;
const int F40T_XP               = 18;

void SetMenuOptionInt(string sOptionText, int iOptionValue, object oPC, string sList = "F40T_LIST");
void DoConfirmAction(object oPC);
void SetConfirmAction(object oPC, string sPrompt, int nActionConfirm, string sConfirm="Yes, Sir", string sCancel="No, Sir", int nActionCancel=F40T_END_CONVO);
void SetShowMessage(object oPC, string sPrompt, int nOkAction = F40T_END_CONVO);
void DoShowMessage(object oPC);

void SetMenuOptionInt(string sOptionText, int iOptionValue, object oPC, string sList = "F40T_LIST")
{
    ReplaceIntElement(AddStringElement(GetRGB(15,12,7) + sOptionText, "F40T_LIST", oPC)-1, iOptionValue  , sList, oPC);
}

int GetNextPage()
{
    return GetLocalInt(GetPcDlgSpeaker(), "F40T_CURRENT_PAGE");
}

void SetNextPage(int nPage)
{
    SetLocalInt(GetPcDlgSpeaker(), "F40T_CURRENT_PAGE", nPage);
}

void SetConfirmAction(object oPC, string sPrompt, int nActionConfirm, string sConfirm="Yes, Sir", string sCancel="No, Sir", int nActionCancel=F40T_END_CONVO)
{
    SetLocalString(oPC, "F40T_CONFIRM", sPrompt);
    SetLocalInt(oPC, "F40T_CONFIRM" + "_Y", nActionConfirm);
    SetLocalInt(oPC, "F40T_CONFIRM" + "_N", nActionCancel);
    SetLocalString(oPC, "F40T_CONFIRM" + "_Y", sConfirm);
    SetLocalString(oPC, "F40T_CONFIRM" + "_N", sCancel);
    SetNextPage(F40T_CONFIRM);
}

void DoConfirmAction(object oPC)
{
    SetDlgPrompt(GetLocalString(oPC, "F40T_CONFIRM"));
    SetMenuOptionInt(GetLocalString(oPC, "F40T_CONFIRM" + "_Y"), GetLocalInt(oPC, "F40T_CONFIRM" + "_Y"), oPC);
    SetMenuOptionInt(GetLocalString(oPC, "F40T_CONFIRM" + "_N"), GetLocalInt(oPC, "F40T_CONFIRM" + "_N"), oPC);
}

void SetShowMessage(object oPC, string sPrompt, int nOkAction = F40T_END_CONVO)
{
    SetLocalString(oPC, "F40T_CONFIRM", sPrompt);
    SetLocalInt(oPC, "F40T_CONFIRM", nOkAction);
    SetNextPage(F40T_SHOW_MESSAGE);
}

void DoShowMessage(object oPC)
{
    SetDlgPrompt(GetLocalString(oPC, "F40T_CONFIRM"));
    int nOkAction = GetLocalInt(oPC, "F40T_CONFIRM");
    DeleteLocalInt(oPC, "F40T_CONFIRM");
    if (nOkAction != F40T_END_CONVO) SetMenuOptionInt(GetRGB(15,5,1) + "[Ok]", nOkAction, oPC);
}

int GetPageOptionSelected(string sLIST = "F40T_LIST")
{
    return GetIntElement(GetDlgSelection(), sLIST, GetPcDlgSpeaker());
}

string DisabledText(string sText)
{
   return GetRGB(6,6,6) + sText;
}

string TrainingAccountValue(object oPC, string sTRUEID)
{
    return "\n\n" + GetRGB(10,10,10) + "[account value: " + IntToString(GetTrainingSessions(oPC, sTRUEID)) + "]";
}

void HandleSelection(object oPC)
{
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    string sPCName = GetName(oPC);
    string sPCLogin = GetPCPlayerName(oPC);
    int nSession;
    object oToken;
    int iOptionSelected = GetPageOptionSelected();

    switch (iOptionSelected) {
    case F40T_MAIN_MENU:
    case F40T_EXPLAIN:
        SetNextPage(iOptionSelected);
        return;
    case F40T_LEVELUP:
        nSession = GetTrainingSessions(oPC, sTRUEID);
        if (GetLocalInt(oPC, "F40T_CONFIRM") < 1) // confirm 1st
        {
            if (nSession < 1)
            {
                SetShowMessage(oPC, "What do you think this is? A charity for wanna-be adventurers? You don't have any session tokens left to purchase my services with.");
                return;
            }
            SetConfirmAction(oPC, "So you are completely lost without my help, and wish to use one of your training session tokens to level this [test] character?", iOptionSelected);
            SetLocalInt(oPC, "F40T_CONFIRM", 1); // confirmed
            return;
        }

        nSession--;
        SetTrainingSessions(oPC, sTRUEID, nSession);
        SetXPLevel(oPC, 40);
        SetShowMessage(oPC, "(Grumbles) One of the worst apprentices I've ever had. Regardless, you have what you came for.");
        return;
    case F40T_TOKEN:
        nSession = GetTrainingSessions(oPC, sTRUEID);
        if (GetLocalInt(oPC, "F40T_CONFIRM") < 1) // confirm 1st
        {
            if (nSession < 1)
            {
                SetShowMessage(oPC, "What do you think this is? A charity for wanna-be adventurers? You don't have any session tokens left to purchase my services with.");
                return;
            }
            SetConfirmAction(oPC, "Withdraw 1 token?", iOptionSelected);
            SetLocalInt(oPC, "F40T_CONFIRM", 1); // confirmed
            return;
        }
        nSession--;
        SetTrainingSessions(oPC, sTRUEID, nSession);
        CreateTrainingToken(oPC, 1);
        SetShowMessage(oPC, "You have withdrawn 1 training session token.");
        return;
    case F40T_XP:
        nSession = GetTrainingSessions(oPC, sTRUEID);
        if (GetLocalInt(oPC, "F40T_CONFIRM") < 1) // confirm 1st
        {
            if (nSession < 1)
            {
                SetShowMessage(oPC, "What do you think this is? A charity for wanna-be adventurers? You don't have any free session tokens left to purchase my services with.");
                return;
            }
            SetConfirmAction(oPC, "Too lazy to level a real character the normal way are you?\n\n Use 1 session for " + IntToString(XP_PER_SESSION) + "XP?", iOptionSelected);
            SetLocalInt(oPC, "F40T_CONFIRM", 1); // confirmed
            return;
        }
        nSession--;
        SetTrainingSessions(oPC, sTRUEID, nSession);
        GiveXPToCreature(oPC, XP_PER_SESSION);
        SetShowMessage(oPC, "I suppose that is understandable considering your obvious incompetence. Here is your xp.");
        return;
    case F40T_DELETE:
        if (GetLocalInt(oPC, "F40T_CONFIRM") < 1) // confirm 1st
        {
            SetConfirmAction(oPC, "How foolish, you wish to remove this character from existance?", iOptionSelected);
            SetLocalInt(oPC, "F40T_CONFIRM", 1); // confirmed
            return;
        }
        if (GetLocalInt(oPC, "F40T_CONFIRM") < 2) // confirm 2nd
        {
            SetConfirmAction(oPC, "This is my last warning... are sure you want this character deleted?",
                             F40T_END_CONVO, "Opps, No Sir!!", "YES SIR, DELETE IT SIR!!", iOptionSelected);
            SetLocalInt(oPC, "F40T_CONFIRM", 2); // confirmed
            return;
        }
        DeletePC(oPC);
        EndDlg();
    case F40T_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    DeleteList("F40T_LIST", oPC); // START FRESH PAGE
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    string sPCName = GetName(oPC);
    string sPCLogin = GetPCPlayerName(oPC);
    int nTestChar = GetIsTestChar(oPC);
    int nXP = GetXP(oPC);
    switch (nPage){
    case F40T_MAIN_MENU:
        DeleteLocalInt(oPC, "F40T_CONFIRM");
        SetDlgPrompt("Do you need something, or do you just like wasting my time?" + TrainingAccountValue(oPC, sTRUEID));
        SetMenuOptionInt("How does this all work?", F40T_EXPLAIN, oPC);
        if (GetIsPC(oPC))
        {
            if (nTestChar && nXP < 780000) SetMenuOptionInt("Train this test character (Full 40)", F40T_LEVELUP, oPC);
            else SetMenuOptionInt(DisabledText("Train this [test] character (Full 40)"), F40T_MAIN_MENU, oPC);

            if (!nTestChar && nXP < 780000) SetMenuOptionInt("Train this real character (" + IntToString(XP_PER_SESSION) + "XP)", F40T_XP, oPC);
            else SetMenuOptionInt(DisabledText("Train this character (" + IntToString(XP_PER_SESSION) + "XP)"), F40T_MAIN_MENU, oPC);

            if (!nTestChar) SetMenuOptionInt("Withdraw a training session token", F40T_TOKEN, oPC);
            else SetMenuOptionInt(DisabledText("Withdraw a training session token"), F40T_MAIN_MENU, oPC);

            SetMenuOptionInt("Delete this character!", F40T_DELETE, oPC);
        }
        return;
    case F40T_EXPLAIN:
        SetDlgPrompt("Great, another ignorant swashbuckler has graced me with his presence. The basics of the training hall " +
                     "are as follows:\n\n Everyone starts out with " + IntToString(BASE_SESSION_COUNT) + " session tokens. These tokens can either be used to set a test " +
                     "character to 40, or to give " + IntToString(XP_PER_SESSION) + " xp to an in-game character. Both will cost one token. To create a test character you put [test] in your name " +
                     "A player will recieve an additional 2 tokens for reaching level 40 with a real character. These tokens can be traded. " +
                     "You can earn more session tokens with other activities, but currently I don't know how.");
        SetMenuOptionInt("Alright, thank you.", F40T_MAIN_MENU, oPC);
        return;
    case F40T_CONFIRM:
        DoConfirmAction(oPC);
        return;
    case F40T_SHOW_MESSAGE:
        DoShowMessage(oPC);
        return;
    }
}

void CleanUp(object oPC)
{
    DeleteList("F40T_LIST", oPC);
    DeleteLocalInt(oPC, "F40T_CURRENT_PAGE");
    DeleteLocalInt(oPC, "ZDIALOG");
    DeleteLocalInt(oPC, "F40T_CONFIRM" + "_Y");
    DeleteLocalInt(oPC, "F40T_CONFIRM" + "_N");
    DeleteLocalInt(oPC, "F40T_CONFIRM");
    DeleteLocalString(oPC, "F40T_CONFIRM");
    DeleteLocalString(oPC, "F40T_CONFIRM" + "_Y");
    DeleteLocalString(oPC, "F40T_CONFIRM" + "_N");
}

void main (){
    object oPC = GetLastSpeaker();

    if (!GetLocalInt(oPC, "ZDIALOG"))
    {
        if (!dbCheckDatabase())
        {
            SendMessageToPC(oPC, "Sorry, the instructor is sick today [Database Error]");
            return;
        }
        OpenNextDlg(oPC, OBJECT_SELF,"ez_free40trainer", TRUE, FALSE);
        SetLocalInt(oPC, "ZDIALOG", TRUE);
        return;
    }
    oPC = GetPcDlgSpeaker();

    int iEvent = GetDlgEventType();
    switch(iEvent) {
    case DLG_INIT:
        SetNextPage(F40T_MAIN_MENU);
        break;
    case DLG_PAGE_INIT:
        BuildPage(GetNextPage(), oPC);
        SetShowEndSelection(TRUE);
        SetDlgResponseList("F40T_LIST", oPC);
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

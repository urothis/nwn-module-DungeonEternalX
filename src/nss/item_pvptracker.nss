#include "zdlg_include_i"
#include "ness_pvp_db_inc"

string sPvpTokenName    = "PvP Token";
string sPvpTokenTag     = "pvptokens";
object LIST_OWNER       = GetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST

// PERSIST VARIABLE STRINGS
const string PVP_TOKEN_LIST     = "PVP_TOKEN_LIST";
const string PVP_TOKEN_PAGE     = "PVP_TOKEN_PAGE";
const string CONFIRM            = "CONFIRM";

const int WITHDRAW_ALL         = 0;
const int WITHDRAW_1           = 1;
const int WITHDRAW_2           = 2;
const int WITHDRAW_4           = 3;
const int WITHDRAW_8           = 4;
// PAGES
const int PAGE_MAIN_MENU        = 10;  // View the list of options
const int PAGE_SHOW_MESSAGE     = 11;  // Page to Show Result of Current Action (ok)
const int PAGE_WITHDRAW_ACTION  = 12;  // Page to Show the possible withdraw amounts

// ACTIONS
const int ACTION_END_CONVO      = 21; // END CONVERSATION
const int ACTION_WITHDRAW       = 22; //
const int ACTION_DEPOSIT        = 23; //

void   AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = PVP_TOKEN_LIST);
void   AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = PVP_TOKEN_LIST);
void   AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = PVP_TOKEN_LIST);
void   SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO, string sOk = "OK");
void   SetNextPage(int nPage);
void   BuildPage(int nPage);
void   HandleSelection();
void   DoShowMessage();
void   CleanUp();
void   Init();
int    GetNextPage();
int    GetPageOptionSelected(string sList = PVP_TOKEN_LIST);
// Count PvP Tokens in Players Inventory
int GetPvpTokenInInv();
// Count PvP Tokens in Players Bank
float GetPvpTokenInBank();
// Returns information about PvP Tokens in Bank and Inventory for use as prompt message.
string TokenInfo();
// Withdraw Token from Bank to Inventory
void WithdrawToken(int nAmount);
// -----------------------------------------------------------------------------
int GetPvpTokenInInv()
{
    object oItem = GetFirstItemInInventory(LIST_OWNER);
    int nTokenCountInv   = 0;
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == sPvpTokenTag)
            nTokenCountInv += GetItemStackSize(oItem);
        oItem = GetNextItemInInventory(LIST_OWNER);
    }
    return nTokenCountInv;
}
// -----------------------------------------------------------------------------
float GetPvpTokenInBank()
{
    return StringToFloat(dbTokenCount(LIST_OWNER, GetPCPublicCDKey(LIST_OWNER)));
}
// -----------------------------------------------------------------------------
string TokenInfo()
{
    return "Your " + sPvpTokenName + " Account:\n\n" + FloatToString(GetPvpTokenInBank(), 0, 2) + " in Bank\n" + IntToString(GetPvpTokenInInv()) + " in Inventory";
}
// -----------------------------------------------------------------------------
void WithdrawToken(int nAmount)
{
    int i;
    int nCount = 0;
    string sCdKey = GetPCPublicCDKey(LIST_OWNER);
    float fTokenInBank = GetPvpTokenInBank();
    if (nAmount >= 99)
    {
        for (i = 0; i < nAmount/99; i++)
        {
            CreateItemOnObject(sPvpTokenTag, LIST_OWNER, 99);
            fTokenInBank -= 99;
            dbUpdateTokenCount(LIST_OWNER, fTokenInBank, sCdKey);
            nCount += 99;
        }
        SetShowMessage("You have withdrawed " + IntToString(nCount) + " " + sPvpTokenName + ".\n" + TokenInfo(), ACTION_WITHDRAW, "Back");
    }
    else
    {
        CreateItemOnObject(sPvpTokenTag, LIST_OWNER, nAmount);
        dbUpdateTokenCount(LIST_OWNER, GetPvpTokenInBank() - IntToFloat(nAmount), sCdKey);
        SetShowMessage("You have withdrawed " + IntToString(nAmount) + " " + sPvpTokenName + ".\n" + TokenInfo());
    }
}
// -----------------------------------------------------------------------------
void DepositToken()
{
    float fCount      = 0.0;
    float fFinalCount = 0.0;
    float fDbCount    = GetPvpTokenInBank();
    object oItem      = GetFirstItemInInventory(LIST_OWNER);

    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == sPvpTokenTag)
        {
            DestroyObject(oItem);
            fCount += IntToFloat(GetItemStackSize(oItem));
        }
        oItem = GetNextItemInInventory(LIST_OWNER);
    }
    //Update the DB
    fFinalCount = fDbCount + fCount;
    dbUpdateTokenCount(LIST_OWNER, fFinalCount, GetPCPublicCDKey(LIST_OWNER));
    SetShowMessage("You have added " + FloatToString(fCount, 0, 2) + " " + sPvpTokenName + " to your Bank.\n\nBank total Value: \n" + FloatToString(fFinalCount, 0, 2) + " " + sPvpTokenName);
}
// -----------------------------------------------------------------------------
void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = PVP_TOKEN_LIST)
{
    ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
    AddIntElement(nSubValue, PVP_TOKEN_LIST + "_SUB", LIST_OWNER);
}
// -----------------------------------------------------------------------------
void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = PVP_TOKEN_LIST)
{
    ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
    AddStringElement(sSubValue, PVP_TOKEN_LIST + "_SUB", LIST_OWNER);
}
// -----------------------------------------------------------------------------
void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = PVP_TOKEN_LIST)
{
    ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
    AddObjectElement(oSubValue, PVP_TOKEN_LIST + "_SUB", LIST_OWNER);
}
// -----------------------------------------------------------------------------
int GetPageOptionSelected(string sList = PVP_TOKEN_LIST)
{
    return GetIntElement(GetDlgSelection(), sList, LIST_OWNER);
}
// -----------------------------------------------------------------------------
int GetNextPage()
{
    return GetLocalInt(LIST_OWNER, PVP_TOKEN_PAGE);
}
// -----------------------------------------------------------------------------
void SetNextPage(int nPage)
{
    SetLocalInt(LIST_OWNER, PVP_TOKEN_PAGE, nPage);
}
// -----------------------------------------------------------------------------
void SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO, string sOk = "OK")
{
    SetLocalString(LIST_OWNER, CONFIRM, sPrompt);
    SetLocalString(LIST_OWNER, CONFIRM+"_OK", sOk);
    SetLocalInt(LIST_OWNER, CONFIRM, nOkAction);
    SetNextPage(PAGE_SHOW_MESSAGE);
}
// -----------------------------------------------------------------------------
void DoShowMessage()
{
    SetDlgPrompt(GetLocalString(LIST_OWNER, CONFIRM));
    int nOkAction = GetLocalInt(LIST_OWNER, CONFIRM);
    string sOk    = GetLocalString(LIST_OWNER, CONFIRM+"_OK");
    if (nOkAction!=ACTION_END_CONVO) AddMenuSelectionInt(sOk, nOkAction); // DON'T SHOW OK IF WE ARE ENDING CONVO, DEFAULT "END" WILL HANDLE IT
}
// -----------------------------------------------------------------------------
void Init()
{
    object oPC = GetPcDlgSpeaker();
    SetNextPage(PAGE_MAIN_MENU);
}
// -----------------------------------------------------------------------------
void HandleSelection()
{
    object oPC = GetPcDlgSpeaker();
    int iSelection = GetDlgSelection();
    int iOptionSelected = GetPageOptionSelected(); // RETURN THE KEY VALUE ASSOCIATED WITH THE SELECTION
    string sOptionSelected;
    int nConfirmed;
    switch (iOptionSelected) {
        // ********************************
        // HANDLE SIMPLE PAGE TURNING FIRST
        // ********************************
        case PAGE_MAIN_MENU:
            SetNextPage(iOptionSelected); // TURN TO NEW PAGE
            return;
            // ************************
            // HANDLE PAGE ACTIONS NEXT
            // ************************
        case ACTION_END_CONVO:
            EndDlg();
            return;
        case ACTION_WITHDRAW:
            SetNextPage(PAGE_WITHDRAW_ACTION);
            return;
        case ACTION_DEPOSIT:
            DepositToken();
            return;
        case WITHDRAW_ALL:
            WithdrawToken(FloatToInt(GetPvpTokenInBank()));
            return;
        case WITHDRAW_1:
            WithdrawToken(99);
            return;
        case WITHDRAW_2:
            WithdrawToken(2*99);
            return;
        case WITHDRAW_4:
            WithdrawToken(4*99);
            return;
        case WITHDRAW_8:
            WithdrawToken(8*99);
            return;
    }
    SetNextPage(PAGE_MAIN_MENU); // If broken, send to main menu
}
// -----------------------------------------------------------------------------
void BuildPage(int nPage)
{
    object oPC = GetPcDlgSpeaker();
    int nCount;
    DeleteList(PVP_TOKEN_LIST, LIST_OWNER);
    DeleteList(PVP_TOKEN_LIST+"_SUB", LIST_OWNER);
    string sMessage;
    float fTokenInBank = GetPvpTokenInBank();
    int nTokenInInv = GetPvpTokenInInv();
    switch (nPage)
    {
        case PAGE_MAIN_MENU:
            sMessage = TokenInfo();
            if (fTokenInBank >= 1.0 || nTokenInInv) sMessage += "\n\nWhat do you wish to do?";
                SetDlgPrompt(sMessage);
                if (GetPvpTokenInInv())
                    AddMenuSelectionString("Deposit " + sPvpTokenName, ACTION_DEPOSIT, "deposit");
                //if (fTokenInBank >= 1.0)
                    //AddMenuSelectionString("Withdraw " + sPvpTokenName, ACTION_WITHDRAW, "withdraw");
               break;
        case PAGE_WITHDRAW_ACTION:
            nCount = FloatToInt(fTokenInBank);
            SetDlgPrompt(TokenInfo() + "\n\nHow much you wish to withdraw?");
            if (nCount >= 99)
                AddMenuSelectionInt("1 Stack (99 " + sPvpTokenName + ")", WITHDRAW_1);
            if (nCount >= 198)
                AddMenuSelectionInt("2 Stacks (198 " + sPvpTokenName + ")", WITHDRAW_2);
            if (nCount >= 396)
                AddMenuSelectionInt("4 Stacks (396 " + sPvpTokenName + ")", WITHDRAW_4);
            if (nCount >= 792)
                AddMenuSelectionInt("8 Stacks (792 " + sPvpTokenName + ")", WITHDRAW_8);
            if (nCount < 99 && nCount != 0)
                AddMenuSelectionInt("All " + FloatToString(fTokenInBank, 0, 0) + " " + sPvpTokenName, WITHDRAW_ALL);
            AddMenuSelectionInt("Back", PAGE_MAIN_MENU);
            break;
        case PAGE_SHOW_MESSAGE:
            DoShowMessage();
            break;
    }
}
// -----------------------------------------------------------------------------
void CleanUp()
{
    DeleteLocalInt(LIST_OWNER, PVP_TOKEN_PAGE);
    DeleteList(PVP_TOKEN_LIST, LIST_OWNER);
    DeleteList(PVP_TOKEN_LIST+"_SUB", LIST_OWNER);
}
// -----------------------------------------------------------------------------
void main()
{
    // Check if pvptracker is executing this script. SetLocalString is in OnItemActivate
    string sItemTag = GetLocalString(LIST_OWNER, "pvptracker");
    if (sItemTag != "pvptracker")
        return;

    if (GetIsDM(LIST_OWNER) || GetIsDMPossessed(LIST_OWNER)) return;

    int iEvent = GetDlgEventType();
    switch(iEvent) {
        case DLG_INIT:
            Init();
            break;
        case DLG_PAGE_INIT:
            BuildPage(GetNextPage());
            SetShowEndSelection(TRUE);
            SetDlgResponseList(PVP_TOKEN_LIST, LIST_OWNER);
            break;
        case DLG_SELECTION:
            HandleSelection();
            break;
        case DLG_ABORT:
        case DLG_END:
            CleanUp();
            DeleteLocalString(LIST_OWNER, "pvptracker");
            break;
    }
}

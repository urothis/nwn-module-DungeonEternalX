#include "zdlg_include_i"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

const int ZDIALOG_CONFIRM        = 1001;
const int ZDIALOG_SHOW_MESSAGE   = 1002;
const int ZDIALOG_END_CONVO      = 1003;
const int ZDIALOG_MAIN_MENU      = 1004;

const int ZDIALOG_PAGE           = 9999;

void SetMenuOptionInt(string sOptionText, int nOptionValue, object oHolder);
void SetMenuOptionObject(string sOptionText, int nOptionValue, object oHolder);
int GetNextPage(object oHolder);
void SetNextPage(object oHolder, int nPage);
void SetConfirmAction(object oHolder, string sPrompt, int nActionConfirm, string sConfirm="Yes", string sCancel="No", int nActionCancel=ZDIALOG_MAIN_MENU);
void DoConfirmAction(object oHolder);
void SetShowMessage(object oHolder, string sPrompt, int nOkAction = ZDIALOG_END_CONVO);
void DoShowMessage(object oHolder);
int GetPageOptionSelected(object oHolder);
string DisabledText(string sText);
string GetCurrentList(object oHolder);
void SetCurrentList(object oHolder, string sList);
void CleanUpInc(object oHolder);


void SetMenuOptionInt(string sOptionText, int nOptionValue, object oHolder)
{
    string sList = GetCurrentList(oHolder);
    ReplaceIntElement(AddStringElement(GetRGB(15,12,7) + sOptionText, sList, oHolder)-1, nOptionValue, sList, oHolder);
}

int GetNextPage(object oHolder)
{
    return GetLocalInt(oHolder, GetCurrentList(oHolder) + "_CURRENT_PAGE");
}

void SetNextPage(object oHolder, int nPage)
{
    SetLocalInt(oHolder, GetCurrentList(oHolder) + "_CURRENT_PAGE", nPage);
}

void SetConfirmAction(object oHolder, string sPrompt, int nActionConfirm, string sConfirm="Yes", string sCancel="No",  int nActionCancel=ZDIALOG_MAIN_MENU)
{
    string sList = GetCurrentList(oHolder);
    SetLocalString(oHolder, sList + "_CONFIRM", sPrompt);
    SetLocalInt(oHolder, sList + "_CONFIRM" + "_Y", nActionConfirm);
    SetLocalInt(oHolder, sList + "_CONFIRM" + "_N", nActionCancel);
    SetLocalString(oHolder, sList + "_CONFIRM" + "_Y", sConfirm);
    SetLocalString(oHolder, sList + "_CONFIRM" + "_N", sCancel);
    SetNextPage(oHolder, ZDIALOG_CONFIRM);
}

void DoConfirmAction(object oHolder)
{
    string sList = GetCurrentList(oHolder);
    SetDlgPrompt(GetLocalString(oHolder, sList + "_CONFIRM"));
    SetMenuOptionInt(GetLocalString(oHolder, sList + "_CONFIRM" + "_Y"), GetLocalInt(oHolder, sList + "_CONFIRM" + "_Y"), oHolder);
    SetMenuOptionInt(GetLocalString(oHolder, sList + "_CONFIRM" + "_N"), GetLocalInt(oHolder, sList + "_CONFIRM" + "_N"), oHolder);
}

void SetShowMessage(object oHolder, string sPrompt, int nOkAction = ZDIALOG_END_CONVO)
{
    string sList = GetCurrentList(oHolder);
    SetLocalString(oHolder, sList + "_CONFIRM", sPrompt);
    SetLocalInt(oHolder, sList + "_CONFIRM", nOkAction);
    SetNextPage(oHolder, ZDIALOG_SHOW_MESSAGE);
}

void DoShowMessage(object oHolder)
{
    string sList = GetCurrentList(oHolder);
    SetDlgPrompt(GetLocalString(oHolder, sList + "_CONFIRM"));
    int nOkAction = GetLocalInt(oHolder, sList + "_CONFIRM");
    DeleteLocalInt(oHolder, sList + "_CONFIRM");
    if (nOkAction != ZDIALOG_END_CONVO) SetMenuOptionInt(GetRGB(15,5,1) + "[Ok]", nOkAction, oHolder);
}

int GetPageOptionSelected(object oHolder)
{
    return GetIntElement(GetDlgSelection(), GetCurrentList(oHolder), oHolder);
}

string DisabledText(string sText)
{
    return GetRGB(6,6,6) + sText;
}

string GetCurrentList(object oHolder)
{
    return GetLocalString(oHolder, "CURRENT_ZDLG_LIST");
}

void SetCurrentList(object oHolder, string sList)
{
    SetLocalString(oHolder, "CURRENT_ZDLG_LIST", sList);
}

void CleanUpInc(object oHolder)
{
    string sList = GetCurrentList(oHolder);
    DeleteList(sList, oHolder);
    DeleteList(sList + "_SUB", oHolder);
    DeleteLocalInt(oHolder, sList + "_CURRENT_PAGE");
    DeleteLocalInt(oHolder, sList + "_CONFIRM" + "_Y");
    DeleteLocalInt(oHolder, sList + "_CONFIRM" + "_N");
    DeleteLocalInt(oHolder, sList + "_CONFIRM");
    DeleteLocalString(oHolder, sList + "_CONFIRM");
    DeleteLocalString(oHolder, sList + "_CONFIRM" + "_Y");
    DeleteLocalString(oHolder, sList + "_CONFIRM" + "_N");
    DeleteLocalString(oHolder, "CURRENT_ZDLG_LIST");
}

// void main (){}

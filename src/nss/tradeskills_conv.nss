#include "zdlg_include_i"
#include "zdialog_inc"
#include "tradeskills_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

const int TS_PICK_SKILL     = 1;
const int TS_PICK_AMOUNT    = 2;
const int TS_DO_INCREASE    = 3;

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);


void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    string sList   = GetCurrentList(oHolder);
    string sSkill;  int nAmount;    int nFree;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case TS_PICK_SKILL:
        sSkill = GetStringElement(GetDlgSelection(), sList + "_SUB", oHolder);
        SetLocalString(oHolder, "TS_PICKED_SKILL", sSkill);
        SetNextPage(oHolder, nOptionSelected);
        return;
    case TS_PICK_AMOUNT:
        sSkill = GetLocalString(oHolder, "TS_PICKED_SKILL");
        nAmount = GetIntElement(GetDlgSelection(), sList + "_SUB", oHolder);
        SetLocalInt(oHolder, "TS_PICKED_AMOUNT", nAmount);
        nFree = TS_GetSkillPoints(TS_GetVariableHolder(), IntToString(dbGetTRUEID(oPC)), "ts_free");
        SetConfirmAction(oHolder, "Do you really want to increase " + TS_GetSkillName(sSkill) + " by " + IntToString(nAmount) + " with your " + IntToString(nFree) + " free skill points?", TS_DO_INCREASE, "Yes, do it now.", "No, do it later.");
        return;
    case TS_DO_INCREASE:
        sSkill = GetLocalString(oHolder, "TS_PICKED_SKILL");
        nAmount = GetLocalInt(oHolder, "TS_PICKED_AMOUNT");
        nFree = TS_GetSkillPoints(TS_GetVariableHolder(), IntToString(dbGetTRUEID(oPC)), "ts_free");
        if (nAmount > nFree)
        {
            SetShowMessage(oHolder, "You do not have enough free skill points!");
            return;
        }
        TS_UseFreeSkills(oPC, nAmount);
        TS_IncreaseSkill(oPC, nAmount, sSkill);
        SetNextPage(oHolder, ZDIALOG_MAIN_MENU);
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
    string sSkill;    int nFree;
    DeleteList(sList, oHolder); // START FRESH PAGE
    DeleteList(sList + "_SUB", oHolder); // START FRESH PAGE
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        nFree = TS_GetSkillPoints(TS_GetVariableHolder(), IntToString(dbGetTRUEID(oPC)), "ts_free");
        SetDlgPrompt("Which skill you want to increase with your " + IntToString(nFree) + " free skill points?");
        if (nFree > 0)
        {
            SetMenuOptionInt(TS_GetSkillName("ts_melting"), TS_PICK_SKILL, oHolder);
            AddStringElement("ts_melting", sList + "_SUB", oHolder);

            SetMenuOptionInt(TS_GetSkillName("ts_milling"), TS_PICK_SKILL, oHolder);
            AddStringElement("ts_milling", sList + "_SUB", oHolder);

            SetMenuOptionInt(TS_GetSkillName("ts_brewing"), TS_PICK_SKILL, oHolder);
            AddStringElement("ts_brewing", sList + "_SUB", oHolder);

            SetMenuOptionInt(TS_GetSkillName("ts_alchemy"), TS_PICK_SKILL, oHolder);
            AddStringElement("ts_alchemy", sList + "_SUB", oHolder);

            SetMenuOptionInt(TS_GetSkillName("ts_farming"), TS_PICK_SKILL, oHolder);
            AddStringElement("ts_farming", sList + "_SUB", oHolder);
        }
        return;
   case TS_PICK_SKILL:
        nFree = TS_GetSkillPoints(TS_GetVariableHolder(), IntToString(dbGetTRUEID(oPC)), "ts_free");
        sSkill = GetLocalString(oHolder, "TS_PICKED_SKILL");
        SetDlgPrompt("Pick amount to increase " + TS_GetSkillName(sSkill) + ". You have " + IntToString(nFree) + " free skill points left.");
        if (nFree >= 1)
        {
            SetMenuOptionInt("Increase 1", TS_PICK_AMOUNT, oHolder);
            AddIntElement(1, sList + "_SUB", oHolder);
        }
        if (nFree >= 5)
        {
            SetMenuOptionInt("Increase 5", TS_PICK_AMOUNT, oHolder);
            AddIntElement(5, sList + "_SUB", oHolder);
        }
        if (nFree >= 10)
        {
            SetMenuOptionInt("Increase 10", TS_PICK_AMOUNT, oHolder);
            AddIntElement(10, sList + "_SUB", oHolder);
        }
        if (nFree < 10 && nFree > 0 && nFree != 1 && nFree != 5)
        {
            SetMenuOptionInt("Use All " + IntToString(nFree) + " points", TS_PICK_AMOUNT, oHolder);
            AddIntElement(nFree, sList + "_SUB", oHolder);
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
    DeleteLocalString(oHolder, "TS_PICKED_SKILL");
    DeleteLocalInt(oHolder, "TS_PICKED_AMOUNT");
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

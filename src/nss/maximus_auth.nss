#include "zdlg_include_i"
#include "zdialog_inc"
#include "seed_faction_inc"
#include "db_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);
string GetProtectionMode(string sString);

void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    string sMode;   string sString;     string sFAID;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
    case 1:
        sString = "C:" + GetPCPublicCDKey(oPC);
        NWNX_SQL_ExecuteQuery("update account set ac_auth='"+ sString + "' where ac_acid=" + IntToString(dbGetACID(oPC)));
        SetLocalString(oPC, "AC_AUTH", sString);
        SetShowMessage(oHolder, "Account protected by CD-KEY");
        return;
    case 2:
        sFAID = SDB_GetFAID(oPC);
        if (!StringToInt(sFAID))
        {
            SetShowMessage(oHolder, "Can not protect account by FACTION, you are factionless.");
            return;
        }
        else
        {
            if (SDB_FactionGetRank(oPC) == "Member")
            {
                SetShowMessage(oHolder, "Can not protect account by FACTION, you are not a faction officer.");
                return;
            }
        }
        sString = "F:" + sFAID;
        NWNX_SQL_ExecuteQuery("update account set ac_auth='" + sString + "' where ac_acid=" + IntToString(dbGetACID((oPC))));
        SetLocalString(oPC, "AC_AUTH", sString);
        SetShowMessage(oHolder, "Account protected by FACTION");
        return;
    case 3:
        if (GetProtectionMode(GetLocalString(oPC, "AC_AUTH")) == "FACTION")
        {
            if (SDB_FactionGetRank(oPC) == "Member")
            {
                SetShowMessage(oHolder, "Can not disable account protection, you are not a faction officer.");
                return;
            }
        }
        NWNX_SQL_ExecuteQuery("update account set ac_auth='' where ac_acid=" + IntToString(dbGetACID(oPC)));
        DeleteLocalString(oPC, "AC_AUTH");
        SetShowMessage(oHolder, "Disabled account protection");
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
    string sMode;
    DeleteList(sList, oHolder); // START FRESH PAGE
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        sMode = GetProtectionMode(GetLocalString(oPC, "AC_AUTH"));
        SetDlgPrompt("Currently account protection: " + sMode);
        if (sMode != "CD-KEY") SetMenuOptionInt("Protect account by CD-KEY", 1, oHolder);
        if (sMode != "FACTION") SetMenuOptionInt("Protect account by FACTION", 2, oHolder);
        if (sMode != "NOT ACTIVE") SetMenuOptionInt("Disable protection", 3, oHolder);
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

string GetProtectionMode(string sString)
{
    if (sString == "") return "NOT ACTIVE";
    string sMode = GetStringLeft(sString, 1);

    if (sMode == "C") return "CD-KEY";
    else if (sMode == "F") return "FACTION";
    //else if (sMode == "I") return "IP-ADRESS";
    return "NOT ACTIVE";
}

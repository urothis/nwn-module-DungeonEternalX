#include "zdlg_include_i"
#include "fact_finance_inc"
#include "artifact_inc"
#include "pc_inc"

// PAGES
const int PAGE_MAIN_MENU          =  0;   // View the list of options
const int PAGE_CONFIRM_ACTION     =  1;   // Page to Confirm Current Action (ok, cancel)
const int PAGE_SHOW_MESSAGE       =  2;   // Page to Show Result of Current Action (ok)
const int PAGE_FINANCE_MENU       =  3;   //
const int PAGE_PORT_LEADER        =  4;   // Port to any of the currently online faction leaders
const int PAGE_PICK_FACTION       =  5;   // View faction diplomacy, or edit them (commander/gen only)
const int PAGE_TARGET_SUBMENU     =  8;   // Target Submenu
const int PAGE_DECISIONS_SUBMENU  =  9;   // Faction decisions - ie leave, step down,etc
const int PAGE_DM_MENU            = 10;   // DM Menu, Remove From, or Select a Faction
const int PAGE_DM_SUBMENU         = 11;   // DM Faction Menu, Add To A Faction
const int PAGE_GIVE_GOLD          = 12;   //
const int PAGE_GIVE_XP            = 13;   //
const int PAGE_CHANGE_TITHE       = 14;   //

// SHOW PAGE BIT FLAGS
const int SHOW_TARGET_MENU        =    1; // Commanders & Generals
const int SHOW_INVITE_TARGET      =    4; // Commanders & Generals
const int SHOW_REMOVE_TARGET      =    8; // Commanders & Generals
const int SHOW_STEP_DOWN          =   16; // Commanders & General
const int SHOW_PROMOTE_MEMBER     =   32; // Generals only
const int SHOW_PROMOTE_MEMBER2    =   64; // Generals only
const int SHOW_DEMOTE_COMMANDER   =  128; // Generals only
const int SHOW_NEW_GENERAL        =  256; // Generals only
const int SHOW_GIVE               =  512; // Generals only

// ACTIONS
const int ACTION_CONFIRM          = 20;   // CONFIRM CURRENT ACTION
const int ACTION_CANCEL           = 21;   // CANCEL CURRENT ACTION
const int ACTION_END_CONVO        = 22;   // END CONVERSATION

const int ACTION_DEMOTE_COMMANDER = 23;   // Demote Commander to Member
const int ACTION_PROMOTE_MEMBER2  = 24;   // Make a Member a Lieutenant
const int ACTION_INVITE_TARGET    = 25;   // Invite Target into faction
const int ACTION_JOIN_PARTY       = 26;   //
const int ACTION_LEAVE_FACTION    = 27;   // Leave your faction (generals must select successors)
const int ACTION_NEW_GENERAL      = 28;   // Demote Commander to Member
const int ACTION_PICKED_FACTION   = 29;   //
const int ACTION_PORT_LEADER      = 30;   //
const int ACTION_PROMOTE_MEMBER   = 31;   // Make a Member a Commander
const int ACTION_REMOVE_MEMBER    = 32;   // boot from faction
const int ACTION_RESET_MEMBER     = 33;   //
const int ACTION_SHOW_MEMBERS     = 34;   //
const int ACTION_STEP_DOWN        = 35;   // Step Down As Commander
const int ACTION_RESET_LIEUTENANT = 36;   //

const int ACTION_VIEW_MEMBERS     = 37;   // View the current members of your faction online
const int ACTION_RESET_COMMANDER  = 38;   //
const int ACTION_PORT_CASTLE      = 39;   //
const int ACTION_SHOW_ARTIFACTS   = 40;   //
const int ACTION_GIVE_GOLD        = 41;   //
const int ACTION_GIVE_XP          = 42;   //
const int ACTION_AMOUNT_CHANGE    = 43;   //
const int ACTION_WITHDRAW_GOLD    = 44;   //
const int ACTION_WITHDRAW_XP      = 45;   //
const int ACTION_VIEW_ACCOUNT     = 46;   // View the current members of your faction online
const int ACTION_AMOUNT_SET       = 47;   //
const int ACTION_CHANGE_TITHE     = 48;   //

// DM ONLY OPTIONS
const int ACTION_DM_ADD           = 51;   //
const int ACTION_DM_REMOVE        = 52;   //

const int MAX_GP_WITHDRAW         = 5000000;

int    GetConfirmedAction();
int    GetNextPage();
int    GetPageOptions();
int    GetPageOptionSelected(string sList = SDB_TOME_LIST);
int    GetPageOptionSelectedInt(string sList = SDB_TOME_LIST);
int    ShowPage(int nPage);
object GetPageOptionSelectedObject(string sList = SDB_TOME_LIST);
object GetTargetPC();
string GetPageOptionSelectedString(string sList = SDB_TOME_LIST);
string GetTargetOption();
string GetTargetFaction();
void   AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = SDB_TOME_LIST);
void   AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = SDB_TOME_LIST);
void   AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = SDB_TOME_LIST);
void   AddPageOptions(int nOptions);
void   ClearPageOptions();
void   DoConfirmAction();
void   DoShowMessage();
void   RemovePageOption(int nOption);
void   SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MAIN_MENU, string sConfirm="Yes", string sCancel="No");
void   SetNextPage(int nPage);
void   SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO);
void   SetTargetOption(string sOption);
void   SetTargetFaction(string sFAID);

object LIST_OWNER = GetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST

void ClearPageOptions()
{
    SetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS, 0);
}

void AddPageOptions(int nOptions)
{
    SetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS, GetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS) | nOptions);
}

void RemovePageOption(int nOption)
{
    SetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS, GetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS) ^ nOption);
}

int GetPageOptions()
{
    return GetLocalInt(LIST_OWNER, SDB_TOME_OPTIONS);
}

void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = SDB_TOME_LIST)
{
    ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
    AddIntElement(nSubValue, SDB_TOME_LIST + "_SUB", LIST_OWNER);
}
void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = SDB_TOME_LIST)
{
    ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
    AddStringElement(sSubValue, SDB_TOME_LIST + "_SUB", LIST_OWNER);
}
void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = SDB_TOME_LIST)
{
    ReplaceIntElement(AddStringElement(sSelectionText, sList, LIST_OWNER)-1, nSelectionValue, sList, LIST_OWNER);
    AddObjectElement(oSubValue, SDB_TOME_LIST + "_SUB", LIST_OWNER);
}

int ShowPage(int nPage)
{
    return (GetPageOptions() & nPage);
}

int GetNextPage()
{
    return GetLocalInt(LIST_OWNER, SDB_TOME_PAGE);
}

void SetNextPage(int nPage)
{
    SetLocalInt(LIST_OWNER, SDB_TOME_PAGE, nPage);
}

int GetPageOptionSelected(string sList = SDB_TOME_LIST)
{
    return GetIntElement(GetDlgSelection(), sList, LIST_OWNER);
}

int GetPageOptionSelectedInt(string sList = SDB_TOME_LIST)
{
    return GetIntElement(GetDlgSelection(), sList + "_SUB", LIST_OWNER);
}

string GetPageOptionSelectedString(string sList = SDB_TOME_LIST)
{
    return GetStringElement(GetDlgSelection(), sList + "_SUB", LIST_OWNER);
}

object GetPageOptionSelectedObject(string sList = SDB_TOME_LIST)
{
    return GetObjectElement(GetDlgSelection(), sList + "_SUB", LIST_OWNER);
}

void SetTargetFaction(string sFAID)
{
    SetLocalString(LIST_OWNER, SDB_TOME_TARGET, sFAID);
}

string GetTargetFaction()
{
    return GetLocalString(LIST_OWNER, SDB_TOME_TARGET);
}

void SetTargetOption(string sOption)
{
    SetLocalString(LIST_OWNER, SDB_TOME_TARGET+"_D", sOption);
}

string GetTargetOption()
{
    return GetLocalString(LIST_OWNER, SDB_TOME_TARGET+"_D");
}

object GetTargetPC()
{
    return GetLocalObject(LIST_OWNER, SDB_TOME_TARGET);
}

void SetAmount(int nAmount)
{
    SetLocalInt(LIST_OWNER, SDB_TOME_LIST+"_AMOUNT", nAmount);
}

int GetAmount()
{
    return GetLocalInt(LIST_OWNER, SDB_TOME_LIST+"_AMOUNT");
}


void SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO)
{
    SetLocalString(LIST_OWNER, SDB_TOME_CONFIRM, sPrompt);
    SetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM, nOkAction);
    SetNextPage(PAGE_SHOW_MESSAGE);
}

void DoShowMessage()
{
    SetDlgPrompt(GetLocalString(LIST_OWNER, SDB_TOME_CONFIRM));
    int nOkAction = GetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM);
    AddMenuSelectionInt("Ok, thanks.", nOkAction);
}

void SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MAIN_MENU, string sConfirm="Yes", string sCancel="No")
{
    SetLocalString(LIST_OWNER, SDB_TOME_CONFIRM, sPrompt);
    SetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM + "_Y", nActionConfirm);
    SetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM + "_N", nActionCancel);
    SetLocalString(LIST_OWNER, SDB_TOME_CONFIRM + "_Y", sConfirm);
    SetLocalString(LIST_OWNER, SDB_TOME_CONFIRM + "_N", sCancel);
    SetNextPage(PAGE_CONFIRM_ACTION);
}

void DoConfirmAction()
{
    SetDlgPrompt(GetLocalString(LIST_OWNER, SDB_TOME_CONFIRM));
    AddMenuSelectionInt(GetLocalString(LIST_OWNER, SDB_TOME_CONFIRM + "_Y"), ACTION_CONFIRM, GetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM+"_Y"));
    AddMenuSelectionInt(GetLocalString(LIST_OWNER, SDB_TOME_CONFIRM + "_N"), GetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM+"_N"));
    AddMenuSelectionInt("End", ACTION_END_CONVO);
}

int GetConfirmedAction()
{
    return GetLocalInt(LIST_OWNER, SDB_TOME_CONFIRM);
}

string SendMsg(object oPC, string sMsg)
{
    if (sMsg != "")
    {
        SendMessageToPC(oPC, sMsg);
        sMsg += "\n";
    }
    return sMsg;
}


void Init()
{
    ClearPageOptions(); // SET TO DEFAULTS
    object oPC = GetPcDlgSpeaker();
    object oTarget = GetTargetPC();
    if (GetIsDM(oPC))
    {
        SetNextPage(PAGE_DM_MENU);
        return;
    }
    string sFAID = SDB_GetFAID(oPC);
    string sRank = SDB_FactionGetRank(oPC);
    if (GetIsObjectValid(oTarget) && oPC!=oTarget)// WORKING WITH A TARGET
    {
        if (!SDB_FactionIsMember(oTarget))// NOT IN ANY FACTION
        {
            if (sRank!=DB_FACTION_MEMBER) AddPageOptions(SHOW_INVITE_TARGET); // AN OFFICER CAN INVITE
        }
        else if (SDB_FactionIsMember(oTarget, sFAID))// IS TARGET IN MY FACTION?
        {
            string sTargetRank = SDB_FactionGetRank(oTarget); // RANK OF TARGETTED PC
            if (sRank==DB_FACTION_GENERAL) // IM A GENERAL I CAN DO ANYTHING!
            {
                AddPageOptions(SHOW_REMOVE_TARGET); // I CAN REMOVE ANYONE I WANT
                if (sTargetRank == DB_FACTION_MEMBER)     AddPageOptions(SHOW_PROMOTE_MEMBER | SHOW_PROMOTE_MEMBER2);
                if (sTargetRank == DB_FACTION_COMMANDER)  AddPageOptions(SHOW_DEMOTE_COMMANDER | SHOW_PROMOTE_MEMBER2);
                if (sTargetRank == DB_FACTION_LIEUTENANT) AddPageOptions(SHOW_NEW_GENERAL | SHOW_DEMOTE_COMMANDER);
            }
            else if (sRank == DB_FACTION_LIEUTENANT)
            {
                if (sTargetRank != DB_FACTION_GENERAL)
                {
                    AddPageOptions(SHOW_REMOVE_TARGET);
                    if (sTargetRank != DB_FACTION_COMMANDER) AddPageOptions(SHOW_PROMOTE_MEMBER);
                }
                if (sTargetRank == DB_FACTION_COMMANDER) AddPageOptions(SHOW_DEMOTE_COMMANDER);
            }
            else if (sRank == DB_FACTION_COMMANDER)
            {
                if (sTargetRank == DB_FACTION_MEMBER) AddPageOptions(SHOW_REMOVE_TARGET);
            }
        }
        else
        {
            SendMessageToPC(oPC, "Target is a member of " + SDB_FactionGetName(SDB_GetFAID(oTarget)));
        }
    }
    if (sRank != DB_FACTION_MEMBER)                                       AddPageOptions(SHOW_TARGET_MENU);
    if (sRank == DB_FACTION_COMMANDER || sRank==DB_FACTION_LIEUTENANT)    AddPageOptions(SHOW_STEP_DOWN);
    if (sRank == DB_FACTION_GENERAL || sRank==DB_FACTION_LIEUTENANT)      AddPageOptions(SHOW_GIVE); // I CAN GIVE OUT XP/GOLD
    SetNextPage(PAGE_MAIN_MENU);
}

void HandleSelection()
{
    object oPC = GetPcDlgSpeaker();
    int iSelection = GetDlgSelection();
    object oMember, oAltar;
    object oTarget = GetTargetPC();
    int iOptionSelected = GetPageOptionSelected(); // RETURN THE KEY VALUE ASSOCIATED WITH THE SELECTION
    string sOptionSelected;
    object oObjectSelected;
    string sFAID = SDB_GetFAID(oPC);
    string sRank = SDB_FactionGetRank(oPC);
    string sFactionName = SDB_FactionGetName(sFAID);
    string stFAID = GetTargetFaction();
    string stFactionName = SDB_FactionGetName(stFAID);
    string sSQL;        string sText;
    string sGeneral;    string sLieutenant;     string sCommander;      string sMember;
    int nConfirmed;     int nAmount;            int nXpPC;
    switch (iOptionSelected)
    {
        // ********************************
        // HANDLE SIMPLE PAGE TURNING FIRST
        // ********************************
        case PAGE_MAIN_MENU:
        case PAGE_PICK_FACTION:
        case PAGE_PORT_LEADER:
        //case PAGE_SET_DIPLOMACY:
        case PAGE_TARGET_SUBMENU:
        case PAGE_DECISIONS_SUBMENU:
        case PAGE_FINANCE_MENU:
        case PAGE_DM_MENU:
        case PAGE_GIVE_GOLD:
        case PAGE_CHANGE_TITHE:
            SetNextPage(iOptionSelected); // TURN TO NEW PAGE
            return;
        case PAGE_GIVE_XP:
            SetAmount(pcGetRealLevel(oPC));
            SetNextPage(iOptionSelected); // TURN TO NEW PAGE
            return;
        // ************************
        // HANDLE PAGE ACTIONS NEXT
        // ************************
        case ACTION_END_CONVO:
            EndDlg();
            return;
        case ACTION_AMOUNT_SET:
            SetAmount(GetPageOptionSelectedInt());
            PlaySound("it_coins");
            return;
        case ACTION_AMOUNT_CHANGE:
            nAmount = GetPageOptionSelectedInt() + GetAmount();
            SetAmount(nAmount);
            PlaySound("it_coins");
            return;
        case ACTION_WITHDRAW_GOLD:
            nAmount = GetAmount();
            sText = "Your faction can withdraw GP only once per 10 minutes up to " + IntToString(MAX_GP_WITHDRAW) + " GP\n\n";
            if (!GetHasTimePassed(oAltar, 5, "WITHDRAW_GP"))
            {
                sText += ShowLastUpdate(oAltar, "WITHDRAW_GP", "withdraw");
                SetShowMessage(sText);
                return;
            }
            SetConfirmAction(sText + "Give " + IntToString(nAmount) + " gold to " + GetName(oTarget) + "?", ACTION_WITHDRAW_GOLD, PAGE_TARGET_SUBMENU);
            return;
        case ACTION_WITHDRAW_XP:
            nAmount = GetAmount();
            sText = " and advance them to level " + IntToString(nAmount);
            nAmount = GetMin(780000, GetMax(0, pcGetXPByLevel(nAmount) - GetXP(oTarget)));
            SetAmount(nAmount);
            SetConfirmAction("Give " + IntToString(nAmount) + " xp to " + GetName(oTarget) + sText + "?", ACTION_WITHDRAW_XP, PAGE_TARGET_SUBMENU);
            return;
        case ACTION_PICKED_FACTION:
            SetTargetFaction(GetPageOptionSelectedString());
            if (GetIsDM(oPC)) SetNextPage(PAGE_DM_SUBMENU);
            else EndDlg(); // SetNextPage(PAGE_FACTION_SUBMENU);
            return;
        case ACTION_CHANGE_TITHE:
            nAmount = GetPageOptionSelectedInt();
            SetLocalInt(oPC, "TITHE_PCT", nAmount);
            SetShowMessage("Tithe changed to " + IntToString(nAmount) + "%");
            return;
        case ACTION_PORT_LEADER:
            oObjectSelected = GetPageOptionSelectedObject();
            if (GetIsObjectValid(oObjectSelected))
            {
                int nPMTarget = GetPortMode(oObjectSelected);
                if (nPMTarget == PORT_NOT_ALLOWED)
                {
                    SendMessageToPC(oPC, "You can not port to target at this time.");
                    EndDlg();
                    return;
                }
                if (IsWarpAllowed(oPC))
                {
                    if (nPMTarget != PORT_IS_ALLOWED)
                    {
                        if (GetCurrentHitPoints(oObjectSelected) < 1)
                        {
                            SendMessageToPC(oPC, "Sorry, " + GetName(oObjectSelected) + " is currently unable to take your call.");
                            SetPortMode(oObjectSelected, PORT_NOT_ALLOWED);
                            DelayCommand(3.0, SetPortMode(oObjectSelected, FALSE));
                            EndDlg();
                            return;
                        }
                        object oAreaTarget = GetArea(oObjectSelected);
                        stFAID = GetLocalString(oAreaTarget, "FAID"); // FACTION ID OF AREA PORTING TO
                        if (stFAID != "" && stFAID != sFAID)
                        {
                            SendMessageToPC(oPC, "Sorry, you can not port to this area.");
                            SetPortMode(oObjectSelected, PORT_NOT_ALLOWED);
                            DelayCommand(3.0, SetPortMode(oObjectSelected, FALSE));
                            EndDlg();
                            return;
                        }
                        if (GetIsHostilePcNearby(oObjectSelected, oAreaTarget, 35.0, 5))
                        {
                            SendMessageToPC(oPC, "Sorry, " + GetName(oObjectSelected) + " is too close to enemies");
                            SetPortMode(oObjectSelected, PORT_NOT_ALLOWED);
                            DelayCommand(3.0, SetPortMode(oObjectSelected, FALSE));
                            EndDlg();
                            return;
                        }
                    }
                    SetPortMode(oObjectSelected, PORT_IS_ALLOWED);
                    DelayCommand(3.0, SetPortMode(oObjectSelected));
                    SetLocalInt(oPC, "DO_PORT_FX", TRUE);
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(472), GetLocation(oPC));
                    AssignCommand(oPC, DelayCommand(1.0, JumpToLocation(GetLocation(oObjectSelected))));
                    EndDlg();
                    return;
                }
                EndDlg();
                return;
            }
            SendMessageToPC(oPC, "Target is invalid");
            EndDlg();
            return;
        case ACTION_PORT_CASTLE:
            oObjectSelected = DefGetObjectByTag("WP_FACTION_BASE_" + sFAID, GetWPHolder());
            if (IsWarpAllowed(oPC))
            {
                AssignCommand(oPC, DelayCommand(1.0, JumpToObject(oObjectSelected)));
                SetLocalInt(oPC, "DO_PORT_FX", TRUE);
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(472), GetLocation(oPC));
            }
            EndDlg();
            return;
        case ACTION_SHOW_ARTIFACTS:
            sText = "";
            sText += SendMsg(oPC, "Faction Artifact Locations");
            sText += SendMsg(oPC, Artifact_ShowOwner("1"));
            sText += SendMsg(oPC, Artifact_ShowOwner("2"));
            sText += SendMsg(oPC, Artifact_ShowOwner("3"));
            sText += SendMsg(oPC, Artifact_ShowOwner("4"));
            sText += SendMsg(oPC, Artifact_ShowOwner("5"));
            sText += SendMsg(oPC, Artifact_ShowOwner("6"));
            sText += SendMsg(oPC, Artifact_ShowOwner("7"));
            sText += SendMsg(oPC, Artifact_ShowOwner("8"));
            sText += SendMsg(oPC, Artifact_ShowOwner("9"));
            sText += SendMsg(oPC, Artifact_ShowOwner("10"));
            SetShowMessage(sText, PAGE_MAIN_MENU);
            return;
        case ACTION_VIEW_ACCOUNT:
            oAltar = FactionGetAltar(sFAID);
            SetShowMessage(ShowAccountBalance(oAltar, sFAID, GetPageOptionSelectedString()));
            return;
        case ACTION_VIEW_MEMBERS:
            sGeneral = "";
            sLieutenant = "";
            sCommander = "";
            sMember = "";
            oMember = GetFirstPC();
            while (GetIsObjectValid(oMember))
            {
                stFAID = SDB_GetFAID(oMember);
                if (sFAID == stFAID && !GetIsDM(oMember))
                {
                    sRank = SDB_FactionGetRank(oMember);
                    if (sRank == DB_FACTION_GENERAL)
                    {
                        sGeneral = "   General " +GetName(oMember);
                    }
                    else if (sRank == DB_FACTION_LIEUTENANT)
                    {
                        sLieutenant = "   Lieutenant " + GetName(oMember) + "\n";
                    }
                    else if (sRank==DB_FACTION_COMMANDER)
                    {
                        sCommander += "   Commander " + GetName(oMember) + "\n";
                    }
                    else
                    {
                        sMember = DelimList(GetName(oMember), sMember);
                    }
                }
                oMember = GetNextPC();
            }
            if (sGeneral=="")   sGeneral = "   General not logged in.";
            if (sLieutenant=="")   sLieutenant = "   Lieutenant not logged in.";
            if (sCommander=="") sCommander = "   Commanders not logged in.";
            if (sMember=="")    sMember = "No Members logged in.";
            else sMember = "\nMembers logged in:\n   " + sMember;
            sText += SendMsg(oPC, sFactionName + " members online:\n\nOfficers:");
            sText += SendMsg(oPC, sGeneral);
            sText += SendMsg(oPC, sLieutenant);
            sText += SendMsg(oPC, sCommander);
            sText += SendMsg(oPC, sMember);
            SetShowMessage(sText, PAGE_MAIN_MENU);
            return;
        case ACTION_JOIN_PARTY:
            SetConfirmAction("Leave your current party and join your faction party?", ACTION_JOIN_PARTY);
            return;
        case ACTION_LEAVE_FACTION:
            SetConfirmAction("Are you sure you want to leave your faction?", ACTION_LEAVE_FACTION);
            return;
        case ACTION_REMOVE_MEMBER:
            SetConfirmAction("Are you sure you want to remove\n" + GetName(oTarget) + " from " + sFactionName + "?", ACTION_REMOVE_MEMBER);
            return;
        case ACTION_INVITE_TARGET:
            if (GetTotalFame(oTarget) >= 10) SetConfirmAction("Are you sure you want to invite\n" + GetName(oTarget) + " into " + sFactionName + "?", ACTION_INVITE_TARGET);
            else SetShowMessage("Target has not enough fame (min 10)");
            return;
        case ACTION_PROMOTE_MEMBER:
            SetConfirmAction("Are you sure you want to promote\n" + GetName(oTarget) + " to Commander?", ACTION_PROMOTE_MEMBER);
            return;
        case ACTION_PROMOTE_MEMBER2:
            SetConfirmAction("Are you sure you want to promote\n" + GetName(oTarget) + " to Lieutenant?", ACTION_PROMOTE_MEMBER2);
            return;
        case ACTION_STEP_DOWN:
            SetConfirmAction("Are you sure you want to step down\n as a Commander/Lieutenant of " + sFactionName + "?", ACTION_STEP_DOWN);
            return;
        case ACTION_DEMOTE_COMMANDER:
            SetConfirmAction("Are you sure you want to strip\n" + GetName(oTarget) + " of the rank Commander/Lieutenant of " + sFactionName + "?", ACTION_DEMOTE_COMMANDER);
            return;
        case ACTION_NEW_GENERAL:
            SetConfirmAction("Are you sure you want to step down\n as the General of " + sFactionName + " and pass the torch to " + GetName(oTarget) + "?", ACTION_NEW_GENERAL);
            return;
        case ACTION_RESET_LIEUTENANT:
            SetConfirmAction("Are you sure you want to demote the Lieutenant?", ACTION_RESET_LIEUTENANT);
            return;
        case ACTION_RESET_COMMANDER:
            SetConfirmAction("Are you sure you want to demote all Commanders?", ACTION_RESET_COMMANDER);
            return;
        case ACTION_RESET_MEMBER:
            SetConfirmAction("Are you sure you want to remove all Non-Officer Members?", ACTION_RESET_MEMBER);
            return;
        case ACTION_DM_ADD:
            sOptionSelected = GetPageOptionSelectedString();
            SetTargetOption(sOptionSelected);
            SetConfirmAction("Are you sure you want to add  " + GetName(oTarget) + " to " + stFactionName + " and make them a " + sOptionSelected + "?", ACTION_DM_ADD, PAGE_DM_MENU);
            return;
        case ACTION_DM_REMOVE:
            stFAID = SDB_GetFAID(oTarget);
            stFactionName = SDB_FactionGetName(stFAID);
            SetConfirmAction("Are you sure you want to remove  " + GetName(oTarget) + " from " + stFactionName + "?", ACTION_DM_REMOVE, PAGE_DM_MENU);
            return;
        // *****************************************
        // HANDLE CONFIRMED PAGE ACTIONS AND WE DONE
        // *****************************************
        case ACTION_CONFIRM: // THEY SAID YES TO SOMETHING (OR IT WAS AUTO-CONFIRMED ACTION)
            nConfirmed = GetPageOptionSelectedInt(); // THIS IS THE ACTION THEY CONFIRMED
            switch (nConfirmed)
            {
                case ACTION_WITHDRAW_GOLD:
                    nAmount = GetAmount();
                    if (nAmount >= GetFactionsGold(sFAID))
                    {
                        SetShowMessage("Sorry, you don't have enough Gold for that transaction.");
                        return;
                    }
                    sSQL = "update faction set fa_bankgold=fa_bankgold-" + IntToString(nAmount) + " where fa_faid=" + sFAID;
                    NWNX_SQL_ExecuteQuery(sSQL);
                    DelayCommand(0.1, UpdateFactionStats(sFAID));
                    GiveGoldToCreature(oTarget, nAmount);
                    FactionLogBankTransfer("", GetPCPlayerName(oTarget), FBANK_T1_GP, FBANK_T2_WITHDRAW, nAmount, sFAID, sRank);
                    break;
                case ACTION_WITHDRAW_XP:
                    nAmount = GetAmount();
                    if (nAmount >= GetFactionsXP(sFAID))
                    {
                        SetShowMessage("Sorry, you don't have enough XP for that transaction.");
                        return;
                    }
                    //nAmount = GetXPByLevel(nAmount) - GetXP(oTarget);
                    if (nAmount > 0)
                    {
                        sSQL = "update faction set fa_bankxp=fa_bankxp-" + IntToString(nAmount) + " where fa_faid=" + sFAID;
                        NWNX_SQL_ExecuteQuery(sSQL);
                        DelayCommand(0.1, UpdateFactionStats(sFAID));
                        nXpPC = GetXP(oTarget) + nAmount;

                        // Cory - This was setting players bank accounts to the amount of xp their char should be set to. Easily exploited.
                        //dbSetXP(oTarget, nXpPC, "FACTIONXP");

                        SetXP(oTarget, nXpPC);

                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
                        PlayVoiceChat(VOICE_CHAT_YES, oPC);
                        DelayCommand(1.0, dbSaveHighestXP(oPC, nXpPC));
                        FactionLogBankTransfer("", GetPCPlayerName(oTarget), FBANK_T1_XP, FBANK_T2_WITHDRAW, nAmount, sFAID, sRank);
                    }
                    break;
                case ACTION_JOIN_PARTY:
                    SDB_LoadDiplomacy(oPC); // leave party first
                    DelayCommand(2.0, SDB_LoadDiplomacy(oPC, FALSE, TRUE)); // then load dislike/like settings
                    EndDlg();
                    return;
                case ACTION_LEAVE_FACTION:
                    SetShowMessage(SDB_FactionRemove(oPC)); // REMOVING SELF
                    EndDlg();
                    return;
                case ACTION_REMOVE_MEMBER:
                    SetShowMessage(SDB_FactionRemove(oTarget, oPC), PAGE_MAIN_MENU);
                    RemovePageOption(SHOW_REMOVE_TARGET);
                    AddPageOptions(SHOW_INVITE_TARGET);
                    return;
                case ACTION_INVITE_TARGET:
                    SetCustomToken(2408,sFactionName); // SAVE FACTION NAME FOR NEXT CONVO
                    SetLocalObject(oTarget, "FACTION_SPEAKER", oPC); // SAVE INVITER FOR NEXT CONVO
                    AssignCommand(oTarget, ActionStartConversation(oTarget,"flel_faction_inv", FALSE, TRUE)); // ASK TARGET TO JOIN
                    SetShowMessage(GetName(oTarget) + " has been invited to join " + sFactionName, PAGE_MAIN_MENU);
                    RemovePageOption(SHOW_INVITE_TARGET);
                    return;
                case ACTION_PROMOTE_MEMBER:
                    SetShowMessage(SDB_FactionSetRank(oTarget, DB_FACTION_COMMANDER));
                    return;
                case ACTION_PROMOTE_MEMBER2:
                    SetShowMessage(SDB_FactionSetRank(oTarget, DB_FACTION_LIEUTENANT));
                    return;
                case ACTION_STEP_DOWN:
                    SetShowMessage(SDB_FactionSetRank(oPC, DB_FACTION_MEMBER));
                    return;
                case ACTION_DEMOTE_COMMANDER:
                    SetShowMessage(SDB_FactionSetRank(oTarget, DB_FACTION_MEMBER));
                    return;
                case ACTION_NEW_GENERAL:
                    SetShowMessage(SDB_FactionNewGeneral(oTarget, oPC));
                    return;
                case ACTION_RESET_LIEUTENANT:
                    SetShowMessage(SDB_FactionReset(oPC, DB_FACTION_LIEUTENANT));
                    return;
                case ACTION_RESET_COMMANDER:
                    SetShowMessage(SDB_FactionReset(oPC, DB_FACTION_COMMANDER));
                    return;
                case ACTION_RESET_MEMBER:
                    SetShowMessage(SDB_FactionReset(oPC, DB_FACTION_MEMBER));
                    return;
                case ACTION_DM_ADD:
                    SetShowMessage(SDB_FactionDMAdd(oTarget, stFAID, GetTargetOption()));
                    return;
                case ACTION_DM_REMOVE:
                    SetShowMessage(SDB_FactionDMRemove(oTarget));
                    return;
            }
    }
    SetNextPage(PAGE_MAIN_MENU); // If broken, send to main menu
}

void BuildPage(int nPage)
{
    object oPC = GetPcDlgSpeaker();
    object oTarget = GetTargetPC();
    int bValidTarget = GetIsObjectValid(oTarget) && oTarget!=oPC;
    object oMember, oAltar;
    int nOptions = GetPageOptions();
    string sFAID = SDB_GetFAID(oPC);
    string sRank = SDB_FactionGetRank(oPC);
    string sFactionName = SDB_FactionGetName(sFAID);
    string sName;
    string stFAID;
    string sDiplo;
    string sText;
    int nAccountAmount;
    int nAmount;
    int nTithePCT;
    int nLevel;

    DeleteList(SDB_TOME_LIST, LIST_OWNER);
    DeleteList(SDB_TOME_LIST+"_SUB", LIST_OWNER);
    switch (nPage)
    {
        case PAGE_DM_MENU:
            stFAID = SDB_GetFAID(oTarget);
            if (StringToInt(stFAID))
            {
                SetDlgPrompt("Hello DM " + GetName(oPC) + "\nWhat do you want to do with " + GetName(oTarget) + "?");
                AddMenuSelectionInt("Remove " + SDB_FactionGetRank(oTarget) + " from " + SDB_FactionGetName(stFAID), ACTION_DM_REMOVE);
            }
            else
            {
                SetDlgPrompt("Hello DM " + GetName(oPC) + "\nSelect the faction to add " + GetName(oTarget) + " to:");
                sFAID = SDB_FactionGetFirst();
                while (sFAID!="")
                {
                    AddMenuSelectionString(SDB_FactionGetName(sFAID), ACTION_PICKED_FACTION, sFAID);
                    sFAID = SDB_FactionGetNext();
                }
            }
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            break;
        case PAGE_DM_SUBMENU:
            SetDlgPrompt("What rank would you want like to assign " + GetName(oTarget) + "?");
            AddMenuSelectionString("General", ACTION_DM_ADD, DB_FACTION_GENERAL);
            AddMenuSelectionString("Member",  ACTION_DM_ADD, DB_FACTION_MEMBER);
            AddMenuSelectionInt("Back", PAGE_DM_MENU);
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            break;
        case PAGE_MAIN_MENU:
            SetDlgPrompt("Hello " + sFactionName + " " + sRank + "\nWhat do you want to do?");
            AddMenuSelectionInt("View Members on-line", ACTION_VIEW_MEMBERS);
            AddMenuSelectionInt("Port to a Leader", PAGE_PORT_LEADER);
            AddMenuSelectionInt("Port to Castle", ACTION_PORT_CASTLE);
            AddMenuSelectionInt("Join Faction party", ACTION_JOIN_PARTY);
            AddMenuSelectionInt("Artifact Locations", ACTION_SHOW_ARTIFACTS);
            AddMenuSelectionInt("Faction Finance", PAGE_FINANCE_MENU);
            AddMenuSelectionInt("Faction Decisions", PAGE_DECISIONS_SUBMENU);
            if (ShowPage(SHOW_TARGET_MENU) && GetIsObjectValid(oTarget)) AddMenuSelectionInt("Work on target: " + GetName(oTarget), PAGE_TARGET_SUBMENU);
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            break;
        case PAGE_FINANCE_MENU:
            sText = "The Faction Account contains:\n" +
                    IntToString(GetFactionsXP(sFAID)) + " XP and " +
                    IntToString(GetFactionsGold(sFAID)) + " GP.";

            sText += "\nThe Tithe-Accumulator contains:\n" +
                    IntToString(GetLocalInt(GetModule(), "TITHE_XP_" + sFAID)) + " XP and " +
                    IntToString(GetLocalInt(GetModule(), "TITHE_GOLD_" + sFAID)) + " GP.";

            sText += "\n\nAfter exceeding " + IntToString(FACTION_TITHE_ACCUM) + "XP, the collected XP and GP will be transfered into your Faction Account.";

            SetDlgPrompt(sText);
            AddMenuSelectionInt("Change Faction-Tithe", PAGE_CHANGE_TITHE);
            AddMenuSelectionString("Show bank overview", ACTION_VIEW_ACCOUNT, "FINANCE_INFO_TOTAL");
            AddMenuSelectionString("Show withdraw overview", ACTION_VIEW_ACCOUNT, FBANK_T1_XP+FBANK_T2_WITHDRAW);
            AddMenuSelectionString("Show withdraw details", ACTION_VIEW_ACCOUNT, FBANK_T1_XP+FBANK_T2_WITHDRAW+"OFFICER");
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            break;
        case PAGE_TARGET_SUBMENU:
            SetDlgPrompt("What do you want to do with\n" + SDB_FactionGetRank(oTarget) + " " + GetName(oTarget) + "?");
            if (ShowPage(SHOW_INVITE_TARGET) && bValidTarget)    AddMenuSelectionInt("Invite Target into Faction", ACTION_INVITE_TARGET);
            if (ShowPage(SHOW_REMOVE_TARGET) && bValidTarget)    AddMenuSelectionInt("Remove Target from Faction", ACTION_REMOVE_MEMBER);
            if (ShowPage(SHOW_PROMOTE_MEMBER) && bValidTarget)   AddMenuSelectionInt("Promote Target to Commander", ACTION_PROMOTE_MEMBER);
            if (ShowPage(SHOW_PROMOTE_MEMBER2) && bValidTarget)  AddMenuSelectionInt("Promote Target to Lieutenant", ACTION_PROMOTE_MEMBER2);
            if (ShowPage(SHOW_DEMOTE_COMMANDER) && bValidTarget) AddMenuSelectionInt("Demote Commander/Lieutenant " + GetName(oTarget), ACTION_DEMOTE_COMMANDER);
            if (ShowPage(SHOW_NEW_GENERAL) && bValidTarget)      AddMenuSelectionInt("Promote Lieutenant " + GetName(oTarget) + " to General", ACTION_NEW_GENERAL);
            if (ShowPage(SHOW_GIVE))
            {
                AddMenuSelectionInt("Give Faction Gold (" + IntToString(GetFactionsGold(sFAID)) + ") to " + GetName(oTarget), PAGE_GIVE_GOLD);
                AddMenuSelectionInt("Give Faction XP (" + IntToString(GetFactionsXP(sFAID)) + ") to " + GetName(oTarget), PAGE_GIVE_XP);
            }
            AddMenuSelectionInt("Back", PAGE_MAIN_MENU);
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            SetAmount(0);
            break;
        case PAGE_DECISIONS_SUBMENU:
            if (ShowPage(SHOW_STEP_DOWN))  AddMenuSelectionInt("Step down as Commander/Lieutenant", ACTION_STEP_DOWN);
            if (sRank != DB_FACTION_GENERAL) AddMenuSelectionInt("Leave Faction", ACTION_LEAVE_FACTION);
            if (sRank == DB_FACTION_GENERAL)
            {
                AddMenuSelectionInt("Demote Lieutenant", ACTION_RESET_LIEUTENANT);
                AddMenuSelectionInt("Demote all Commanders", ACTION_RESET_COMMANDER);
                AddMenuSelectionInt("Remove all Members", ACTION_RESET_MEMBER);
            }
            AddMenuSelectionInt("Back", PAGE_MAIN_MENU);
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            break;
        case PAGE_SHOW_MESSAGE:
            DoShowMessage();
            break;
        case PAGE_CONFIRM_ACTION:
            DoConfirmAction();
            break;
        case PAGE_PORT_LEADER:
            SetDlgPrompt("Select the member to port to:");
            nOptions = 0;
            if (sRank != DB_FACTION_GENERAL)
            {
                AddMenuSelectionObject("General: off-line",   ACTION_PORT_LEADER, OBJECT_INVALID);
                nOptions++;
            }
            if (sRank != DB_FACTION_LIEUTENANT)
            {
                AddMenuSelectionObject("Lieutenant: off-line", ACTION_PORT_LEADER, OBJECT_INVALID);
            }
            if (sRank != DB_FACTION_COMMANDER)
            {
                AddMenuSelectionObject("Commander: off-line", ACTION_PORT_LEADER, OBJECT_INVALID);
            }
            AddMenuSelectionObject("Commander: off-line", ACTION_PORT_LEADER, OBJECT_INVALID);
            AddMenuSelectionObject("Commander: off-line", ACTION_PORT_LEADER, OBJECT_INVALID);
            AddMenuSelectionObject("Commander: off-line", ACTION_PORT_LEADER, OBJECT_INVALID);
            oMember = GetFirstPC();
            while (GetIsObjectValid(oMember))
            {
                stFAID = SDB_GetFAID(oMember);
                if (stFAID == sFAID)
                {
                    string sRankM = SDB_FactionGetRank(oMember);
                    if (oMember != oPC && !GetIsDM(oMember))
                    {
                        string sName = GetName(oMember);  // + " (" + sRankM + ")";
                        if (sRankM == DB_FACTION_GENERAL)
                        {
                            ReplaceStringElement(0, "General: " + sName, SDB_TOME_LIST, LIST_OWNER);
                            ReplaceObjectElement(0, oMember,  SDB_TOME_LIST+"_SUB", LIST_OWNER);
                        }
                        else if (sRankM == DB_FACTION_LIEUTENANT)
                        {
                            ReplaceStringElement(nOptions, "Lieutenant: " + sName, SDB_TOME_LIST, LIST_OWNER);
                            ReplaceObjectElement(nOptions, oMember,  SDB_TOME_LIST+"_SUB", LIST_OWNER);
                            nOptions++;
                        }
                        else if (sRankM == DB_FACTION_COMMANDER)
                        {
                            ReplaceStringElement(nOptions, "Commander: " + sName, SDB_TOME_LIST, LIST_OWNER);
                            ReplaceObjectElement(nOptions, oMember,  SDB_TOME_LIST+"_SUB", LIST_OWNER);
                            nOptions++;
                        }
                        else if (sRank != DB_FACTION_MEMBER)// OFFICERS CAN GO TO ANYONE
                        {
                            AddMenuSelectionObject(sName, ACTION_PORT_LEADER, oMember);
                        }
                    }
                }
                oMember = GetNextPC();
            }
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            break;
        case PAGE_CHANGE_TITHE:
            nLevel = pcGetRealLevel(oPC);
            if (nLevel >= 40) nTithePCT = 30;
            else
            {
                nTithePCT = GetLocalInt(oPC, "TITHE_PCT");
                if (nTithePCT != 10) AddMenuSelectionInt("Change to 10%", ACTION_CHANGE_TITHE, 10);
                if (nTithePCT != 30) AddMenuSelectionInt("Change to 30%", ACTION_CHANGE_TITHE, 30);
            }
            sText = "Your Faction-Tithe is set to " + IntToString(nTithePCT) + "%";
            if (nLevel >= 40) sText += "\nChanging Tithe at level 40 not possible.";
            SetDlgPrompt(sText);
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            return;
        case PAGE_GIVE_GOLD:
            nAccountAmount = GetFactionsGold(sFAID);
            nAmount = GetAmount();
            oAltar = FactionGetAltar(sFAID);
            if (nAmount > MAX_GP_WITHDRAW)
            {
                nAmount = MAX_GP_WITHDRAW;
                SetAmount(MAX_GP_WITHDRAW);
            }
            sText = "Faction Account has "+IntToString(nAccountAmount)+" Gold\n" +
                     YellowText("-----------------------------------\n") +
                    "Faction Member:       " + GetName(oTarget) + "\n" +
                    "Current Withdrawal:   " + IntToString(nAmount)+" gold\n" +
                     YellowText("-----------------------------------\n") +
                    "Final Balance "+IntToString(nAccountAmount-nAmount)+" gold\n";
            if (nAmount <= MAX_GP_WITHDRAW)
            {
                if (nAccountAmount - nAmount > 100000) AddMenuSelectionInt("Increase Withdraw:  100000", ACTION_AMOUNT_CHANGE,  100000);
                if (nAccountAmount - nAmount > 200000) AddMenuSelectionInt("Increase Withdraw:  200000", ACTION_AMOUNT_CHANGE,  200000);
                if (nAccountAmount - nAmount > 400000) AddMenuSelectionInt("Increase Withdraw:  400000", ACTION_AMOUNT_CHANGE,  400000);
                if (nAccountAmount - nAmount > 800000) AddMenuSelectionInt("Increase Withdraw:  800000", ACTION_AMOUNT_CHANGE,  800000);
                if (nAccountAmount - nAmount >1600000) AddMenuSelectionInt("Increase Withdraw: 1600000", ACTION_AMOUNT_CHANGE, 1600000);
                if (nAmount > 0) AddMenuSelectionInt("Make the Withdraw", ACTION_WITHDRAW_GOLD);
            }
            SetDlgPrompt(sText);
            AddMenuSelectionInt("Back", PAGE_TARGET_SUBMENU);
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            break;
        case PAGE_GIVE_XP:
            int nXP = GetXP(oTarget);
            if (nXP >= 780000)
            {
                SetDlgPrompt(GetName(oTarget) + " is at max XP.");
                AddMenuSelectionInt("Back", PAGE_TARGET_SUBMENU);
                AddMenuSelectionInt("End", ACTION_END_CONVO);
                break;
            }
            nAccountAmount = GetFactionsXP(sFAID);
            nAmount = GetAmount();
            int nNewLevelXP = pcGetXPByLevel(nAmount); // THIS IS THE XP TO HIT THE NEW LEVEL
            if (nNewLevelXP < nXP) nNewLevelXP = nXP; // THEY HAVE AT LEAST THIS MUCH
            int nXPtoNextLevel = nNewLevelXP - nXP;
            sText = "Faction Account has "+IntToString(nAccountAmount)+" XP\n" +
                     YellowText("-----------------------------------\n") +
                    "Faction Member:       " + GetName(oTarget) + "\n" +
                    "Final Level:            " + IntToString(nAmount) + "\n" +
                    "Current Withdrawal:   " + IntToString(nXPtoNextLevel)+" XP\n" +
                     YellowText("-----------------------------------\n") +
                    "Final Balance "+IntToString(nAccountAmount-nXPtoNextLevel)+" XP\n";
            SetDlgPrompt(sText);
            int nXPNextLevel = pcGetXPByLevel(nAmount+1) - nXP;
            if (nAccountAmount >= nXPNextLevel && nAmount+1 <= 40) AddMenuSelectionInt("Add One Level", ACTION_AMOUNT_CHANGE,  1);
            nXPNextLevel = pcGetXPByLevel(10) - nXP;
            if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 10", ACTION_AMOUNT_SET,  10);
            nXPNextLevel = pcGetXPByLevel(15) - nXP;
            if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 15", ACTION_AMOUNT_SET,  15);
            nXPNextLevel = pcGetXPByLevel(20) - nXP;
            if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 20", ACTION_AMOUNT_SET,  20);
            nXPNextLevel = pcGetXPByLevel(25) - nXP;
            if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 25", ACTION_AMOUNT_SET,  25);
            nXPNextLevel = pcGetXPByLevel(30) - nXP;
            if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 30", ACTION_AMOUNT_SET,  30);
            nXPNextLevel = pcGetXPByLevel(35) - nXP;
            if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 35", ACTION_AMOUNT_SET,  35);
            nXPNextLevel = pcGetXPByLevel(40) - nXP;
            if (nAccountAmount >= nXPNextLevel && nXPNextLevel > 0) AddMenuSelectionInt("Advance to Level 40", ACTION_AMOUNT_SET,  40);

            if (nAmount > GetHitDice(oTarget)) AddMenuSelectionInt("Make the Withdraw", ACTION_WITHDRAW_XP);
            AddMenuSelectionInt("Back", PAGE_TARGET_SUBMENU);
            AddMenuSelectionInt("End", ACTION_END_CONVO);
            break;
    }
}

void CleanUp()
{
    DeleteLocalObject(LIST_OWNER, SDB_TOME_TARGET);
    DeleteLocalInt(LIST_OWNER, SDB_TOME_PAGE);
    DeleteLocalInt(LIST_OWNER, SDB_TOME_OPTIONS);
    DeleteLocalString(LIST_OWNER, SDB_TOME_TARGET);
    DeleteList(SDB_TOME_LIST, LIST_OWNER);
    DeleteList(SDB_TOME_LIST+"_SUB", LIST_OWNER);
}

void main()
{
    object oPC = GetPcDlgSpeaker();
    if (!SDB_FactionIsMember(oPC) && !GetIsDM(oPC)) return;
    int iEvent = GetDlgEventType();
    switch(iEvent)
    {
        case DLG_INIT:
            if (oPC==GetTargetPC() && SDB_FactionGetRank(oPC)!=DB_FACTION_GENERAL) SetLocalObject(LIST_OWNER, SDB_TOME_TARGET, OBJECT_INVALID);
            Init();
            break;
        case DLG_PAGE_INIT:
            BuildPage(GetNextPage());
            SetShowEndSelection(FALSE);
            SetDlgResponseList(SDB_TOME_LIST, LIST_OWNER);
            break;
        case DLG_SELECTION:
            HandleSelection();
            break;
        case DLG_ABORT:
        case DLG_END:
            CleanUp();
            break;
    }
}



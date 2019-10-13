#include "flel_faction_inc"
#include "zdlg_include_i"
#include "x0_i0_transport"
#include "x0_i0_position"

location lTarget;
object oCreature;

void Init()
{
    object oPC = GetPcDlgSpeaker();
    object oTarget = GetLocalObject(oPC,TARGET);

    SetOptions ();
    if (GetIsObjectValid(oTarget))
    {
        if (IsStatusGeneral(oPC))
        {
            if (IsStatusMember(oTarget))
                SetOptions(GetOptions() | OPTION_REMOVE_TARGET | OPTION_MAKE_TARGET_COMMANDER);
            if (IsStatusCommander(oTarget))
                SetOptions(GetOptions() | OPTION_REMOVE_TARGET | OPTION_REMOVE_TARGET_COMMANDER);
            if (!IsInFaction(oTarget,GetLocalInt(oPC,ID_FACTION)))
                SetOptions(GetOptions() | OPTION_INVITE_TARGET);
        }
        else if (IsStatusCommander(oPC))
        {
            if (IsStatusMember(oTarget))
                SetOptions(GetOptions() | OPTION_REMOVE_TARGET);
            if (IsStatusCommander(oTarget))
                SetOptions(GetOptions() | OPTION_REMOVE_TARGET);
            if (!IsInFaction(oTarget,GetLocalInt(oPC,ID_FACTION)))
                SetOptions(GetOptions() | OPTION_INVITE_TARGET);
        }
    }
    if (IsStatusGeneral(oPC) || IsStatusCommander(oPC))
        SetOptions(GetOptions() | OPTION_STEP_DOWN);
}

void HandleSelection()
{
    object oPC = GetPcDlgSpeaker();
    int iSelection = GetDlgSelection();
    object oMember;
    object oTarget = GetLocalObject(oPC,TARGET);
    string stFAID;
    string sFAID;
    DeleteList(LIST);
    switch (GetSelector())
    {
        case SELECT_MAIN_MENU:
            SetSelector(GetIntElement(iSelection,GetDlgResponseList(),oPC));
            return;
        case SELECT_VIEW_MEMBERS_ONLINE:
            break;
        case SELECT_PORT_LEADER:
            stFAID = GetLocalString(GetArea(oMember), "FAID"); // FACTION ID OF AREA PORTING TO
            sFAID = GetLocalString(oPC, "SDB_FAID");
            oMember = GetObjectElement(iSelection,GetDlgResponseList(),oPC);
            oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oMember);
            if (stFAID!="" && stFAID!=sFAID) {
                SendMessageToPC(oPC, "Sorry, " + GetName(oMember) + " is currently in a Faction territory.");
                EndDlg();
                return;
            }
            else if (oCreature!=OBJECT_INVALID) {
               if (GetDistanceBetween(oMember, oCreature) < 25.0) {
                 SendMessageToPC(oPC, "It is unsafe to port to " + GetName(oMember) + ". Try again in a few seconds.");
                  EndDlg();
                  return;
               }
            }
            else if ((stFAID =="" && stFAID==sFAID) && (GetDistanceBetween(oMember, oCreature) > 25.0))
            {
                TransportToWaypoint(oPC,GetObjectElement(iSelection,GetDlgResponseList(),oPC));
                EndDlg();
                return;
            }

        case SELECT_FACTION_DIPLOMACY:
            if (!IsStatusMember(oPC))
            {
                SetLocalInt(oPC,"TEMP",GetIntElement(iSelection,GetDlgResponseList(),oPC));
                SetSelector(SELECT_EDIT_DIPLOMACY);
                return;
            }
            break;
       case SELECT_EDIT_DIPLOMACY:
            UpdateDiplomacy(GetIDFaction(oPC),GetLocalInt(oPC,"TEMP"),GetIntElement(iSelection,GetDlgResponseList(),oPC));
            break;
        case SELECT_JOIN_FACTION_PARTY:
            if (GetIntElement(iSelection,GetDlgResponseList(),oPC) == TRUE)
            {
                JoinFactionParty(oPC);
                EndDlg();
            }
            return;
        case SELECT_LEAVE_FACTION:
            if (GetIntElement(iSelection,GetDlgResponseList(),oPC) == TRUE)
            {
                RemoveMember(oPC,oPC);
                EndDlg();
                return;
            }
            break;
        case SELECT_INVITE_TARGET:
            if (GetIntElement(iSelection,GetDlgResponseList(),oPC) == TRUE)
            {
                SetCustomToken(2408,GetLocalString(oPC,FACTION_NAME));
                SetLocalObject(oTarget,FACTION_SPEAKER,oPC);
                AssignCommand(oTarget,ActionStartConversation(oTarget,"flel_faction_inv", FALSE, TRUE));
                SetOptions((GetOptions() | OPTION_REMOVE_TARGET) ^ OPTION_INVITE_TARGET);
            }
            break;
        case SELECT_REMOVE_TARGET:
            if (GetIntElement(iSelection,GetDlgResponseList(),oPC) == TRUE)
            {
                RemoveMember(oPC,oTarget);
                SetOptions((GetOptions() | OPTION_INVITE_TARGET) ^ OPTION_REMOVE_TARGET);
            }
            break;
        case SELECT_STEP_DOWN:
            if (GetIntElement(iSelection,GetDlgResponseList(),oPC) == TRUE)
                StepDown(oPC);
            break;
        case SELECT_MAKE_TARGET_COMMANDER:
            if (GetIntElement(iSelection,GetDlgResponseList(),oPC) == TRUE)
                PromoteCommander(oPC,oTarget);
            break;
        case SELECT_REMOVE_TARGET_COMMANDER:
            if (GetIntElement(iSelection,GetDlgResponseList(),oPC) == TRUE)
                DemoteCommander(oPC,oTarget);
            break;
    }
    SetSelector(SELECT_MAIN_MENU); // If broken, send to main menu
}

void BuildList()
{
    object oPC = GetPcDlgSpeaker();
    object oTarget = GetLocalObject(oPC,TARGET);
    object oMember;
    int nOptions = GetOptions();
    DeleteList(LIST,oPC);
    switch (GetSelector())
    {
        case SELECT_MAIN_MENU:
            if (nOptions & OPTION_VIEW_MEMBERS_ONLINE)
                ReplaceIntElement(
                    AddStringElement("View members online", LIST, oPC)-1,
                    SELECT_VIEW_MEMBERS_ONLINE,LIST,oPC);
            if (nOptions & OPTION_PORT_LEADER)
                ReplaceIntElement(
                    AddStringElement("Port to a player", LIST, oPC)-1,
                    SELECT_PORT_LEADER,LIST,oPC);
            if (nOptions & OPTION_JOIN_FACTION_PARTY)
                ReplaceIntElement(
                    AddStringElement("Join faction party", LIST, oPC)-1,
                    SELECT_JOIN_FACTION_PARTY,LIST,oPC);
            if (nOptions & OPTION_JOIN_FACTION_PARTY)
                ReplaceIntElement(
                    AddStringElement("Faction Diplomacy", LIST, oPC)-1,
                    SELECT_FACTION_DIPLOMACY,LIST,oPC);
            if (nOptions & OPTION_LEAVE_FACTION)
                ReplaceIntElement(
                    AddStringElement("Leave your faction", LIST, oPC)-1,
                    SELECT_LEAVE_FACTION,LIST,oPC);
            if (nOptions & OPTION_INVITE_TARGET)
                ReplaceIntElement(
                    AddStringElement("Invite player to your faction", LIST, oPC)-1,
                    SELECT_INVITE_TARGET,LIST,oPC);
            if (nOptions & OPTION_REMOVE_TARGET)
                ReplaceIntElement(
                    AddStringElement("Remove player from your faction", LIST, oPC)-1,
                    SELECT_REMOVE_TARGET,LIST,oPC);
            if (nOptions & OPTION_STEP_DOWN)
                ReplaceIntElement(
                    AddStringElement("Step down as a " + FactionStatusToString(GetLocalInt(oPC,STATUS)), LIST, oPC)-1,
                    SELECT_STEP_DOWN,LIST,oPC);
            if (nOptions & OPTION_MAKE_TARGET_COMMANDER)
                ReplaceIntElement(
                    AddStringElement("Promote the targetted member to commander", LIST, oPC)-1,
                    SELECT_MAKE_TARGET_COMMANDER,LIST,oPC);
            if (nOptions & OPTION_REMOVE_TARGET_COMMANDER)
                ReplaceIntElement(
                    AddStringElement("Remove the targetted commander's status", LIST, oPC)-1,
                    SELECT_REMOVE_TARGET_COMMANDER,LIST,oPC);
            break;
        case SELECT_VIEW_MEMBERS_ONLINE:
            SetDlgPrompt("Currently online are");
            oMember = GetFirstPC();
            while (GetIsObjectValid(oMember))
            {
                if (GetLocalInt(oPC,ID_FACTION) == GetLocalInt(oMember,ID_FACTION))
                {
                    AddStringElement(
                        GetName(oMember) + " (" + FactionStatusToString(GetLocalInt(oMember,STATUS)) + ")",
                        LIST,oPC);
                }
                oMember = GetNextPC();
            }
            break;
        case SELECT_JOIN_FACTION_PARTY:
            SetDlgPrompt("Are you sure you want to leave your current party and join your faction party?");
            ReplaceIntElement(
                AddStringElement("Yes", LIST,oPC)-1,
                TRUE, LIST, oPC);
            ReplaceIntElement(
                AddStringElement("No", LIST,oPC)-1,
                FALSE, LIST, oPC);
            break;
        case SELECT_PORT_LEADER:
            SetDlgPrompt("Pick to whom you'd like to port");
            oMember = GetFirstPC();
            while (GetIsObjectValid(oMember))
            {
                if (GetLocalInt(oPC,ID_FACTION) == GetLocalInt(oMember,ID_FACTION))
                {
                    if (oMember != oPC && (IsStatusGeneral(oMember) || IsStatusCommander(oMember) || IsStatusGeneral(oPC) || IsStatusCommander(oPC)))
                    {
                        ReplaceObjectElement(
                            AddStringElement(
                                GetName(oMember) + " (" + FactionStatusToString(GetLocalInt(oMember,STATUS)) + ")",
                                LIST,oPC)-1,
                            oMember, LIST, oPC);
                    }
                }
                oMember = GetNextPC();
            }
            break;
        case SELECT_FACTION_DIPLOMACY:
            NWNX_SQL_ExecuteQuery("SELECT faction_diplomacy.id_faction_b,faction_diplomacy.diplomacy,id_faction.name FROM faction_diplomacy,id_faction WHERE faction_diplomacy.id_faction_a='" + IntToString(GetIDFaction(oPC)) + "' AND id_faction.id=faction_diplomacy.id_faction_b ORDER BY faction_diplomacy.id_faction_b");
            while(NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                ReplaceIntElement(
                    AddStringElement(NWNX_SQL_ReadDataInActiveRow(2) + " (" + FactionDiplomacyToString(StringToInt(NWNX_SQL_ReadDataInActiveRow(1))) + ")", LIST,oPC)-1,
                    StringToInt(NWNX_SQL_ReadDataInActiveRow(0)), LIST, oPC);
            }
            return;
        case SELECT_EDIT_DIPLOMACY:
            SetDlgPrompt("What do you want to set diplomacy to?");
            ReplaceIntElement(
                AddStringElement("Friendly", LIST,oPC)-1,
                1, LIST, oPC);
            ReplaceIntElement(
                AddStringElement("Neutral", LIST,oPC)-1,
                0, LIST, oPC);
            ReplaceIntElement(
                AddStringElement("Enemy", LIST,oPC)-1,
                -1, LIST, oPC);
            return;
        case SELECT_LEAVE_FACTION:
            SetDlgPrompt("Are you sure you want to leave your faction?");
            ReplaceIntElement(
                AddStringElement("Yes", LIST,oPC)-1,
                TRUE, LIST, oPC);
            ReplaceIntElement(
                AddStringElement("No", LIST,oPC)-1,
                FALSE, LIST, oPC);
            break;
        case SELECT_INVITE_TARGET:
            SetDlgPrompt("Are you sure you want to invite " + GetName(oTarget) + " to your faction?");
            ReplaceIntElement(
                AddStringElement("Yes", LIST,oPC)-1,
                TRUE, LIST, oPC);
            ReplaceIntElement(
                AddStringElement("No", LIST,oPC)-1,
                FALSE, LIST, oPC);
            break;
        case SELECT_REMOVE_TARGET:
            SetDlgPrompt("Are you sure you want to kick " + GetName(oTarget) + " from your faction?");
            ReplaceIntElement(
                AddStringElement("Yes", LIST,oPC)-1,
                TRUE, LIST, oPC);
            ReplaceIntElement(
                AddStringElement("No", LIST,oPC)-1,
                FALSE, LIST, oPC);
            break;
        case SELECT_STEP_DOWN:
            SetDlgPrompt("Are you sure you want to step down as a " + FactionStatusToString(GetLocalInt(oPC,STATUS)) + "?");
            ReplaceIntElement(
                AddStringElement("Yes", LIST,oPC)-1,
                TRUE, LIST, oPC);
            ReplaceIntElement(
                AddStringElement("No", LIST,oPC)-1,
                FALSE, LIST, oPC);
            break;
        case SELECT_MAKE_TARGET_COMMANDER:
            SetDlgPrompt("Are you sure you want to promote " + GetName(oTarget) + " to commander?");
            ReplaceIntElement(
                AddStringElement("Yes", LIST,oPC)-1,
                TRUE, LIST, oPC);
            ReplaceIntElement(
                AddStringElement("No", LIST,oPC)-1,
                FALSE, LIST, oPC);
            break;
        case SELECT_REMOVE_TARGET_COMMANDER:
            SetDlgPrompt("Are you sure you want to demote commander " + GetName(oTarget) + " to regular member?");
            ReplaceIntElement(
                AddStringElement("Yes", LIST,oPC)-1,
                TRUE, LIST, oPC);
            ReplaceIntElement(
                AddStringElement("No", LIST,oPC)-1,
                FALSE, LIST, oPC);
            break;
    }
}

void CleanUp()
{
    object oPC = GetPcDlgSpeaker();
    DeleteLocalObject(oPC,TARGET);
    DeleteLocalInt(oPC,SELECTOR);
    DeleteLocalInt(oPC,OPTIONS);
    DeleteLocalObject(oPC,TARGET);
    DeleteList(LIST,oPC);
}

void main()
{
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    switch(iEvent)
    {
        case DLG_INIT:
            Init();
            break;
        case DLG_PAGE_INIT:
            SetShowEndSelection(TRUE);
            BuildList();
            SetDlgResponseList(LIST,oPC);
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

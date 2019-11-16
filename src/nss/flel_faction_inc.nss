#include "nw_i0_plot"
#include "zdlg_include_i"
#include "db_inc"

//void main() {}

const string LIST = "FACTION_TOME_LIST";

const string TARGET = "FACTION_TOME_TARGET";

const string SELECTOR = "FACTION_TOME_SELECTOR";

const int SELECT_MAIN_MENU                  = 0;// View the list of options
const int SELECT_VIEW_MEMBERS_ONLINE        = 1;// View the current members of your faction online
const int SELECT_PORT_LEADER                = 2;// Port to any of the currently online faction leaders
const int SELECT_JOIN_FACTION_PARTY         = 3;// Join your faction's party
const int SELECT_FACTION_DIPLOMACY          = 4;// View faction diplomacy, or edit them (commander/gen only)
const int SELECT_EDIT_DIPLOMACY             = 5;// Edit faction diplomacy
const int SELECT_LEAVE_FACTION              = 6;// Leave your faction (generals must select successors)
const int SELECT_INVITE_TARGET              = 7;// Invite the target to your faction
const int SELECT_REMOVE_TARGET              = 8;// Remove the target from your faction
const int SELECT_STEP_DOWN                  = 9;// Step down as a general/commander (generals become commanders, commanders become members) generals must select a replacement out of the current commanders
const int SELECT_MAKE_TARGET_COMMANDER      = 10;// Make the target commander
const int SELECT_REMOVE_TARGET_COMMANDER    = 11;// Remove commander status of the target

const string OPTIONS = "FACTION_TOME_OPTIONS";

const int OPTION_VIEW_MEMBERS_ONLINE        = 1;// Members
const int OPTION_PORT_LEADER                = 2;// Members
const int OPTION_JOIN_FACTION_PARTY         = 4;// Members
const int OPTION_FACTION_DIPLOMACY          = 8;// Members (Special: commander/gen only)
const int OPTION_LEAVE_FACTION              = 16;// Members
const int OPTION_INVITE_TARGET              = 32;// Commanders & Generals
const int OPTION_REMOVE_TARGET              = 64;// Commanders & Generals
const int OPTION_STEP_DOWN                  = 128;// Commanders & General
const int OPTION_MAKE_TARGET_COMMANDER      = 256;// Generals only
const int OPTION_REMOVE_TARGET_COMMANDER    = 512;// Generals only

const int OPTION_DEFAULT = 31;

// Status constants
const int STATUS_GENERAL = 0;
const int STATUS_COMMANDER = 1;
const int STATUS_MEMBER = 2;

// Local variables stored on all faction members
const string ID_FACTION = "ID_FACTION";
const string FACTION_NAME = "FACTION_NAME";
const string ID_MEMBER = "ID_MEMBER";
const string STATUS = "STATUS";
/*const string ALLIED_FACTIONS = "ALLIED_FACTIONS";
const string ENEMY_FACTIONS = "ENEMY_FACTIONS";
const string OFFERED_ALLIANCES = "OFFERED_ALLIANCES";
const string WAR_DECLARATIONS = "WAR_DECLARATIONS"; */

/*const string PARTY_POS = "PARTY_POS";

const string FACTION_CONST_PREFIX = "FACTION_PARTY_";*/

const string FACTION_SPEAKER = "FACTION_SPEAKER";

void SetOptions(int nOptions = OPTION_DEFAULT)
{
    SetLocalInt(GetPcDlgSpeaker(),OPTIONS,nOptions);
}

int GetOptions()
{
    return GetLocalInt(GetPcDlgSpeaker(),OPTIONS);
}

int GetSelector()
{
    return GetLocalInt(GetPcDlgSpeaker(), SELECTOR);
}

/*int GetLastSelector()
{
    return GetLocalInt(GetPcDlgSpeaker(), LAST_SELECTOR);
} */

void SetSelector(int nSelector)
{
    object oPlayer = GetPcDlgSpeaker();
    //SetLocalInt(oPlayer, LAST_SELECTOR,GetSelector());
    SetLocalInt(oPlayer, SELECTOR, nSelector);
}

int IsFactioned(object oPC)
{
    if (!GetIsPC(oPC))
        return FALSE;

    NWNX_SQL_ExecuteQuery("SELECT faid FROM trueid WHERE trueid='" + IntToString(dbGetTRUEID(oPC)) + "'");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        if (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)) > 0)
        {
            WriteTimestampedLogEntry("IsFactioned(" + GetName(oPC) + ") = TRUE");
            return TRUE;
        }
    }
    WriteTimestampedLogEntry("IsFactioned(" + GetName(oPC) + ") = FALSE");
    return FALSE;
}

int GetIDFaction (object oPC)
{
    int n = GetLocalInt(oPC,ID_FACTION);
    return n;
}

void UnloadFactionData(object oPC)
{
    if (!GetIsPC(oPC))
        return;
    WriteTimestampedLogEntry("IsFactioned(" + GetName(oPC) + ") = FALSE");
    //RemoveElement(GetLocalInt(oPC,PARTY_POS),FACTION_CONST_PREFIX+IntToString(GetLocalInt(oPC,ID_FACTION)),GetModule());
}

string FactionStatusToString(int nStatus)
{
    switch (nStatus)
    {
        case STATUS_GENERAL:
            return "General";
        case STATUS_COMMANDER:
            return "Commander";
        case STATUS_MEMBER:
            return "Member";
        default:
            return "";
    }
    return "";
}

string FactionDiplomacyToString(int nDiplomacy)
{
    switch (nDiplomacy)
    {
        case 1:
            return "Friendly";
        case 0:
            return "Neutral";
        case -1:
            return "Enemy";
        default:
            return "";
    }
    return "";
}

int IsStatusGeneral (object oPC)
{
    return GetLocalInt(oPC,STATUS) == STATUS_GENERAL;
}

int IsStatusCommander (object oPC)
{
    return GetLocalInt(oPC,STATUS) == STATUS_COMMANDER;
}

int IsStatusMember (object oPC)
{
    return GetLocalInt(oPC,STATUS) == STATUS_MEMBER;
}

int GetIDMember (object oPC)
{
    return GetLocalInt(oPC,ID_MEMBER);
}

int IsInFaction (object oPC, int nIDFaction)
{
    NWNX_SQL_ExecuteQuery("SELECT faid FROM trueid WHERE trueid='" + IntToString(dbGetTRUEID(oPC)) + "'");
    return NWNX_SQL_ReadyToReadNextRow();
}

/*void LoadAlliedFactions(object oPC)
{
    SQLExecDirect("SELECT faction_diplomacy.id_faction_a,id_faction.name FROM faction_diplomacy,id_faction WHERE id_faction.id=faction_diplomacy.id_faction_a AND faction_diplomacy.id_faction_b='" + IntToString(GetIDFaction(oPC)) + "' AND faction_diplomacy.diplomacy='0' AND faction_diplomacy.status='1'");
    while(SQLFetch())
    {
        ReplaceIntElement(
            AddStringElement(SQLGetData(2),ALLIED_FACTIONS,oPC)-1,
            StringToInt(SQLGetData(1)),ALLIED_FACTIONS,oPC); // Retrieve faction data from allied factions and store them on the player
        string sList = FACTION_CONST_PREFIX + SQLGetData(1);
        object oMember=GetFirstObjectElement(sList,GetModule()); // Loop through all the players online of the allied faction and set the current player to like them
        while (GetIsObjectValid(oMember))
        {
            oMember=GetNextObjectElement();
            SetPCLike(oPC,oMember);
        }
    }
} */

void UpdateDiplomacy (int nFactionA,int nFactionB,int nEnemy=0)
{
    string sFaction1,sFaction2;
    int nFactionCount=0;

    //Fetch Previous Enemies into strings.
    NWNX_SQL_ExecuteQuery("select fa_enemies from faction where fa_faid="+IntToString(nFactionA)+" or fa_faid="+IntToString(nFactionA)+" limit 2");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sFaction1=NWNX_SQL_ReadDataInActiveRow(0);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sFaction2=NWNX_SQL_ReadDataInActiveRow(0);
        }
    }

    //Count how many factions there are
    NWNX_SQL_ExecuteQuery("select COUNT(fa_faid) from faction");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        nFactionCount=StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    }

    //Search FactionA for FactionB as an enemy
    int nFound=FALSE; string sTemp;
    int count;  //for loop should start at the end and search for the number in F1F3F2-like strings
    for (count=GetStringLength(sFaction1);count>=0;count-2)
    {
        if (StringToInt(GetSubString(sFaction1,count-1,count))==nFactionB)
        {
            nFound=count;//StringToInt(GetSubString(sTemp,count-1,count));
            break;
        }
    }

    if (nFound)
    {
        if (!nEnemy)
        {
            sTemp=GetSubString(sFaction1,0,nFound-2)+GetSubString(sFaction1,nFound,GetStringLength(sFaction1)); //Truncates that F# from the string
            NWNX_SQL_ExecuteQuery("UPDATE faction SET fa_enemies="+dbQuotes(sTemp));
        }
    }
    else if (!nFound && nEnemy)
    {
        NWNX_SQL_ExecuteQuery("UPDATE faction SET fa_enemies="+dbQuotes(sFaction1+"F"+IntToString(nFactionB)));
    }
}

/*void LoadEnemyFactions(object oPC)
{
    SQLExecDirect("SELECT faction_diplomacy.id_faction_a,id_faction.name FROM faction_diplomacy,id_faction WHERE id_faction.id=faction_diplomacy.id_faction_a AND faction_diplomacy.id_faction_b='" + IntToString(GetIDFaction(oPC)) + "' AND faction_diplomacy.diplomacy='1' AND faction_diplomacy.status='1'");
    while(SQLFetch())
    {
        ReplaceIntElement(
            AddStringElement(SQLGetData(2),ENEMY_FACTIONS,oPC)-1,
            StringToInt(SQLGetData(1)),ENEMY_FACTIONS,oPC); // Retrieve faction data from warring factions and store them on the player
        string sList = FACTION_CONST_PREFIX + SQLGetData(1);
        object oMember=GetFirstObjectElement(sList,GetModule()); // Loop through all the players online of the warring faction and set the current player to dislike them
        while (GetIsObjectValid(oMember))
        {
            oMember=GetNextObjectElement();
            SetPCDislike(oPC,oMember);
        }
    }
} */

/*string GetOfferedAlliances(object oPC)
{
    DeleteList(OFFERED_ALLIANCES,oPC);
    SQLExecDirect("SELECT faction_diplomacy.id_faction_a,id_faction.name FROM faction_diplomacy,id_faction WHERE id_faction.id=faction_diplomacy.id_faction_a AND faction_diplomacy.id_faction_b='" + IntToString(GetIDFaction(oPC)) + "' AND faction_diplomacy.diplomacy='0' AND faction_diplomacy.status='0'");
    while(SQLFetch())
    {
        ReplaceIntElement(
            AddStringElement(SQLGetData(2),OFFERED_ALLIANCES,oPC)-1,
            StringToInt(SQLGetData(1)),OFFERED_ALLIANCES,oPC); // Retrieve faction data from allied factions and store them on the player
    }
    return OFFERED_ALLIANCES;
}

void AcceptAlliance(object oPC,int nIDFaction)
{
    SQLExecDirect("UPDATE faction_diplomacy SET diplomacy='0',status='1' WHERE id_faction_a='" + IntToString(GetIDFaction(oPC)) + "' AND id_faction_b='" + IntToString(nIDFaction) + "'");
    SQLExecDirect("UPDATE faction_diplomacy SET diplomacy='0',status='1' WHERE id_faction_b='" + IntToString(GetIDFaction(oPC)) + "' AND id_faction_a='" + IntToString(nIDFaction) + "'");
}

void OfferAlliance(object oPC,int nIDFaction)
{
    SQLExecDirect("UPDATE faction_diplomacy SET diplomacy='0',status='0' WHERE id_faction_a='" + IntToString(GetIDFaction(oPC)) + "' AND id_faction_b='" + IntToString(nIDFaction) + "'");
    if (nIDFaction == 0)
        AcceptAlliance(oPC,nIDFaction);
}

string GetWarDeclarations(object oPC)
{
    SQLExecDirect("SELECT faction_diplomacy.id_faction_a,id_faction.name FROM faction_diplomacy,id_faction WHERE id_faction.id=faction_diplomacy.id_faction_a AND faction_diplomacy.id_faction_b='" + IntToString(GetIDFaction(oPC)) + "' AND faction_diplomacy.diplomacy='1' AND faction_diplomacy.status='0'");
    while(SQLFetch())
    {
        ReplaceIntElement(
            AddStringElement(SQLGetData(2),OFFERED_ALLIANCES,oPC)-1,
            StringToInt(SQLGetData(1)),OFFERED_ALLIANCES,oPC); // Retrieve faction data from allied factions and store them on the player
    }
    return WAR_DECLARATIONS;
}

void ReturnWar(object oPC, int nIDFaction)
{
    SQLExecDirect("UPDATE faction_diplomacy SET diplomacy='1',status='1' WHERE id_faction_a='" + IntToString(GetIDFaction(oPC)) + "' AND id_faction_b='" + IntToString(nIDFaction) + "'");
    SQLExecDirect("UPDATE faction_diplomacy SET diplomacy='1',status='1' WHERE id_faction_b='" + IntToString(GetIDFaction(oPC)) + "' AND id_faction_a='" + IntToString(nIDFaction) + "'");
}

void DeclareWar(object oPC,int nIDFaction)
{
    SQLExecDirect("UPDATE faction_diplomacy SET diplomacy='1',status='0' WHERE id_faction_a='" + IntToString(GetIDFaction(oPC)) + "' AND id_faction_b='" + IntToString(nIDFaction) + "'");
    if (nIDFaction == 0)
        ReturnWar(oPC,nIDFaction);
} */

int LoadNullFactionData(object oPC)
{
    if (!GetIsPC(oPC))
        return FALSE;

    WriteTimestampedLogEntry("Not in a faction... Loading NULL Faction data for " + GetName(oPC) + "...");

    SetLocalInt(oPC,ID_FACTION,0);

    return TRUE;
}

void SetFactionAlignment(object oSubject, string sAlign)
{
    if (GetStringLength(sAlign) != 2)
        return;

    string sLawChaos = GetStringLeft(sAlign,1);
    string sGoodEvil = GetStringRight(sAlign,1);

    int nLawChaos = GetLawChaosValue(oSubject);
    int nGoodEvil = GetGoodEvilValue(oSubject);

    /*if (sLawChaos == "L" && nLawChaos != )
        AdjustAlignment(oSubject,ALIGNMENT_LAWFUL,200);
    else if (sLawChaos == "N")

    else if (sLawChaos == "C") */


    if (sGoodEvil == "G" && nGoodEvil < 70)
        AdjustAlignment(oSubject,ALIGNMENT_GOOD,100);
    //else if (sGoodEvil == "N")

    else if (sGoodEvil == "E" && nGoodEvil > 30)
        AdjustAlignment(oSubject,ALIGNMENT_EVIL,100);
}

int LoadFactionData (object oPC)
{
    if (!GetIsPC(oPC))
        return FALSE;

    WriteTimestampedLogEntry("Loading Faction data for " + GetName(oPC) + "...");

    NWNX_SQL_ExecuteQuery("SELECT id_faction_member.id,id_faction_member.status,id_faction.id,id_faction.aura,id_faction.name,id_faction.alignment FROM id_faction_member,id_faction WHERE id_faction_member.account='" + SQLEncodeSpecialChars(GetPCPlayerName(oPC)) + "' AND id_faction_member.id_faction=id_faction.id");

    if (!NWNX_SQL_ReadyToReadNextRow())
        return FALSE;

    NWNX_SQL_ReadNextRow();
    int nIDFaction = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));

    /*string sFactionConst = FACTION_CONST_PREFIX + IntToString(nIDFaction);

    if (GetLocalInt(oPC,PARTY_POS) == -1) // only want this to run once
    {
        SetLocalInt(oPC,PARTY_POS,
            AddObjectElement(oPC,sFactionConst,GetModule())-1);
        AddToParty(oPC,GetFirstObjectElement(sFactionConst,GetModule()));
    } */

    SetLocalInt(oPC,ID_MEMBER,StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
    SetLocalInt(oPC,STATUS,StringToInt(NWNX_SQL_ReadDataInActiveRow(1)));
    SetLocalInt(oPC,ID_FACTION,nIDFaction);
    SetLocalString(oPC,FACTION_NAME,NWNX_SQL_ReadDataInActiveRow(4));

    SetFactionAlignment(oPC,NWNX_SQL_ReadDataInActiveRow(5));

    WriteTimestampedLogEntry("    ID_FACTION=" + IntToString(nIDFaction));
    WriteTimestampedLogEntry("    ID_MEMBER=" + NWNX_SQL_ReadDataInActiveRow(0));
    WriteTimestampedLogEntry("    STATUS=" + NWNX_SQL_ReadDataInActiveRow(1));
    WriteTimestampedLogEntry("    FACTION_NAME=" + NWNX_SQL_ReadDataInActiveRow(4));

    ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(StringToInt(NWNX_SQL_ReadDataInActiveRow(3))),oPC);

    if (!HasItem(oPC,"flel_it_factome"))
        CreateItemOnObject("factiontoken", oPC);

    /*LoadAlliedFactions(oPC);
    LoadEnemyFactions(oPC);

    string sWarDeclaringFaction = GetFirstStringElement(GetWarDeclarations(oPC),oPC);
    while (GetStringLength(sWarDeclaringFaction)>0)
    {
        sWarDeclaringFaction=GetNextStringElement();
        FloatingTextStringOnCreature(sWarDeclaringFaction + " has declared war on your faction!",oPC);
    }

    string sAlliancesOffered = GetFirstStringElement(GetOfferedAlliances(oPC),oPC);
    while (GetStringLength(sAlliancesOffered)>0)
    {
        sAlliancesOffered=GetNextStringElement();
        FloatingTextStringOnCreature(sAlliancesOffered + " has offered your faction an alliance.",oPC);
    }  */

    return TRUE;
}

void JoinFactionParty(object oPC)
{
    object oMember = GetFirstPC();
    while (GetIsObjectValid(oMember))
    {
        if (oPC != oMember && !GetIsDM(oMember) && (GetIDFaction(oMember) == GetIDFaction(oPC)))
        {
            AddToParty(oPC,oMember);
            break;
        }
        oMember = GetNextPC();
    }
}

void AddMember(object oFrom, object oTo)
{
    if (IsFactioned(oTo))
    {
        SendMessageToPC(oFrom, "Failure! " + GetPCPlayerName(oTo) + " is already in a faction");
        SendMessageToPC(oTo, "You must leave your former faction before joining a new one.");
        return;
    }

    NWNX_SQL_ExecuteQuery("INSERT INTO id_faction_member (account,id_faction,status) VALUES ('" + SQLEncodeSpecialChars(GetPCPlayerName(oTo)) + "','" + IntToString(GetIDFaction(oFrom)) + "','2')");
    WriteTimestampedLogEntry("AddMember(" + GetName(oFrom) + ":" +  IntToString(GetIDFaction(oFrom)) + ", " + GetName(oTo) + ")");
    if (LoadFactionData(oTo))
    {
        NWNX_SQL_ExecuteQuery("SELECT id_faction.name FROM id_faction,id_faction_member WHERE id_faction_member.account='" + SQLEncodeSpecialChars(GetPCPlayerName(oTo)) + "' AND id_faction_member.id_faction=id_faction.id");
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            string sName = NWNX_SQL_ReadDataInActiveRow(0);
            SendMessageToPC(oFrom, "Success! " + GetPCPlayerName(oTo) + " was added to " + sName);
            SendMessageToPC(oTo, "Welcome to " + sName + ", " + GetName(oTo) + "! Your faction data has been linked to your account.");
        }
    }
}

void RemoveMember(object oFrom, object oTo)
{
    NWNX_SQL_ExecuteQuery("DELETE FROM id_faction_member WHERE id='" + IntToString(GetIDMember(oTo)) + "'");
    if (!LoadFactionData(oTo))
    {
        NWNX_SQL_ExecuteQuery("SELECT aura FROM id_faction WHERE id='" + IntToString(GetIDFaction(oFrom)) + "'");
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            RemoveEffect(oTo, EffectVisualEffect(StringToInt(NWNX_SQL_ReadDataInActiveRow(0))));

            SendMessageToPC(oFrom, "Success! " + GetPCPlayerName(oTo) + " has been removed from the faction.");
            SendMessageToPC(oTo, "You have been kicked from your faction.");
            RemoveFromParty(oTo);
            object oItem = GetItemPossessedBy(oTo,"flel_it_factome");
            if (GetIsObjectValid(oItem))
                DestroyObject(oItem);
            LoadNullFactionData(oTo);
        }
    }
}

void PromoteCommander(object oFrom, object oTo)
{
    NWNX_SQL_ExecuteQuery("UPDATE id_faction_member SET status='1' WHERE id='" + IntToString(GetIDMember(oTo)) + "'");
    if (LoadFactionData(oTo))
    {
        SendMessageToPC(oFrom, "Success! " + GetPCPlayerName(oTo) + " has been promoted to commander");
        SendMessageToPC(oTo, "You have been promoted to faction commander. Congratulations!");
    }
}

void DemoteCommander(object oFrom, object oTo)
{
    NWNX_SQL_ExecuteQuery("UPDATE id_faction_member SET status='2' WHERE id='" + IntToString(GetIDMember(oTo)) + "'");
    if (LoadFactionData(oTo))
    {
        SendMessageToPC(oFrom, "Success! " + GetPCPlayerName(oTo) + " has been demoted to member");
        SendMessageToPC(oTo, "You have been demoted to a regular member");
    }
}

void DemoteGeneral(object oPC)
{
    NWNX_SQL_ExecuteQuery("UPDATE id_faction_member SET status='1' WHERE id='" + IntToString(GetIDMember(oPC)) + "'");
    if (LoadFactionData(oPC))
         SendMessageToPC(oPC, "You have been demoted to commander");
}

void StepDown(object oPC)
{
    if (IsStatusGeneral(oPC))
        DemoteGeneral(oPC);
    if (IsStatusCommander(oPC))
        DemoteCommander(OBJECT_INVALID,oPC);
}

void LoadDiplomacy(object oPC)
{
    NWNX_SQL_ExecuteQuery("SELECT diplomacy,id_faction_b FROM faction_diplomacy WHERE id_faction_a='" + IntToString(GetIDFaction(oPC)) + "'");
    while(NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        object oMember = GetFirstPC();
        while (GetIsObjectValid(oMember))
        {
            if (oPC != oMember && !GetIsDM(oMember) && (GetIDFaction(oMember) != GetIDFaction(oPC)) && GetIDFaction(oMember) == StringToInt(NWNX_SQL_ReadDataInActiveRow(1)))
            {
                switch (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)))
                {
                    case 1:
                        AssignCommand(oPC,SetIsTemporaryFriend(oMember));
                        SetPCLike(oPC,oMember);
                        break;
                    case 0:
                        AssignCommand(oPC,SetIsTemporaryNeutral(oMember));
                        break;
                    case -1:
                        AssignCommand(oPC,SetIsTemporaryEnemy(oMember));
                        SetPCDislike(oPC,oMember);
                        break;
                }
            }
            oMember = GetNextPC();
        }
    }
}

#include "nw_i0_plot"
#include "db_inc"
#include "pg_lists_i"
#include "inc_tokenizer"

const string SDB_FACTION_TOMETAG      = "flel_it_factome";
const string SDB_FACTION_TOMERESREF   = "factiontoken";
const string SDB_TOME_OPTIONS = "SDB_TOME_OPTIONS";
const string SDB_TOME_LIST    = "SDB_TOME_LIST";
const string SDB_TOME_TARGET  = "SDB_TOME_TARGET";
const string SDB_TOME_PAGE    = "SDB_TOME_PAGE";
const string SDB_TOME_SPEAKER = "SDB_TOME_SPEAKER";
const string SDB_TOME_CONFIRM = "SDB_TOME_CONFIRM";

const string FBANK_T1_XP       = "XP";
const string FBANK_T1_GP       = "GP";
const string FBANK_T2_OBELISK  = "OBELISK";
const string FBANK_T2_TITHE    = "TITHE";
const string FBANK_T2_WITHDRAW = "WITHDRAW";
const string FBANK_T2_DEPOSIT  = "DEPOSIT";
const string FBANK_T2_SHOP     = "SHOP";

const int SDB_FACTION_COMMANDER_CNT = 4;
const int FACTION_TITHE_ACCUM       = 30000; // After this amount of XP, the XP and GP will be transfered into factionbank
const int MIN_XP_IN_BANK            = 500000;
const int MIN_GP_IN_BANK            = 15000000;
const int XP_WORTH_GP               = 25; // how much gold worth 1 XP?
const int FACT_GP_DEPOSIT_CAP       = 2500000;
const int FACT_XP_REWARD_CAP        = 100000;
const int FACT_GP_REWARD_CAP        = 10000000;

const string SDB_FAID_LIST          = "SDB_FAID_LIST";
//const string SDB_FMID             = "SDB_FMID";
const string SDB_FACTION_AURA       = "SDB_FACTION_AURA_";
const string SDB_FACTION_AURA2      = "SDB_FACTION_AURA2_";
const string SDB_FACTION_NAME       = "SDB_FACTION_NAME_";
const string SDB_FACTION_ANIMOSITY  = "SDB_FACTION_ANIMOSITY";
const string SDB_FACTION_WP         = "SDB_FACTION_WP_";
const string SDB_FACTION_DIPLO      = "SDB_FACTION_DIPLO_";
const string SDB_FACTION_ARTIFACT   = "SDB_FACTION_ARTIFACT";
const string SDB_FACTION_ARTICOUNT  = "SDB_FACTION_ARTICOUNT";
const string SDB_FACTION_BOSSNAME   = "SDB_FACTION_BOSSNAME";
const string SDB_FACTION_BOSSSKIN   = "SDB_FACTION_BOSSSKIN";
const string SDB_FACTION_ARTINAME   = "SDB_FACTION_ARTINAME";
//const string SDB_FACTION_TITHE    = "SDB_FACTION_TITHE";

string SDB_FactionAdd(object oPC, object oTomer); // oTomer IS AN OFFICER INVITING oPC
void   SDB_FactionApplyAura(object oPC);
int    SDB_FactionGetAura(string sFAID, string sRank); // GET THE FACTION AURA
string SDB_FactionGetFirst();
string SDB_FactionGetName(string sFAID); // GET THE FACTION NAME
string SDB_FactionGetNext();
string SDB_FactionGetRank(object oPC);
int    SDB_FactionHasRank(object oPC, string sRank = DB_FACTION_MEMBER);
int    SDB_FactionIsMember(object oPC, string sFAID = "0"); // TRUE/FALSE IF IN FACTION, OPTIONALLY CHECK FOR SPECIFIC FACTION
void   SDB_FactionLoadData(); // LOAD MASTER FACTION DATA ON MODULE
void   SDB_LoadDiplomacy(object oPC, int nJoinParty = TRUE, int nLoadDiplomacy = FALSE);
string SDB_FactionNewGeneral(object oCommander, object oGeneral);
void   SDB_FactionOnClientEnter(object oPC);
void   SDB_FactionOnModuleLoad();
void   SDB_FactionOnPCDeath(object oPC, object oKiller);
void   SDB_FactionOnPCRespawn(object oPC);
void   SDB_FactionOnPCRest(object oPC);
void   SDB_FactionReloadData(object oPC);
string SDB_FactionRemove(object oPC, object oTomer=OBJECT_INVALID); // oTomer IS AN OFFICER REMOVING oPC, ELSE REMOVING SELF
string SDB_FactionSetRank(object oPC, string sRank = DB_FACTION_MEMBER);
string SDB_GetFAID(object oPC);
//string SDB_GetFMID(object oPC, int nCheckCKID = FALSE); // GET THE FACTION MEMBER ID
int    SDB_InList(string sList, string sValue, string sDelim = "|");
string SDB_FactionDMAdd(object oPC, string sFAID, string sRank);
string SDB_FactionDMRemove(object oPC);
object FactionGetAltar(string sFAID);
// - sAcc_In: Use Depositing player account
// - sAcc_Out: Withdraw target player account
// - sType1: FBANK_T1_*
// - sType2: FBANK_T2_*
// - nAmount: Amount of Withdraw/Deposit
// - sFAID: FAID of the Bank
// - sRank_Out: Who gave XP/GP out - DB_FACTION_LIEUTENANT, DB_FACTION_GENERAL
void FactionLogBankTransfer(string sTRUEID_In, string sTRUEID_Out, string sType1, string sType2, int nAmount, string sFAID, string sRank_Out = "");
string FactionGetShortcut(string sFAID);
void SetFactionXP(int nXP, string sFAID);
int GetFactionsXP(string sFAID);
void SetFactionGold(int nXP, string sFAID);
int GetFactionsGold(string sFAID);

// give factionless player a Party ID
// to prevent player leaving party for teamkill
void PartyGiveID(object oPC);
// * Returns TRUE if the Party Ids of the two objects are the same
// Different than GetFactionEqual(), will return TRUE even after one player leaving the Party
// IDs are given to factionless player at OnPlayerRest
// Use this only if one of the objects is factionless
int PartyGetEqualID(object oFirst, object oSecond);

void SetFactionXP(int nXP, string sFAID)
{
    SetLocalInt(GetModule(), "FACTION_XP_" + sFAID, nXP - MIN_XP_IN_BANK);
}

int GetFactionsXP(string sFAID)
{
    return GetLocalInt(GetModule(), "FACTION_XP_" + sFAID);
}

void SetFactionGold(int nGP, string sFAID)
{
    SetLocalInt(GetModule(), "FACTION_GOLD_" + sFAID, nGP - MIN_GP_IN_BANK);
}

int GetFactionsGold(string sFAID)
{
    return GetLocalInt(GetModule(), "FACTION_GOLD_" + sFAID);
}

string EnemyGetList(object oPC, int nFAID)
{
    if (nFAID) return GetLocalString(GetModule(), "ENEMY_LIST" + IntToString(nFAID));
    return GetLocalString(oPC, "ENEMY_LIST");
}

void EnemySaveList(object oPC, string sList, string sWhere)
{
    string sSQL;
    if (sWhere == "F")
    {
        string sFAID = SDB_GetFAID(oPC);
        sSQL = "update faction set fa_enemies='" + sList + "' where fa_faid=" + sFAID;
        SetLocalString(GetModule(), "ENEMY_LIST" + sFAID, sList);
    }
    else if (sWhere == "A")
    {
        sSQL = "update trueid set enemies='" + sList + "' where trueid=" + IntToString(dbGetTRUEID(oPC));
        SetLocalString(oPC, "ENEMY_LIST", sList);
    }
    else return;
    NWNX_SQL_ExecuteQuery(sSQL);
}

string SDB_GetFAID(object oPC)
{
   //SDB_GetFMID(oPC); // JUST TO BE SURE FACTION DATA LOADED
   return GetLocalString(oPC, DB_FAID);
}

void SDB_FactionReloadData(object oPC)
{
   //DeleteLocalString(oPC, SDB_FMID);
   DeleteLocalString(oPC, DB_FAID);
   DeleteLocalString(oPC, DB_FACTION_RANK);
   //ALERTALERTALERTALERTALERTALERTALERTALERTALERTALERTALERTALERTALERTALERTALERTALERT ALLOW force reloading faction stuff for aura changes.
   //dbGetCKID(oPC);
   //dbGetCKID(oPC, TRUE);
   //SDB_GetFMID(oPC); // RELOAD FACTION DATA
}

// TRUE/FALSE IF IN FACTION, OPTIONALLY CHECK FOR SPECIFIC FACTION
int SDB_FactionIsMember(object oPC, string sFAID = "0")
{
   if (sFAID != "0") return (sFAID == SDB_GetFAID(oPC)); // CHECK SPECIFIC
   return (StringToInt(GetLocalString(oPC, DB_FAID))); // CHECK ANY
}

string SDB_FactionGetRank(object oPC)
{
   //SDB_GetFMID(oPC); // JUST TO BE SURE FACTION DATA LOADED
   return GetLocalString(oPC, DB_FACTION_RANK);
}

int SDB_FactionHasRank(object oPC, string sRank = DB_FACTION_MEMBER)
{
   return (SDB_FactionGetRank(oPC) == sRank);
}

string SDB_FactionNewGeneral(object oLieutenant, object oGeneral)
{
   string scTRUEID = IntToString(dbGetTRUEID(oLieutenant));
   string sgTRUEID = IntToString(dbGetTRUEID(oGeneral));
   if (SDB_FactionGetRank(oLieutenant) == DB_FACTION_LIEUTENANT && SDB_FactionGetRank(oGeneral) == DB_FACTION_GENERAL)
   {
      NWNX_SQL_ExecuteQuery("update trueid set farank=" + dbQuotes(DB_FACTION_LIEUTENANT) + " where trueid=" + sgTRUEID);
      NWNX_SQL_ExecuteQuery("update trueid set farank=" + dbQuotes(DB_FACTION_GENERAL) +    " where trueid=" + sgTRUEID);
      SDB_FactionReloadData(oLieutenant); // RELOAD FACTION DATA
      SDB_FactionReloadData(oGeneral); // RELOAD FACTION DATA
      return "Success! The torch has been passed. " + GetName(oLieutenant) + " is the new General of " + SDB_FactionGetName(SDB_GetFAID(oLieutenant));
   }
   return "Failure! The Faction General can only appoint an existing Lieutenant to his position.";
}

string SDB_FactionSetRank(object oPC, string sRank = DB_FACTION_MEMBER)
{
    //string sFMID = SDB_GetFMID(oPC);
    string sFAID = SDB_GetFAID(oPC);
    string sOldRank = SDB_FactionGetRank(oPC);
    string sSQL;
    string sMsg = "";
    int nCnt = 0;
    if (sRank == DB_FACTION_MEMBER && sOldRank == DB_FACTION_COMMANDER)
    { // DEMOTING COMMANDER TO MEMBER
        SendMessageToPC(oPC, "You have been demoted from Faction Commander to Member.");
        sMsg = GetName(oPC) + " has been demoted from Faction Commander to Member.";
    }
    else if (sRank == DB_FACTION_COMMANDER && sOldRank == DB_FACTION_MEMBER)
    { // PROMOTING MEMBER TO COMMANDER, COUNT EXISTING FIRST
        NWNX_SQL_ExecuteQuery("select count(*) from trueid where faid=" + sFAID + " and farank=" + dbQuotes(DB_FACTION_COMMANDER));
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            nCnt = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        }
        if (nCnt == SDB_FACTION_COMMANDER_CNT)
        {
            return "Failure! " + SDB_FactionGetName(sFAID) + " already has the maximum of " + IntToString(SDB_FACTION_COMMANDER_CNT) + " Commanders";
        }
        else
        {
            SendMessageToPC(oPC, "Congratulations! You have been promoted to Faction Commander.");
            sMsg =  "Success! " + GetName(oPC) + " has been promoted to Faction Commander.";
        }
    }
    else if (sRank == DB_FACTION_LIEUTENANT && (sOldRank == DB_FACTION_MEMBER || sOldRank == DB_FACTION_COMMANDER))
    { // PROMOTING MEMBER OR COMMANDER TO LIEUTENANT, COUNT EXISTING FIRST
        NWNX_SQL_ExecuteQuery("select count(*) from trueid where faid=" + sFAID + " and farank=" + dbQuotes(DB_FACTION_LIEUTENANT));
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            nCnt = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        }
        if (nCnt)
        {
            return "Failure! " + SDB_FactionGetName(sFAID) + " already has a Faction Lieutenant";
        }
        else
        {
            SendMessageToPC(oPC, "Congratulations! You have been promoted to Faction Lieutenant.");
            sMsg =  "Success! " + GetName(oPC) + " has been promoted to Faction Lieutenant.";
        }
    }
    else if (sRank == DB_FACTION_MEMBER && sOldRank == DB_FACTION_LIEUTENANT)
    { // DEMOTING LIEUTENANT TO MEMBER
        SendMessageToPC(oPC, "You have been demoted from Faction Lieutenant to Member.");
        sMsg = GetName(oPC) + " has been demoted from Faction Lieutenant to Member.";
    }
    NWNX_SQL_ExecuteQuery("update trueid set farank=" + dbQuotes(sRank) + " where trueid=" + IntToString(dbGetTRUEID(oPC)));
    SDB_FactionReloadData(oPC); // RELOAD FACTION DATA
    return sMsg;
}

string SDB_FactionGetName(string sFAID) // GET THE FACTION NAME
{
    return GetLocalString(GetModule(), SDB_FACTION_NAME + sFAID);
}


int SDB_FactionGetAura(string sFAID, string sRank) // GET THE FACTION AURA
{
    if (sRank == DB_FACTION_GENERAL) return GetLocalInt(GetModule(), SDB_FACTION_AURA2 + sFAID);
    return GetLocalInt(GetModule(), SDB_FACTION_AURA + sFAID);
}

void SDB_FactionApplyAura(object oPC)
{
    if (!SDB_FactionIsMember(oPC) || GetIsDM(oPC)) return;
    int nAura = SDB_FactionGetAura(SDB_GetFAID(oPC), SDB_FactionGetRank(oPC));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(nAura)), oPC);
}

void SDB_FactionSetArtifact(string sFAID, string sArtiFAID) // SET THE FACTION ARTIFACT OWNER
{
    SetLocalString(GetModule(), SDB_FACTION_ARTIFACT + sFAID, sArtiFAID);
    string sSQL = "update faction set fa_artifact=" + sArtiFAID + " where fa_faid=" + sFAID;
    NWNX_SQL_ExecuteQuery(sSQL);
}

string SDB_FactionGetArtifact(string sFAID) // GET THE FACTION ARTIFACT POSSESSING FACTION
{
    return GetLocalString(GetModule(), SDB_FACTION_ARTIFACT + sFAID);
}

string SDB_FactionGetArtifactName(string sFAID) // GET THE FACTION ARTIFACT NAME
{
    return GetLocalString(GetModule(), SDB_FACTION_ARTINAME + sFAID);
}

int SDB_FactionGetArtifactCount(string sFAID) // GET THE FACTION ARTIFACT COUNT
{
    return GetLocalInt(GetModule(), SDB_FACTION_ARTICOUNT + sFAID);
}

string SDB_FactionGetBossName(string sFAID) // GET THE FACTION BOSS NAME
{
    return GetLocalString(GetModule(), SDB_FACTION_BOSSNAME + sFAID);
}

int SDB_FactionGetBossSkin(string sFAID) // GET THE FACTION BOSS SKIN
{
    return GetLocalInt(GetModule(), SDB_FACTION_BOSSSKIN + sFAID);
}

int SDB_FactionGetShortcut(string sFAID)
{
    return GetLocalInt(GetModule(), "FACTION_SHORTCUT_" + sFAID);
}

void FactionLoadAltars()
{
    object oModule = GetModule();
    int nCnt = 0;
    object oAltar = GetObjectByTag("FACTION_ALTAR", nCnt);
    while (GetIsObjectValid(oAltar))
    {
        SetLocalObject(oModule, "FACTION_ALTAR" + GetLocalString(GetArea(oAltar), "FAID"), oAltar);
        nCnt++;
        oAltar = GetObjectByTag("FACTION_ALTAR", nCnt);
    }
}

object FactionGetAltar(string sFAID)
{
    return GetLocalObject(GetModule(), "FACTION_ALTAR" + sFAID);
}

void SDB_FactionLoadData() // LOAD MASTER FACTION DATA ON MODULE
{
    FactionLoadAltars();
    object oModule = GetModule();
    DeleteList(SDB_FAID_LIST, oModule);
    string sFAList = "";
    string sSQL;
    sSQL = "update faction set fa_artifact=fa_faid where fa_artifact=0";  // REBOOTED WITH NO OWNERS
    NWNX_SQL_ExecuteQuery(sSQL);
    sSQL = "select fa_faid, fa_name, fa_aura, fa_aura2, fa_shortcut, fa_artifact, fa_bossname, fa_bossskin, fa_artifactname, fa_fame, fa_enemies from faction order by fa_faid";
    NWNX_SQL_ExecuteQuery(sSQL);
    while(NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string sFAID = NWNX_SQL_ReadDataInActiveRow(0);
        SetLocalString(oModule, DB_FAID + "_" + sFAID, sFAID);
        SetLocalString(oModule, SDB_FACTION_NAME + sFAID, NWNX_SQL_ReadDataInActiveRow(1));
        SetLocalInt(oModule, SDB_FACTION_AURA + sFAID, StringToInt(NWNX_SQL_ReadDataInActiveRow(2)));
        SetLocalInt(oModule, SDB_FACTION_AURA2 + sFAID, StringToInt(NWNX_SQL_ReadDataInActiveRow(3)));
        SetLocalString(oModule, "FACTION_SHORTCUT_" + sFAID, NWNX_SQL_ReadDataInActiveRow(4));
        SetLocalString(oModule, SDB_FACTION_ARTIFACT + sFAID, NWNX_SQL_ReadDataInActiveRow(5));
        SetLocalString(oModule, SDB_FACTION_BOSSNAME + sFAID, NWNX_SQL_ReadDataInActiveRow(6));
        SetLocalInt(oModule, SDB_FACTION_BOSSSKIN + sFAID, StringToInt(NWNX_SQL_ReadDataInActiveRow(7)));
        SetLocalString(oModule, SDB_FACTION_ARTINAME + sFAID, NWNX_SQL_ReadDataInActiveRow(8));
        SetLocalInt(oModule, "FACTION_FAME_" + sFAID, StringToInt(NWNX_SQL_ReadDataInActiveRow(9)));
        SetLocalString(oModule, "ENEMY_LIST" + sFAID, NWNX_SQL_ReadDataInActiveRow(10));
        int nEle = AddStringElement(sFAID, SDB_FAID_LIST, oModule);
    }
}

string FactionGetShortcut(string sFAID)
{
    return GetLocalString(GetModule(), "FACTION_SHORTCUT_" + sFAID);
}

string SDB_FactionAdd(object oPC, object oTomer) // oTomer IS AN OFFICER INVITING oPC
{
    string sFAIDOld = SDB_GetFAID(oPC);
    string sFAID = SDB_GetFAID(oTomer); // NEW FACTION
    string sFactionName = SDB_FactionGetName(sFAID);
    if (StringToInt(sFAIDOld)) // SHOULD NOT HAPPEN, BUT IN CASE
    {
        SendMessageToPC(oTomer, "Sorry, " + GetName(oPC) + " is already a " + SDB_FactionGetRank(oPC) + " in " + SDB_FactionGetName(sFAIDOld));
        return "Sorry, you are already a " + SDB_FactionGetRank(oPC) + " in " + SDB_FactionGetName(sFAIDOld);
    }
    string sSQL = "update trueid set faid=" + sFAID + ", farank=" + dbQuotes(DB_FACTION_MEMBER) + " where trueid=" + IntToString(dbGetTRUEID(oPC));
    NWNX_SQL_ExecuteQuery(sSQL);
    SDB_FactionReloadData(oPC); // RELOAD FACTION DATA
    SendMessageToPC(oTomer, "Success! " + GetName(oPC) + " is the newest member of " + sFactionName);
    if (!HasItem(oPC, SDB_FACTION_TOMETAG)) CreateItemOnObject(SDB_FACTION_TOMERESREF, oPC); // GIVE TOME
    return "Success! You are the newest member of " + sFactionName;
}

string SDB_FactionRemove(object oPC, object oTomer=OBJECT_INVALID) // oTomer IS AN OFFICER REMOVING oPC, ELSE REMOVING SELF
{
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    string sFAID   = SDB_GetFAID(oPC);
    string sFactionRank = SDB_FactionGetRank(oPC);
    string sFactionName = SDB_FactionGetName(sFAID);
    if (sFactionRank == DB_FACTION_GENERAL)
    { // GENERAL REMOVING SELF!
        return "Failure! Please promote a new General before quitting " + sFactionName;
    }
    string sSQL = "update trueid set faid=0, farank=" + dbQuotes(DB_FACTION_MEMBER) + " where trueid=" + sTRUEID;
    NWNX_SQL_ExecuteQuery(sSQL);
    DeleteLocalString(oPC, DB_FAID);
    DeleteLocalString(oPC, DB_FACTION_RANK);
    SetLocalString(FactionGetAltar(sFAID), "OLD_FAID"+sTRUEID, sFAID); // check for ppl leaving faction to skip some checks, like factionsop
    RemoveEffect(oPC, EffectVisualEffect(SDB_FactionGetAura(sFAID, sFactionRank)));
    DestroyObject(GetItemPossessedBy(oPC, SDB_FACTION_TOMETAG)); // REMOVE TOME
    if (GetIsObjectValid(oTomer))
    { // FORCED REMOVAL BY OFFICER
        SendMessageToPC(oPC, "You have been removed as a member of " + sFactionName + " by " + GetName(oTomer));
        return "Success! " + GetName(oPC) + " is no longer a member of " + sFactionName;
    }
    return "Success! You are no longer a member of " + sFactionName;
}

string SDB_FactionReset(object oGeneral, string sResetRank)
{
    string sFAID = SDB_GetFAID(oGeneral);
    string sFactionRank = SDB_FactionGetRank(oGeneral);
    string sFactionName = SDB_FactionGetName(sFAID);
    string sSQL;
    if (sFactionRank != DB_FACTION_GENERAL || sResetRank == DB_FACTION_GENERAL)
    {
        return "Error, you can not reset " + sResetRank;
    }
    else if (sResetRank == DB_FACTION_LIEUTENANT)
    {
        sSQL = "update trueid set farank=" + dbQuotes(DB_FACTION_MEMBER) + " where farank=" + dbQuotes(DB_FACTION_LIEUTENANT) + " and faid=" + sFAID;
    }
    else if (sResetRank == DB_FACTION_COMMANDER)
    {
        sSQL = "update trueid set farank=" + dbQuotes(DB_FACTION_MEMBER) + " where farank=" + dbQuotes(DB_FACTION_COMMANDER) + " and faid=" + sFAID;
    }
    else if (sResetRank == DB_FACTION_MEMBER)
    {
        sSQL = "update trueid set faid=0, farank=" + dbQuotes(DB_FACTION_MEMBER) + " where farank=" + dbQuotes(DB_FACTION_MEMBER) + " and faid=" + sFAID;
    }
    NWNX_SQL_ExecuteQuery(sSQL);

    object oMember = GetFirstPC();
    while (GetIsObjectValid(oMember))
    {
        if (SDB_GetFAID(oMember) == sFAID)
        {
            if (sResetRank == SDB_FactionGetRank(oMember))
            {
                SendMessageToPC(oMember, "Faction Reset! You have been removed as a " + sResetRank + " of " + sFactionName);
                if (sResetRank == DB_FACTION_MEMBER)
                {
                    RemoveEffect(oMember, EffectVisualEffect(SDB_FactionGetAura(sFAID, sFactionRank)));
                    DestroyObject(GetItemPossessedBy(oMember, SDB_FACTION_TOMETAG)); // REMOVE TOME
                }
                SDB_FactionReloadData(oMember);
            }
        }
        oMember = GetNextPC();
    }
    NWNX_SQL_ExecuteQuery(sSQL);

    if (sResetRank == DB_FACTION_MEMBER) return "Success! Removed all Non-Officer " + sResetRank + " from " + sFactionName;
    return "Success! Demoted all Member from rank " + sResetRank + " to Non-Officer Member.";
}

int SDB_InList(string sList, string sValue, string sDelim = "|")
{
   return (FindSubString(sList, sDelim + sValue + sDelim)!=-1);
}

object PickJoinPartyMember(object oObjectSelected, object oMember, string sRank)
{
    if (!GetIsObjectValid(oObjectSelected))  // TAKE FIRST FACTION MEMBER FOUND
    {
        if (!GetIsDeXStadium(GetTag(GetArea(oMember)))) oObjectSelected = oMember;
    }
    else if (sRank == DB_FACTION_GENERAL)  // FOUND THE GENERAL, PICK HIM
    {
        if (!GetIsDeXStadium(GetTag(GetArea(oMember)))) oObjectSelected = oMember;
    }
    else if (sRank == DB_FACTION_LIEUTENANT)  // FOUND A LIEUTENANT
    {
        if (!GetIsDeXStadium(GetTag(GetArea(oMember)))) oObjectSelected = oMember; // TAKE LIEUTENANT OVER A MEMBER
    }
    else if (sRank == DB_FACTION_COMMANDER)  // FOUND A COMMANDER
    {
        if (!GetIsDeXStadium(GetTag(GetArea(oMember)))) oObjectSelected = oMember; // TAKE COMMANDER OVER A MEMBER
    }
    return oObjectSelected;
}


void SDB_LoadDiplomacy(object oPC, int nJoinParty = TRUE, int nLoadDiplomacy = FALSE)
{
    if (!GetIsObjectValid(oPC)) return;
    string sFAID = SDB_GetFAID(oPC);
    string sIDPC;       string sRank;   string stFAID;
    object oGeneral;    object oObjectSelected;
    int nIsFactioned = StringToInt(sFAID);
    int nIsFactionedTarget;
    object oMember = GetFirstPC();
    while (GetIsObjectValid(oMember))
    {
        stFAID = SDB_GetFAID(oMember);
        nIsFactionedTarget = StringToInt(stFAID);

        if (!GetIsDM(oMember) && oPC != oMember)
        {
            string stFAID = SDB_GetFAID(oMember);
            if (nIsFactioned && sFAID == stFAID) // pc factioned and same faction with target
            {
                if (nJoinParty && sRank != DB_FACTION_GENERAL)
                {
                    sRank = SDB_FactionGetRank(oMember);
                    oObjectSelected = PickJoinPartyMember(oObjectSelected, oMember, sRank);
                }
            }
            else if (nLoadDiplomacy)
            {
                if (nIsFactionedTarget) stFAID = "F" + stFAID;
                else stFAID = "A" + IntToString(dbGetACID(oMember));

                if (nIsFactioned) sIDPC = "F" + sFAID;
                else sIDPC = "A" + IntToString(dbGetACID(oPC));

                if (GetIsTokenInString(stFAID, EnemyGetList(oPC, nIsFactioned))) DelayCommand(1.0, SetPCDislike(oPC, oMember));
                else if (GetIsTokenInString(sIDPC, EnemyGetList(oMember, nIsFactionedTarget))) DelayCommand(1.0, SetPCDislike(oPC, oMember));
            }
        }
        oMember = GetNextPC();
    }

    if (nIsFactioned && nJoinParty)
    {
        if (!GetIsObjectValid(oObjectSelected)) SendMessageToPC(oPC, "Sorry, no " + SDB_FactionGetName(sFAID) + " members are logged in right now.");
        else
        {
            AddToParty(oPC, oObjectSelected);
            SendMessageToPC(oPC, "You have joined your Faction's party.");
        }
    }
    return;
}

void SDB_FactionOnClientEnter(object oPC)
{
   if (SDB_FactionIsMember(oPC))
   {
      SDB_FactionApplyAura(oPC);
      if (!HasItem(oPC, SDB_FACTION_TOMETAG)) CreateItemOnObject(SDB_FACTION_TOMERESREF, oPC); // GIVE IF NOT THERE
   }
}

void SDB_FactionOnModuleLoad()
{
   SDB_FactionLoadData();
}

void SDB_FactionOnPCRest(object oPC)
{
   SDB_FactionApplyAura(oPC);
}

void SDB_FactionOnPCRespawn(object oPC)
{
   SDB_FactionApplyAura(oPC);
}

string SDB_FactionGetFirst()
{
   return GetFirstStringElement(SDB_FAID_LIST, GetModule());
}
string SDB_FactionGetNext()
{
   return GetNextStringElement();
}

string SDB_FactionDMAdd(object oPC, string sFAID, string sRank)
{
    string sFactionName = SDB_FactionGetName(sFAID);
    string sSQL;
    if (sRank == DB_FACTION_GENERAL) // DEMOTE OLD GENERAL
    {
        sSQL = "update trueid set farank=" + dbQuotes(DB_FACTION_MEMBER) + " where farank=" + dbQuotes(DB_FACTION_GENERAL) + " and faid=" + sFAID;
        NWNX_SQL_ExecuteQuery(sSQL);
    }
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    sSQL = "update trueid set faid=" + sFAID + ", farank=" + dbQuotes(sRank) + " where trueid=" + sTRUEID;
    NWNX_SQL_ExecuteQuery(sSQL);
    SDB_FactionReloadData(oPC); // RELOAD FACTION DATA
    SendMessageToPC(oPC, "Success! You are the newest " + sRank + " of " + sFactionName);
    if (!HasItem(oPC, SDB_FACTION_TOMETAG)) CreateItemOnObject(SDB_FACTION_TOMERESREF, oPC); // GIVE TOME
    return "Success! " + GetName(oPC) + " is a " + sRank + " of " + sFactionName;
}

string SDB_FactionDMRemove(object oPC)
{
   string sTRUEID = IntToString(dbGetTRUEID(oPC));
   string sFAID   = SDB_GetFAID(oPC);
   string sFactionRank = SDB_FactionGetRank(oPC);
   string sFactionName = SDB_FactionGetName(sFAID);
   string sSQL = "update trueid set farank=" + dbQuotes(DB_FACTION_MEMBER) + ", faid=0 where trueid=" + sTRUEID;
   NWNX_SQL_ExecuteQuery(sSQL);
   DeleteLocalString(oPC, DB_FAID);
   DeleteLocalString(oPC, DB_FACTION_RANK);
   RemoveEffect(oPC, EffectVisualEffect(SDB_FactionGetAura(sFAID, sFactionRank)));
   DestroyObject(GetItemPossessedBy(oPC, SDB_FACTION_TOMETAG)); // REMOVE TOME
   SendMessageToPC(oPC, "You have been removed as a " + sFactionRank + " of " + sFactionName + " by a DM");
   return "Success! " + GetName(oPC) + " is no longer a " + sFactionRank + " of " + sFactionName;
}

void FactionLogBankTransfer(string sTRUEID_In, string sTRUEID_Out, string sType1, string sType2, int nAmount, string sFAID, string sRank_Out = "")
{
    NWNX_SQL_ExecuteQuery("insert into factionbank (fb_trueid_in,fb_trueid_out,fb_type1,fb_type2,fb_amount,fb_faid,fb_rank_out) values (" + DelimList(dbQuotes(sTRUEID_In), dbQuotes(sTRUEID_Out), dbQuotes(sType1), dbQuotes(sType2), IntToString(nAmount), sFAID, dbQuotes(sRank_Out)) + ")");
}

void PartyGiveID(object oPC)
{
    string sID = IntToString(dbGetTRUEID(GetFactionLeader(oPC)));
    object oMember = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oMember))
    {
        SetLocalString(oMember, "PARTY_ID", sID);
        oMember = GetNextFactionMember(oPC);
    }
}

int PartyGetEqualID(object oFirst, object oSecond)
{
    return (GetLocalString(oFirst, "PARTY_ID") == GetLocalString(oSecond, "PARTY_ID"));
}
//void main() {}



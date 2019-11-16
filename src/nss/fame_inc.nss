//#include "aps_include"
#include "pg_lists_i"
#include "gen_inc_color"
#include "seed_faction_inc"
#include "_functions"
#include "db_inc"


// Divide fFame with all player in same party
void GiveAllPartyMembersFame(object oPC, float fReward, float fMaxPerMember, string sReason, int nCheckArea = FALSE, int nDoShout = TRUE);
// Fame_inc
void StoreFameOnDB(object oPC, string sFAID, int nWithBoost = TRUE, int nLogOut = FALSE);
// Fame_inc
void StoreTimeOnDB(object oPC, string sFAID, int nLogOut = FALSE);
// Fame_inc - Add fVal with SetLocalFloat on oPC and return total count
float IncFameOnChar(object oPC, float fVal = 0.0);
// Fame_inc - Add fVal with SetLocalFloat on oPC and return total count
float IncTimeOnChar(object oPC, float fVal = 0.0);
int GetFactionPlaytime(string sFAID, int nRealHours=1);
// 1 = XP, 2 = Gold, 3 = Fame
int GetFactionStats(string sFAID, int nWhich=1);
void UpdateFactionStats(string sFAID = "all");
void UpdateRichStatues();
string GetTopFamousFAID(string sRank="1");
string GetTopRichestFAID(string sRank="1");
// return variable 1, 2 or 3, depending on ranking
int GetRichModifier(int nMod1, int nMod2, int nMod3, string sFAID);
// return variable 1, 2 or 3, depending on ranking
int GetFamousModifier(int nMod1, int nMod2, int nMod3, string sFAID);
// oPC steal XP and Gold from sFAID bank and tansfer into own bank.
// sReason = What triggered it (for shout), nWhich 0 = absolute amount, 1 = % of sFAID bank
void StealFromFaction(object oPC, float fBonusXP, float fBonusGold, string sFAID, string sFAIDName, string sReason, int nWhich=0);
// use this at cliententer only
void FameSetBoost(object oPC, float fCurrentFame, float fFameSpent);
// fame for donated XP
float GetFameForXP(int nXP);


const float  FAME_PER_ARTEFACT    = 25.0;
const float  FAME_PER_GAMEHOUR    = 0.03;
const float  FAME_PER_TAKEN_LEVEL = 0.1;

// use this at cliententer only
void FameSetBoost(object oPC, float fCurrentFame, float fFameSpent)
{
    float fBoost = 3.0 - (fCurrentFame + fFameSpent) / 2500;
    if (fBoost > 0.0) SetLocalFloat(oPC, "FAME_BOOST", fBoost);
    else
        DeleteLocalFloat(oPC, "FAME_BOOST");
}

float FameGetBoost(object oPC)
{
    return 1.0 + GetLocalFloat(oPC, "FAME_BOOST");
}

float GetFameForXP(int nXP)
{
   return IntToFloat(nXP)/3750.0f;
}

void FameClientEnter(object oPC)
{
    string sFame = "0.0";
    string sFameSpent = "0.0";
    // DeleteLocalFloat(oPC, "PVPTOKEN_ON_CHAR");
    DeleteLocalFloat(oPC, "FAME_ON_CHAR");
    DeleteLocalFloat(oPC, "TIME_ON_CHAR");
    DeleteLocalFloat(oPC, "FAME_BOOST");

    NWNX_SQL_ExecuteQuery("select fame,famespent from trueid where trueid="+ dbQuotes(IntToString(dbGetTRUEID(oPC))) +" limit 1");

    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sFame = NWNX_SQL_ReadDataInActiveRow(0);
        sFameSpent = NWNX_SQL_ReadDataInActiveRow(1);
        SendMessageToPC(oPC, "You have "+sFame+" fame, and you have spent "+sFameSpent+" fame.");
    }
    SetLocalInt(oPC, "PLAYER_FAME", StringToInt(sFame));
    SetLocalInt(oPC, "PLAYER_FAME_SPENT", StringToInt(sFameSpent));

    FameSetBoost(oPC, StringToFloat(sFame), StringToFloat(sFameSpent));

    string nFameRanking = "0";
    if (StringToInt(sFame) + StringToInt(sFameSpent) > 100)
    {
        NWNX_SQL_ExecuteQuery("select count(fame) from trueid where fame+famespent >= (select fame+famespent from trueid where trueid=" + IntToString(dbGetTRUEID(oPC)) + ")");
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            nFameRanking = NWNX_SQL_ReadDataInActiveRow(0);
        }
    }
    SetLocalString(oPC, "PLAYER_FAME_RANKING", nFameRanking);
}

int GetTotalFame(object oPC)
{
    return GetLocalInt(oPC, "PLAYER_FAME") + GetLocalInt(oPC, "PLAYER_FAME_SPENT");
}

void GiveAllPartyMembersFame(object oPC, float fReward, float fMaxPerMember, string sReason, int nCheckArea = FALSE, int nDoShout = TRUE)
{
    if (!GetIsObjectValid(oPC)) return;
    int nMemberCount;
    float fMemberCVRCount;
    string sMsg;
    object oModule = GetModule();
    object oAreaPC = GetArea(oPC);

    object oMember = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oMember)) // loop through all members in party
    {
        if (nCheckArea && GetArea(oMember) != oAreaPC)
        {
            // do nothing
        }
        else
        {
            fMemberCVRCount += GetLocalFloat(oMember, "CVR_MODIFIER");
            nMemberCount++;
        }
        oMember = GetNextFactionMember(oPC);
    }
    // divide reward by members in party
    float fModifiedMemberCount = IntToFloat(nMemberCount) + fMemberCVRCount;
    float fDivided             = fReward / fModifiedMemberCount;
    if (fDivided > fMaxPerMember) fDivided = fMaxPerMember; // set cap
    fReward = fDivided * fModifiedMemberCount; // re-calculate actual total reward

    if (sReason != "") sReason = "(" + sReason + ") ";
    sMsg = GetRGB(11,9,11) + sReason + "Rewarding " + IntToString(nMemberCount) +
        " player: " + FloatToString(fDivided, 0, 2) + " Fame " +
        "(" + FloatToString(fReward, 0, 2) + "/" +
        FloatToString(fModifiedMemberCount, 0, 2) + ")";

    // Reward them
    oMember = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oMember))
    {
        if (nCheckArea && GetArea(oMember) != oAreaPC)
        {
            // do nothing
        }
        else
        {
            IncFameOnChar(oMember, fDivided);
            if (!nDoShout) SendMessageToPC(oMember, sMsg);
        }
        oMember = GetNextFactionMember(oPC);
    }
    if (nDoShout) SpeakString(sMsg, TALKVOLUME_SHOUT);
}

void StealFromFaction(object oPC, float fBonusXP, float fBonusGold, string sFAID, string sFAIDName, string sReason, int nWhich=0)
{
    if (!GetIsObjectValid(oPC)) return;

    // first get fresh data
    NWNX_SQL_ExecuteQuery("select fa_bankxp, fa_bankgold from faction where fa_faid=" + sFAID);
    if (!NWNX_SQL_ReadyToReadNextRow())    return;

    NWNX_SQL_ReadNextRow();
    int nFactXP   = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    int nFactGold = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));

    int nBonusXP, nBonusGold;

    if (nWhich == 1)
    {
        nBonusXP = FloatToInt(IntToFloat(nFactXP) / 200.0 * fBonusXP);
        nBonusGold = FloatToInt(IntToFloat(nFactGold) / 200.0 * fBonusGold);
    }
    else
    {
        nBonusXP = FloatToInt(fBonusXP);
        nBonusGold = FloatToInt(fBonusGold);
    }

     // check if bank values less than bonus somehow, just incase
    if (nFactXP < nBonusXP) nBonusXP = nFactXP;
    if (nFactGold < nBonusGold) nBonusGold = nFactGold;

    if (nBonusXP > FACT_XP_REWARD_CAP) nBonusXP = FACT_XP_REWARD_CAP;
    if (nBonusGold > FACT_GP_REWARD_CAP) nBonusGold = FACT_GP_REWARD_CAP;

    object oModule = GetModule();
    // actualize it ingame
    SetFactionXP(nFactXP - nBonusXP, sFAID);
    SetFactionGold(nFactGold - nBonusGold, sFAID);

    // steal from bank
    NWNX_SQL_ExecuteQuery("update faction set fa_bankxp=fa_bankxp-" + IntToString(nBonusXP) +
                  ", fa_bankgold=fa_bankgold-" + IntToString(nBonusGold) + " where fa_faid=" + sFAID);

    ////////////////////////////////////////////////
    // get player informations about bank
    string sTRUEID = IntToString(dbGetTRUEID(oPC));

    NWNX_SQL_ExecuteQuery("select xp,gp from trueid where trueid=" + sTRUEID);
    if (!NWNX_SQL_ReadyToReadNextRow()) return;

    NWNX_SQL_ReadNextRow();
    int nPcXP   = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
    int nPcGold = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));

     // actualize it ingame

    SetLocalInt(oPC, "BANKXP", nPcXP + nBonusXP); // "db_inc"
    SetLocalInt(oPC, "BANKGOLD", nPcGold + nBonusGold); // "db_inc"

    // reward the player
    NWNX_SQL_ExecuteQuery("update trueid set xp=xp+" + IntToString(nBonusXP) +
                  ", gp=gp+" + IntToString(nBonusGold) + " where trueid=" + sTRUEID);

    FactionLogBankTransfer("", GetPCPlayerName(oPC), FBANK_T1_XP, FBANK_T2_OBELISK, nBonusXP, sFAID);
    FactionLogBankTransfer("", GetPCPlayerName(oPC), FBANK_T1_GP, FBANK_T2_OBELISK, nBonusGold, sFAID);

    AssignCommand(oModule, SpeakString(GetRGB(15,5,1) + "(" + sReason + ") " + GetName(oPC) +
                                    " has stolen " + IntToString(nBonusXP) + "XP and " +
                                    IntToString(nBonusGold) + "GP from " + sFAIDName, TALKVOLUME_SHOUT));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
}

void StoreTimeOnDB(object oPC, string sFAID, int nLogOut = FALSE)
{
    int nTime = GetLocalInt(oPC, "TIME_ON_CHAR");
    if (nTime)
    {
        if (StringToInt(sFAID))
        {
            NWNX_SQL_ExecuteQuery("update faction set fa_time=fa_time+" + IntToString(nTime) + " where fa_faid=" + sFAID);
        }
        if (GetIsObjectValid(oPC) && !nLogOut)
        {
            DeleteLocalInt(oPC, "TIME_ON_CHAR");
            IncFameOnChar(oPC, IntToFloat(nTime) * FAME_PER_GAMEHOUR);
        }
    }
}

void StoreFameOnDB(object oPC, string sFAID, int nWithBoost = TRUE, int nLogOut = FALSE)
{
    float fBoost = 1.0;
    if (nWithBoost == TRUE) fBoost = FameGetBoost(oPC);
    float fFame = GetLocalFloat(oPC, "FAME_ON_CHAR") * fBoost;
    if (fFame > 1.0)
    {
        string sFame = FloatToString(fFame, 0, 2);
        if (StringToInt(sFAID))
        {
            NWNX_SQL_ExecuteQuery("update faction set fa_fame=fa_fame+" + sFame + " where fa_faid=" + sFAID);
        }
        NWNX_SQL_ExecuteQuery("update trueid set fame=fame+"+ sFame +" where trueid="+dbQuotes(IntToString(dbGetTRUEID(oPC))));

        if (GetIsObjectValid(oPC) && !nLogOut)
        {
            string sBoostMsg = "";
            if (fBoost > 1.0) sBoostMsg = " (Starter boost modifier " + IntToString(FloatToInt(fBoost) + 1) + ")";
            SendMessageToPC(oPC, "+" + sFame + " fame" + sBoostMsg);
            GiveGoldToCreature(oPC, FloatToInt(fFame * 1800.0));
            DeleteLocalFloat(oPC, "FAME_ON_CHAR");
            IncLocalInt(oPC, "PLAYER_FAME", FloatToInt(fFame));
        }
    }
}

float IncFameOnChar(object oPC, float fVal = 0.0)
{
    float fNew = GetLocalFloat(oPC, "FAME_ON_CHAR") + fVal;
    if (fVal != 0.0) SetLocalFloat(oPC, "FAME_ON_CHAR", fNew);
    return fNew;
}

float IncTimeOnChar(object oPC, float fVal = 0.0)
{
    float fNew = GetLocalFloat(oPC, "TIME_ON_CHAR") + fVal;
    if (fVal != 0.0) SetLocalFloat(oPC, "TIME_ON_CHAR", fNew);
    return fNew;
}

string GetTopFamousFAID(string sRank="1")
{
    return GetLocalString(GetModule(), "FACTION_FAMOUS_" + sRank);
}

string GetTopRichestFAID(string sRank="1")
{
    return GetLocalString(GetModule(), "FACTION_RICHEST_" + sRank);
}

int GetFactionPlaytime(string sFAID, int nRealHours=1)
{
    if (nRealHours) return (GetLocalInt(GetModule(), "FACTION_TIME_" + sFAID)/2)*60;
    return GetLocalInt(GetModule(), "FACTION_TIME_" + sFAID);
}

int GetFactionStats(string sFAID, int nWhich=1)
{
   if (nWhich == 1) return GetFactionsXP(sFAID);
   if (nWhich == 2) return GetFactionsGold(sFAID);
   if (nWhich == 3) return GetLocalInt(GetModule(), "FACTION_FAME_" + sFAID);
   return FALSE;
}

int GetRichModifier(int nMod1, int nMod2, int nMod3, string sFAID)
{
    int nMod = FALSE;
    if (GetTopRichestFAID("1") == sFAID) nMod = nMod1;
    else if (GetTopRichestFAID("2") == sFAID) nMod = nMod2;
    else if (GetTopRichestFAID("3") == sFAID) nMod = nMod3;
    return nMod;
}

int GetFamousModifier(int nMod1, int nMod2, int nMod3, string sFAID)
{
    int nMod = 0;
    if (GetTopFamousFAID("1") == sFAID) nMod = nMod1;
    else if (GetTopFamousFAID("2") == sFAID) nMod = nMod2;
    else if (GetTopFamousFAID("3") == sFAID) nMod = nMod3;
    return nMod;
}

void LoadFactionRanking()
{
    object oModule = GetModule();

    int nCnt = 1;
    NWNX_SQL_ExecuteQuery("select fa_faid from faction order by fa_bankxp + fa_bankgold/" + IntToString(XP_WORTH_GP) + " desc limit 4");
    while (NWNX_SQL_ReadyToReadNextRow() && nCnt <= 4)
    {
        NWNX_SQL_ReadNextRow();
        SetLocalString(oModule, "FACTION_RICHEST_" + IntToString(nCnt), NWNX_SQL_ReadDataInActiveRow(0));
        nCnt++;
    }

    nCnt = 1;
    NWNX_SQL_ExecuteQuery("select fa_faid from faction order by fa_fame desc limit 4");
    while (NWNX_SQL_ReadyToReadNextRow() && nCnt <= 4)
    {
        NWNX_SQL_ReadNextRow();
        SetLocalString(oModule, "FACTION_FAMOUS_" + IntToString(nCnt), NWNX_SQL_ReadDataInActiveRow(0));
        nCnt++;
    }
}

void UpdateFactionStats(string sFAID = "all")
{
    int nDoAll;
    if (sFAID == "all")
    {
        nDoAll = TRUE;
        sFAID = GetFirstStringElement("SDB_FAID_LIST", GetModule());
    }

    while (sFAID != "")
    {
        NWNX_SQL_ExecuteQuery("select fa_bankxp, fa_bankgold, fa_fame from faction where fa_faid=" + sFAID);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            SetFactionXP(StringToInt(NWNX_SQL_ReadDataInActiveRow(0)), sFAID);
            SetFactionGold(StringToInt(NWNX_SQL_ReadDataInActiveRow(1)), sFAID);
            SetLocalInt(GetModule(), "FACTION_FAME_" + sFAID, StringToInt(NWNX_SQL_ReadDataInActiveRow(2)));
        }
        if (nDoAll) sFAID = GetNextStringElement();
        else return;
    }
}

void UpdateRichStatues()
{
    object oModule = GetModule();
    object oRichStatue;
    effect eVfx = EffectVisualEffect(VFX_FNF_PWSTUN);
    string sFAIDCheck; string sFAID; string sCnt;
    int nCnt = 1;

    while (nCnt <= 3)
    {
        sCnt = IntToString(nCnt);
        oRichStatue = GetLocalObject(oModule, "FACTION_RICH_STATUE_" + sCnt);
        if (GetIsObjectValid(oRichStatue))
        {
            sFAIDCheck = GetLocalString(oRichStatue, "FAID");
            sFAID = GetTopRichestFAID(sCnt);
            if (sFAIDCheck != sFAID)
            {
                SetName(oRichStatue, "#" + sCnt + " Richest Faction: " + GetLocalString(oModule, "SDB_FACTION_NAME_" + sFAID));
                SetLocalString(oRichStatue, "FAID", sFAID);
                DelayCommand(IntToFloat(nCnt)/2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVfx, oRichStatue));
            }
        }
        nCnt++;
    }
}

void RespawnFameObelisk(object oModule, string sWhichObelisk, int nCheckExisting = TRUE)
{
    object oObelisk;

    // Get the FAID for this obelisk by ranking
    string sFAID = GetTopFamousFAID(sWhichObelisk);
    //if (sFAID == "") return;

    // check if FAID existing on a Obelisk first, if yes, destroy.
    // respawn if its on another obelisk
    if (nCheckExisting)
    {
        int nCnt = 1;
        string sCnt, sFAIDCheck;
        while (nCnt <= 3)
        {
            sCnt = IntToString(nCnt);
            oObelisk = GetLocalObject(oModule, "OBELISK_" + sCnt);
            if (GetIsObjectValid(oObelisk))
            {
                sFAIDCheck = GetLocalString(oObelisk, "FAID");
                if (sFAIDCheck == sFAID)
                {
                    SetPlotFlag(oObelisk, FALSE);
                    DestroyObject(oObelisk);
                    if (sWhichObelisk != sCnt) AssignCommand(oModule, DelayCommand(1.0, RespawnFameObelisk(oModule, sCnt, FALSE)));
                }
            }
            nCnt++;
        }
    }
    // Back to our WhichObelisk
    object oWpObelisk = GetLocalObject(oModule, "WP_OBELISK_" + sWhichObelisk);
    if (GetIsObjectValid(oWpObelisk)) // If the waypoint existing
    {
        oObelisk = CreateObject(OBJECT_TYPE_PLACEABLE, "factionobelisk", GetLocation(oWpObelisk));
        SetLocalObject(oModule, "OBELISK_" + sWhichObelisk, oObelisk);
        SetLocalString(oObelisk, "FAID", sFAID);
        SetLocalString(oObelisk, "WHICH_OBELISK", sWhichObelisk);
        SetName(oObelisk, "#" + sWhichObelisk + " Famous Faction: " + GetLocalString(oModule, "SDB_FACTION_NAME_" + sFAID));
        effect eVfx = EffectVisualEffect(VFX_FNF_PWSTUN);
        AssignCommand(oModule, DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVfx, oObelisk)));

        object oObeliskLock = GetLocalObject(oModule, "OBELISK_0");
        if (GetIsObjectValid(oObeliskLock))
        {
            effect eBeam = EffectBeam(VFX_BEAM_SILENT_LIGHTNING, oObeliskLock, BODY_NODE_CHEST);
            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBeam, oObelisk));
            SetPlotFlag(oObelisk, TRUE);
        }
        else SetPlotFlag(oObelisk, FALSE);
    }
}

void RespawnObeliskLock(object oWp)
{
    object oModule = GetModule();
    if (GetIsObjectValid(GetLocalObject(oModule, "OBELISK_0"))) return;
    object oObeliskLock = CreateObject(OBJECT_TYPE_PLACEABLE, "factionobelisk0", GetLocation(oWp));
    SetLocalObject(oModule, "OBELISK_0", oObeliskLock);
    effect eVfx = EffectVisualEffect(VFX_FNF_PWSTUN);
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVfx, oObeliskLock));

    effect eBeam = EffectBeam(VFX_BEAM_SILENT_LIGHTNING, oObeliskLock, BODY_NODE_CHEST);
    object oObelisk;
    int nCnt = 1;
    while (nCnt <= 3)
    {
        oObelisk = GetLocalObject(oModule, "OBELISK_" + IntToString(nCnt));
        if (GetIsObjectValid(oObelisk))
        {
            SetPlotFlag(oObelisk, TRUE);
            DelayCommand(IntToFloat(nCnt)/2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBeam, oObelisk));
        }
        nCnt++;
    }
}

void FameOnModLoad()
{
    object oModule = GetModule();

    // Store Richstatues
    SetLocalObject(oModule, "FACTION_RICH_STATUE_1", GetObjectByTag("FACTION_RICH_STATUE_1"));
    SetLocalObject(oModule, "FACTION_RICH_STATUE_2", GetObjectByTag("FACTION_RICH_STATUE_2"));
    SetLocalObject(oModule, "FACTION_RICH_STATUE_3", GetObjectByTag("FACTION_RICH_STATUE_3"));

    // Store Obelisks
    object oSweep = GetLocalObject(oModule, "WHICH_SWEEP"); // Which sweeping Map?
    object oWpObelisk0 = GetFirstObjectInArea(oSweep); //Pick first object there
    if (GetTag(oWpObelisk0) != "WP_OBELISK_0") oWpObelisk0 = GetNearestObjectByTag("WP_OBELISK_0", oWpObelisk0); // assign obelisk0 next to first object in sweeping
    object oWpObelisk1 = GetNearestObjectByTag("WP_OBELISK_1", oWpObelisk0);
    object oWpObelisk2 = GetNearestObjectByTag("WP_OBELISK_2", oWpObelisk0);
    object oWpObelisk3 = GetNearestObjectByTag("WP_OBELISK_3", oWpObelisk0);

    SetLocalObject(oModule, "WP_OBELISK_0", oWpObelisk0); // store wps local
    SetLocalObject(oModule, "WP_OBELISK_1", oWpObelisk1);
    SetLocalObject(oModule, "WP_OBELISK_2", oWpObelisk2);
    SetLocalObject(oModule, "WP_OBELISK_3", oWpObelisk3);

    DelayCommand(10.0, RespawnFameObelisk(oModule, "1", FALSE));
    DelayCommand(11.0, RespawnFameObelisk(oModule, "2", FALSE));
    DelayCommand(12.0, RespawnFameObelisk(oModule, "3", FALSE));
    DelayCommand(13.0, RespawnObeliskLock(GetLocalObject(oModule, "WP_OBELISK_0")));
}

//void main(){}

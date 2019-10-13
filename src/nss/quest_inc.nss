#include "db_inc"
#include "fame_inc"
#include "random_loot_inc"
#include "time_inc"

////////////////////////////////////////////////////////////////////////////////
//
// Allways create new quests in Journal starting with Category ID 1
// ID 1000 for success and ID 1001 for failed journal entries
// Quest Tags in Journal allways starting with "QUEST_" + a integer number
// Quest-Tag: QUEST_1   ID: 1 (First Entry)   ID: 1000 (Success)   ID: 1001 (Failed)
// Insert in Journal editor the total states into Quest XP Field
//
////////////////////////////////////////////////////////////////////////////////

// these states are set at module load when quest failed because timeout
// or when succeeding the quest. ID of Category in Journal are set as Finish Categories.
// When creating new Quest, allways use these ID's for success and fail journal entries.
const string QUEST_STATE_SUCCESS    = "1000";
const string QUEST_STATE_FAILED     = "1001";

// quests with these states are basically removed and not visible for player anymore.
// Only information is stored in DB for statistic.
const string QUEST_DB_SUCCESS       = "1002";
const string QUEST_DB_FAILED        = "1003";


// Load Player journal, look for new quests...
void Q_OnTavernEnter(object oPC);

// Allways use const QUEST_STATE_SUCCESS as state for succeeded quests
// Leave sState as "" for updating to next State automatically
void Q_UpdateQuest(object oPC, string sQuest, int AddNew = FALSE, string sState = "");

// Return the current State or FALSE. ReturnAll = FALSE will return finished quests as FALSE
int Q_GetHasQuest(object oPC, string sQuest, int nReturnAll = TRUE);

// Get the expire or restart time in days
// nWhich = 1 for Expire and 2 for Restart
int Q_GetExpireRestart(int nQuest, int nWhich = 1);

object Q_GetVariableHolder();

object Q_GetVariableHolder()
{
    return GetLocalObject(GetModule(), "VARS_QUEST");
}

int Q_GetExpireRestart(int nQuest, int nWhich = 1)
{
    switch (nQuest)
    {                          // expire  // restart
        //case 1:  return (nWhich == 1) ? 7 : 7;  // MISSION 01: Kill the Scouts
        //case 2:  return (nWhich == 1) ? 7 : 7;  // MISSION 02: Kill a Champion
        //case 3:  return (nWhich == 1) ? 7 : 7;  // MISSION 03: Silver for Stonehead
        case 4:  return (nWhich == 1) ? 4 : 7; // MISSION 04: Knuckles for Hashishkabob
        //case 5:  return (nWhich == 1) ? 7 : 7;  // MISSION 05: Idol for Zelda
        case 6:  return (nWhich == 1) ? 15 : 3; // MISSION 06: Maglubiyet Statue
        case 7:  return (nWhich == 1) ? 10 : 7; // MISSION 07: Kill Shadows
        //case 8:  return (nWhich == 1) ? 7 : 7;  // MISSION 08: Faction Obelisks
        //case 9: return (nWhich == 1) ? 7 : 7;  // MISSION 09: Fame Trophy
        case 10: return (nWhich == 1) ? 15 : 10;// MISSION 10: Donate XP for Fame
        case 11: return (nWhich == 1) ? 4 : 3;  // MISSION 11: Stars
        case 12: return (nWhich == 1) ? 10 : 3; // MISSION 12: Kill Onos, the Kobold
        //case 13: return (nWhich == 1) ? 7 : 7;  // MISSION 13: Join Castle Raids
        //case 14: return (nWhich == 1) ? 7 : 7;  // MISSION 14: Craft Potions
        //case 15: return (nWhich == 1) ? 7 : 7;  // MISSION 15: Broken Harp
        //case 16: return (nWhich == 1) ? 7 : 7;  // MISSION 16: Broken Horn
        case 17: return (nWhich == 1) ? 9 : 4;  // MISSION 17: Find scrolls
        case 1002: return (nWhich == 1) ? 7 : 30;  // SPECIAL: Weekly Tombola
        case 1003: return (nWhich == 1) ? 2 : 14;  // SPECIAL: Daily Tombola
        case 1001: // special like easter or xmas
            int nSpecialDays = GetLocalInt(Q_GetVariableHolder(), "SPECIAL_DAYS_LEFT");
            return (nWhich == 1) ? nSpecialDays : nSpecialDays + 7;
    }
    return (nWhich == 1) ? 7 : 7;
}

int Q_GetTotalStates(string sQuestTag)
{
    return GetJournalQuestExperience("QUEST_" + sQuestTag);
}

void Q_DoTombola(int nQuest)
{
    string sExpire = IntToString(Q_GetExpireRestart(nQuest));
    string sRestart = IntToString(Q_GetExpireRestart(nQuest, 2));
    string sQuest = IntToString(nQuest);
    // pick random winner. participate whoever loged on within 7 days. player with still active mission do not participate
    NWNX_SQL_ExecuteQuery("SELECT trueid FROM trueid where adddate(lastlogin, 7) > now() and trueid not in(SELECT qu_trueid FROM quest where qu_quest=" + sQuest + " and qu_state < 1002) order by rand() limit 1");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string sTRUEID = NWNX_SQL_ReadDataInActiveRow(0);
        NWNX_SQL_ExecuteQuery("insert into quest (qu_trueid, qu_quest, qu_state, qu_added, qu_expire, qu_restart) values (" + DelimList(sTRUEID, sQuest, "1", "now()", sExpire, sRestart) + ")");
    }
}

void Q_OnModuleLoad()
{
    object oHolder = GetObjectByTag("NEW_PLAYER_NPC");
    if (!GetIsObjectValid(oHolder))
    {
        WriteTimestampedLogEntry("Error in Q_OnModuleLoad(), can not find Variable Holder");
        oHolder = GetAreaFromLocation(GetStartingLocation());
    }
    SetLocalObject(GetModule(), "VARS_QUEST", oHolder);
    SetLocalInt(oHolder, "TOTAL_QUESTS", 17);
    float fDelay = 1.0;
    if (dbGetLastSessionCrashed()) fDelay = 1800.0; // last session crashed, allow new quests after 30 minutes
    DelayCommand(fDelay, SetLocalInt(oHolder, "ENABLE_QUESTS", 1));

    // SPECIAL
    NWNX_SQL_ExecuteQuery("select DATEDIFF('2010-04-07', now())");
    string sSpecialDays = "0";
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sSpecialDays = NWNX_SQL_ReadDataInActiveRow(0);
    }
    SetLocalInt(oHolder, "SPECIAL_DAYS_LEFT", StringToInt(sSpecialDays));

    // daily and weekly tombola
    NWNX_SQL_ExecuteQuery("SELECT qu_id FROM quest where date(qu_added) = curdate() and qu_quest = 1003 limit 1");
    if (!NWNX_SQL_ReadyToReadNextRow()) // check if done today allready
    {
        Q_DoTombola(1003); // do daily
        Q_DoTombola(1003); // do daily
        Q_DoTombola(1003); // do daily

        NWNX_SQL_ExecuteQuery("select weekday(now())");
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            if (NWNX_SQL_ReadDataInActiveRow(0) == "1") // check if tuesday
            {
                Q_DoTombola(1002); // do weekly
                Q_DoTombola(1002); // do weekly
                Q_DoTombola(1002); // do weekly
            }
        }
    }
}

string Q_GetTimeLeft(object oPC, string sQuest, int nSeconds = 0)
{
    string sTime;
    if (!nSeconds) nSeconds = GetLocalInt(oPC, "TIMELEFT_QUEST_" + sQuest);
    if (nSeconds == -1) sTime = "until next server reboot!";
    else sTime = ConvertSecondsToString(nSeconds);

    return "Time left: " + sTime;
}

int Q_LoadQuestsFromDB(object oPC, object oHolder)
{
    int nState;     int nTimeLeft;  int nCnt;
    string sQuest;  string sState;
    string sTRUEID = IntToString(dbGetTRUEID(oPC));

    string sSQLTimeLeft = "round((UNIX_TIMESTAMP(adddate(qu_added, qu_expire)) - UNIX_TIMESTAMP(now()))/60)";
    NWNX_SQL_ExecuteQuery("select qu_quest, qu_state, " + sSQLTimeLeft + " from quest where qu_trueid=" + sTRUEID + " and qu_state < " + QUEST_DB_SUCCESS + " order by qu_last limit 20");
    int nServerTimeLeft = GetLocalInt(GetModule(), "SERVER_TIME_LEFT");
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sQuest = NWNX_SQL_ReadDataInActiveRow(0);
        sState = NWNX_SQL_ReadDataInActiveRow(1);
        nState = StringToInt(sState);
        nTimeLeft = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));

        AddStringElement(sQuest + ":" + sState, "QUEST_LIST_" + sTRUEID, oHolder);
        AddJournalQuestEntry("QUEST_" + sQuest, nState, oPC, FALSE);
        if (nState < 1000) // not finished quest states
        {
            if (nTimeLeft < nServerTimeLeft) nTimeLeft = -1;
            else nTimeLeft *= 60; // store in seconds for sec_to_time function
            //SetLocalInt(oPC, "TIMELEFT_QUEST_" + sQuest, nTimeLeft);
            SendMessageToPC(oPC, "MISSION " + sQuest + " " + Q_GetTimeLeft(oPC, sQuest, nTimeLeft));
        }
        nCnt++;
    }
    return nCnt;
}

void Q_LoadQuestsFromCache(object oPC, object oHolder)
{
    string sState;     int nPos;
    string sQuest;
    string sString = GetFirstStringElement("QUEST_LIST_" + IntToString(dbGetTRUEID(oHolder)), oHolder);
    while (sString != "")
    {
        nPos = FindSubString(sString, ":");
        if (nPos != -1)
        {
            sQuest = GetStringLeft(sString, nPos);
            sState = GetStringRight(sString, GetStringLength(sString) - (nPos + 1));
            AddJournalQuestEntry("QUEST_" + sQuest, StringToInt(sState), oPC, FALSE);
        }
        sString = GetNextStringElement();
    }
}

// load journal and decide if new quests allowed
int Q_LoadJournal(object oPC, object oHolder)
{
    int nCnt;   int nNewQuest;
    if (GetFirstStringElement("QUEST_LIST_" + IntToString(dbGetTRUEID(oHolder)), oHolder) == "") // cache empty
    {
        int nCnt = Q_LoadQuestsFromDB(oPC, oHolder);
        if (nCnt < 20) // limit to 20 quests in journal
        {
            if (!GetLocalInt(oHolder, IntToString(dbGetTRUEID(oPC))))
            {
                SetLocalInt(oHolder, IntToString(dbGetTRUEID(oPC)), TRUE);
                nNewQuest = TRUE;
            }
        }
    }
    else
    {
        Q_LoadQuestsFromCache(oPC, oHolder);
        nNewQuest = FALSE; // dont allow new quests
    }
    return nNewQuest;
}

int Q_GetHasQuest(object oPC, string sQuest, int nReturnAll = TRUE)
{
    int nState = GetLocalInt(oPC, "NW_JOURNAL_ENTRYQUEST_" + sQuest);
    if (nReturnAll) return nState;
    if (nState > 0 && nState < 1000) return nState;
    return FALSE;
}

void Q_UpdateQuest(object oPC, string sQuest, int AddNew = FALSE, string sState = "")
{
    int nCurrentState = Q_GetHasQuest(oPC, sQuest); // current quest-state
    int nTotalStates = Q_GetTotalStates(sQuest); // get total states

    // last state, continue only if sState is SUCCESS state
    if (nCurrentState == nTotalStates && sState != QUEST_STATE_SUCCESS) return;

    if (!nCurrentState && AddNew) // got no quest, but addnew
    {
        object oHolder = Q_GetVariableHolder();
        if (sState == "") sState = "1";
        AddJournalQuestEntry("QUEST_" + sQuest, 1, oPC, FALSE);
        int nQuest = StringToInt(sQuest);
        string sExpire = IntToString(Q_GetExpireRestart(nQuest));
        string sRestart = IntToString(Q_GetExpireRestart(nQuest, 2));
        string sTRUEID = IntToString(dbGetTRUEID(oPC));
        NWNX_SQL_ExecuteQuery("insert into quest (qu_trueid, qu_quest, qu_state, qu_added, qu_expire, qu_restart) values (" + DelimList(sTRUEID, sQuest, "1", "now()", sExpire, sRestart) + ")");
        AddStringElement(sQuest + ":" + sState, "QUEST_LIST_" + sTRUEID, oHolder); // add new quest to cache
    }
    else if (nCurrentState && nCurrentState < 1001)
    {
        if (sState == "") sState = IntToString(nCurrentState + 1); // sState auto-increment
        int nState = StringToInt(sState);

        if (nState > nTotalStates && nState < 1000) nState = nTotalStates;

        string sTRUEID = IntToString(dbGetTRUEID(oPC));
        if (nState < 1000) AssignCommand(oPC, PlaySound("gui_journaladd"));

        string sAddSQL;
        if (sState == QUEST_STATE_SUCCESS) sAddSQL = ", qu_restart=qu_restart*2";
        AddJournalQuestEntry("QUEST_" + sQuest, nState, oPC, FALSE);
        NWNX_SQL_ExecuteQuery("update quest set qu_state=" + sState + sAddSQL + " where qu_TRUEID=" + sTRUEID + " and qu_quest=" + sQuest + " and qu_state < " + QUEST_STATE_SUCCESS);
        DeleteList("QUEST_LIST_" + sTRUEID, Q_GetVariableHolder()); // delete cache, will reload at player login
    }
}

void Q_DoReward(object oPC, string sQuest)
{
    object oBag = CreateObject(OBJECT_TYPE_PLACEABLE, "questbag", GetLocation(oPC), FALSE, "QUESTBAG");
    SetLocalString(oBag, "TRUEID", IntToString(dbGetTRUEID(oPC)));
    SetLocalString(oBag, "QUEST", sQuest);
    AssignCommand(oBag, DelayCommand(180.0, LootDestroyLootbag(oBag)));
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionInteractObject(oBag));
}

void Q_DialogQuestSuccess(string sQuestText)
{
    object oPC = GetPCSpeaker();
    string sQuest = IntToString(GetLocalInt(OBJECT_SELF, "QUEST_TEXT_" + sQuestText));
    if (Q_GetHasQuest(oPC, sQuest) != Q_GetTotalStates(sQuest)) return; // check again, just incase

    Q_UpdateQuest(oPC, sQuest, FALSE, QUEST_STATE_SUCCESS);
    AssignCommand(oPC, PlaySound("gui_quest_done"));
    DelayCommand(2.0, Q_DoReward(oPC, sQuest));
}

int Q_GetNewQuest(object oPC, object oHolder)
{
    /*if (!Q_GetHasQuest(oPC, "1001")) // special XMAS/easter Quest
    {
        int nExpire = Q_GetExpireRestart(1001);
        if (nExpire > 1)
        {
            SetCustomToken(1000, IntToString(nExpire));
            return 1001;
        }
    }*/

    int nTot = GetLocalInt(oHolder, "TOTAL_QUESTS");
    int nQuestTag = Random(nTot) + 1;
    int nCnt = 1;
    if (!nQuestTag) return FALSE; // something wrong, stop before doing crazy loops


    // player got this quest or quest not existing/disabled, start looping for next one
    // disabled/deleted quests are set 0 XP in journal
    while (nCnt <= nTot)
    {
        if (!Q_GetHasQuest(oPC, IntToString(nQuestTag)))
        {
            if (Q_GetTotalStates(IntToString(nQuestTag)))
            {
                SetCustomToken(1000, IntToString(Q_GetExpireRestart(nQuestTag)));
                return nQuestTag;
            }
        }
        nCnt++;
        if (nQuestTag == nTot) nQuestTag = 1; // at last quest, continue looping at 1
        else nQuestTag++; // else try next quest
    }
    return FALSE; // went through all quests and found nothing
}

void Q_StartQuestDialog(object oPC, int nQuestTag)
{
    // splitting up dialog files, if you add more quests later, continue like this
    string sDialogFile;
    int nFile;
    if (nQuestTag <= 20)
    {
        sDialogFile = "tavern_quest1";
    }
    else if (nQuestTag <= 40)
    {
        sDialogFile = "tavern_quest2";
        nFile = 20;
    }
    else if (nQuestTag <= 60)
    {
        sDialogFile = "tavern_quest3";
        nFile = 40;
    }
    else if (nQuestTag >= 1001 && nQuestTag <= 1020) // special quests
    {
        sDialogFile = "tavern_quest_s1";
        nFile = 1000;
    }
    else
    {
        FadeFromBlack(oPC);
        return; // something wrong
    }

    SetLocalInt(oPC, "QUEST_DIAFILE", nFile);
    SetLocalInt(oPC, "QUEST_DONEW", nQuestTag - nFile); // needed for dialog conditions
    AssignCommand(oPC, ClearAllActions());
    DelayCommand(0.1, AssignCommand(oPC, ActionStartConversation(oPC, sDialogFile, TRUE, FALSE)));
}

void Q_OnTavernEnter(object oPC)
{
    // if (GetPCPlayerName(oPC) != "Ezramun") return;
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    object oHolder = Q_GetVariableHolder();

    if (!Q_LoadJournal(oPC, oHolder)) return; // don't do new quests for this player
    if (!GetLocalInt(oHolder, "ENABLE_QUESTS")) return;

    int nQuestTag = Q_GetNewQuest(oPC, oHolder);
    if (!nQuestTag) return;

    BlackScreen(oPC);
    Q_StartQuestDialog(oPC, nQuestTag);
}

void Q_NotifyTombola(object oPC, int nQuest)
{
    SetCustomToken(1000, IntToString(dbGetTRUEID(oPC)));
    DelayCommand(0.5, AssignCommand(oPC, PlaySound("as_cv_gongring3")));
    DelayCommand(1.0, Q_StartQuestDialog(oPC, nQuest));
    Q_UpdateQuest(oPC, IntToString(nQuest));
}

void Q_CleanupDialogVariables(object oPC, int TavernNewQuest = FALSE)
{
    DeleteLocalInt(oPC, "QUEST_COND");

    if (TavernNewQuest)
    {
        DeleteLocalInt(oPC, "QUEST_DONEW");
        DeleteLocalInt(oPC, "QUEST_DIAFILE");
        if (Q_GetHasQuest(oPC, "1003") == 1)
        {
            Q_NotifyTombola(oPC, 1003); // daily Tombola
            return;
        }
        if (Q_GetHasQuest(oPC, "1002") == 1)
        {
            Q_NotifyTombola(oPC, 1002); // weekly Tombola
            return;
        }
        FadeFromBlack(oPC);
    }
}

int Q_StartingConditional()
{
    object oSpeaker = OBJECT_SELF;
    object oPC = GetPCSpeaker();
    int nCnt = GetLocalInt(oPC, "QUEST_COND"); // get current Count on PC
    if (!nCnt) nCnt = 1;
    SetLocalInt(oPC, "QUEST_COND", nCnt + 1); // store Cnt for next text in dialog file

    if (oSpeaker == oPC) // PC talking to self, it is the new Quest dialog in tavern
    {
        int nQuest = GetLocalInt(oPC, "QUEST_DONEW");
        if (nQuest == nCnt) return TRUE;
        return FALSE;
    }
    // it is some NPC
    int nQuest = GetLocalInt(oSpeaker, "QUEST_TEXT_" + IntToString(nCnt)); // get the assigned Quest ID for this count
    int nCheckState = GetLocalInt(oSpeaker, "QUEST_STATE_" + IntToString(nCnt));
    if (nCheckState)
    {
        return (Q_GetHasQuest(oPC, IntToString(nQuest), FALSE) == nCheckState);
    }
    return Q_GetHasQuest(oPC, IntToString(nQuest), FALSE);
}

int Q_StartingConditionalFinish(string sQuestText)
{
    object oPC = GetPCSpeaker();
    string sQuest = IntToString(GetLocalInt(OBJECT_SELF, "QUEST_TEXT_" + sQuestText));
    if (Q_GetHasQuest(oPC, sQuest) == Q_GetTotalStates(sQuest)) return TRUE;
    return FALSE;
}

void Q_DialogAccept()
{
    object oPC = GetPCSpeaker();
    int nQuest = GetLocalInt(oPC, "QUEST_DONEW");
    nQuest += GetLocalInt(oPC, "QUEST_DIAFILE");
    Q_UpdateQuest(oPC, IntToString(nQuest), TRUE, "1");
}

void Q_FactionAltar(object oPC)
{
    if (!GetIsObjectValid(oPC)) return;

    object oMember = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oMember))
    {
        Q_UpdateQuest(oMember, "13");
        oMember = GetNextFactionMember(oPC);
    }
}

void Q_BindStoneQuest(object oPC, string sAreaTag)
{
    if (sAreaTag == "MAP_ENCH_MIDLAND")
    {
        if (Q_GetHasQuest(oPC, "18") == 1) Q_UpdateQuest(oPC, "18", FALSE);
    }
    else if (sAreaTag == "MAP_PEACEFULL_GRAVES")
    {
        if (Q_GetHasQuest(oPC, "18") == 2) Q_UpdateQuest(oPC, "18", FALSE);
    }
    else if (sAreaTag == "MAP_UD_HOLE")
    {
        if (Q_GetHasQuest(oPC, "18") == 3) Q_UpdateQuest(oPC, "18", FALSE);
    }
    else if (sAreaTag == "MAP_MYTHARA")
    {
        if (Q_GetHasQuest(oPC, "18") == 4) Q_UpdateQuest(oPC, "18", FALSE);
    }
}

void SpawnDryadBoss(object oPC, object oArea, int nNonHostile = FALSE)
{
    object oWP = GetNearestObjectByTag("WP_DRYAD_BOSS", oPC);
    string sTag = "DRYAD_BOSS";
    if (nNonHostile) sTag = "DRYAD_NONHOSTILE";

    object oBoss = CreateObject(OBJECT_TYPE_CREATURE, "epimeliad", GetLocation(oWP), FALSE, sTag);
    SetLocalObject(oArea, "DRYAD_BOSS", oBoss);

    if (!nNonHostile)
    {
        oWP = GetNearestObjectByTag("WP_DRYAD_GUARDS1", oPC);
        object oGuard = CreateObject(OBJECT_TYPE_CREATURE, "dryad_hulk", GetLocation(oWP), FALSE, "DRYAD_HULK");
        SetLocalObject(oGuard, "DRYAD_BOSS", oBoss);

        oWP = GetNearestObjectByTag("WP_DRYAD_GUARDS2", oPC);
        oGuard = CreateObject(OBJECT_TYPE_CREATURE, "dryad_hulk", GetLocation(oWP), FALSE, "DRYAD_HULK");
        SetLocalObject(oGuard, "DRYAD_BOSS", oBoss);
    }
    else SetIsTemporaryFriend(oPC, oBoss);
}

int QuestGetIsStoreScroll(object oScroll)
{
    string sTag = GetTag(oScroll);
    object oStoreItem;
    int nCnt = 1;
    int nStack;
    object oStore = GetObjectByTag("MAGICSHOP_1");
    while (nCnt < 10) // 9 magicshops existing
    {
        if (GetIsObjectValid(oStore))
        {
            oStoreItem = GetFirstItemInInventory(oStore);
            while (GetIsObjectValid(oStoreItem))
            {
                if (GetTag(oStoreItem) == sTag)
                {
                    return TRUE;
                }
                oStoreItem = GetNextItemInInventory(oStore);
            }
        }
        nCnt++;
        oStore = GetObjectByTag("MAGICSHOP_" + IntToString(nCnt));
    }
    return FALSE;
}

//void main(){}

#include "zdlg_include_i"
#include "zdialog_inc"
#include "_inc_port"
#include "fame_inc"
#include "seed_faction_inc"
#include "pc_inc"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

const int QUEST_CRYPTS_FIRST      = 1;
const int QUEST_CRYPTS_COUNT      = 2;
const int QUEST_CRYPTS_TOOK_QUEST = 3;
const int QUEST_CRYPTS_STATS      = 4;

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

void CryptCutscene1(object oPC)
{
    location lMob  = GetLocation(GetWaypointByTag("WP_CRYPT_QUEST_MOB"));
    object oZombie = CreateObject(OBJECT_TYPE_CREATURE, "zombie", lMob);
    object oCow1   = CreateObject(OBJECT_TYPE_CREATURE, "nw_cow", lMob);
    object oCow2   = CreateObject(OBJECT_TYPE_CREATURE, "nw_cow", lMob);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), oZombie);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackIncrease(20), oZombie);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(DAMAGE_BONUS_20, DAMAGE_TYPE_BLUDGEONING), oZombie);
    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectModifyAttacks(5), oZombie);
    SetPortMode(oPC, PORT_NOT_ALLOWED);

    ActionDoCommand(SetCutsceneMode(oPC, TRUE, FALSE));
    ActionDoCommand(FadeToBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oPC, 11.0));
    ActionDoCommand(AssignCommand(oPC, SetCameraFacing(220.0, 5.0, 70.0)));
    ActionDoCommand(AssignCommand(oPC, JumpToObject(GetWaypointByTag("WP_CRYPT_QUEST_PC"))));
    ActionDoCommand(FadeFromBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oZombie, ActionAttack(oCow1)));
    ActionWait(1.0);
    ActionDoCommand(AssignCommand(oCow2, ActionMoveAwayFromObject(oZombie)));
    ActionWait(1.0);
    ActionDoCommand(AssignCommand(oZombie, ActionMoveToObject(oCow2)));
    ActionWait(5.0);
    ActionDoCommand(FadeToBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oPC, ClearAllActions()));
    ActionDoCommand(SetCutsceneMode(oPC, FALSE, TRUE));
    ActionDoCommand(AssignCommand(oPC, JumpToObject(GetWaypointByTag("WP_LOFT_GUARD"))));
    ActionWait(1.0);
    ActionDoCommand(FadeFromBlack(oPC));
    ActionDoCommand(SetPortMode(oPC));
    ActionDoCommand(DestroyObject(oCow1));
    ActionDoCommand(DestroyObject(oCow2));
    ActionDoCommand(DestroyObject(oZombie));
}

void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    object oRing, oModule;
    int nCnt, nMob1, nMob2, nMob3, nMob4, nMob5, nMob6, nTotal;
    float fFame;
    string sCnt, sValue, sMsg, sSQL;
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    string sVarName = "QUEST_CRYPT_RING";
    int nOptionSelected = GetPageOptionSelected(oHolder);
    switch (nOptionSelected){ // WHAT IS SELECTED AT BUILDPAGE?
    case ZDIALOG_MAIN_MENU:
    case QUEST_CRYPTS_FIRST:
        SetNextPage(oHolder, nOptionSelected);
        return;
    case QUEST_CRYPTS_TOOK_QUEST:
        dbSetPersistentInt(oPC, "QUEST_CRYPT_STATE", 2, 15);
        SetLocalInt(oPC, "QUEST_CRYPT_STATE", 2);
        CreateItemOnObject("cryptring", oPC);
        CreateItemOnObject("tp_loftenwood", oPC, 10);
        SetShowMessage(oHolder, "Thank you very much, talk to me again after the ring is fully loaded. But it does not work on every creature.\nYou can find the undead creatures north from Loftenwood.\n\nAnd take some of these scrolls, you can return to me with them, good luck!");
        DelayCommand(8.0, CryptCutscene1(oPC));
        return;
    case QUEST_CRYPTS_COUNT:
        oRing = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC);
        if (GetTag(oRing) != sVarName) oRing = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
        if (GetTag(oRing) != sVarName)
        {
            SetShowMessage(oHolder, "You have to equip the ring first");
            return;
        }
        nMob1 = GetLocalInt(oRing, "ZOMBIE");
        nMob2 = GetLocalInt(oRing, "CRYPT_ZOMBIE");
        nMob3 = GetLocalInt(oRing, "SKELLY_BRAWLER");
        nMob4 = GetLocalInt(oRing, "SKELLY_MAGE");
        nMob5 = GetLocalInt(oRing, "SKELLY_WIZARD");
        nMob6 = GetLocalInt(oRing, "SKELLY_PRIEST");

        nCnt = nMob1 + nMob2 + nMob3 + nMob4 + nMob5 + nMob6;
        sCnt = IntToString(nCnt);
        if (GetLocalInt(oRing, sVarName) == 5)
        {
            oModule = GetModule();
            fFame = IntToFloat(nMob1) * 0.1 +
                    IntToFloat(nMob2) * 0.09 +
                    IntToFloat(nMob3) * 0.08 +
                    IntToFloat(nMob4) * 0.07 +
                    IntToFloat(nMob5) * 0.06 +
                    IntToFloat(nMob6) * 0.05;

            GiveXPToCreature(oPC, nCnt * 100);
            GiveGoldToCreature(oPC, nCnt * 1000);
            if (nCnt > 100) CreateTrainingToken(oPC, 1);
            IncFameOnChar(oPC, fFame);
            DelayCommand(0.1, StoreFameOnDB(oPC, SDB_GetFAID(oPC)));

            NWNX_SQL_ExecuteQuery("select st_crypt from statistics where st_trueid=" + IntToString(dbGetTRUEID(oPC)));
            if (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                nCnt = nCnt + StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
                NWNX_SQL_ExecuteQuery("update statistics set st_crypt=" + IntToString(nCnt) + " where st_trueid=" + IntToString(dbGetTRUEID(oPC)));
            }
            else
                NWNX_SQL_ExecuteQuery("insert into statistics (st_trueid,st_crypt) values (" + IntToString(dbGetTRUEID(oPC)) + "," + IntToString(nCnt) + ")");

            if (nCnt > GetLocalInt(oModule, sVarName))
            {
                SetLocalString(oModule, sVarName, sTRUEID);
                SetLocalInt(oModule, sVarName, nCnt);
            }

            SetShowMessage(oHolder, "Great! You have rescued " + sCnt + " souls, baba yaga will be pleased. \nYou should go to Ridgetown now and buy new equippment if you haven't done allready, Ridgetown is east from Loftenwood. Good Luck!");
            dbSetPersistentInt(oPC, "QUEST_CRYPT_STATE", 3, 30);
            SetLocalInt(oPC, "QUEST_CRYPT_STATE", 3);

            DeleteLocalInt(oRing, "ZOMBIE");
            DeleteLocalInt(oRing, "CRYPT_ZOMBIE");
            DeleteLocalInt(oRing, "SKELLY_BRAWLER");
            DeleteLocalInt(oRing, "SKELLY_MAGE");
            DeleteLocalInt(oRing, "SKELLY_WIZARD");
            DeleteLocalInt(oRing, "SKELLY_PRIEST");
            return;
        }
        SetShowMessage(oHolder, "You have rescued " + sCnt + " souls, but the ring is not fully loaded.");
        return;
    case QUEST_CRYPTS_STATS:
        oModule = GetModule();
        sMsg = GetLocalString(oModule, sVarName) + " has rescued " + IntToString(GetLocalInt(oModule, sVarName)) + " Souls.";
        sSQL = "select st_crypt from statistics where st_trueid=" + IntToString(dbGetTRUEID(oPC));
        NWNX_SQL_ExecuteQuery(sSQL);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sMsg += "\nYou have rescued " + NWNX_SQL_ReadDataInActiveRow(0) + " Souls.";
        }
        SetShowMessage(oHolder, sMsg);
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
    object oRing;
    int nState;
    DeleteList(sList, oHolder); // START FRESH PAGE
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        SetMenuOptionInt("Who did best job so far?", QUEST_CRYPTS_STATS, oHolder);
        if (pcGetRealLevel(oPC) > 20) // dont do everything for everyone
        {
            SetDlgPrompt("Hello, have you seen some new adventurer? (lvl 1 quest)");
            return;
        }
        nState = GetLocalInt(oPC, "QUEST_CRYPT_STATE");
        if (nState == 0) // no entry on pc?
        {
            nState = dbGetPersistentInt(oPC, "QUEST_CRYPT_STATE"); // get from DB
            if (nState != 1 && nState != 2 && nState != 3) // no valid entry on DB?
            {
                nState = 1; // 1 is nothing happen so far
            }
            SetLocalInt(oPC, "QUEST_CRYPT_STATE", nState); // store it on pc
        }

        if (nState == 1) // nothing happen so far
        {
            SetDlgPrompt("Hello, we have serious trouble with the undead creatures coming from the crypts. Loftenwood need some brave hands!");
            SetMenuOptionInt("Sure, tell me more.", QUEST_CRYPTS_FIRST, oHolder);
            return;
        }
        // state 2 is quest running
        else if (nState == 2)
        {
            SetDlgPrompt("Ah hello, you are back.");
            SetMenuOptionInt("The ring is fully loaded now?", QUEST_CRYPTS_COUNT, oHolder);
            return;
        }
        else if (nState == 3) // 3 is finished
        {
            SetDlgPrompt("Thank you again, you did good job!");
            return;
        }
        return;
   case QUEST_CRYPTS_FIRST:
        SetDlgPrompt("Baba yaga is creating magical rings to stop this undead plague. Use it on them and you will release their souls and load up the ring with power.\n" +
                     "Baba yaga need the power to keep providing us with buffs in the future and stop these undead coming to close to Loftenwood.\n\nYou should use these buffs too if you go down the crypts, his house is somewhere here in loftenwood.");
        SetMenuOptionInt("Alright, give me a ring please.", QUEST_CRYPTS_TOOK_QUEST, oHolder);
        return;
   case ZDIALOG_CONFIRM:
        DoConfirmAction(oHolder);
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

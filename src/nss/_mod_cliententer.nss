#include "db_inc"
#include "fky_chat_inc"
#include "sfsub_cheat_inc"
#include "effect_inc"
#include "_inc_port"
#include "rune_include"
#include "_inc_inventory"
#include "_webhook"

void InitNewCharacter(object oPC)
{
    if (!GetIsObjectValid(oPC)) return;
    // Strip naked
    int iSlot;
    for(iSlot = 0; iSlot < NUM_INVENTORY_SLOTS; iSlot++)
    {
        object oItem = GetItemInSlot(iSlot, oPC);
        if (GetIsObjectValid(oItem))   Insured_Destroy(oItem);
    }

    // Empty inventory
    object oItem=GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        Insured_Destroy(oItem);
        oItem = GetNextItemInInventory(oPC);
    }

    // Empty pockets
    TakeGoldFromCreature(GetGold(oPC), oPC);

    // Starting Items
    CreateItemOnObject("rulebook", oPC);
    CreateItemOnObject("tp_loft", oPC);
    CreateItemOnObject("bindcrystal", oPC);
    CreateItemOnObject("massdislike", oPC);
    CreateItemOnObject("starterspeed", oPC, 10);
    CreateItemOnObject("nw_it_medkit001", oPC, 10);
    CreateItemOnObject("destroyer", oPC);

    // Give some gold
    GiveGoldToCreature(oPC, 60000);
}

void InitDMCharacter(object oPC)
{
    NWNX_SQL_ExecuteQuery("select dm from trueid where trueid="+IntToString(dbGetTRUEID(oPC)));
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        if (!StringToInt(NWNX_SQL_ReadDataInActiveRow(0)))
        {
            AssignCommand(oPC,ActionJumpToObject(GetWaypointByTag("WP_JAIL")));
            DelayCommand(2.0f,SetCutsceneMode(oPC));
            DelayCommand(4.0f,ActionFloatingTextStringOnCreature("You aren't a DM, numbnuts. Enjoy Chapter 1 of NWN!",oPC));
            DelayCommand(10.0f,ActivatePortal(oPC,"jail.dungeoneternalx.com:5123","","",TRUE));
        }
    }

    // Strip naked
    int iSlot;
    for(iSlot = 0; iSlot < NUM_INVENTORY_SLOTS; iSlot++)
    {
        object oItem = GetItemInSlot(iSlot, oPC);
        if (GetIsObjectValid(oItem))   Insured_Destroy(oItem);
    }

    // Empty inventory
    object oItem=GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        Insured_Destroy(oItem);
        oItem = GetNextItemInInventory(oPC);
    }

    // Starting Items
    CreateItemOnObject("knower", oPC);
    CreateItemOnObject("itemstripper", oPC);
    CreateItemOnObject("dmprizewand", oPC);
    CreateItemOnObject("dmreboot", oPC);
    CreateItemOnObject("dmreboot2", oPC);
    CreateItemOnObject("GTFO", oPC);
    CreateItemOnObject(SDB_FACTION_TOMERESREF, oPC);
    CreateItemOnObject("jailwand", oPC);
    CreateItemOnObject("dmevent", oPC);
}

void OnClientEnter(object oPC) // CALL ON CLIENT ENTER
{
    // CLEAR ALL OLD ID'S - THIS WILL RELOAD ACCOUNT DATA THAT MAY BE IN THE DATABASE BUT STORED LOCALLY - IT MAY HAVE BEEN ACCESSED BY ANOTHER CHAR
    DeleteLocalString(oPC, "BANNED");

    string sName       = GetName(oPC);
    string sAccount    = GetPCPlayerName(oPC);
    string sCDKEY      = GetPCPublicCDKey(oPC);


    if (GetIsDM(oPC) && GetIsObjectValid(oPC))
        InitDMCharacter(oPC);

    //Modifying old subraces to match the new ones (Kobold2 to Kobold, for example)
    if (!GetIsDM(oPC) && GetIsObjectValid(oPC))
    {
        string sSubrace = GetSubRace(oPC);
        if (GetSubString(sSubrace, GetStringLength(sSubrace) - 1, 1) == "2")
            SetSubRace(oPC, GetSubString(sSubrace,  0, GetStringLength(sSubrace) - 1));
    }

    if (GetIsObjectValid(oPC))  dbCheckBan(oPC);

    if (dbCheckPCforTempBan(oPC) && GetIsObjectValid(oPC))
        dbBootPC(oPC, "You are banned. Tough life.", "Banned player attempting to join.\n"+dbPCtoString(oPC));

    // UP SESSION COUNT
    dbUpdateSessionCnt(1);

    // SET UP SESSION VARS
    SetLocalInt(oPC, "TIME", GetTick()); // SAVE TIME FOR RECORDING HOW LONG PLAYER PLAYED CHARACTER
    SetLocalInt(oPC, "XP", GetXP(oPC));  // VAR TO ACCUM XP
    SetLocalInt(oPC, "KILLS", 0);        // VAR TO ACCUM KILLS
    SetLocalInt(oPC, "KILLS_NEW", 0);

    if (!GetIsDM(oPC))
    {
        //Loads faction data
        NWNX_SQL_ExecuteQuery("select faid,farank from trueid where trueid="+IntToString(dbGetTRUEID(oPC)));
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            if (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)))
            {
                NWNX_SQL_ReadNextRow();
                //Set FAID
                SetLocalString(oPC,DB_FAID,NWNX_SQL_ReadDataInActiveRow(0));
                //Set RANK
                SetLocalString(oPC,DB_FACTION_RANK,NWNX_SQL_ReadDataInActiveRow(1));
            }

        }
    }

    if (!GetIsDM(oPC))
    {
        // Strips all valid effects including excess Hit Points
        int iMaxHP = GetMaxHitPoints(oPC);
        int iCurrentHP = GetCurrentHitPoints(oPC);
        int iNewHP;
        DelayCommand(0.1, StripAllEffects(oPC));

        int nDamage = GetLocalInt(oPC, "DAMAGE");

        if (iCurrentHP>iMaxHP)
        {
            iNewHP = iCurrentHP - iMaxHP;
            effect eResetHP = EffectDamage(iNewHP, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
            DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eResetHP, oPC));
        }

        if (nDamage > 0) // PLAYER LOGGED OUT WITH DAMAGE, REAPPLY NOW
        {
            if (GetMaxHitPoints(oPC)<=nDamage) // KILL EM
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE, TRUE), oPC);
                SetLocalInt(oPC, "NO_DEATH_PEN", TRUE);
            }
            else if (nDamage>0)
            { // HURT EM
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE), oPC);
            }
        }
        DeleteLocalInt(oPC, "DAMAGE");

        // Remove rune effects from the player
        CleanRuneFromPC(oPC);
    }

    if (GetIsObjectValid(oPC) && !GetIsDM(oPC))
    {
        AddJournalQuestEntry("rules",          1, oPC, FALSE, FALSE);
        AddJournalQuestEntry("readme",         1, oPC, FALSE, FALSE);
        AddJournalQuestEntry("AREA_CR_INFO",   1, oPC, FALSE, FALSE);
        AddJournalQuestEntry("Items",          1, oPC, FALSE, FALSE);
        AddJournalQuestEntry("CVR",            1, oPC, FALSE, FALSE);
        AddJournalQuestEntry("KillSpree",      1, oPC, FALSE, FALSE);
        AddJournalQuestEntry("factions",       1, oPC, FALSE, FALSE);
        AddJournalQuestEntry("subrace",        1, oPC, FALSE, FALSE);
        AddJournalQuestEntry("pking",          1, oPC, FALSE, FALSE);
        AddJournalQuestEntry("summons",          1, oPC, FALSE, FALSE);


        dbUpdatePlayerStatus(oPC);

        dbLoadBindLocation(oPC);
    }
    DeleteLocalString(oPC, "DELETECHAR"); // for leto function
}

void main()
{
    object oPC = GetEnteringObject();

    DelayCommand(0.1, ExportSingleCharacter(oPC));

    DeleteLocalInt(oPC, "ACID");
    DeleteLocalInt(oPC, "CKID");
    DeleteLocalInt(oPC, "IPID");
    DeleteLocalInt(oPC, "DEXID");
    DeleteLocalInt(oPC, "TRUEID");
    DeleteLocalInt(oPC, "PLID");

    string sName       = GetName(oPC);
    string sAccount    = GetPCPlayerName(oPC);
    string sCDKEY      = GetPCPublicCDKey(oPC, TRUE);
    int    nTRUEID     = dbInitTRUEID(oPC);

    /////////////////////////////////////////
    // login webhook
    LoginWebhook(oPC);

    /////////////////////////////////////////
    //Subrace stuff
    if (!GetIsDM(oPC) && !GetXP(oPC))
    {
        if (!SF_GetIsCharacterLegal(oPC, sName))
        {
            SetCutsceneMode(oPC, TRUE);
            PopUpDeathGUIPanel(oPC, FALSE, FALSE, 0, "This character is flagged as an illegal character. Deleting...");
            DelayCommand(5.0f,NWNX_Administration_DeletePlayerCharacter(oPC, TRUE));
            return;
        }
        InitNewCharacter(oPC);
    }

    //If they get booted due to auth failure, this will prevent errors.
    if (!GetIsObjectValid(oPC)) return;

    Speech_OnClientEnter(oPC);

    OnClientEnter(oPC);

    if (!GetIsDM(oPC)) DelayCommand(10.0, LetoReadSpellSchool(oPC));

    DelayCommand(8.0f, ActionFloatingTextStringOnCreature(COLOR_GREEN+"TRUEID System Initialized. Your TRUEID is "+IntToString(dbGetTRUEID(oPC))+": "+dbGetTRUEIDName(oPC)+COLOR_END, oPC, FALSE));

    // for _mod_clientleave
    SetLocalString(oPC, "player_name",  sName);
    SetLocalString(oPC, "player_pname", sAccount);
    SetLocalString(oPC, "player_cdkey", sCDKEY);
    SetPortMode(oPC, FALSE);

    ////////////////////////////////////////////////////////////////////////////////
    // Run DM options and stop executing script in the case of a DM
    if (GetIsDM(oPC))
    {
        InitDMCharacter(oPC);
        return;
    }
    //////////////// ONLY NON DM AFTER THIS /////////////////////////////////////////
    SetLocalInt(oPC, "DO_TAVERN_ENTER", TRUE);
    SetPlotFlag(oPC, FALSE);


    if (GetIsObjectValid(oPC) && !GetIsDM(oPC))
    {
        DeleteLocalObject(oPC, "LAST_DIED_AREA");
        SetCVRating(oPC, ComputeCVRating(oPC));
        FameClientEnter(oPC); // "fame_inc"
        AssignCommand(oPC, JumpToLocation(GetStartingLocation()));
        // Destroy Gtr Dispell scolls  LJU
        DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602");
        DelayCommand(5.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
        DelayCommand(10.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
        DelayCommand(15.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
        DelayCommand(20.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
        // Destroy Gtr Mantle scolls  LJU
        DelayCommand(25.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
        DelayCommand(30.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
        DelayCommand(35.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
        DelayCommand(40.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
        DelayCommand(45.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
        // Destroy Gtr Undeaths Eternal Foe  LJU
        DelayCommand(50.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));
        DelayCommand(55.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));
        DelayCommand(60.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));
        DelayCommand(65.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));
        DelayCommand(70.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));

        //Update all login counts
        dbUpdateLogin(oPC,LOGIN_TYPE_ACID);
        dbUpdateLogin(oPC,LOGIN_TYPE_CKID);
        dbUpdateLogin(oPC,LOGIN_TYPE_DEXID);
        dbUpdateLogin(oPC,LOGIN_TYPE_IPID);
        dbUpdateLogin(oPC,LOGIN_TYPE_PLID);
        dbUpdateLogin(oPC,LOGIN_TYPE_TRUEID);



        // See file "inc_traininghall" for more informations
        if (!GetIsTestChar(oPC))
        {
            if (TestStringAgainstPattern("**[test]**", GetStringLowerCase(sName)))
            {
                SetIsTestChar(oPC);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 8.0);
                DelayCommand(8.0, JumpToTraininghalls(oPC));
            }
        }


        // Disable Horse Summon (FPS issues)
        DecrementRemainingFeatUses(oPC, FEAT_PALADIN_SUMMON_MOUNT);
        NWNX_Creature_RemoveFeat(oPC, FEAT_PALADIN_SUMMON_MOUNT);
    }
}


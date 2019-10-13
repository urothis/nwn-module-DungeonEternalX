#include "x2_inc_switches"
#include "x2_inc_toollib"
#include "gen_inc_color"
#include "db_inc"
#include "seed_faction_inc"
#include "artifact_inc"
#include "fame_inc"
#include "_server_reboot"
#include "fky_chat_inc"
#include "epic_inc"
#include "random_loot_inc"
#include "maglu_inc"
#include "quest_inc"
#include "tradeskills_inc"
#include "nwnx_chat"

void ChangeGroundTiles(object oArea, int nGroundTileConst, float fZOffset=-0.4f, int nStartCol=0, int nStartRow=0, int nColumns=0, int nRows=0)
{
   object oTile;
   vector vPos;
   vPos.x = 5.0 + (10.0 * nStartRow);
   vPos.y = 0.0;
   vPos.z = fZOffset;
   float fFace = 0.0;
   location lLoc;
   int i, j;
   for (i = nStartCol ; i <= (nStartCol + nColumns); i++) {
      for (j = nStartRow; j <= (nStartRow + nRows); j++) {
         vPos.y = -5.0 + (10.0 * (i+1));
         vPos.x = -5.0 + (10.0 * (j+1));
         lLoc = Location(oArea, vPos, fFace);
         oTile = CreateObject(OBJECT_TYPE_PLACEABLE, "invisobj", lLoc, FALSE, "x2_tmp_tile");
         //if (oTile == OBJECT_INVALID) CreateObject(OBJECT_TYPE_CREATURE, "nw_badger",GetLocation(GetObjectByTag("UNIQUE")));
           //SetPlotFlag(oTile, TRUE);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(nGroundTileConst)), oTile);
      }
   }
}

void TileAt(object oArea, int nGroundTileConst, float fX, float fY, float fZ=-0.4f, float fFace=0.0f)
{
   vector vPos;
   vPos.x = fX;
   vPos.y = fY;
   vPos.z = fZ;
   object oTile = CreateObject(OBJECT_TYPE_PLACEABLE, "invisobj", Location(oArea, vPos, fFace), FALSE, "x2_tmp_tile");
   //SetPlotFlag(oTile,TRUE);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(nGroundTileConst)), oTile);
}


void LoadBindstones()
{
    // check file "_inc_port"
    object oStoreOn = GetObjectByTag("VARS_WP");
    SetLocalObject(GetModule(), "VARS_WP", oStoreOn);
    int nCnt = 0;
    object oWP = GetObjectByTag("WP_BINDSTONE", nCnt);
    while (GetIsObjectValid(oWP))
    {
        SetLocalObject(oStoreOn, GetName(oWP), oWP);
        nCnt++;
        oWP = GetObjectByTag("WP_BINDSTONE", nCnt);
    }
}

void OnModuleLoad()
{
    int nServer = 1;
    SetLocalInt(GetModule(), "SERVER", nServer);
    WriteTimestampedLogEntry("Started Server #" + IntToString(nServer));

    if (dbGetSEID(nServer)) // CREATE A NEW SESSION
        WriteTimestampedLogEntry("Session ID created. Celebrate!");
    NWNX_SQL_ExecuteQuery("delete from temporaryban where expires<=now()"); // UNBAN THE TEMPS
    NWNX_SQL_ExecuteQuery("DELETE FROM pwdata WHERE ADDDATE(last, expire)<now() and expire > 0"); // PURGE PW DATA
    NWNX_SQL_ExecuteQuery("delete from factionbank where fb_date < date_add(now(), interval -90 day)");
    // SQLExecDirect("delete from chattext where ct_added < date_add(now(), interval -5 day)"); // PURGE CHAT DATA THAT IS 5 DAYS OLD OR MORE
    // SQLExecDirect("delete from banktransactions where bt_added < date_add(now(), interval -90 day)");
    // SQLExecDirect("delete from login where li_login < date_add(now(), interval -90 day)");
    // SQLExecDirect("delete from logmsg where lm_added < date_add(now(), interval -90 day)");
    NWNX_SQL_ExecuteQuery("update player set active=0 where active<>0");
    NWNX_SQL_ExecuteQuery("update player set position='' where position<>''");
    NWNX_SQL_ExecuteQuery("update quest set qu_state = 1001 where adddate(qu_added, qu_expire) < now() and qu_state < 1000");
    NWNX_SQL_ExecuteQuery("update quest set qu_state = 1002 where adddate(qu_last, qu_restart) < now() and qu_state = 1000");
    NWNX_SQL_ExecuteQuery("update quest set qu_state = 1003 where adddate(qu_last, qu_restart) < now() and qu_state = 1001");
    // SQLExecDirect("update factionshop set fs_cost=fs_cost-fs_cost/25 where fs_avail=1 and fs_cost > 10000 and fs_date < date_add(now(), interval -24 hour)");

    SetLocalInt(GetModule(), "LINUX", 1);
    NWNX_Chat_RegisterChatScript("fky_chat");
}

void main()
{
    object oModule = OBJECT_SELF;
    // Needed for Random Sweeping map and fame obelisks ("jump_sweep", "fame_inc")
    string sSweep = IntToString(d3());
    object oSweep = GetArea(GetObjectByTag("MYTH_SWEEP_" + sSweep + "_WP"));
    SetLocalString(oModule, "WHICH_SWEEP", sSweep);
    SetLocalObject(oModule, "WHICH_SWEEP", oSweep);

    // inc_tokenizer
    SetLocalObject(oModule, "#TOKENIZER_CACHE#", GetObjectByTag("TOKENIZER_CACHE"));

    LoadBindstones();

    object oChange = GetArea(GetObjectByTag("BC_XP_CHAIN"));
    ChangeGroundTiles(oChange, X2_TL_GROUNDTILE_LAVA, 0.63, 9, 2, 1, 7); // ACROSS THE TOP
    ChangeGroundTiles(oChange, X2_TL_GROUNDTILE_LAVA, 0.63, 2, 2, 2, 5); // ACROSS BOTTOM
    ChangeGroundTiles(oChange, X2_TL_GROUNDTILE_LAVA, 0.63, 3, 2, 5, 1); // LEFT SIDE
    ChangeGroundTiles(oChange, X2_TL_GROUNDTILE_LAVA, 0.63, 4, 8, 4, 2); // RIGHT SIDE
    ChangeGroundTiles(oChange, X2_TL_GROUNDTILE_LAVA, 0.63, 1, 8, 3, 3); // FOUNTAIN SQUARE
    TileAt(oChange, X2_TL_GROUNDTILE_LAVA_FOUNTAIN, 95.0f, 25.0f, -0.50f); // FOUNTAIN BURST

    oChange = GetObjectByTag("SNIRBLES_TOWER_FLAGS_1");
    ChangeGroundTiles(oChange, 511, 0.1, 1, 0, 1, 0);
    ChangeGroundTiles(oChange, 511, 0.1, 0, 0, 0, 2);
    ChangeGroundTiles(oChange, 511, 0.1, 1, 2, 1, 0);
    ChangeGroundTiles(oChange, 511, 0.1, 3, 0, 0, 2);
    oChange = GetObjectByTag("SNIRBLES_TOWER_MAIN");
    TLChangeAreaGroundTiles(oChange, 511, 3, 4, 0.1);
    TileAt(oChange, 430, 20.0, 10.8, -0.5);

    //ChangeGroundTiles(GetArea(GetObjectByTag("TheAbyssStygia")), X2_TL_GROUNDTILE_LAVA, -2.0, 0, 0, 16, 16);

    dbCheckDatabase();

    OnModuleLoad();
    SDB_FactionOnModuleLoad();
    Artifact_OnModuleLoad();
    FameOnModLoad();
    EI_LoadData(); // Epic items
    LootLoadData();
    Q_OnModuleLoad();
    TS_OnModuleLoad();
    ChainWonderLoad();
    DelayCommand(0.5, ExecuteScript("sf_subraces", oModule)); // Subraces

    SetMaxHenchmen(5);

    TLChangeAreaGroundTiles(GetObjectByTag("MTMMOORE_LAVA"),350,16,16,-1.0f);
    TLChangeAreaGroundTiles(GetObjectByTag("MTMMOORE_SLOPES"),350,16,16,-1.0f);
    TLChangeAreaGroundTiles(GetObjectByTag("MTMMOORE_TONGUE"),350,16,16,-1.0f);
    TLChangeAreaGroundTiles(GetObjectByTag("MTMMOORE_PEAK"),350,16,16,-1.0f);
    //TLChangeAreaGroundTiles(GetObjectByTag("DESERT_COMPOUND"),401,10,10,0.6f);


    SetLocalInt(oModule, "tcoun_next",1101);
    SetLocalInt(oModule, "tcoun_logged",0);
    SetLocalInt(oModule, "tcoun_space",0);
    SetLocalInt(oModule, "tcoun_spaceno",0);
    SetLocalInt(GetModule(), "TheFortOwner", 123456); // Cory - Fort Reset



    SetModuleSwitch(MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING, TRUE);
    SetModuleSwitch(MODULE_SWITCH_NO_RANDOM_MONSTER_LOOT, TRUE);
    SetModuleSwitch(MODULE_VAR_AI_STOP_EXPERTISE_ABUSE, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);
    SetModuleSwitch(MODULE_SWITCH_DISABLE_ITEM_CREATION_FEATS, TRUE);
    SetModuleSwitch(MODULE_VAR_OVERRIDE_SPELLSCRIPT,TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
    SetModuleOverrideSpellscript("stop_spellcheat");

    // I'm using this 1 minute recursive script to track reboots. It allows me to tell remaining time left.
    int nRebootLen = 360;
    string sSQL = "select se_length, se_day, se_hour from sessionlength where se_day=if(date_format(NOW(),'%w')=0 or date_format(NOW(),'%w')=6,'Weekend','Weekday') and se_hour=floor(date_format(NOW(), '%H') / 4)+1";
    string sTimeZone = "Default Reboot Time of 6 Hours";
    NWNX_SQL_ExecuteQuery(sSQL);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        nRebootLen = GetMax(60, StringToInt(NWNX_SQL_ReadDataInActiveRow(0))); // NEVER LESS THAN 60 MINUTES UP TIME
        sTimeZone = NWNX_SQL_ReadDataInActiveRow(2) + " " + NWNX_SQL_ReadDataInActiveRow(1) + " Reboot Time of " + HoursToMinutes(nRebootLen);
    }
    SetLocalString(oModule, "TIMEZONE", sTimeZone);
    SetLocalInt(GetModule(), SERVER_TIME_LEFT, nRebootLen);
    DelayCommand(3.0, TimedServerReboot(IntToString(dbGetSEID())));

    DelayCommand(1.0, MagluLoadWP()); // maglu_inc

    // Crypt Quest stats
    NWNX_SQL_ExecuteQuery("select st_trueid, st_crypt from statistics order by st_crypt desc limit 1");
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        SetLocalString(oModule, "QUEST_CRYPT_RING", NWNX_SQL_ReadDataInActiveRow(0));
        SetLocalInt(oModule, "QUEST_CRYPT_RING", StringToInt(NWNX_SQL_ReadDataInActiveRow(1)));
    }
}

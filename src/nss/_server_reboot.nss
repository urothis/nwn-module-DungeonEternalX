#include "fame_inc"
#include "random_loot_inc"
#include "inc_server"
#include "db_inc"
#include "nwnx_admin"
#include "_webhook"


void finalShutdown() {
    ChainWonderSave();
    object oMaglubiyet = GetObjectByTag("MAGLUBIYET_STATUE");
    if (GetIsObjectValid(oMaglubiyet)) {
        int nCall = GetLocalInt(oMaglubiyet, "CALL");
        NWNX_SQL_ExecuteQuery("update pwdata set val='" + IntToString(nCall) + "' where name='MAGLUBIYET'");
    }

    // remove players bank area
    object oBank = GetArea(GetObjectByTag("BANK_DOOR_WP"));
    object oPC = GetFirstObjectInArea(oBank);

    // location to move them to
    location lLoc = GetStartingLocation();
    while (GetIsObjectValid(oPC)) {
        if (GetIsPC(oPC) && !GetIsDM(oPC)) AssignCommand(oPC, JumpToLocation(lLoc));
        oPC = GetNextObjectInArea(oBank);
    }

    ExportAllCharacters();
    SpeakString( "All characters have been saved by auto-reboot script.", TALKVOLUME_SHOUT);
    SpeakString("<cσ  >Server restart has begun.",TALKVOLUME_SHOUT);
    DelayCommand(1.0,  SpeakString(" SERVER RESET IN <cσσσ>60</c> SECONDS!!!",TALKVOLUME_SHOUT));
    DelayCommand(30.0, SpeakString(" SERVER RESET IN <cσσσ>30</c> SECONDS!!!",TALKVOLUME_SHOUT));
    DelayCommand(45.0, SpeakString(" SERVER RESET IN <cσσσ>15</c> SECONDS!!!",TALKVOLUME_SHOUT));
    DelayCommand(50.0, SpeakString(" SERVER RESET IN <cσσσ>10</c> SECONDS!!!",TALKVOLUME_SHOUT));
    DelayCommand(55.0, SpeakString(" SERVER RESET IN <cσσσ>5</c>",TALKVOLUME_SHOUT));
    DelayCommand(56.0, SpeakString(" SERVER RESET IN <cσσσ>4</c>",TALKVOLUME_SHOUT));
    DelayCommand(57.0, SpeakString(" SERVER RESET IN <cσσσ>3</c>",TALKVOLUME_SHOUT));
    DelayCommand(58.0, SpeakString(" SERVER RESET IN <cσσσ>2</c>",TALKVOLUME_SHOUT));
    DelayCommand(59.0, SpeakString(" SERVER RESET IN <cσσσ>1</c>",TALKVOLUME_SHOUT));
    DelayCommand(60.0, SpeakString("<cσ  >SERVER INSTANCE RESET",TALKVOLUME_SHOUT));
    DelayCommand(61.0, BootAllPC());
    DelayCommand(62.0, dbSessionEnd());
    DelayCommand(62.0, ModDownWebhook());
    DelayCommand(63.9, WriteTimestampedLogEntry("*****SERVER RESTART*****"));
    DelayCommand(64.0, NWNX_Administration_ShutdownServer());
}

void mainRebootChecker() {
    object oModule = GetModule();
    int timekeeper = GetLocalInt(oModule, "REBOOT_TICKER");
    int iUpTime = NWNX_Time_GetTimeStamp() - GetLocalInt(oModule, "RAW_BOOT_TIME");

    // TODO some stuff
    NWNX_SQL_ExecuteQuery("delete from temporaryban where expires<=now()");
    DelayCommand(1.0, UpdateFactionStats());
    DelayCommand(2.0, LoadFactionRanking());
    DelayCommand(3.0, UpdateRichStatues());

    if (timekeeper == 0 && iUpTime > 60) {
        SpeakString("Server restart in<cσσσ> 24 </c>hours.", TALKVOLUME_SHOUT);
        SetLocalInt(oModule, "REBOOT_TICKER", (timekeeper + 1));
        return;
    }

    else if (timekeeper == 1 && iUpTime > 82800) {
        SpeakString("Server restart in<cσσσ> 1 </c>hour.", TALKVOLUME_SHOUT);
        SetLocalInt(oModule, "REBOOT_TICKER", (timekeeper + 1));
        return;
    }

    else if (timekeeper == 2 && iUpTime > 84600) {
        SpeakString("Server restart in<cσσσ> 30 </c>minutes.", TALKVOLUME_SHOUT);
        SetLocalInt(oModule, "REBOOT_TICKER", (timekeeper + 1));
        return;
    }

    else if (timekeeper == 3 && iUpTime > 85500) {
        SpeakString("Server restart in<cσσσ> 15 </c>minutes.", TALKVOLUME_SHOUT);
        SetLocalInt(oModule, "REBOOT_TICKER", (timekeeper + 1));
        return;
    }

    else if (timekeeper == 4 && iUpTime > 86100){
        SpeakString("Server restart in<cσσσ> 5 </c>minutes.", TALKVOLUME_SHOUT);
        SetLocalInt(oModule, "REBOOT_TICKER", (timekeeper + 1));
        return;
    }

    else if (timekeeper == 5 && iUpTime > 86400){
        finalShutdown();
        SetLocalInt(oModule, "REBOOT_TICKER", (timekeeper + 1));
        return;
    }
}

#include "fame_inc"
#include "random_loot_inc"
#include "inc_server"
#include "db_inc"

string TimeLeftMessage(int nRemain);
void TimedServerReboot(string sSEID);

string TimeLeftMessage(int nRemain)
{
    if (nRemain > 59)
    {
        if (nRemain / 60 > 1)
        {
            if (nRemain % 60 != 0) return IntToString(nRemain / 60) + " hours " + IntToString(nRemain % 60) + " minutes.";
            else return IntToString(nRemain / 60) + " hours.";
        }
        else if (nRemain % 60 != 0)
        {
            return IntToString(nRemain / 60) + " hour " + IntToString(nRemain % 60) + " minutes.";
        }
        else return IntToString(nRemain / 60) + " hour.";
    }
    else if (nRemain % 60 != 1) return IntToString(nRemain % 60) + " minutes.";
    return "1 minute.";
}


void TimedServerReboot(string sSEID)
{
    int nRemain = GetLocalInt(GetModule(), SERVER_TIME_LEFT);

    if (nRemain == 0)
    {
        ChainWonderSave();
        object oMaglubiyet = GetObjectByTag("MAGLUBIYET_STATUE");
        if (GetIsObjectValid(oMaglubiyet))
        {
            int nCall = GetLocalInt(oMaglubiyet, "CALL");
            NWNX_SQL_ExecuteQuery("update pwdata set val='" + IntToString(nCall) + "' where name='MAGLUBIYET'");
        }
        dbSessionEnd();
        DelayCommand(4.0, SetLocalString(GetModule(), "NWNX!SHELL!SHUTDOWN", "CLOSE"));
        SpeakString("Server Session #" + sSEID + " is rebooting. Thank you come again.", TALKVOLUME_SHOUT);
        return;
    }

    if ((nRemain % 60) == 0 || nRemain <= 5)// 60 min & 5, 4, 3, 2, 1 notices
    {
        SpeakString("Server Session #" + sSEID + " will restart in " + TimeLeftMessage(nRemain), TALKVOLUME_SHOUT);
    }
    if ((nRemain % 60) == 0) // UNBAN THE TEMPS HOURLY
    {
        NWNX_SQL_ExecuteQuery("delete from temporaryban where expires<=now()");
    }

    if ((nRemain % 15) == 0)
    {
        DelayCommand(1.0, UpdateFactionStats());
        DelayCommand(2.0, LoadFactionRanking());
        DelayCommand(3.0, UpdateRichStatues());
    }

    if (nRemain == 2)
    {
        return;
        SpeakString("Loftenwood Bank is now closed.", TALKVOLUME_SHOUT);
        object bankDoorO = GetObjectByTag("LOFT_BANK");
        object bankDoorI = GetObjectByTag("BANK_DOOR");
        if (GetIsOpen(bankDoorO))
        {
            AssignCommand(bankDoorO, ActionCloseDoor(bankDoorO));
            AssignCommand(bankDoorO, SetLocked(bankDoorO, TRUE));
        }
        if (GetIsOpen(bankDoorI)) AssignCommand(bankDoorI, ActionCloseDoor(bankDoorI));

    }
    if (nRemain == 1)
    {
        object oBank = GetArea(GetObjectByTag("BANK_DOOR_WP"));
        location lLoc = GetStartingLocation();

        object oPC = GetFirstObjectInArea(oBank);
        while (GetIsObjectValid(oPC))
        {
            if (GetIsPC(oPC) && !GetIsDM(oPC)) AssignCommand(oPC, JumpToLocation(lLoc));
            oPC = GetNextObjectInArea(oBank);
        }
    }
    // less recursive calls
    /*if (nRemain > 60)
    {
        SetLocalInt(GetModule(), SERVER_TIME_LEFT, nRemain - 15);
        DelayCommand(900.0, TimedServerReboot(sSEID));
    }
    else if (nRemain > 5)*/
    if (nRemain > 5)
    {
        SetLocalInt(GetModule(), SERVER_TIME_LEFT, nRemain - 5);
        DelayCommand(300.0, TimedServerReboot(sSEID));
    }
    else
    {
        SetLocalInt(GetModule(), SERVER_TIME_LEFT, nRemain - 1);
        DelayCommand(60.0, TimedServerReboot(sSEID));
    }
}

//void main(){}

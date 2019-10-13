#include "db_inc"
#include "zdlg_include_i"
#include "zdialog_inc"


const int TS_MAX_LVL = 40;

// ts_melting, ts_milling, ts_brewing, ts_alchemy, ts_farming, ts_free
int TS_AdjustCraftingTime(object oPC, int nSeconds, string sSkill);

// ts_melting, ts_milling, ts_brewing, ts_alchemy, ts_farming, ts_free
void TS_IncreaseSkill(object oPC, int nAmount, string sSkill);
int TS_GetLevel(int nSkill);
object TS_GetVariableHolder();
int TS_GetSkillPoints(object oHolder, string sTRUEID, string sSkill);

object TS_GetVariableHolder()
{
    return GetLocalObject(GetModule(), "VARS_TRADESKILL");
}

void TS_OnModuleLoad()
{
    object oHolder = GetObjectByTag("GRAZ_MAGIC");
    if (!GetIsObjectValid(oHolder))
    {
        WriteTimestampedLogEntry("Error in TS_OnModuleLoad(), can not find Variable Holder");
        oHolder = GetAreaFromLocation(GetStartingLocation());
    }
    SetLocalObject(GetModule(), "VARS_TRADESKILL", oHolder);
}

string TS_GetSkillName(string sSkill)
{
    if      (sSkill == "ts_melting")    return "Melting Skills";
    else if (sSkill == "ts_milling")    return "Milling Skills";
    else if (sSkill == "ts_brewing")    return "Brewing Skills";
    else if (sSkill == "ts_alchemy")    return "Alchemy Skills";
    else if (sSkill == "ts_farming")    return "Farming Skills";
    else if (sSkill == "ts_free")       return "Free Skills";
    return "Invalid Skills";
}

void TS_LoadPlayerData(object oHolder, string sTRUEID)
{
    NWNX_SQL_ExecuteQuery("select ts_melting, ts_milling, ts_brewing, ts_alchemy, ts_farming, ts_free from tradeskills where ts_trueid=" + sTRUEID);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        SetLocalInt(oHolder, "ts_melting" + sTRUEID, StringToInt((NWNX_SQL_ReadDataInActiveRow(0))));
        SetLocalInt(oHolder, "ts_milling" + sTRUEID, StringToInt((NWNX_SQL_ReadDataInActiveRow(1))));
        SetLocalInt(oHolder, "ts_brewing" + sTRUEID, StringToInt((NWNX_SQL_ReadDataInActiveRow(2))));
        SetLocalInt(oHolder, "ts_alchemy" + sTRUEID, StringToInt((NWNX_SQL_ReadDataInActiveRow(3))));
        SetLocalInt(oHolder, "ts_farming" + sTRUEID, StringToInt((NWNX_SQL_ReadDataInActiveRow(4))));
        SetLocalInt(oHolder, "ts_free"    + sTRUEID, StringToInt((NWNX_SQL_ReadDataInActiveRow(5))));
    }
    else
    {
        NWNX_SQL_ExecuteQuery("insert into tradeskills (ts_trueid) values (" + sTRUEID + ")");
    }
}

int TS_GetSkillPoints(object oHolder, string sTRUEID, string sSkill)
{
    int nSkill = GetLocalInt(oHolder, sSkill + sTRUEID); // get current amount
    int nCheckReload = nSkill;
     // default is 1 in DB, load player data if skill 0
    // free skills can be 0, use other skill to check if data loaded
    if (sSkill == "ts_free") nCheckReload = GetLocalInt(oHolder, "ts_melting" + sTRUEID);
    if (!nCheckReload) // skill is 0, data not loaded
    {
        TS_LoadPlayerData(oHolder, sTRUEID);
        return GetLocalInt(oHolder, sSkill + sTRUEID);
    }
    return nSkill;
}

int TS_GetLevel(int nSkill)
{
    int nNextLvl;
    int nNextXP;
    int nLvl = 1;
    int i;
    for (i = nLvl; i <= TS_MAX_LVL; i++)
    {
        nNextLvl = i + 1;
        nNextXP = ((nNextLvl * (nNextLvl - 1)) / 2) * 3;
        if (nSkill < nNextXP) return i;
    }
    return nLvl;
}

int TS_GetSkillByLevel(int nLevel)
{
   return ((nLevel * (nLevel - 1)) / 2) * 3;
}

string TS_ShowSkillsMsg(object oPC)
{
    object oHolder = TS_GetVariableHolder();
    string sTRUEID = IntToString(dbGetTRUEID(oPC));

    string sMsg;
    int nSkill = TS_GetSkillPoints(oHolder, sTRUEID, "ts_melting");
    sMsg += TS_GetSkillName("ts_melting") + " Level " + IntToString(TS_GetLevel(nSkill)) + " with " + IntToString(nSkill) + " skill points.\n";

    nSkill = TS_GetSkillPoints(oHolder, sTRUEID, "ts_milling");
    sMsg += TS_GetSkillName("ts_milling") + " Level " + IntToString(TS_GetLevel(nSkill)) + " with " + IntToString(nSkill) + " skill points.\n";

    nSkill = TS_GetSkillPoints(oHolder, sTRUEID, "ts_brewing");
    sMsg += TS_GetSkillName("ts_brewing") + " Level " + IntToString(TS_GetLevel(nSkill)) + " with " + IntToString(nSkill) + " skill points.\n";

    nSkill = TS_GetSkillPoints(oHolder, sTRUEID, "ts_alchemy");
    sMsg += TS_GetSkillName("ts_alchemy") + " Level " + IntToString(TS_GetLevel(nSkill)) + " with " + IntToString(nSkill) + " skill points.\n";

    nSkill = TS_GetSkillPoints(oHolder, sTRUEID, "ts_farming");
    sMsg += TS_GetSkillName("ts_farming") + " Level " + IntToString(TS_GetLevel(nSkill)) + " with " + IntToString(nSkill) + " skill points.\n";

    nSkill = TS_GetSkillPoints(oHolder, sTRUEID, "ts_free");
    sMsg += "\nYou have " + IntToString(nSkill) + " free skill points.";

    return sMsg;
}

void TS_IncreaseSkill(object oPC, int nAmount, string sSkill)
{
    object oHolder = TS_GetVariableHolder();
    string sTRUEID = IntToString(dbGetTRUEID(oPC));

    int nSkill = TS_GetSkillPoints(oHolder, sTRUEID, sSkill);
    int nLevel = TS_GetLevel(nSkill); // get current level
    if (nLevel >= TS_MAX_LVL && sSkill != "ts_free")
    {
        sSkill = "ts_free"; // after reaching level 40, give allways only free skills
    }

    SetLocalInt(oHolder, sSkill + sTRUEID, nSkill + nAmount);
    NWNX_SQL_ExecuteQuery("update tradeskills set " + sSkill + "=" + sSkill + "+" + IntToString(nAmount) + " where ts_trueid=" + sTRUEID);

    if (sSkill != "ts_free")
    {
        int nLevelNext = TS_GetLevel(nSkill+nAmount); // get level after increasing
        if (nLevelNext > nLevel) // player lvl up?
        {
            if (nLevelNext > TS_MAX_LVL) // lvled to high
            {
                // reset skills to max lvl
                nAmount = TS_GetSkillByLevel(nLevelNext) - TS_GetSkillByLevel(TS_MAX_LVL);
                SetLocalInt(oHolder, sSkill + sTRUEID, nSkill - nAmount);
                NWNX_SQL_ExecuteQuery("update tradeskills set " + sSkill + "=" + sSkill + "-" + IntToString(nAmount) + " where ts_trueid=" + sTRUEID);
            }
            TS_IncreaseSkill(oPC, nLevelNext, "ts_free"); // give free skills
            FloatingTextStringOnCreature(GetRGB(11,9,11) + GetName(oPC) + " has advanced to level " + IntToString(nLevelNext) + " in " + TS_GetSkillName(sSkill), oPC);
            AssignCommand(oPC, PlaySound("gui_level_up"));
        }
    }
}

void TS_UseFreeSkills(object oPC, int nAmount)
{
    object oHolder = TS_GetVariableHolder();
    string sTRUEID = IntToString(dbGetTRUEID(oPC));

    int nSkill = TS_GetSkillPoints(oHolder, sTRUEID, "ts_free");
    NWNX_SQL_ExecuteQuery("update tradeskills set ts_free=ts_free-" + IntToString(nAmount) + " where ts_trueid=" + sTRUEID);
    SetLocalInt(oHolder, "ts_free" + sTRUEID, nSkill - nAmount);
}

int TS_AdjustCraftingTime(object oPC, int nSeconds, string sSkill)
{
    object oHolder = TS_GetVariableHolder();
    string sTRUEID = IntToString(dbGetTRUEID(oPC));
    int nSkill = TS_GetSkillPoints(oHolder, sTRUEID, sSkill);
    int nLevel = TS_GetLevel(nSkill);
    SendMessageToPC(oPC, TS_GetSkillName(sSkill) + " level " + IntToString(nLevel));
    nSeconds = nSeconds - nLevel - (nLevel/2);
    if (nSeconds < 1) return 1;
    return nSeconds;
}


// void main(){}

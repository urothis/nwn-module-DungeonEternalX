#include "event_plac_inc"
#include "tradeskills_inc"
#include "time_inc"

string GetStatistics(string sColumn, object oHolder = OBJECT_SELF)
{
    int nTick = GetTick();
    int nStoredTick = GetLocalInt(oHolder, "STAT_TICK");
    string sMsg;    string sLastUpdate;
    if (nTick - nStoredTick > 7)
    {
        NWNX_SQL_ExecuteQuery("select st_trueid, " + sColumn + " from statistics order by " + sColumn + " desc limit 10");
        sLastUpdate = "- last update was < 1 minute ago\n\n";
        int nCnt;
        string sValue;
        while (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            nCnt++;
            sValue = NWNX_SQL_ReadDataInActiveRow(1);
            if (sValue == "0") break;
            sMsg += IntToString(nCnt) + ". " + NWNX_SQL_ReadDataInActiveRow(0) + ": " + sValue + "\n";
        }
        SetLocalString(oHolder, "STATISTICS", sMsg);
    }
    else
    {
        sLastUpdate = "- last list update was " + ConvertSecondsToString((nTick - nStoredTick)*120+60) + "ago\n\n";
        sMsg = GetLocalString(oHolder, "STATISTICS");
    }
    return sLastUpdate + sMsg;
}

int StartingConditional()
{
    string sTag = GetTag(OBJECT_SELF);
    if (sTag == "EVENT_PLACARD")
    {
        SetCustomToken(8000, EventPlacard(OBJECT_SELF, sTag));
        return TRUE;
    }
    else if (sTag == "GRAZ_MAGIC")
    {
        SetCustomToken(8000, TS_ShowSkillsMsg(GetPCSpeaker()));
        return TRUE;
    }

    string sColumn;
    if (sTag == "snirble_gemgrip")      sColumn = "st_flagstars";
    else if (sTag == "quest_zelda")     sColumn = "st_gnollidol";
    else if (sTag == "quest_hashish")   sColumn = "st_knuckles_tot";
    else if (sTag == "quest_crypts")
    {
        sColumn = "st_crypt";
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLEEP), OBJECT_SELF);
    }
    else if (sTag == "MARINER")         sColumn = "st_bankrob";
    else                                return FALSE;

    SetCustomToken(8000, GetStatistics(sColumn));
    return TRUE;
}

#include "db_inc"
#include "time_inc"

void EventPlacardSaveDB(object oPlacard, string sDmName)
{
    int nParticipants = GetLocalInt(oPlacard, sDmName);
    int nCnt = GetLocalInt(oPlacard, "EVENT_CNT") + 1;
    string sPlayer = " SE:" + IntToString(dbGetSEID()) + ":" + IntToString(nCnt);
    string sSQL = "insert into pwdata (player,tag,name,val,expire) values('" + sPlayer + "'," +
            "'DM_EVENT'," + Quotes(sDmName) + ",'" + IntToString(nParticipants) + "'," + IntToString(30) + ")";
    NWNX_SQL_ExecuteQuery(sSQL);
    DeleteLocalInt(oPlacard, sDmName);
}

string EventPlacard(object oPlacard, string sVarName)
{
    string sMsg;
    if (GetHasTimePassed(oPlacard, 7, sVarName))
    {
        NWNX_SQL_ExecuteQuery("select name, val, round((UNIX_TIMESTAMP(now()) - UNIX_TIMESTAMP(last))/60) " +
        "from pwdata where tag='DM_EVENT' order by last desc limit 15");
        string sTime;
        while (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sTime = NWNX_SQL_ReadDataInActiveRow(2);
            sTime = ConvertSecondsToString(StringToInt(sTime)*60);
            sMsg += "Held by " + NWNX_SQL_ReadDataInActiveRow(0) + " with " + NWNX_SQL_ReadDataInActiveRow(1) + " participants " + sTime + " ago\n";
        }
        SetLocalString(oPlacard, sVarName, sMsg);
    }
    else sMsg = GetLocalString(oPlacard, sVarName);

    return ShowLastUpdate(oPlacard, sVarName) + sMsg;
}

//void main(){}

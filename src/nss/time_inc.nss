#include "_functions"
#include "string_inc"
#include "nwnx_time"

string ShowLastUpdate(object oHolder, string sVarName = "", string sWhat = "update");
string HoursToMinutes(int iTime);

//Returns a string like "4 days and 3 hours" or "3 hours"
string HoursToDays(int nHours);
string RemainingUpTime();
// Return total gamehour
int GetTick();

//Checks the LocalInt VarName TICK_sVarName if time has passed.
//TRUE of FALSE
int GetHasTimePassed(object oHolder, int nGameHours, string sVarName = "");
string HoursInDays(int nHours);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

string ShowLastUpdate(object oHolder, string sVarName = "", string sWhat = "update")
{
    int nTick = GetTick();
    sVarName = "TICK_" + sVarName;
    int nStoredTick = GetLocalInt(oHolder, sVarName);
    if (nTick - nStoredTick < 1) return "- last " + sWhat + " was < 1 minute ago\n\n";
    else return "- last " + sWhat + " was " + ConvertSecondsToString((nTick - nStoredTick)*120+60) + "ago\n\n";
}

string HoursToMinutes(int iTime)
{
   int iHours = iTime / 60;
   int iMinutes = iTime % 60;
   string sTime = "";
   if (iHours > 0) sTime = IntToString(iHours) + AddStoString(" hour", iHours) + " ";
   if (iMinutes > 0) sTime = sTime + IntToString(iMinutes) + AddStoString(" minute", iMinutes);
   return sTime;
}

string HoursToDays(int nHours)
{
   if (nHours>24)
       return IntToString(nHours/24)+" days and "+IntToString(nHours%24)+" hours";
   else
       return IntToString(nHours%24)+" hours";
}

string RemainingUpTime()
{
    return HoursToMinutes(GetLocalInt(GetModule(), SERVER_TIME_LEFT));
}

int GetTick()
{
   int nYear = GetCalendarYear();
   int nMonth = GetCalendarMonth();
   int nDay = GetCalendarDay();
   int nHour = GetTimeHour();
   return (nYear) * 12 * 28 * 24 + (nMonth-1) * 28 * 24 + (nDay-1) * 24 + nHour;
}

int GetHasTimePassed(object oHolder, int nGameHours, string sVarName = "")
{
    int nTick = GetTick();
    sVarName = "TICK_" + sVarName;
    int nStoredTick = GetLocalInt(oHolder, sVarName);
    if (nTick - nStoredTick > nGameHours)
    {
        SetLocalInt(oHolder, sVarName, nTick);
        return TRUE;
    }
    return FALSE;
}

string HoursInDays(int nHours)
{
   if (nHours>24) return IntToString(nHours/24)+" days and "+IntToString(nHours%24)+" hours";
   return IntToString(nHours%24)+" hours";
}

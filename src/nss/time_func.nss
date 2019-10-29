//Returns Total game time converted into total ammount of seconds
int GetTotalTimeInSeconds();

int GetTotalTimeInSeconds()
{
    int nTime = FloatToInt(HoursToSeconds((GetCalendarMonth() * 28) * 24));
    nTime += FloatToInt(HoursToSeconds(GetCalendarDay() * 24));
    nTime += FloatToInt(HoursToSeconds(GetTimeHour()));
    nTime += GetTimeMinute() * 60;
    nTime += GetTimeSecond();
    return nTime;
}

int WaitInterval(int SecondsToWait, object VHolder = OBJECT_SELF)
{
    int FirstRun = GetLocalInt(VHolder, "FirstRun");
    int RValue;
    if (FirstRun == FALSE)
    {
        int CTime = GetTotalTimeInSeconds();
        SetLocalInt(VHolder, "TimeRan", CTime);
        SetLocalInt(VHolder, "FirstRun", TRUE);
        RValue = TRUE;
    }
    else if (FirstRun == TRUE)
    {
        int RTime = GetLocalInt(VHolder, "TimeRan");
        int CTime = GetTotalTimeInSeconds();
        if (CTime >= RTime + SecondsToWait)
        {
            SetLocalInt(VHolder, "TimeRan", CTime);
            RValue = TRUE;
        }
        else
        {
            RValue = FALSE;
        }
    }
    return RValue;
}

//void main(){}

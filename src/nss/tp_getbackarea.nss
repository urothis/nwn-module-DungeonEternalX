int StartingConditional()
{
    string sName = GetName(GetAreaFromLocation(GetLocalLocation(GetPCSpeaker(), "TP_TARGET")));
    if(sName != "")
    {
        SetCustomToken(28000, sName);
        return TRUE;
    }
    return FALSE;
}

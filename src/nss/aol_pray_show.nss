int StartingConditional()
{
    int iResult;
    object oDead = GetPCSpeaker();
    if(GetLocalInt(oDead, "Prayed") == TRUE)
    {
        return FALSE;
    }
    return TRUE;
}

int StartingConditional()
{
    int iResult;
    object oC = GetItemInSlot(INVENTORY_SLOT_HEAD, GetPCSpeaker());
    if (!GetIsObjectValid(oC))
    {
        return TRUE;
    }
    if (GetPlotFlag(oC))
    {
        return TRUE;
    }
    return FALSE;
}

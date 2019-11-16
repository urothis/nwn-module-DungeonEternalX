int StartingConditional()
{
    int iResult;
    object oC = GetItemInSlot(INVENTORY_SLOT_CLOAK, GetPCSpeaker());
    if (!GetIsObjectValid(oC))
    {
        return FALSE;
    }
    if (GetPlotFlag(oC))
    {
        return FALSE;
    }
    return TRUE;
}

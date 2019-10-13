int StartingConditional()
{
    object oA = GetItemInSlot(INVENTORY_SLOT_CHEST,GetPCSpeaker());
    if (!GetIsObjectValid(oA))
    {
        return FALSE;
    }
    if (GetPlotFlag(oA))
    {
        return FALSE;
    }
    return TRUE;
}

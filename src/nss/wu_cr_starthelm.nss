#include "x2_inc_itemprop"

int StartingConditional()
{
    int iResult;
    object oA = GetItemInSlot(INVENTORY_SLOT_HEAD,GetPCSpeaker());
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

#include "x2_inc_itemprop"

int StartingConditional()
{
    int iResult;
    object oS = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,GetPCSpeaker());
    int iType = GetBaseItemType(oS);
    if (!GetIsObjectValid(oS))
    {
        return FALSE;
    }
    else if (GetPlotFlag(oS))
    {
        return FALSE;
    }
    if (iType!=BASE_ITEM_SMALLSHIELD&&iType!=BASE_ITEM_LARGESHIELD&&iType!=BASE_ITEM_TOWERSHIELD)
    {
     return FALSE;
    }
    return TRUE;
}

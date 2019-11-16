//------------------------------------------------------------------------------
// Condition: Can Craft Weapons?
//------------------------------------------------------------------------------

#include "mk_inc_craft"

int StartingConditional()
{
    int iResult;
    object oW = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,GetPCSpeaker());
    if (!GetIsObjectValid(oW))
    {
        return FALSE;
    }
    else if (GetPlotFlag(oW))
    {
        return FALSE;
    }
    else if (!MK_GetIsModifiableWeapon(oW))
    {
        return FALSE;
    }
    else if (IPGetIsIntelligentWeapon(oW))
    {
        return FALSE;
    }
    return TRUE;
}

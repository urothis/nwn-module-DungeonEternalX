#include "dmg_stones_inc"

object GetRightMerchant(int nCost)
{
    object oPawn = OBJECT_SELF;
    object oMerchant;
    if (nCost <= 1000) oMerchant = DefGetObjectByTag("PAWNSHOP_1", oPawn);
    else if (nCost <= 2000) oMerchant = DefGetObjectByTag("PAWNSHOP_2", oPawn);
    else if (nCost <= 3000) oMerchant = DefGetObjectByTag("PAWNSHOP_3", oPawn);
    else if (nCost <= 4000) oMerchant = DefGetObjectByTag("PAWNSHOP_4", oPawn);
    else oMerchant = DefGetObjectByTag("PAWNSHOP_5", oPawn);
    return oMerchant;
}

void main()
{
    object oItem = GetFirstItemInInventory();
    while(GetIsObjectValid(oItem))
    {
        if (!GetIdentified(oItem)) SetIdentified(oItem, TRUE);
        if (GetIsItemPropertyValid(GetFirstItemProperty(oItem)))
        {
            string sTag = GetTag(oItem);
            string sTag5 = GetStringLeft(sTag, 5);
            string sTag8 = GetStringLeft(sTag, 8);
            if (GetTag(oItem) == "NW_WSWLS001")// mordsword, exploiter selling it
            {
                // DO NOTHING
            }
            else if (sTag8 == "EPICITEM" || sTag8 == "EPICCRAF")
            {
                NWNX_SQL_ExecuteQuery("update epic_item set ei_status='trashed' where ei_id=" + GetLocalString(oItem, "ID"));
            }
            else if (GetStringLeft(sTag, 7) == "CRAFTED")
            {
                // DO NOTHING
            }
            else if (sTag5 == "QUEST")
            {
                // DO NOTHING
            }
            else if (sTag5 == "DMGS_")
            {
                DMGS_UpdateStoneDB(oItem, oItem);
            }
            else if (GetBaseItemType(oItem)==BASE_ITEM_ARROW || GetBaseItemType(oItem)==BASE_ITEM_BOLT ||
                     GetBaseItemType(oItem)==BASE_ITEM_BULLET || GetBaseItemType(oItem)==BASE_ITEM_DART ||
                     GetBaseItemType(oItem)==BASE_ITEM_SHURIKEN || GetBaseItemType(oItem)==BASE_ITEM_THROWINGAXE)
            {
                // DO NOTHING
            }
            else
            {
                int nStackSize = GetItemStackSize(oItem);
                int nCost = GetGoldPieceValue(oItem)/nStackSize;
                object oMerchant = GetRightMerchant(nCost);
                SetIdentified(CopyItem(oItem, oMerchant), TRUE);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory();
    }
}

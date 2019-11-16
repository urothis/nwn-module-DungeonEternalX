//Makes sure the item is unequipped before moving through the script.
void Insured_UnequipItem(object oItem);

void DestroySpecificItem(object oItem)
{
    if(oItem == OBJECT_INVALID)
        return;
    object oPos = GetItemPossessor(oItem);
    if(GetIsPC(oPos) == FALSE)
        DestroyObject(oItem);
}

void DestroyInventoryItems(object oDead, int DropItems)
{
    object oItem = GetFirstItemInInventory( oDead );
    object oDestroy;
    while( GetIsObjectValid( oItem ) == TRUE )
    {
        if( GetDroppableFlag( oItem ) == TRUE && DropItems == TRUE)
        {
            oDestroy = CreateObject(OBJECT_TYPE_ITEM, GetResRef(oItem), GetLocation(oDead));
            DelayCommand(60.0, DestroySpecificItem(oDestroy));
        }
        SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oDead);
    }
    int iSlotID;
    for( iSlotID = 0; iSlotID < NUM_INVENTORY_SLOTS; iSlotID++ )
    {
        oItem = GetItemInSlot(iSlotID, oDead );
        if(GetIsObjectValid(oItem))
        {
            if( GetDroppableFlag( oItem ) == TRUE && DropItems == TRUE)
            {
                oDestroy = CreateObject(OBJECT_TYPE_ITEM, GetResRef(oItem), GetLocation(oDead));
                DelayCommand(60.0, DestroySpecificItem(oDestroy));
            }
            SetPlotFlag(oItem, FALSE);
            DestroyObject( oItem );
        }
    }
}

//  Destroy's a all Stacks or Single Items of Tag Name in a targets inventory.
//  Added originally to remove GTR Dispells from inventory.  (LJU)

void DestroyAllSpecificInvItems(object oTarget, string sTag)
{
    int nStackSize;
    object oItem;
    oItem = GetObjectByTag(sTag);
    nStackSize = GetItemStackSize(oItem);
    // If a stack of items of sTag are found, make it a single item.
    if(nStackSize > 1)
    {
        SetItemStackSize(oItem, 1);
    }
    // Destroy the single Item.
    DelayCommand(1.0, DestroyObject(oItem));
}


void Insured_UnequipItem(object oItem)
{
    ActionUnequipItem(oItem);
}

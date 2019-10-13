void Checkbows (object oItem, object oPC)
{
itemproperty iAB = GetFirstItemProperty(oItem);
     while(GetIsItemPropertyValid(iAB))
     {
        if (GetItemPropertyType(iAB) == ITEM_PROPERTY_ATTACK_BONUS)
        {
            if (GetItemPropertyCostTableValue(iAB) > 15)
            {
            RemoveItemProperty(oItem, iAB);
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAttackBonus(15) , oItem);
            }
        }
     iAB = GetNextItemProperty(oItem);
     }
}
void main()
{
    object oPC= OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iNext;
    if(oItem != OBJECT_INVALID)
    {
     if(GetTag(oItem) == "SharsKiss")
     {
     DestroyObject(oItem);
     CreateItemOnObject("sharskiss",oPC);
     }
     if(GetTag(oItem) == "SharsLove")
     {
     DestroyObject(oItem);
     CreateItemOnObject("sharslove",oPC);
     }
     if(GetBaseItemType(oItem) == BASE_ITEM_LONGBOW ||
        GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW)
     {
     Checkbows(oItem,oPC);
     }
    }
    oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
     if(GetBaseItemType(oItem) == BASE_ITEM_DART ||
        GetBaseItemType(oItem) == BASE_ITEM_SHURIKEN ||
        GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE)
     {
     GiveGoldToCreature(oPC, GetGoldPieceValue(oItem));
     DestroyObject(oItem);
     }
    oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
     if(GetIsObjectValid(oItem))
     {
     GiveGoldToCreature(oPC, GetGoldPieceValue(oItem));
     DestroyObject(oItem);
     }
    oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
     if(GetIsObjectValid(oItem))
     {
     GiveGoldToCreature(oPC, GetGoldPieceValue(oItem));
     DestroyObject(oItem);
     }
    oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
     if(GetIsObjectValid(oItem))
     {
     GiveGoldToCreature(oPC, GetGoldPieceValue(oItem));
     DestroyObject(oItem);
     }
    oItem=GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
     if(GetTag(oItem) == "SharsKiss")
     {
     DestroyObject(oItem);
     CreateItemOnObject("sharskiss",oPC);
     }
     if(GetTag(oItem) == "SharsLove")
     {
     DestroyObject(oItem);
     CreateItemOnObject("sharslove",oPC);
     }
     if(GetBaseItemType(oItem) == BASE_ITEM_ARROW ||
        GetBaseItemType(oItem) == BASE_ITEM_DART ||
        GetBaseItemType(oItem) == BASE_ITEM_SHURIKEN ||
        GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE ||
        GetBaseItemType(oItem) == BASE_ITEM_BULLET ||
        GetBaseItemType(oItem) == BASE_ITEM_BOLT)
     {
     GiveGoldToCreature(oPC, GetGoldPieceValue(oItem));
     DestroyObject(oItem);
     }
     if(GetBaseItemType(oItem) == BASE_ITEM_LONGBOW ||
        GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW)
     {
     Checkbows(oItem,oPC);
     }
     oItem=GetNextItemInInventory(oPC);
    }

}


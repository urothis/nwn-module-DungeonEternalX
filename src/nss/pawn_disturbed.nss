void main()
{
    object oPC = GetLastDisturbed();
    object oItem = GetInventoryDisturbItem();
    int iMaxBuyCost = 4000000;
    int iDType = GetInventoryDisturbType();
    int iValue = GetGoldPieceValue(oItem);
    if (iDType == INVENTORY_DISTURB_TYPE_ADDED && iValue <= iMaxBuyCost)
    {

        if (GetBaseItemType(oItem) == BASE_ITEM_ARROW
        || GetBaseItemType(oItem) == BASE_ITEM_BOLT
        || GetBaseItemType(oItem) == BASE_ITEM_BULLET
        || GetBaseItemType(oItem) == BASE_ITEM_SHURIKEN
        || GetBaseItemType(oItem) == BASE_ITEM_DART
        || GetBaseItemType(oItem) == BASE_ITEM_GRENADE
        || GetBaseItemType(oItem) == BASE_ITEM_TRAPKIT
        || GetBaseItemType(oItem) == BASE_ITEM_THIEVESTOOLS
        || GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE)
        {
            iValue = iValue/12;
            GiveGoldToCreature(oPC, iValue);
            DestroyObject(oItem);
        }
        else
        {
            GiveGoldToCreature(oPC, iValue);
            DestroyObject(oItem);
        }

    }
    else
    {
        SendMessageToPC(oPC, "The item you just pawned is considered illegal and will be destroyed without a gp exchange.");
        DestroyObject(oItem);
    }
}

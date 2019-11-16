void main() {
    object oPC = GetPCSpeaker();
    int nGold;
    object oItem = GetFirstItemInInventory(oPC);
    while (oItem != OBJECT_INVALID)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_GEM)
        {
            nGold = nGold + GetGoldPieceValue(oItem);
            DestroyObject(oItem);
        }
        oItem = GetNextItemInInventory(oPC);
    }
    GiveGoldToCreature(oPC, nGold);
}

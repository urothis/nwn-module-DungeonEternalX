void main()
{
    object oChest = OBJECT_SELF;
    SetLocked(oChest, TRUE);
    object oPC = GetLastClosedBy();
    object oLever = GetLocalObject(oChest, "SLOT_LEVER");

    int nGold = GetLocalInt(oLever, "SLOT_CREDIT");

    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_GEM)
        {
            nGold += GetGoldPieceValue(oItem);
            DestroyObject(oItem);
        }
        oItem = GetNextItemInInventory(oChest);
    }
    SetLocalInt(oLever, "SLOT_CREDIT", nGold);

    DelayCommand(6.0, SetLocked(oChest, FALSE));
    SendMessageToPC(oPC, "Credit: " + IntToString(nGold));
}

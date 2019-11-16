#include "random_loot_inc"

void main()
{
    object oChest = OBJECT_SELF;
    object oLever = GetLocalObject(oChest, "SLOT_LEVER");

    int nGold = GetLocalInt(oLever, "SLOT_CREDIT");
    DeleteLocalInt(oLever, "SLOT_CREDIT");
    if (!nGold) return;
    if (nGold > 0 && nGold < 1000) nGold = 1000;
    LootCreateGems(oChest, nGold, nGold, FALSE);

    SendMessageToPC(GetLastOpenedBy(), "Cash out: " + IntToString(nGold));
}

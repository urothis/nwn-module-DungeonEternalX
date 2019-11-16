#include "quest_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetFirstItemInInventory(oPC);
    int nCnt;
    int nStack;
    while (GetIsObjectValid(oItem) && nCnt < 10)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_SPELLSCROLL)
        {
            if (!QuestGetIsStoreScroll(oItem))
            {
                nStack = GetItemStackSize(oItem);
                if (nStack > 1) SetItemStackSize(oItem, nStack - 1);
                else DestroyObject(oItem);
                nCnt++;
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }
    if (nCnt == 10) Q_UpdateQuest(oPC, "17");
}

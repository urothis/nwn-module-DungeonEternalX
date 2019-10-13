#include "quest_inc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sMsg;
    object oItem = GetFirstItemInInventory(oPC);
    int nCnt;
    while (GetIsObjectValid(oItem) && nCnt < 10)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_SPELLSCROLL)
        {
            if (!QuestGetIsStoreScroll(oItem))
            {
                sMsg += ", " + GetName(oItem);
                nCnt++;
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }
    SetCustomToken(1100, sMsg);
    if (nCnt == 10) return TRUE;
    return FALSE;
}

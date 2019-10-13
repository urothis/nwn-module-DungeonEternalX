// Conversation Action Taken: show item

#include "x2_inc_craft"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    SetHiddenWhenEquipped(oItem, FALSE);
}

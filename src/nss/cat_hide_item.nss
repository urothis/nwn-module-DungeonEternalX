// Conversation Action Taken: hide item

#include "x2_inc_craft"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    SetHiddenWhenEquipped(oItem, TRUE);
}

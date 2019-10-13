// Support for cloak crafting: next appearance

#include "x2_inc_itemprop"

void main()
{
object oPC = GetPCSpeaker();
object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
int nAppearance = GetItemAppearance(oCloak, ITEM_APPR_TYPE_SIMPLE_MODEL, 12);
if(nAppearance == 15)
{
nAppearance = -1;
}
object oNew = CopyItemAndModify(oCloak, ITEM_APPR_TYPE_SIMPLE_MODEL, 12, nAppearance+1, TRUE);
DestroyObject(oCloak);
DelayCommand(0.1, AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_CLOAK)));
}

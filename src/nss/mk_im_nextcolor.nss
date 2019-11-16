#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    if (!GetIsObjectValid(oItem))
    {
        return;
    }

    switch (CIGetCurrentModMode(oPC))
    {
    case X2_CI_MODMODE_ARMOR:
    case MK_CI_MODMODE_CLOAK:
    case MK_CI_MODMODE_HELMET:
        {
            int iMaterialToDye = GetLocalInt(oPC, "MK_MaterialToDye");
            int iColor = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye);
            iColor = (iColor+1) % 176;

            MK_DyeItem(oPC,iMaterialToDye,iColor);
        }
        break;
    case X2_CI_MODMODE_WEAPON:
        {
            int nPart =  GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART");
            object oNew = MK_GetModifiedWeapon(oItem, nPart, MK_IP_ITEMCOLOR_NEXT, TRUE);
            CISetCurrentModItem(oPC,oNew);
            AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_RIGHTHAND));
       }
       break;
    case MK_CI_MODMODE_SHIELD:
        break;
    }


}

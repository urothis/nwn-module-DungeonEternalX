//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Cycle prev part
   Changes the appearance of the currently active armorpart
   on the tailor to the previous appearance
*/
//  created/updated 2003-06-24 Georg Zoeller, Bioware Corp
//  modified Kamiryn 2006-07-23
//////////////////////////////////////////////////////////

#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    int nPart =  GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART");
    int nPart2 = GetLocalInt(OBJECT_SELF,"MK_TAILOR_CURRENT_PART2");

    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    if(GetIsObjectValid(oItem) == TRUE)
    {
        // Store the cost for modifying this item here
        object oNew;
        AssignCommand(oPC,ClearAllActions(TRUE));
        int nInventorySlot=-1;

        switch (CIGetCurrentModMode(oPC))
        {
        case X2_CI_MODMODE_ARMOR:
            oNew = MK_GetModifiedArmor(oItem, nPart, X2_IP_ARMORTYPE_PREV, TRUE);
            if ((nPart2>=0) && (nPart2<ITEM_APPR_ARMOR_NUM_MODELS))
            {
                oNew = MK_GetModifiedArmor(oNew, nPart2, MK_IP_ITEMTYPE_OPPOSITE, TRUE);
            }
            CISetCurrentModItem(oPC,oNew);
            nInventorySlot = INVENTORY_SLOT_CHEST;
            break;
        case X2_CI_MODMODE_WEAPON:
            oNew = MK_GetModifiedWeapon(oItem, nPart, MK_IP_ITEMTYPE_PREV, TRUE);
            CISetCurrentModItem(oPC,oNew);
            nInventorySlot = INVENTORY_SLOT_RIGHTHAND;
            break;
        case MK_CI_MODMODE_CLOAK:
            oNew = MK_GetModifiedCloak(oItem, nPart, MK_IP_ITEMTYPE_PREV, TRUE);
            CISetCurrentModItem(oPC,oNew);
            nInventorySlot = INVENTORY_SLOT_CLOAK;
            break;
        case MK_CI_MODMODE_HELMET:
            oNew = MK_GetModifiedHelmet(oItem, MK_IP_ITEMTYPE_PREV, TRUE);
            CISetCurrentModItem(oPC,oNew);
            nInventorySlot = INVENTORY_SLOT_HEAD;
            break;
        case MK_CI_MODMODE_SHIELD:
            oNew = MK_GetModifiedShield(oItem, MK_IP_ITEMTYPE_PREV, TRUE);
            CISetCurrentModItem(oPC,oNew);
            nInventorySlot = INVENTORY_SLOT_LEFTHAND;
            break;
        }
        if (nInventorySlot!=-1)
        {
            AssignCommand(oPC, ActionEquipItem(oNew, nInventorySlot));
        }
    }
}


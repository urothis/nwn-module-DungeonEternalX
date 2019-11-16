//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation

   Changes the appearance of the currently active armorpart
   on the tailor to the next available appearance
*/
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
//  modified Kamiryn 2006-07-23
//////////////////////////////////////////////////////////

#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    int nPart =  GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART");

    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    if(GetIsObjectValid(oItem) == TRUE)
    {
        // Store the cost for modifying this item here
        object oNew;
        AssignCommand(oPC,ClearAllActions(TRUE));

        switch (CIGetCurrentModMode(oPC))
        {
        case X2_CI_MODMODE_ARMOR:
            oNew = MK_GetModifiedArmor(oItem, nPart, MK_IP_ITEMTYPE_OPPOSITE, TRUE);
            CISetCurrentModItem(oPC,oNew);
            AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST));
            break;
        }
    }
}


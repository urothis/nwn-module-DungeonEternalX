//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Action Script: Set current selected part to
   Left Shoulder and Right Shoulder
*/
// created/updated 2006-10-03 Kamiryn
/////////////////////////////////////////////////////////

#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    MK_SetCurrentModParts(GetPCSpeaker(),
        ITEM_APPR_ARMOR_MODEL_LSHOULDER, ITEM_APPR_ARMOR_MODEL_RSHOULDER,
        7150, 7146);
}

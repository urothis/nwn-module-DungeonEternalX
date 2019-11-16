//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Action Script: Set current selected part to
   Left Shin and Right Shin
*/
/////////////////////////////////////////////////////////

#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    MK_SetCurrentModParts(GetPCSpeaker(),
        ITEM_APPR_ARMOR_MODEL_LSHIN, ITEM_APPR_ARMOR_MODEL_RSHIN,
        83348, 83349);
}

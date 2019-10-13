//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Action Script: Set current selected part to
   Left Arm and Right Arm
*/
/////////////////////////////////////////////////////////
#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    MK_SetCurrentModParts(GetPCSpeaker(),
        ITEM_APPR_ARMOR_MODEL_LFOREARM, ITEM_APPR_ARMOR_MODEL_RFOREARM,
        7152, 7148);
}

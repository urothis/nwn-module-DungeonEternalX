//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Action Script: Set current selected part to
   Left Glove and Right Glove
*/
/////////////////////////////////////////////////////////

#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    MK_SetCurrentModParts(GetPCSpeaker(),
        ITEM_APPR_ARMOR_MODEL_LHAND, ITEM_APPR_ARMOR_MODEL_RHAND,
        7153, 7149);
}

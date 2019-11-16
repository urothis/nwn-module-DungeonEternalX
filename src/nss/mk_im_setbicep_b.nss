//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Action Script: Set current selected part to
   Left Bicep and Right Bicep
*/
/////////////////////////////////////////////////////////

#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    MK_SetCurrentModParts(GetPCSpeaker(),
        ITEM_APPR_ARMOR_MODEL_LBICEP, ITEM_APPR_ARMOR_MODEL_RBICEP,
        7151, 7147);
}

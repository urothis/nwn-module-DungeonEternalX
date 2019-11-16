//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Action Script: Set current selected part to
   Right Glove
*/
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
// fixed wrong tlk string reference (Kamiryn, 2006-09-24)
/////////////////////////////////////////////////////////
#include "x2_inc_craft"
void main()
{
   CISetCurrentModPart(GetPCSpeaker(),ITEM_APPR_ARMOR_MODEL_RHAND,7149);
}

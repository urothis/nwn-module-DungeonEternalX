//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Cycle next part
   Changes the appearance of the currently active armorpart
   on the tailor to the next available appearance
*/
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
//////////////////////////////////////////////////////////
#include "x2_inc_craft"
void main()
{
 int nPart =  GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART");
 object oPC = GetPCSpeaker();
 object oItem = CIGetCurrentModItem(oPC);
 int nCurrentAppearance;
 object oNew;
 if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
  {
   nCurrentAppearance = GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);
  }
 if(GetIsObjectValid(oItem) == TRUE)
  {
   AssignCommand(oPC,ClearAllActions(TRUE));
  if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
   {
    oNew = IPGetModifiedArmor(oItem, nPart, X2_IP_ARMORTYPE_NEXT, TRUE);
    DestroyObject(oItem);
    CISetCurrentModItem(oPC,oNew);
    AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST));
   }
  else if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_WEAPON)
   {
    int nCurrApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, nPart);
    int nBaseType = BaseItemRange(oItem);
    int nMin = StringToInt(Get2DAString("des_range", "Min", nBaseType));
    int nMax = StringToInt(Get2DAString("des_range", "Max", nBaseType));
    if (++nCurrApp>nMax) nCurrApp = nMin;
    oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, nPart, nCurrApp, TRUE);
    DestroyObject(oItem);
    CISetCurrentModItem(oPC,oNew);
    AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_RIGHTHAND));
   }

  else if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_SHIELD)
   {
    int nCurrApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    int nBaseType = BaseItemRange(oItem);
    int nMod = (nCurrApp/10)*10;
    nCurrApp-= nMod;
    int nMin = StringToInt(Get2DAString("des_range", "Min", nBaseType));
    int nMax = (StringToInt(Get2DAString("des_range", "Max", nBaseType))/10)*10;
    nMod+=10;
    if (nMod>nMax) nMod = nMin;
    nCurrApp += nMod;
    oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nCurrApp, TRUE);
    DestroyObject(oItem);
    CISetCurrentModItem(oPC,oNew);
    AssignCommand(oPC, ActionEquipItem(oNew,INVENTORY_SLOT_LEFTHAND));
   }
  else if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_HELM)
   {
    int nCurrApp = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0);
    int nBaseType = GetBaseItemType(oItem);
    int nMin = 1;
    int nMax = 32;
    if (++nCurrApp>nMax) nCurrApp = nMin;
    oNew = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, 0, nCurrApp, TRUE);
    DestroyObject(oItem);
    CISetCurrentModItem(oPC,oNew);
    AssignCommand(oPC, ActionEquipItem(oNew,INVENTORY_SLOT_HEAD));
   }
  }

}


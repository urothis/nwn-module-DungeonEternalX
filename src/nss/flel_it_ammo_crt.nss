#include "x2_inc_switches"
#include "_leto_name"
#include "gen_inc_color"

void main() {
   int i = 0;
   int iCost = 0;
   if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;
   object oWorkContainer = GetObjectByTag("WorkContainer");
   object oPC = GetItemActivator();
   object oItem = RetrieveCampaignObject("AMMO_CREATORS","ACRT_",GetLocation(oWorkContainer),oWorkContainer,oPC);
   if (GetTag(oItem)=="COO_AASSDARTS") {
      DestroyObject(oItem);
      oItem = CreateItemOnObject("nw_it_msmlmisc20", oWorkContainer, 1);
      StoreCampaignObject("AMMO_CREATORS","ACRT_", oItem, oPC);
      SetName(oItem, "Aass Fish");
   }
   SetName(oItem, GetName(oItem) + " of " + GetName(oPC));
   if (GetIsObjectValid(oItem)) {
      SendMessageToPC(oPC,GetRGB(11,9,11) + "Success! Retrieved: " + GetName(oItem) + " from ammo creator");
      if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_HIT_PROPERTIES)) {
         iCost = GetGoldPieceValue(oItem) * 3;
         if (GetGold(oPC)>=iCost) {
            TakeGoldFromCreature(iCost, oPC, TRUE);
            PlaySound("it_coins");
         } else {
            SendMessageToPC(oPC, "Sorry, you cannot afford ammo with on hit properties.");
            DestroyObject(oItem);
            return;
         }
      }
      for(i=0;i<5;i++) {
         CopyItem(oItem,oPC);
      }
      DestroyObject(oItem);
   }
}

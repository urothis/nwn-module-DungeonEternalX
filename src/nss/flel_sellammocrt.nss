#include "gen_inc_color"
void main() {
   object oPC = GetPCSpeaker();
   object oItem = GetItemPossessedBy(oPC,"flel_it_ammo_crt");
   if (GetIsObjectValid(oItem)) {
      object oItem2 = RetrieveCampaignObject("AMMO_CREATORS","ACRT_",GetLocation(oPC),oPC,oPC);
      GiveGoldToCreature(oPC, GetGoldPieceValue(oItem2) * 3);
      DestroyObject(oItem);
   } else {
      SendMessageToPC(oPC,GetRGB(11,9,11) + "You don't have one to sell");
   }
}

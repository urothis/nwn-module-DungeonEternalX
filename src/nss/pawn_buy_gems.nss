int DoGem(object oPC, int iGold = 0, int iGemValue = 0, string sRef = "") {
   int i;
   int iTake = 0;
   int iGemCount = iGold / (iGemValue * 10);
   for (i=1; i<=iGemCount; i++) {
      CreateItemOnObject(sRef, oPC, 10);
      iTake = iTake + (iGemValue * 10);
   }
   iGold = iGold - iTake;
   iGemCount = iGold / iGemValue;
   if (iGemCount) {
      CreateItemOnObject(sRef, oPC, iGemCount);
      iTake = iTake + (iGemValue * iGemCount);
   }
   TakeGoldFromCreature(iTake, oPC);
   return iTake;
}

void main() {
   object oPC = GetPCSpeaker();
   int iGold = GetGold(oPC) - 15000;
   if (iGold > 15000) iGold = iGold - DoGem(oPC, iGold, 15000, "starsapphire");
   if (iGold > 10000) iGold = iGold - DoGem(oPC, iGold, 10000, "perfectruby");
   if (iGold >  5000) iGold = iGold - DoGem(oPC, iGold,  5000, "perfectsapphire");
   if (iGold >  4000) iGold = iGold - DoGem(oPC, iGold,  4000, "nw_it_gem012");    // Emerald
   if (iGold >  3000) iGold = iGold - DoGem(oPC, iGold,  3000, "nw_it_gem006");    // Ruby
   if (iGold >  2000) iGold = iGold - DoGem(oPC, iGold,  2000, "nw_it_gem005");    // Diamond
   if (iGold >  1000) iGold = iGold - DoGem(oPC, iGold,  1000, "nw_it_gem008");    // Sapphire
}

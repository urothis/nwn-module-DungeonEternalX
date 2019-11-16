#include "_functions"

void main() {
   string sWhich=GetTag(OBJECT_SELF);
   object oPC = GetClickingObject();
   object oWP = GetWaypointByTag("BYH_DOOR_WP");
   location lTarget;
   int nHP;
   int nHPMin;

   if (GetIsHostilePcNearby(oPC, GetArea(oPC), 35.0, 5)) return;

   if (sWhich == "BYH_DOOR") { // MAIN EXIT FROM BABA YAGA'S HOLE
      sWhich = GetLocalString(oPC,"FROM_BYH")+ "_WP";
      oWP = GetWaypointByTag(sWhich);
   } else { // VARIOUS TOWN ENTRANCES
      SetLocalString(oPC,"FROM_BYH",sWhich);
      nHP = GetCurrentHitPoints(oPC);
      nHPMin = GetMaxHitPoints(oPC)/5;
      if (nHP<nHPMin) {
         SendMessageToPC(oPC, "Sorry, You are too wounded to enter!");
         return;
      }
   }
   lTarget = GetLocation(oWP);
   if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) lTarget = GetLocation(GetWaypointByTag("LOFT_BYH_WP"));
   AssignCommand(oPC,JumpToLocation(lTarget));
}

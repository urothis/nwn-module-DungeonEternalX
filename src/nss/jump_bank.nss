void main() {
   string sWhich=GetTag(OBJECT_SELF);
   object oPC = GetClickingObject();
   object oWP = GetWaypointByTag("BANK_DOOR_WP");
   location lTarget;

   if (sWhich == "BANK_DOOR") { // MAIN EXIT FROM BANK
      sWhich = GetLocalString(oPC,"FROM_BANK")+ "_WP";
      oWP = GetWaypointByTag(sWhich);
   } else { // VARIOUS TOWN ENTRANCES
      SetLocalString(oPC,"FROM_BANK",sWhich);
   }
   lTarget = GetLocation(oWP);
   if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) lTarget = GetLocation(GetWaypointByTag("LOFT_BANK_WP"));
   AssignCommand(oPC,JumpToLocation(lTarget));
}

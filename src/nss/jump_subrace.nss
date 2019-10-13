void main() {
   object oPC = GetClickingObject();
   if (GetXP(oPC)>2) {
      SendMessageToPC(oPC, "Only new characters may enter these halls.");
      return;
   } else {
      object oWP = GetWaypointByTag("SUBRACE_TAVERN_WP");
      AssignCommand(oPC,JumpToLocation(GetLocation(oWP)));
   }

}

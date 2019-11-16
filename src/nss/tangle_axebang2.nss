void GetOre (object oPC) {
   SetCommandable(TRUE,oPC);
   int nWhat = d100();
   if (nWhat <= 25) {
      SendMessageToPC(oPC,"Just a bunch of rubbish!");
   } else if (nWhat <= 50) {
      CreateItemOnObject("NW_IT_GOLD001", oPC, d20(6));
   } else if (nWhat <= 60) {  //Crimson Ore
      CreateItemOnObject("crimsonore", oPC,1);
   } else if (nWhat <= 70) { //Maranta Ore
      CreateItemOnObject("marantaore", oPC,1);
   } else if (nWhat <= 80) {  //Ember Ore
      CreateItemOnObject("emberore", oPC,1);
   } else if (nWhat <= 90) {  //Organa Ore
      CreateItemOnObject("organaore", oPC,1);
   } else if (nWhat <= 95) {
      string sTag = "GolemWaypoint";
      object oGolemPoint = GetWaypointByTag (sTag);
      location lGolemPoint1 = GetLocation(oGolemPoint);
      SendMessageToPC(oPC,"Just a bunch of rubbish!");
      CreateObject(OBJECT_TYPE_CREATURE,"stonegolem",lGolemPoint1);
   } else { // Uber Ore
      CreateItemOnObject("uberore", oPC,1);
   }
}

void main() {
   object oPC = GetPCSpeaker();
   object oRock = OBJECT_SELF;
   SendMessageToPC(oPC,"**SWING**");
   SendMessageToPC(oPC,"Some rocks fell to the floor.. You take a look..");
   AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,6.0));
   DelayCommand(1.0,SetCommandable(FALSE,oPC));
   DelayCommand(6.0,GetOre(oPC));
}

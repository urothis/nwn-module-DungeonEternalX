void main() {
   SpeakString("Enjoy the trip, see you next fall.");
   object oWP = GetObjectByTag("DOT_SHIP_WP");
   object oPC = GetPCSpeaker();
   DelayCommand(1.0, AssignCommand(oPC, JumpToObject(oWP)));
}

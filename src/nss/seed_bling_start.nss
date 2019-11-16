#include "zdlg_include_i"

void main() {
   object oPC = GetItemActivator();
   object oTarget = GetItemActivatedTarget();

   if (!GetIsPC(oTarget) || oPC==oTarget) { // Target needs to be PC
      SendMessageToPC(oPC, "Target is not a valid player character");
      return;
   }
   SetLocalObject(oPC, "PRIZE_TARGET", oTarget);
   OpenNextDlg(oPC,GetItemActivated(), "seed_bling_wand", TRUE, FALSE);
}

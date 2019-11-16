#include "zdlg_include_i"

void main()
{
   object oPC = GetItemActivator();
   object oTarget = GetItemActivatedTarget();
   if (!GetIsDM(oPC)) {
      DestroyObject(GetItemActivated());
      SendMessageToPC(oPC, "You are not a DM. Your action has been logged.");
      return;
   }
   if (!GetIsPC(oTarget)) { // Target needs to be PC
      SendMessageToPC(oPC, "Target is not a valid player character");
      return;
   }
   if (oPC==oTarget) { // Target needs to be PC
      SendMessageToPC(oPC, "Don't ban yourself fool...");
      return;
   }
   SetLocalObject(oPC, "BAN_TARGET", oTarget);
   OpenNextDlg(oPC,GetItemActivated(), "seed_ban_tool", TRUE, FALSE);
}

#include "seed_faction_inc"
#include "zdlg_include_i"
#include "x2_inc_switches"

void main() {
   object oPC = GetItemActivator();
   object oTarget = GetItemActivatedTarget();
   if (!GetIsPC(oTarget) || oPC == oTarget) { // Target needs to be PC and not self
      if (SDB_FactionGetRank(oPC)!=DB_FACTION_GENERAL) oTarget = OBJECT_INVALID;
   }
   if (GetIsDM(oPC)) {
      if (oTarget==OBJECT_INVALID) {
         SendMessageToPC(oPC, "Please select a valid target.");
         return;
      }
   }
   if (!SDB_FactionIsMember(oPC) && !GetIsDM(oPC)) {
      SendMessageToPC(oPC, "You're not in a faction. Removing faction token...");
      DestroyObject(GetItemActivated());
      return;
   }
   SetLocalObject(oPC, SDB_TOME_TARGET, oTarget);
  //StartDlg(oPC,GetItemActivated(),"seed_factiontool",TRUE,FALSE);
   OpenNextDlg(oPC, GetItemActivated(), "seed_factiontool", TRUE, FALSE);
}

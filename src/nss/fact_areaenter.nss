#include "seed_faction_inc"

void main() {
   ExecuteScript("_mod_areaenter", OBJECT_SELF);
   object oPC = GetEnteringObject();
   if (GetIsDM(oPC)) return;
   if(!GetIsPC(oPC)) return;
   object oArea = OBJECT_SELF;
   string sTag = GetTag(oArea);
   string sCastleFAID = GetLocalString(oArea, "FAID"); // GET AREA'S FACTION
   if (FindSubString(sTag, "approach")!=-1) return; // NOTHING DONE ON ENTER TO FACTION APPROACH
   if (FindSubString(sTag, "castle")!=-1) return; // NOTHING DONE ON ENTER TO FACTION CASTLE
   string sEnteringFAID = SDB_GetFAID(oPC);
   if (FindSubString(sTag, "plane")!=-1) { // BOSS PLANE
      object oBoss = GetObjectByTag("BOSS_" + sCastleFAID);
      if (oBoss!=OBJECT_INVALID) {
         ClearPersonalReputation(oBoss, oPC);
         if (sEnteringFAID==sCastleFAID) SetIsTemporaryFriend(oPC, oBoss);
         else SetIsTemporaryEnemy(oPC, oBoss);
      }
   }

   if (sEnteringFAID!=sCastleFAID) { // NOT A MEMBER OF THIS CASTLE'S FACTION
      object oMember = GetFirstPC();
      while (GetIsObjectValid(oMember)) { // LOOP OVER ALL PC'S AND CHECK IF IN CASTLE'S FACTION
         if (SDB_GetFAID(oMember) == sCastleFAID) {
            SendMessageToPC(oMember, GetName(oPC) + " has entered " + GetName(oArea));
            SetPCDislike(oPC, oMember); // OOH I HATE THEM SO!
         }
         oMember = GetNextPC();
      }
   }

}

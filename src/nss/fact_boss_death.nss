#include "artifact_inc"

void main() {
   object oBoss = OBJECT_SELF;
   string sBossFAID = GetLocalString(oBoss, "FAID"); // WHICH FACTION'S BOSS GOT KILLED
   SetLocalInt(GetModule(), SDB_FACTION_ARTICOUNT + sBossFAID, 0); // ZERO ARTIFACT COUNT

   Artifact_DropFromBoss(oBoss, "1");
   Artifact_DropFromBoss(oBoss, "2");
   Artifact_DropFromBoss(oBoss, "3");
   Artifact_DropFromBoss(oBoss, "4");
   Artifact_DropFromBoss(oBoss, "5");
   Artifact_DropFromBoss(oBoss, "6");
   Artifact_DropFromBoss(oBoss, "7");
   Artifact_DropFromBoss(oBoss, "8");
   Artifact_DropFromBoss(oBoss, "9");
   Artifact_DropFromBoss(oBoss, "10");

   ExecuteScript("x2_def_ondeath", OBJECT_SELF);
}

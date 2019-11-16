#include "seed_faction_inc"
#include "fame_inc"
#include "_inc_port"
#include "effect_inc"

void Artifact_SetHeld(object oPC, string sFAID)
{
   SetLocalString(oPC, "ARTIFACT_HELD", sFAID);
}

string Artifact_GetHeld(object oPC)
{
   return GetLocalString(oPC, "ARTIFACT_HELD");
}

object Artifact_GetFactionBoss(string sFAID) { // Gets/Spawns A FACTION'S BOSS
   string sBossTag = "BOSS_" + sFAID;
   object oBoss = GetObjectByTag(sBossTag);
   if (oBoss == OBJECT_INVALID) {
      location lBossWP = GetLocation(GetObjectByTag(sBossTag + "_WP"));
      oBoss = CreateObject(OBJECT_TYPE_CREATURE, "faction_boss", lBossWP, FALSE, sBossTag);
      SetName(oBoss, SDB_FactionGetBossName(sFAID));
      AssignCommand(oBoss, SpeakString("Long Live " + SDB_FactionGetName(sFAID)+ "!", TALKVOLUME_SHOUT));
      SetLocalString(oBoss, "FAID", sFAID);
      SetCreatureAppearanceType(oBoss, SDB_FactionGetBossSkin(sFAID));
   }
   return oBoss;
}

void Artifact_OnModuleLoad()
{ // SPAWNS BOSSES & ARTIFACTS
   string sFAID = SDB_FactionGetFirst(); // FACTION WHO'S ARTIFACT WE ARE CHECKING
   while (sFAID!="") {
      string sArtiFAID = SDB_FactionGetArtifact(sFAID); // FACTION THAT POSSESSES THE ARTIFACT
      if (sArtiFAID=="0") sArtiFAID = sFAID;
      object oBoss = Artifact_GetFactionBoss(sArtiFAID);
//      SetLocalInt(oBoss, SDB_FACTION_ARTIFACT + sArtiFAID, 1); //
      SetLocalString(GetModule(), SDB_FACTION_ARTIFACT + sFAID, sArtiFAID);
      IncLocalInt(GetModule(), SDB_FACTION_ARTICOUNT + sArtiFAID, 1); // INCREMENT ARTIFACT COUNT
WriteTimestampedLogEntry("Gave " + GetName(oBoss) + " Artifact " + sFAID);
      sFAID = SDB_FactionGetNext();
   }
}


void Artifact_GiveBonuses(string sFAID, object oMember=OBJECT_INVALID)
{
   if (sFAID=="") return; // NOT FACTIONED
   int nCount = SDB_FactionGetArtifactCount(sFAID);
   if (!nCount) return; // NO ARTIFACTS
   string sBossTag = "BOSS_" + sFAID;
   object oBoss = GetObjectByTag(sBossTag);
   if (oBoss==OBJECT_INVALID) return; // NO BOSS
   if (oMember!=OBJECT_INVALID) { // SINGLE PLAYER RESTED
      SetLocalObject(oBoss, "MEMBER", oMember);
   } else {
      DeleteLocalObject(oBoss, "MEMBER");
   }
   ExecuteScript("artifact_bonus", oBoss);
}

void Artifact_ReturnToBoss(object oPC)
{
   if (!GetIsObjectValid(oPC)) return;
   string sArtiFAID = Artifact_GetHeld(oPC); // FACTION ID WHO'S ARTIFACT I CARRY
   if (sArtiFAID=="") return; // NOT HOLDING ARTIFACT
   Artifact_SetHeld(oPC, "");
   RemoveEffectBySubType(oPC, EFFECT_TYPE_VISUALEFFECT, SUBTYPE_SUPERNATURAL);
   object oBoss = Artifact_GetFactionBoss(sArtiFAID);
   int nCnt = IncLocalInt(GetModule(), SDB_FACTION_ARTICOUNT + sArtiFAID, 1); // INCREMENT ARTIFACT COUNT
   ShoutMsg(GetName(oBoss) + " has reclaimed " + SDB_FactionGetArtifactName(sArtiFAID) + "...(time limit exceeded)");
   SDB_FactionSetArtifact(sArtiFAID, sArtiFAID);
   Artifact_GiveBonuses(sArtiFAID);
   WriteTimestampedLogEntry("Gave " + GetName(oBoss) + " Artifact " + sArtiFAID);
}


void Artifact_AltarOnUsed(object oPC, string sArtiFAID, string sFAID)
{
    Artifact_SetHeld(oPC, "");
    RemoveEffectBySubType(oPC, EFFECT_TYPE_VISUALEFFECT, SUBTYPE_SUPERNATURAL);
    object oBoss = Artifact_GetFactionBoss(sFAID);
    // SetLocalInt(oBoss, SDB_FACTION_ARTIFACT + sFAID, 1); // I HOLD THIS FACTIONS ARTIFACT
    int nCnt = IncLocalInt(GetModule(), SDB_FACTION_ARTICOUNT + sFAID, 1); // INCREMENT ARTIFACT COUNT
    ShoutMsg(GetName(oBoss) + " now has " + SDB_FactionGetName(sArtiFAID) + " artifact.");
    ShoutMsg(GetName(oBoss) + " now holds " + IntToString(nCnt) + " artifacts!");
    if (sFAID != sArtiFAID) GiveAllPartyMembersFame(oPC, FAME_PER_ARTEFACT, 5.0, "Artifact"); // give some fame
    SDB_FactionSetArtifact(sArtiFAID, sFAID);
    Artifact_GiveBonuses(sFAID);
    WriteTimestampedLogEntry("Gave " + GetName(oBoss) + " Artifact " + sFAID);
}

void Artifact_OnGround(string sFAID, location lGround) {
   object oArtifact = CreateObject(OBJECT_TYPE_PLACEABLE, "faction_artifact", lGround);
   object oBubbles = CreateObject(OBJECT_TYPE_PLACEABLE, "nw_plc_bubbleslg", GetLocation(oArtifact));
   SetLocalObject(oArtifact, "EFFECT", oBubbles);
   SetName(oArtifact, SDB_FactionGetArtifactName(sFAID));
   SetLocalString(oArtifact, "FAID", sFAID);
}

void Artifact_Drop(object oPC) {
  if (!GetIsObjectValid(oPC)) return;
  if (!GetIsPC(oPC)) return;
   string sFAID = Artifact_GetHeld(oPC);
   if (sFAID=="") return; // NOT HELD
   Artifact_SetHeld(oPC, "");
   RemoveEffectBySubType(oPC, EFFECT_TYPE_VISUALEFFECT, SUBTYPE_SUPERNATURAL);
   Artifact_OnGround(sFAID, GetLocation(oPC));
}

void Artifact_PickUp(object oPC, object oArtifact=OBJECT_SELF) {
  // valid player?
  if (!GetIsObjectValid(oPC)) return;
  if (!GetIsPC(oPC)) return;
  if (GetIsDM(oPC)) return;
  if (!GetIsObjectValid(oArtifact)) return;
  string sFAIDPC = SDB_GetFAID(oPC);
  if (!StringToInt(sFAIDPC)) return;
  if (!GetIsObjectValid(DefGetObjectByTag("WP_FACTION_BASE_" + sFAIDPC, GetWPHolder()))) return;
  if (Artifact_GetHeld(oPC)!="") {
    FloatingTextStringOnCreature("You already hold an Artifact!", oPC);
    return;
  }
  string sFAID = GetLocalString(oArtifact, "FAID");
  Artifact_SetHeld(oPC, sFAID);
  effect eFlag = EffectVisualEffect(VFX_DUR_FLAG_BLUE);
//  eFlag = EffectLinkEffects(EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10), eFlag);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eFlag), oPC);
  object oBubbles = GetLocalObject(oArtifact, "EFFECT");
  DestroyObject(oBubbles);
  DestroyObject(oArtifact);
  DelayCommand(300.0, Artifact_ReturnToBoss(oPC));
}

void Artifact_DropFromBoss(object oBoss, string sArtiFAID) {
   string sHoldFAID = GetLocalString(GetModule(), SDB_FACTION_ARTIFACT + sArtiFAID); // WHO HOLDS THIS ARTIFACT?
   string sBossFAID = GetLocalString(oBoss, "FAID"); // WHICH FACTION'S BOSS GOT KILLED
   if (sBossFAID==sHoldFAID) { // BOSS HAS THIS ARTIFACT
      if (sBossFAID==sArtiFAID) { // HAS OWN, DROP IT
         Artifact_OnGround(sBossFAID, GetLocation(oBoss));
         SDB_FactionSetArtifact("0", sBossFAID); // IT'S "UNOWNED"
WriteTimestampedLogEntry("Dropped to Ground Artifact " + sArtiFAID);
      } else { // HAS OTHERS, RETURN THEM HOME
         oBoss = Artifact_GetFactionBoss(sArtiFAID);
//         SetLocalInt(oBoss, SDB_FACTION_ARTIFACT + sArtiFAID, 1); //
         IncLocalInt(GetModule(), SDB_FACTION_ARTICOUNT + sArtiFAID, 1); // INCREMENT ARTIFACT COUNT
         SDB_FactionSetArtifact(sArtiFAID, sArtiFAID);  // I CONTROL MY ARTIFACT
WriteTimestampedLogEntry("Gave " + GetName(oBoss) + " Artifact " + sArtiFAID);
      }
   }

}

string Artifact_ShowOwner(string sFAID)
{
   string sText = SDB_FactionGetArtifactName(sFAID);
   sFAID = GetLocalString(GetModule(), SDB_FACTION_ARTIFACT + sFAID); // WHO HOLDS THIS ARTIFACT?
   if (sFAID == "0") sFAID = "Unknown";
   else sFAID = SDB_FactionGetName(sFAID);
   if (sText != "") sText += ": " + sFAID;
   return sText;
}

//void main(){}

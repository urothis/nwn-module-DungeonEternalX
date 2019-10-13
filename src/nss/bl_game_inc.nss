#include "pg_lists_i"
#include "x0_i0_position"
#include "_functions"
#include "effect_inc"

const string RTEAM_LIST        = "RED_LIST";
const string GTEAM_LIST        = "GREEN_LIST";
const string TEAM_LIST         = "TEAM_LIST";
object LIST_OWNER = GetModule();

void JumpTeam(string sList, object oPortal, int nVFX, float fRadius, int bHeal = FALSE) {
   int nCnt = GetElementCount(sList, LIST_OWNER);
   float fStep = IntToFloat(360/nCnt);
   float fAng = 15.0;
   location lPortal = GetLocation(oPortal);
   location lNew;
   object oPC = GetFirstObjectElement(sList, LIST_OWNER);
   while (GetIsObjectValid(oPC)) {
      lNew = GenerateNewLocationFromLocation(lPortal, fRadius, fAng, 180.0f+fAng);
      fAng += fStep;
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, JumpToLocation(lNew));
      if (GetIsDead(oPC)) {
         ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC);
         ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPC)),oPC);
         ForceRest(oPC);
      } else if (bHeal) {
         DelayCommand(0.40, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPC)),oPC));
         DelayCommand(0.50, ForceRest(oPC));
      }
      DelayCommand(0.75, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), oPC));
      //SetLocalString(oPC, "BLOOD_TEAM", sList);
      oPC = GetNextObjectElement();
   }
}

int PCOnTeam(object oPC, string sWhich) {
   object oCheck = GetFirstObjectElement(sWhich, LIST_OWNER);
   int bCheck = FALSE;
   while (GetIsObjectValid(oCheck)) {
      if (oCheck==oPC) bCheck = TRUE;
      oCheck = GetNextObjectElement();
   }
   return bCheck;
}

string TeamList(string sList) {
   object oPC = GetFirstObjectElement(sList, LIST_OWNER);
   string sTeam = "";
   while (GetIsObjectValid(oPC)) {
      sTeam += (sTeam=="") ? GetName(oPC) : ", " + GetName(oPC);
      oPC = GetNextObjectElement();
   }
   return sTeam;
}

void DestroyIfExists(string sWhich) {
   object oKill = GetObjectByTag(sWhich);
   if (oKill!=OBJECT_INVALID) DestroyObject(oKill);
}

void CreateKeg() {
   DestroyIfExists("BL_KEG");
   object oKeg = CreateObject(OBJECT_TYPE_PLACEABLE, "bl_keg", GetLocation(GetObjectByTag("BL_KEG_WP")));
}

void CreateChain(string sWhich, string sName) {
   DestroyIfExists("BL_" + sWhich + "_DESPAIR_1");
   DestroyIfExists("BL_" + sWhich + "_DESPAIR_2");
   object oChain;
   oChain = GetObjectByTag("BL_" + sWhich + "_DESPAIR",0);
   oChain = CreateObject(OBJECT_TYPE_PLACEABLE, "bl_despair_chain", GetLocation(oChain), FALSE, "BL_" + sWhich + "_DESPAIR_1");
   SetName(oChain, sName + " Chain of Despair");
   oChain = GetObjectByTag("BL_" + sWhich + "_DESPAIR",1);
   oChain = CreateObject(OBJECT_TYPE_PLACEABLE, "bl_despair_chain", GetLocation(oChain), FALSE, "BL_" + sWhich + "_DESPAIR_2");
   SetName(oChain, sName + " Chain of Despair");
}

int GetGameRunning() {
   return GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, GetObjectByTag("BL_RED_PORT_IN")));
}

int RemoveKeg(object oPC, int bCreatePlacable=FALSE, int bSkipChecks=FALSE) {
   string sTag = GetTag(GetArea(oPC));
   if (!bSkipChecks && GetLocalString(oPC, "BL_TEAM")=="") return FALSE;
   if (bSkipChecks || sTag=="" || sTag=="DEXBLOOD") {
      object oKegger = GetItemPossessedBy(oPC, "BL_KEG_INV");
      if (oKegger!=OBJECT_INVALID) {
         DestroyObject(oKegger);
         if (bCreatePlacable && GetObjectByTag("BL_KEG")==OBJECT_INVALID) {
            location lKeg = GetLocation(oPC);
            if (GetTag(GetArea(oPC))=="") lKeg = GetLocation(GetObjectByTag("BL_KEG_WP"));
            CreateObject(OBJECT_TYPE_PLACEABLE, "bl_keg", lKeg);
            DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), lKeg));
         }
         RemoveEffectBySubType(oPC, EFFECT_TYPE_VISUALEFFECT, SUBTYPE_EXTRAORDINARY);
         return TRUE;
      }
   }
   return FALSE;
}

void KillKeg() {
   object oKegger;
   object oPC = GetFirstObjectElement(TEAM_LIST, LIST_OWNER);
   while (GetIsObjectValid(oPC)) {
      if (RemoveKeg(oPC)) return;
      oPC = GetNextObjectElement();
   }
}

//void main(){}

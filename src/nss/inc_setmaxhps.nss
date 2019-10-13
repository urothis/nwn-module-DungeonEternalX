#include "db_inc"
#include "inc_server"
#include "epic_inc"
#include "nwnx_admin"
/* inc_setmaxhps

Step 1: on-client-enter, include this file and add this command:

MaxHitPointsPCEnter(GetEnteringObject());

Step 2: on-client-exit, include this file and add this command:

MaxHitPointsPCExit(GetExitingObject());

Step 3: Call this script from an NPC conversation

MaxHitPointsSetMax(GetPCSpeaker());

*/


void MaxHitPointsPCEnter(object oPC)
{
   /*SetLocalString(oPC, "MaxHitPointsName", GetPCPlayerName(oPC)); // Disabled by Ezramun
   DeleteLocalString(oPC, "MaxHitPointsScript");
   int iOld = GetPersistentInt(oPC, "MAXHPS");
   if (iOld > 0) {
      int iChange = GetMaxHitPoints(oPC) - iOld;
      object oPF;
      if (iChange) {
         oPF = GetObjectByTag("MAXHITPOINTS_PASS");
         SendMessageToPC(oPC, "You gained " + IntToString(iChange) + " hit points from the Max Hit Points script.");
      } else {
         oPF = GetObjectByTag("MAXHITPOINTS_FAIL");
         SendMessageToPC(oPC, "You failed to gain any hit points from the Max Hit Points script.");
      }
      if (oPF!=OBJECT_INVALID) DelayCommand(3.0f,AssignCommand(oPC, ActionExamine(oPF)));
      SetPersistentInt(oPC, "MAXHPS", -1, 1); // FLAG IT DONE
   }*/
}

void MaxHitPointsPCExit(object oPC) {
   /*string sScript = GetLocalString(oPC, "MaxHitPointsScript");// Disabled by Ezramun
   if (sScript != "") {
      string sPath = GetLocalString(oPC, "MaxHitPointsName");
      sPath = GetVaultDir()+"/"+sPath+"/";
      if (sPath == "") WriteTimestampedLogEntry("MaxHitPoints Bic Path is Null");
      sScript  = "%char = '"+sPath+"'+FindNewestBic('"+sPath+"'); " + sScript;
      sScript += "%char = '>'; ";
      sScript += "close %char; ";
      WriteTimestampedLogEntry("Leto Max HP Script >: "+sScript);
      SetLocalString(GetModule(), "NWNX!LETO!SCRIPT", sScript);
      string sScriptResult = GetLocalString(GetModule(), "NWNX!LETO!SCRIPT");
      WriteTimestampedLogEntry("Leto Results <: "+sScriptResult);
   }*/
   string sScript = GetLocalString(oPC, "DELETECHAR");
   if (sScript!="") {
      WriteTimestampedLogEntry("Leto DeleteChar Script >: "+sScript);
      SetLocalString(GetModule(), "NWNX!LETO!SCRIPT", sScript);
      string sScriptResult = GetLocalString(GetModule(), "NWNX!LETO!SCRIPT");
      WriteTimestampedLogEntry("Leto Results <: "+sScriptResult);
   }
}

void MaxHitPointsSetMax(object oPC) {
      SendMessageToPC(oPC, "Max HP is disabled. Server maxes your HP when you level now.");
      // ExportSingleCharacter(oPC);
      /*SetPersistentInt(oPC, "MAXHPS", GetMaxHitPoints(oPC), 1);
      string LS = "meta dir => '" + GetSourceDir() + "'; $RDD = 0; for(/LvlStatList) { $HD = lookup 'classes', /~/LvlStatClass, 'HitDie'; if(/~/LvlStatClass == 37) { $RDD++; $HD = $RDD < 4  ? $HD : $RDD < 6  ? 8 : $RDD < 11 ? 10 : 12; } /~/LvlStatHitDie = $HD; }";
      SetLocalString(oPC, "MaxHitPointsScript", LS);
      SpeakString("Ha! Prepare to be Leto'ed and thank Dragonsong!");
      DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND), oPC, 2.20));
      DelayCommand(2.5, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 9.0)));
      DelayCommand(2.6, PlayVoiceChat(VOICE_CHAT_CUSS, oPC));
      DelayCommand(2.7, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC));
      DelayCommand(2.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oPC));
      DelayCommand(2.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), oPC));
      DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oPC));
      DelayCommand(4.5, ActivatePortal(oPC, GetServerIP(), "", "", TRUE));
      */
}

void DeletePC(object oPC) {
    ExportSingleCharacter(oPC);

    if (GetHitDice(oPC) == 40)
    {
        if (GetHasEpicItemWithReq(oPC)) return;
    }

   /*
   string BicPath = GetVaultDir() + "/" + GetPCPlayerName(oPC) + "/";
   BicPath = "q<" + BicPath + "> + " + "FindNewestBic q<" + BicPath + ">;";
   SetLocalString(oPC, "DELETECHAR", "FileDelete " + BicPath);
   */


   AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 11.0));
   PlayVoiceChat(VOICE_CHAT_CUSS, oPC);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), oPC);
   DelayCommand(1.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), oPC));
   DelayCommand(2.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oPC));
   DelayCommand(2.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oPC));
   DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), oPC));
   DelayCommand(3.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oPC));
   DelayCommand(7.0, ActivatePortal(oPC, "server.dungeoneternalx.com:51745", "", "", TRUE));
   DelayCommand(8.0, NWNX_Administration_DeletePlayerCharacter(oPC));
}


//void main(){}

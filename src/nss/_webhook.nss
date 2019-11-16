#include "nwnx_time"
#include "nwnx_util"
#include "nwnx_webhook_rch"
#include "nwnx_player"

const string NAME = "DungeonEternalX";

int playersOnline(){
    object oPC = GetFirstPC();
    int nCount;
    while(GetIsObjectValid(oPC)) {
        if (!GetIsDM(oPC)) nCount++;
        oPC = GetNextPC();
    }
    return nCount;
}

void LoginWebhook(object oPC) {
  string sConstructedMsg;
  string sName = GetName(oPC);
  struct NWNX_WebHook_Message stMessage;
  stMessage.sUsername = NAME;
  stMessage.sTitle = "Login";
  stMessage.sColor = "#14aed3";
  stMessage.sAuthorName = sName;
  stMessage.sAuthorIconURL = "https://nwn.sfo2.digitaloceanspaces.com/portrait/" + GetStringLowerCase(GetPortraitResRef(oPC)) + "t.png";
  stMessage.sThumbnailURL = "https://nwn.sfo2.digitaloceanspaces.com/portrait/" + GetStringLowerCase(GetPortraitResRef(oPC)) + "m.png";
  stMessage.sDescription = " :crossed_swords: **" + sName + "** has logged in! :crossed_swords: ";
  stMessage.sField1Name = "Player count";
  stMessage.sField1Value = IntToString(playersOnline());
  stMessage.iField1Inline = TRUE;
  stMessage.sFooterText = GetName(GetModule());
  stMessage.iTimestamp = NWNX_Time_GetTimeStamp();
  if(GetIsDM(oPC)) {
    // private webhook
    stMessage.sField2Name = "IP";
    stMessage.sField2Value = GetPCIPAddress(oPC);
    stMessage.iField2Inline = TRUE;
    stMessage.sField3Name = "CD";
    stMessage.sField3Value = GetPCPublicCDKey(oPC);
    stMessage.iField3Inline = TRUE;
    stMessage.sField4Name = "Username";
    stMessage.sField4Value = GetPCPlayerName(oPC);
    stMessage.iField4Inline = TRUE;
    sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PRIVATE_CHANNEL"), stMessage);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PRIVATE_CHANNEL"), sConstructedMsg);
  } else {
    // public webhook
    sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), stMessage);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), sConstructedMsg);
    // private webhook
    stMessage.sField2Name = "IP";
    stMessage.sField2Value = GetPCIPAddress(oPC);
    stMessage.iField2Inline = TRUE;
    stMessage.sField3Name = "CD";
    stMessage.sField3Value = GetPCPublicCDKey(oPC);
    stMessage.iField3Inline = TRUE;
    stMessage.sField4Name = "Username";
    stMessage.sField4Value = GetPCPlayerName(oPC);
    stMessage.iField4Inline = TRUE;
    stMessage.sField5Name = "Bic File";
    stMessage.sField5Value = NWNX_Player_GetBicFileName(oPC);
    stMessage.iField5Inline = TRUE;
    sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PRIVATE_CHANNEL"), stMessage);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PRIVATE_CHANNEL"), sConstructedMsg);
  }
}

void LogoutWebhook(object oPC) {
  string sConstructedMsg;
  string sName = GetName(oPC);
  struct NWNX_WebHook_Message stMessage;
  stMessage.sUsername = NAME;
  stMessage.sColor = "#1088a4";
  stMessage.sField1Name = "Player count";
  stMessage.sField1Value = IntToString(playersOnline() - 1);
  stMessage.iField1Inline = TRUE;
  stMessage.sFooterText = GetName(GetModule());
  stMessage.iTimestamp = NWNX_Time_GetTimeStamp();
  if(GetIsDM(oPC)) {
    // private webhook
    stMessage.sAuthorIconURL = "https://nwn.sfo2.digitaloceanspaces.com/portrait/" + GetStringLowerCase(GetPortraitResRef(oPC)) + "t.png";
    stMessage.sThumbnailURL = "https://nwn.sfo2.digitaloceanspaces.com/portrait/" + GetStringLowerCase(GetPortraitResRef(oPC)) + "m.png";
    stMessage.sDescription = " :crossed_swords: **" + sName + "** has logged out. :crossed_swords: ";
    stMessage.sField2Name = "IP";
    stMessage.sField2Value = GetPCIPAddress(oPC);
    stMessage.iField2Inline = TRUE;
    stMessage.sField3Name = "CD";
    stMessage.sField3Value = GetPCPublicCDKey(oPC);
    stMessage.iField3Inline = TRUE;
    stMessage.sField4Name = "Username";
    stMessage.sField4Value = GetPCPlayerName(oPC);
    stMessage.iField4Inline = TRUE;
    stMessage.sField4Name = "Bic File";
    stMessage.sField4Value = NWNX_Player_GetBicFileName(oPC);
    stMessage.iField4Inline = TRUE;
    sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PRIVATE_CHANNEL"), stMessage);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PRIVATE_CHANNEL"), sConstructedMsg);
  } else {
    // public webhook
    sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), stMessage);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), sConstructedMsg);
    // private webhook
    stMessage.sAuthorIconURL = "https://nwn.sfo2.digitaloceanspaces.com/portrait/" + GetStringLowerCase(GetPortraitResRef(oPC)) + "t.png";
    stMessage.sThumbnailURL = "https://nwn.sfo2.digitaloceanspaces.com/portrait/" + GetStringLowerCase(GetPortraitResRef(oPC)) + "m.png";
    stMessage.sDescription = " :crossed_swords: **" + sName + "** has logged out. :crossed_swords: ";
    stMessage.sField2Name = "IP";
    stMessage.sField2Value = GetPCIPAddress(oPC);
    stMessage.iField2Inline = TRUE;
    stMessage.sField3Name = "CD";
    stMessage.sField3Value = GetPCPublicCDKey(oPC);
    stMessage.iField3Inline = TRUE;
    stMessage.sField4Name = "Username";
    stMessage.sField4Value = GetPCPlayerName(oPC);
    stMessage.iField4Inline = TRUE;
    stMessage.sField5Name = "Bic File";
    stMessage.sField5Value = NWNX_Player_GetBicFileName(oPC);
    stMessage.iField5Inline = TRUE;
    sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PRIVATE_CHANNEL"), stMessage);
    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PRIVATE_CHANNEL"), sConstructedMsg);
  }
}

void ModLoadWebhook() {
  string sConstructedMsg;
  struct NWNX_WebHook_Message stMessage;
  stMessage.sUsername = "DungeonEternalX";
  stMessage.sColor = "#bc8812";
  stMessage.sDescription = "DungeonEternalX is coming up!";
  stMessage.sFooterText = GetName(GetModule());
  stMessage.iTimestamp = NWNX_Time_GetTimeStamp();
  sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), stMessage);
  NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), sConstructedMsg);
}

void ModDownWebhook() {
  string sConstructedMsg;
  struct NWNX_WebHook_Message stMessage;
  stMessage.sUsername = "DungeonEternalX";
  stMessage.sColor = "#b81669";
  stMessage.sDescription = "DungeonEternalX is going down.";
  stMessage.sFooterText = GetName(GetModule());
  stMessage.iTimestamp = NWNX_Time_GetTimeStamp();
  sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), stMessage);
  NWNX_WebHook_SendWebHookHTTPS("discordapp.com", NWNX_Util_GetEnvironmentVariable("NWNX_WEBHOOK_PUBLIC_CHANNEL"), sConstructedMsg);
}

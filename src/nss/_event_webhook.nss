#include "nwnx_events"
#include "nwnx_webhook"

void main() {
  object oModule = OBJECT_SELF;
  int iStatus = StringToInt(NWNX_Events_GetEventData("STATUS"));
  // Status 429 means it was Rate Limited
  if (iStatus == 429) {
    // Reset is sent in milliseconds
    float delayToSend = StringToFloat(NWNX_Events_GetEventData("RETRY_AFTER")) / 1000.0f;
    PrintString("WebHook rate limited, resending in "+FloatToString(delayToSend)+" seconds.");
    string sMessage = NWNX_Events_GetEventData("MESSAGE");
    string sHost = NWNX_Events_GetEventData("HOST");
    string sPath = NWNX_Events_GetEventData("PATH");
    NWNX_WebHook_ResendWebHookHTTPS(sHost, sPath, sMessage, delayToSend);
  }
}

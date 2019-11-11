#include "nwnx_chat"
#include "nwnx_redis_short"

int GetChatPermissionLevel(object oPC) {
  return HGET(GetName(GetModule()) + ":" + GetPCPublicCDKey(oPC),"chatLevel");
}

void SetChatPermissionLevel(object oPC, int nLevel) {
  HSET(GetName(GetModule()) + ":" + GetPCPublicCDKey(oPC),"chatLevel", IntToString(nLevel));
  return;
}

int processChatPermission(object oPC, string sMessage) {
  switch(GetChatPermissionLevel(oPC)) {
    // only able to talk in party
    case 1: {
      FloatingTextStringOnCreature("Your chat has been redirected to party.",oPC,TRUE);
      NWNX_Chat_SkipMessage();
      NWNX_Chat_SendMessage(NWNX_CHAT_CHANNEL_PLAYER_PARTY,sMessage, oPC);
      return 0;
    }
    // blocking all chat completely
    case 2: {
      FloatingTextStringOnCreature("You are banned from chat.",oPC,TRUE);
      NWNX_Chat_SkipMessage();
      return 0;
    }
    default: return 1;
  }
  return 1;
}

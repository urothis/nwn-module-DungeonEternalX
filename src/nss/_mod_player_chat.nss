#include "com_source"
#include "nwnx_chat"

int GetChatPermissionLevel(object oPC) {

}

void main() {
    object oPC = NWNX_Chat_GetSender();
    if(!GetIsPC(oPC)) return;

    object oTarget = NWNX_Chat_GetTarget();
    string sMessage = NWNX_Chat_GetMessage();

    // permission levels
    int nPCPermissionLevel = GetChatPermissionLevel(oPC);
    int nChannel = NWNX_Chat_GetChannel();

    switch(nPCPermissionLevel) {
        // only able to talk in party
        case 1: {
            FloatingTextStringOnCreature("Your chat has been redirected to party.",oPC,TRUE);
            NWNX_Chat_SkipMessage();
            NWNX_Chat_SendMessage(NWNX_CHAT_CHANNEL_PLAYER_PARTY,sMessage, oPC);
            break;
        }
        // blocking all chat completely
        case 2: { 
           NWNX_Chat_SkipMessage();
            FloatingTextStringOnCreature("You are banned from chat.",oPC,TRUE);
            break;
        }
        default: break;
    }

    // emote commands
    MRPlayerChat(oPC, sMessage);
}

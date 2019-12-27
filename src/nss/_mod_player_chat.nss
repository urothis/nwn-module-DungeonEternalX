#include "com_source"
#include "chat_volume_inc"

void main() {
    object oPC = NWNX_Chat_GetSender();
    if(!GetIsPC(oPC)) return;

    object oTarget = NWNX_Chat_GetTarget();
    string sMessage = NWNX_Chat_GetMessage();

    // process chat permissions of a player.
    processChatPermission(oPC,sMessage);

    // emote commands
    MRPlayerChat(oPC, sMessage);

    // process a pm to user message
    // dm commands
    // warn mute command
    if (TestStringAgainstPattern(sMessage,"!dm warnmute") && GetIsDM(oPC) && NWNX_Chat_GetChannel() == 4 || NWNX_Chat_GetChannel() == 20 ){
        SetChatPermissionLevel(NWNX_Chat_GetTarget(), 2);
    }

    // mute command
    if (TestStringAgainstPattern(sMessage,"!dm mute") && GetIsDM(oPC) && NWNX_Chat_GetChannel() == 4 || NWNX_Chat_GetChannel() == 20 ){
        SetChatPermissionLevel(NWNX_Chat_GetTarget(), 2);
    }

    // mute command
    if (TestStringAgainstPattern(sMessage,"!dm unmute") && GetIsDM(oPC) && NWNX_Chat_GetChannel() == 4 || NWNX_Chat_GetChannel() == 20 ){
        SetChatPermissionLevel(NWNX_Chat_GetTarget(), 0);
    }
}


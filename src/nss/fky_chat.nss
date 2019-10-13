#include "fky_chat_inc"
#include "nwnx_chat"

void main()
{
//////////////////////////////////Declarations//////////////////////////////////
    /*
    object oPC = NWNX_Chat_GetSender();//OBJECT_SELF;//GetPCChatSpeaker();
    object oTarget = NWNX_Chat_GetTarget();// Speaker = oPC
    string sText, sLogMessage, sLogMessageTarget, sType, sSort;
    //string sTPLID = "0";
    int nChannel, nTarget;



/////////////////////////Gather Message and Target Data/////////////////////////

    SetLocalString(oPC, "NWNX!CHAT!TEXT", Speech_GetSpacer()); // Query for chattext
    sText = GetLocalString(oPC, "NWNX!CHAT!TEXT"); // Get chattext
    nChannel = StringToInt(GetStringLeft(sText, 2)); // Get channel
    nTarget = StringToInt(GetSubString(sText, 2, 10)); // Target ID - Return value of -1 is no target. IE, not a tell/privatemessage
    sText = GetStringRight(sText, GetStringLength(sText) - 12);// Remove Target & Channel Info
    */

    object oPC      = NWNX_Chat_GetSender();
    object oTarget  = NWNX_Chat_GetTarget();
    int nChannel    = NWNX_Chat_GetChannel();
    string sText    = NWNX_Chat_GetMessage();
    string sLogMessage, sLogMessageTarget, sType, sSort;

    if (!GetIsObjectValid(oPC))
        return;

    //Check if the speaker is a NPC
    if (!GetIsPC(oPC))
        return;

    int bLogIt = TEXT_LOGGING_ENABLED;
    if (GetIsObjectValid(oTarget)) // Acquire possible target
    {
        //oTarget = Speech_GetPlayer(nTarget);
        sLogMessageTarget = "->" + GetName(oTarget) + "(" + GetPCPlayerName(oTarget) + ")";
        //sTPLID = SDB_GetPLID(oTarget);
///////////////////////////////////DM Stealth///////////////////////////////////
        if (GetLocalInt(oTarget, "FKY_CHAT_DMSTEALTH") && (oTarget != oPC)) {DoStealth(oPC, oTarget, sText, nChannel, sLogMessageTarget); return;}
    }
    sType = GetSubString(sText, 0, 1);//this is the primary sorting string, the leftmost letter of the text
    if (sType == EMOTE_SYMBOL) {
       HandleEmotes(oPC, sText, nChannel);//emotes
       bLogIt = FALSE;
    }
    else if (sType == COMMAND_SYMBOL) HandleCommands(oPC, oTarget, sText, nChannel);//commands
    else if ((GetStringLowerCase(GetStringLeft(sText, 3)) == "dm_") && (VerifyDMKey(oPC) || VerifyAdminKey(oPC)))
    {
        //HandleDMTraffic(oPC, oTarget, sText);//this has been moved to a new script to allow compiler to digest it
        SetLocalObject(oPC, "FKY_CHAT_DMSHUNT_TARGET", oTarget);//these locals pass the needed values to the new script
        SetLocalString(oPC, "FKY_CHAT_DMSHUNT_TEXT", sText);
        ExecuteScript("fky_chat_dm_comm", oPC);
    }
    else HandleOtherSpeech(oPC, oTarget, sText, nChannel, sLogMessageTarget);
////////////////////////////////////Logging/////////////////////////////////////
    if (bLogIt)
    {
       DoLogging(oPC, sLogMessageTarget, nChannel, sText);

       // ZOMG, disabled by Ezramun
       /*sLogMessage = GetName(oPC) + "(" + GetPCPlayerName(oPC) + ")" + sLogMessageTarget + "[" + Speech_GetChannel(nChannel) + "] " + sText + "\n";

       sType = GetStringLeft(Speech_GetChannel(nChannel), 1);
       string sSQL = "insert into chattext (ct_seid, ct_plid, ct_channel, ct_text, ct_toplid) values (" +
          DelimList(SDB_GetSEID(), SDB_GetPLID(oPC), InQs(sType), InQs(sLogMessage), sTPLID) + ")";
       SQLExecDirect(sSQL);*/
    }
////////////////////////////////////Cleanup/////////////////////////////////////
    //DoCleanup(oPC);
}

#include "com_source"
///////////////////////////////////////////////////////////////////////////////
/////////////////////Mad Rabbit's Player Chat Commands/////////////////////////
///////////////////////////////////////////////////////////////////////////////


////////////////////////////////Main Code//////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    string sMessage = GetPCChatMessage();
    string sSecondaryCommand = GetSubString(sMessage, 5, 3);
    int nLength = GetStringLength(sMessage);
    string sName = GetSubString(sMessage, 9, nLength);
    int nAssociateType = ASSOCIATE_TYPE_SUMMONED;
    object oAssociate = GetAssociate(nAssociateType, oPC);

    if (sSecondaryCommand == "nme") {
        SetPCChatVolume(TALKVOLUME_SILENT_TALK);
        SetName(oAssociate, sName); }
    else if (sSecondaryCommand == "att")
    {
        SetPCChatVolume(TALKVOLUME_SILENT_TALK);
        object oTarget = GetAttackTarget(oPC);

        AssignCommand(oAssociate, ActionDoCommand(ActionAttack(oTarget)));
    }
    else if (sSecondaryCommand == "sth") {
        SetPCChatVolume(TALKVOLUME_SILENT_TALK);
        int nStealth = GetActionMode(oAssociate, ACTION_MODE_STEALTH);

        if (nStealth) {
            SetActionMode(oAssociate, ACTION_MODE_STEALTH, FALSE);
            return; }
        else if (!nStealth)
            SetActionMode(oAssociate, ACTION_MODE_STEALTH, TRUE); }

    else if (sSecondaryCommand == "det") {
        SetPCChatVolume(TALKVOLUME_SILENT_TALK);
        int nDetect = GetActionMode(oAssociate, ACTION_MODE_DETECT);

        if (nDetect) {
            SetActionMode(oAssociate, ACTION_MODE_DETECT, FALSE);
            return; }
        else if (!nDetect)
            SetActionMode(oAssociate, ACTION_MODE_DETECT, TRUE); }

    else if (sSecondaryCommand == "att")
    {
        SetPCChatVolume(TALKVOLUME_SILENT_TALK);
        object oTarget = GetAttackTarget(oPC);
        object oSummon;

        AssignCommand(oSummon, ActionDoCommand(ActionAttack(oTarget)));
    }

}

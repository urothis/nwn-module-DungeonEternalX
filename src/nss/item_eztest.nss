#include "x2_inc_switches"

void SendAImessage(object oPC, object oTarget)
{
    string sMsg;
    int nAIlevel = GetAILevel(oTarget);

    if (nAIlevel == AI_LEVEL_DEFAULT) sMsg = "AI_LEVEL_DEFAULT";
    if (nAIlevel == AI_LEVEL_HIGH) sMsg = "AI_LEVEL_HIGH";
    if (nAIlevel == AI_LEVEL_INVALID) sMsg = "AI_LEVEL_INVALID";
    if (nAIlevel == AI_LEVEL_LOW) sMsg = "AI_LEVEL_LOW";
    if (nAIlevel == AI_LEVEL_NORMAL) sMsg = "AI_LEVEL_NORMAL";
    if (nAIlevel == AI_LEVEL_VERY_HIGH) sMsg = "AI_LEVEL_VERY_HIGH";
    if (nAIlevel == AI_LEVEL_VERY_LOW) sMsg = "AI_LEVEL_VERY_LOW";
    SendMessageToPC(oPC, sMsg);
}

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;
    object oPC = GetItemActivator();

    if (GetPCPlayerName(oPC) != "Ezramun")
    {
        DestroyObject(GetItemActivated());
        return;
    }

    object oTarget = GetItemActivatedTarget();

    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !GetIsPC(oTarget))
    {
        SendAImessage(oPC, oTarget);
        DelayCommand(10.0, SendAImessage(oPC, oTarget));
    }
    else if (GetLocalString(oTarget, "OWNER") != "")
    {
        if (GetStolenFlag(oTarget))
        {
            SetStolenFlag(oTarget, FALSE);
            SendMessageToPC(oPC, "Item was flaged as stolen, removed it");
        }
        else SendMessageToPC(oPC, "Item was not flaged as stolen");
    }
    else SendMessageToPC(oPC, "Item has no owner");

}

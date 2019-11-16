#include "_inc_port"

void DoFakePort(object oPC)
{
    object oWP = GetNearestObjectByTag("BYH_DOOR_WP", oPC);
    if (GetIsObjectValid(oWP))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(472), OBJECT_SELF);
        AssignCommand(oPC, DelayCommand(1.0, JumpToLocation(GetLocation(oWP))));
    }
    return;
}


void main()
{
    object oPC     = GetLastUsedBy();
    object oLeader = GetFactionLeader(oPC);
    if (!GetIsObjectValid(oLeader)) // Leader is invalid somehow, like between maps
    {
        SendMessageToPC(oPC, "Target is invalid");
        DoFakePort(oPC);
        return;
    }
    if (oPC == oLeader) return;

    int nPMLeader = GetPortMode(oLeader);
    if (nPMLeader == PORT_NOT_ALLOWED)
    {
        SendMessageToPC(oPC, "You can not port to target at this time.");
        DoFakePort(oPC);
        return;
    }

    int nPMPC = GetPortMode(oPC);
    if (nPMPC == PORT_NOT_ALLOWED)
    {
        SendMessageToPC(oPC, "You can not try another port attempt so close to the last one.");
        DoFakePort(oPC);
        return;
    }

    if (abs(GetHitDice(oLeader)) - GetHitDice(oPC) > 10)
    {
        SendMessageToPC(oPC, "The level difference between you and the Party Leader is too much. The max is 10 levels.");
        SetPortMode(oPC, PORT_NOT_ALLOWED);
        DelayCommand(3.0, SetPortMode(oPC));
        DoFakePort(oPC);
        return;
    }

    if (nPMLeader != PORT_IS_ALLOWED)
    {
        object oAreaLeader = GetArea(oLeader);
        string sAreaFAID   = GetLocalString(oAreaLeader, "FAID");

        if (sAreaFAID != "")
        {
            if (sAreaFAID != "-1" && sAreaFAID != GetLocalString(oPC, "FAID"))
            {
                SendMessageToPC(oPC, "Sorry, you can not port to " + GetName(oLeader) + "'s area.");
                SetPortMode(oLeader, PORT_NOT_ALLOWED);
                DelayCommand(3.0, SetPortMode(oLeader));
                DoFakePort(oPC);
                return;
            }
        }
        if (GetIsHostilePcNearby(oLeader, oAreaLeader, 35.0, 5))
        {
            SendMessageToPC(oPC, "Sorry, " + GetName(oLeader) + " is too close to enemies");
            SetPortMode(oLeader, PORT_NOT_ALLOWED);
            DelayCommand(3.0, SetPortMode(oLeader));
            DoFakePort(oPC);
            return;
        }
        SetPortMode(oLeader, PORT_IS_ALLOWED);
        DelayCommand(3.0, SetPortMode(oLeader));
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(472), OBJECT_SELF);
    SetLocalInt(oPC, "DO_PORT_FX", TRUE);
    AssignCommand(oPC, DelayCommand(1.0, JumpToLocation(GetLocation(oLeader))));
}

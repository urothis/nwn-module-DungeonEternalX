#include "x2_inc_switches"

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

    object oTarget = GetItemActivatedTarget();

    if (GetLocalInt(oTarget, "JAILED"))
    {
        SetLocalInt(oTarget, "JAILED", FALSE);
        AssignCommand(oTarget, DelayCommand(1.0, JumpToLocation(GetStartingLocation())));
    }
    else
    {
        if (GetIsPC(oTarget))
        {
            object oJail = GetWaypointByTag ("WP_JAIL");
            if (oTarget != GetItemActivator()) SetLocalInt(oTarget, "JAILED", TRUE);
            AssignCommand(oTarget, DelayCommand(1.0, JumpToObject(oJail)));
        }
    }
}

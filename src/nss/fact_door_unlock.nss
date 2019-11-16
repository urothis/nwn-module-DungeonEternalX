#include "seed_faction_inc"

void RelockDoor(object oDoor, object oInnerDoor)
{
    if (GetCurrentHitPoints(oDoor) > 0)
    {
        ActionCloseDoor(oDoor);
        ActionCloseDoor(oInnerDoor);
        DelayCommand(1.0, SetLocked(oDoor, TRUE));
    }
}

void main()
{
    object oDoor = OBJECT_SELF;
    string sFAID = GetLocalString(GetArea(OBJECT_SELF), "FAID");
    string sFaction = SDB_FactionGetName(sFAID);

    object oInnerDoor = DefGetObjectByTag("FACT_" + sFAID + "_CASTLE_MAIN");
    DelayCommand(300.0, RelockDoor(oDoor, oInnerDoor));
}

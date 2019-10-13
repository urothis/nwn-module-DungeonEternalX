#include "enc_inc"

void CheckActivatePortals(object oArea, object oExiting)
{
    if (GetLocalInt(oArea, "PORTS_DEACTIVATE")) DeleteLocalInt(oExiting, "PORTS_DEACTIVATE");
}

void main()
{
    object oPC = GetExitingObject();
    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;
    if (GetIsDMPossessed(oPC)) return;
    object oArea = OBJECT_SELF;

    CheckActivatePortals(oArea, oPC);
    AssignCommand(oArea, DelayCommand(0.1, EncounterOnAreaExit(oPC, oArea)));

    //int nCount = GetLocalInt(oArea, "TOTALCOUNT");
    //if (nCount > 0 && GetIsEncounterCreature(oPC))
    //{
    //   SetLocalInt(oArea, "TOTALCOUNT", --nCount);
    //}
}

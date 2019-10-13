#include "_functions"
#include "db_inc"

void main()
{
    object oPC = GetLastUsedBy();

    if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

    object oChest   = OBJECT_SELF;
    string sID      = IntToString(dbGetTRUEID(oPC));
    string sChestID = GetLocalString(oChest, "CHEST_ID");
    string sDBName  = "PERSISTENT_CHEST";

    if (sChestID != "" && sChestID != sID)
    {
        AssignCommand(oPC, ClearAllActions());
        SetCutsceneMode(oPC, TRUE);
        AssignCommand(oPC, ActionMoveAwayFromObject(oChest, TRUE, 50.0));
        FloatingTextStringOnCreature("Chest is already in use", oPC);
        DelayCommand(5.0, SetCutsceneMode(oPC, FALSE));
    }
}

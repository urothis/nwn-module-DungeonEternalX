//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_used
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//////////////////////////////////////////////////

#include "sfpb_config"
void main()
{
    // Vars
    object oPC = GetLastUsedBy();
    object oChest = OBJECT_SELF;
    string sID = SF_GetPlayerID(oPC);
    string sUserID = GetLocalString(oChest, "USER_ID");
    string sModName = GetName(GetModule());

    // End script if any of these conditions are met
    if (!GetIsPC(oPC) ||
         GetIsDM(oPC) ||
         GetIsDMPossessed(oPC) ||
         GetIsPossessedFamiliar(oPC)) return;

    // If the chest is already in use then this must be a thief
    if (sUserID != "" && sUserID != sID)
    {
        AssignCommand(oPC, ClearAllActions());
        SetCutsceneMode(oPC, TRUE);
        AssignCommand(oPC, ActionMoveAwayFromObject(oChest, TRUE, 50.0));
        FloatingTextStringOnCreature("Chest is allready in use", oPC);
        // SendMessageToAllDMs(GetName(oPC) + " is trying to steal from a bank " +
                                           //"chest that is already in use.");
        DelayCommand(5.0, SetCutsceneMode(oPC, FALSE));
    }
}

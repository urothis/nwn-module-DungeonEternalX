#include "nwnx_rename"
#include "nwnx_creature"
#include "&player_inc"

void logoutDead(object oPC) {
    string sOrigName = NWNX_Creature_GetOriginalName(oPC, TRUE)
    playerSet(oPC, "original_name",); // your persistent function
    NWNX_Creature_SetOriginalName(oPC, "<dead> " + sOrigName, TRUE);
}

void loginDead(object oPC) {
    NWNX_Creature_SetOriginalName(oPC, playerGetString(oPC, "original_name"), TRUE);
    NWNX_Rename_SetPCNameOverride(oPC, GetName(oPC, TRUE));
    NWNX_Rename_ClearPCNameOverride(oPC);
}
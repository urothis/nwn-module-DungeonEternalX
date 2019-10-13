#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oBackup =  CIGetCurrentModBackup(oPC);
    object oItem = CIGetCurrentModItem(oPC);

    int iResult = MK_GetIsModified(oItem, oBackup);

    return iResult;
}

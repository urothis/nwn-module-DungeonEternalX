//::///////////////////////////////////////////////
//:: FileName notanglestone
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/19/2003 9:40:17 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{
    object oPC=GetPCSpeaker();
    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(oPC, "teletangle1"))
        return FALSE;

    return TRUE;
}

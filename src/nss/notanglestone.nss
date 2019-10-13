//::///////////////////////////////////////////////
//:: FileName notanglestone
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/19/2003 9:40:17 PM
//:://////////////////////////////////////////////
#include "nw_i0_plot"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "teletangle1"))
        return TRUE;

    return FALSE;
}

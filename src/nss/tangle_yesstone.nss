#include "nw_i0_tool"

int StartingConditional()
{
    object oPC=GetPCSpeaker();
    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(oPC, "wp_tangle"))
        return FALSE;

    return TRUE;
}

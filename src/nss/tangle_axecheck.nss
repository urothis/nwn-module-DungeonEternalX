//::///////////////////////////////////////////////
//:: FileName axecheck
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/19/2003 2:11:39 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional() {
   // Make sure the PC speaker has these items in their inventory
   if(!HasItem(GetPCSpeaker(), "PickAxe")) return FALSE;
   return TRUE;
}

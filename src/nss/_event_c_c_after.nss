#include "nwnx_player"

/* TODO this part won't work until next patch.
void main(){
    object oPC = OBJECT_SELF;

    // if dm
    if (GetIsDM(oPC)) return;

    // gotta grab the player location and convert here.
    location lLoc = NWNXStringToLocation(util_DecodeLocation(playerGetValueString(oPC, "location")));

    object oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lLoc);
    string sCD = NWNX_Events_GetEventData(CDKEY),
           sBic = NWNX_Player_GetBicFileName(oPC);

    NWNX_Player_SetPersistentLocation(sCD,sBic,oWP);
}
*/

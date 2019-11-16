//::///////////////////////////////////////////////
//:: Secure Persistent Chest System v2.0
//:: spcs_beat
//:://////////////////////////////////////////////
/*
A simple heartbeat function that will fix the chest in the event that a player
attempts to "break" the chest by click-spamming or by cancelling the
ActionInteractObject command after setting the "in_use" variable
*/
//:://////////////////////////////////////////////
//:: Created By: Ophidios
//:: Created On: 8/8/2005
//:://////////////////////////////////////////////

void main()
{

// Recalls the last user of the chest.  If there isn't one (chest is resting),
// then it returns.
object oPC = GetLocalObject(OBJECT_SELF, "user");
if (oPC == OBJECT_INVALID)
    {
    return;
    }

// In the event that a user is set on the chest, but that user is no longer in
// the area (and therefore unable to interact with the chest) then it will reset
// the Local Integer and destroy the Invisible Object.
if (GetTag(GetArea(OBJECT_SELF)) != GetTag(GetArea(oPC)))
    {
    object oChest = GetLocalObject(OBJECT_SELF, "chest_use");
    SetLocalInt(oChest, "in_use", 0);
    DestroyObject(OBJECT_SELF, 0.0);
    return;
    }
}

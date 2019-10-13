//::///////////////////////////////////////////////
//:: Secure Persisten Chest System v2.0
//:: spcs_open
//:://////////////////////////////////////////////
/*
This is the default OnOpen script used by the SPCS
*/
//:://////////////////////////////////////////////
//:: Created By: Ophidios
//:: Created On: 8/8/2005
//:://////////////////////////////////////////////

void main()
{

string SPCS_WAYPOINT = "invisibleteller";  // Tag of a waypoint created at a location in the module to determine the spawn point of the NULL_HUMAN
string SPCS_DB = "SPCS_Storage_Arres";    // Name of the DB to be used to store items

// Defines the player object during OnUse and assigns the player a unique ID.
// The default ID for the player is PCPublicCDKey (the public string of their CD
// key).  This allows for all characters in use by that player to have access to
// the same storage, however the drawback to this is if that player signs into
// their GameSpy account from another computer (which uses a separate CD Key)
// then their storage will not be accessible.  Any valid string can be used as
// an identifier.  If the chest is tied to a specific area (such as a player
// house), then GetTag(GetArea(oPC)) would be perfectly valid as an identifier.
object oPC = GetLastUsedBy();
string PlayerID = GetPCPublicCDKey(oPC);

// Checks to ensure the chest is not in use by another player.  This is done by
// merely setting a local integer on the chest, and prevents other players from
// using it.  There is a possibility of a player cancelling their actions
// between setting this integer and the ActionInteractObject command executing.
// In the case this happens, the chest will become "locked" (much like a chest
// can become "stuck open" by default behavior).  See "spcs_beat" to see how
// this is worked around.
if (GetLocalInt(OBJECT_SELF, "in_use") == 1)
    {
    FloatingTextStringOnCreature("*Storage Chest is currently in use!*", oPC);
    return;
    }
SetLocalInt(OBJECT_SELF, "in_use", 1);

// Finds the waypoint used for spawn and recalls the NULL_HUMAN that is storing
// the chest contents.
object oSpawn = RetrieveCampaignObject(SPCS_DB, PlayerID, GetLocation(GetWaypointByTag(SPCS_WAYPOINT)));

// Creates an Invisible Object to which the player will interact with before all
// items are copied to the NULL_HUMAN and saved.  The Invisible Object is set on
// the chest as a Local Object to be recalled for later functions.  The PC is
// also tagged on the chest as it's user for heartbeat functions to prevent
// permanent locking of the chest.
object oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "spcs_chest_u", GetLocation(OBJECT_SELF));
SetLocalObject(oChest, "chest_use", OBJECT_SELF);
SetLocalObject(oChest, "user", oPC);
SetLocalString(oChest, "usercdkey", GetPCPublicCDKey(oPC));

// Grabs all objects from the NULL_HUMAN and puts them into the Invisible
// Object.  The NULL_HUMAN is then destroyed.
object oItem = GetFirstItemInInventory(oSpawn);
while (GetIsObjectValid(oItem))
    {
    CopyObject(oItem, GetLocation(oChest), oChest);
    DestroyObject(oItem, 0.0);
    oItem = GetNextItemInInventory(oSpawn);
    }
DestroyObject(oSpawn, 0.0);

// Forces the PC to interact with the inventory of the Invisible Object, which
// now contains the contents the NULL_HUMAN was carrying.
AssignCommand(oPC, ActionInteractObject(oChest));
}

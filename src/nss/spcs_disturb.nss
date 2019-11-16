//::///////////////////////////////////////////////
//:: Secure Persistent Chest System v2.0
//:: spcs_disturb
//:://////////////////////////////////////////////
/*
This is the OnDisturb event script for the SPCS.  It will fire anytime an object
is placed within the chest.  It also performs basic counting functions and can
be used to limit the size of the DB and the number of object that can be placed
into the chest by a player.
*/
//:://////////////////////////////////////////////
//:: Created By: Ophidios
//:: Created On: 8/8/2005
//:://////////////////////////////////////////////

void main()
{

int iCheck = 0; // Integer used to check the number of objects in the chest
int iMax = 50;  // Integer used to determine the maximum number of objects that can be placed into the chest

// Defines the player object and also determines the item being added to or
// taken from the chest.
object oPC = GetLastDisturbed();
object oItem = GetInventoryDisturbItem();

// If a player attempts to place gold into the container, it returns it.  There
// are issues with stack size of gold and storage onto creatures and it is best
// left this way.  Gold poses no encumbrance penalties, and it is senselessly
// unfair to deprive thieving PCs the opportunity to utilize their hard-earned
// skills by storing it all.
if (GetTag (oItem) == "NW_IT_GOLD001")
    {
    FloatingTextStringOnCreature("*Gold cannot be stored!*", oPC, FALSE);
    CopyItem(oItem, oPC);
    DestroyObject(oItem, 0.0);
    return;
    }

// A quick counting function.  It merely counts the number of objects for later
// checks and use.
object oCount = GetFirstItemInInventory();
while (GetIsObjectValid(oCount))
    {
    iCheck++;
    oCount = GetNextItemInInventory();
    }

// This will merely check the total number of items, and if it exceeds the iMax
// setting it will return the object back to the player.
if (iCheck > iMax)
    {
    ActionGiveItem(oItem, oPC);
    FloatingTextStringOnCreature("*You cannot exceed " + IntToString(iMax) + " items in storage!*", oPC);
    iCheck = iMax;
    }

// Returns to the player the number of objects stored in the chest currently.
// This will fire when an object is placed into or taken out of the chest.
string sCheck = IntToString(iCheck);
SendMessageToPC(oPC, "You have " + sCheck + " items stored.");
}

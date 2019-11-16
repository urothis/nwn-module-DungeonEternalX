//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_close
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//////////////////////////////////////////////////

#include "sfpb_config"
#include "_functions"
#include "gen_inc_color"
void main()
{
    // Vars
    object oPC = GetLastClosedBy();
    object oChest = OBJECT_SELF;
    location lLoc = GetLocation(oPC);
    string sModName = GetName(GetModule());
    string sUserID = GetLocalString(oChest, "USER_ID");
    int nCount;

    // Lock the chest
    SetLocked(oChest, TRUE);

    // First loop to check for containers
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        // Item count
        nCount++;

        if (GetHasInventory(oItem))
        {
            // Send a message to the player
            FloatingTextStringOnCreature("<cø>[ERROR] Containers/bags are NOT allowed to" +
                IntToString(MAX_ITEMS) + " be stored." +
                                         "\nPlease remove the container/bag.</c>", oPC);

            // Unlock chest and end script
            SetLocked(oChest, FALSE);
            return;
        }
        else if (nCount > MAX_ITEMS)
        {
            // Send a message to the player
            FloatingTextStringOnCreature("<cø>[ERROR] Only a maximum of " +
                IntToString(MAX_ITEMS) + " items are allowed to be stored." +
                                         "\nPlease remove the excess items.</c>", oPC);

            // Unlock chest and end script
            SetLocked(oChest, FALSE);
            return;
        }

        // Next item
        oItem = GetNextItemInInventory(oChest);
    }

    // Spawn in the NPC storer
    object oStorer = CreateObject(OBJECT_TYPE_CREATURE, "sfpb_storage", lLoc, FALSE, sUserID);

    // Loop through all items in the chest and copy them into
    // the NPC storers inventory and destroy the originals
    nCount = 0;
    oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        // This is to stop the duping bug, the dupe bug happened when a player
        // would exit the server while still holding a chest open, the reason for
        // the duping was the NPC storer would never spawn in this case thus not
        // having anywhere to store the items, which ended up the items storing
        // back into the chest duplicating itself, now if this happens, the players
        // items will not be saved thus avoiding any unwanted item duplicates.
        if (!GetIsObjectValid(oStorer))
        {
            // Delete the local CD Key
            DeleteLocalString(oChest, "USER_ID");
            // Send a message to the player
            FloatingTextStringOnCreature("<cø>[ERROR] Items can not be stored</c>", oPC);
            // Unlock Chest
            SetLocked(oChest, FALSE);
            return;
        }

        // Copy item to the storer
        CopyItem(oItem, oStorer, TRUE);
        // Destroy Original
        Insured_Destroy(oItem);
        nCount++;
        // Next item
        oItem = GetNextItemInInventory(oChest);
    }

    FloatingTextStringOnCreature("<cø>Please wait, storing items...</c>", oPC);
    // Save the NPC storer into the database
    if (StoreCampaignObject(sModName, DATABASE_ITEM + sUserID, oStorer)){
        DelayCommand(5.0, ActionFloatingTextStringOnCreature("<cø>You have " + IntToString(nCount) + " items stored.</c>", oPC));
        // Delete the local CD Key
        DeleteLocalString(oChest, "USER_ID");
    }
    else // Failed to store, copy all items back to chest
    {
        object oItem = GetFirstItemInInventory(oStorer);
        while (GetIsObjectValid(oItem))
        {
            // Copy the item into the chest
            CopyItem(oItem, oChest, TRUE);
            // Destroy the original
            Insured_Destroy(oItem);
            // Next item
            oItem = GetNextItemInInventory(oStorer);
        }
        DelayCommand(2.0, ActionFloatingTextStringOnCreature("<cø>[ERROR] Items are not stored</c>", oPC));
    }
    // Destroy NPC storer
    Insured_Destroy(oStorer);
    ExportSingleCharacter(oPC);
    // Unlock Chest
    DelayCommand(5.0, SetLocked(oChest, FALSE));
}

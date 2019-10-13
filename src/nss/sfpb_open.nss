//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_open
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//////////////////////////////////////////////////

#include "sfpb_config"
#include "_functions"

void main()
{
    // Vars
    object oPC = GetLastOpenedBy();
    object oChest = OBJECT_SELF;
    location lLoc = GetLocation(oPC);
    string sID = SF_GetPlayerID(oPC);
    string sUserID = GetLocalString(oChest, "USER_ID");
    string sModName = GetName(GetModule());

    // End script if any of these conditions are met
    if (!GetIsPC(oPC) ||
         GetIsDM(oPC) ||
         GetIsDMPossessed(oPC) ||
         GetIsPossessedFamiliar(oPC)) return;

    // If the chest is already in use then this must be a thief
    if (sUserID != "" && sUserID != sID) return;

    // Set the players ID as a local string onto the chest
    // for anti theft purposes
    SetLocalString(oChest, "USER_ID", sID);

    // Get the player's storer NPC from the database
    object oStorer = RetrieveCampaignObject(sModName, DATABASE_ITEM + sID, lLoc);
    DeleteCampaignVariable(sModName, DATABASE_ITEM + sID);

    // loop through the NPC storers inventory and copy the items
    // into the chest.
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

    // Destroy the NPC storer
    Insured_Destroy(oStorer);
}

//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_deposit
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//////////////////////////////////////////////////

#include "sfpb_config"
void main()
{
    // Vars
    object oPC = GetPCSpeaker(), oBanker = OBJECT_SELF;
    string sID = SF_GetPlayerID(oPC);
    string sAmount = GetLocalString(oBanker, "GOLD");
    int nAmount = StringToInt(sAmount);
    int nTotal;

    // Anti-Cheat Check For Duping Gold
    if (GetGold(oPC) >= nAmount)
    {
        // Take the deposited amount from the player and store
        // in the database
        TakeGoldFromCreature(nAmount, oPC, TRUE);
        int nBanked = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID);
        nTotal = nAmount + nBanked;
        SetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID, nTotal);
    }
    else // Set Anti-Cheat Variable
        SetLocalInt(oBanker, "ANTI_CHEAT", TRUE);

    // Set custom token
    SetCustomToken(1000, IntToString(nTotal));
}

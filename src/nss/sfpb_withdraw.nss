//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_withdraw
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//////////////////////////////////////////////////

#include "sfpb_config"
void main()
{
    // Vars
    object oPC = GetPCSpeaker();
    string sID = SF_GetPlayerID(oPC);
    int nWithdraw = StringToInt(GetLocalString(OBJECT_SELF, "GOLD"));
    int nBanked = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID);

    // Give the amount required tot he player and store in the database
    GiveGoldToCreature(oPC, nWithdraw);
    int nTotal = nBanked - nWithdraw;
    SetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID, nTotal);

    // Set custom token
    SetCustomToken(1000, IntToString(nTotal));
}

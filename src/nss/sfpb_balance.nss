//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_balance
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//////////////////////////////////////////////////

#include "sfpb_config"
void main()
{
    // Vars
    object oPC = GetLastSpeaker();
    string sID = SF_GetPlayerID(oPC);
    int nBanked = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID);

    // Set custom token for the account balance
    SetCustomToken(1000, IntToString(nBanked));
}

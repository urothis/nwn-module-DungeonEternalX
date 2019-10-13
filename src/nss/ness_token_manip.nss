//#include "aps_include"
#include "ness_pvp_db_inc"
#include "_functions"

/*
This script handles the execution of the PvP Tracker item. It takes
PvP Tokens and updates the database with the new amount.
*/


/*
//Abstraction for the overall execution of the PvP tracker item. Counts pvp tokens, deletes them,
//adds them to their DB count.
void useTokenBank(object oPC, object oItem);

//Counts the number of pvp token stacks in a person's inventory. Returns the number of stacks, not the actual count.
int CountPVPTokens(object oPC);

//Gets the number of token stacks from CountPVPTokens() and counts the stacks, deletes them, and updates the database.
void TakeTokens(int nTokens);

/////////////////////////////////////////////

void useTokenBank(object oPC, object oItem)
{
   string tag = GetTag(oItem);
   if (tag!="pvptracker")
   {
      return; // NOT Tracker ITEM
   }
   else
   {
       int count=CountPVPTokens(oPC);
       if (count)   TakeTokens(count);
       else
       {
           SendMessageToPC(oPC, "You did not have any tokens to deposit.");
       }
   }
   return;
}


int CountPVPTokens(object oPC)
{
    int nTokens = 0;
    object nItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(nItem))
    {
        SetIdentified(nItem, TRUE);
        if (GetTag(nItem)=="pvptokens")    nTokens++;
        nItem = GetNextItemInInventory(oPC);
    }
    return nTokens;
}


void TakeTokens(int nTokens)
{
    object oPC=GetItemActivator();
    int stack       = 0;
    int count       = CountPVPTokens(oPC);
    int finalCount  = 0;
    int dbCount     = StringToInt(dbTokenCount(oPC));

    string getKey = GetPCPublicCDKey(oPC);

    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem) && nTokens>0)
    {
        if (GetTag(oItem)=="pvptokens")
        {
            count=GetItemStackSize(oItem);
            nTokens--;
            finalCount += count;
            Insured_Destroy(oItem);
        }
        oItem = GetNextItemInInventory(oPC);
    }
    finalCount += dbCount;  // Adds inventory count and database count.

    //Update the DB
    dbUpdateTokenCount(oPC, finalCount);
}                                              */

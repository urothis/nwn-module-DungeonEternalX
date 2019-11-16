#include "db_inc"
#include "_functions"

//Records in the database the kill.
int pvp_killTrack(object oKiller, object oKilled);

// Clears the pvp table for module load.
int pvp_truncate();

//Grabs the matching CDKEYs for killer and killed and counts the number of kills. Returns the number in string form.
string checkKillCount(object oKiller, object oKilled);

//Pulls their number of PvP tokens based on cdkey. Returns SQL_ERROR, or 0, in a string on an error.
string dbTokenCount(object oPC, string sCdKey);

//Updates the row with the target's cdkey and the total pvp token count. If not found, it creates a new row.
void dbUpdateTokenCount(object oPC, float fTotal, string sCdKey);

//Deletes the pvp tokens from a player's inventory after counting them with pvp_CountTokens(object oPC).
//Then it updates the DB with dbUpdateTokenCount(object oPC, int nTotal).
void pvp_TakeTokens(string sCdKey);

//Counts the number of pvp tokens in a player's inventory.
//Returns the total number.
int pvp_CountTokens(object oPC);

//This function gathers information about an item/player and tracks/stores
//in the table pvp_itemtracker. The action must be specified in order to work.
//Usage: PVP store, tracking of the pvp weapons.
//Actions you must specify:
//purchase, aquire, delete, boss, login
//nCharacterOnly handles if the items is meant for one character.
void pvp_dbTrackItem(object oPC, object oItem, string sAction, int nCost = 0, int nCharacterOnly = 0);

//Accesses the last entry in table pvp_itemtracker and returns the last entry ID +1
//String example: 00011 or 02304
//Meant only for the ID system for pvp items and their tags.
string pvp_GenerateTagID();

//Executes a simple SQL query. Returns 1 if DB is down.
int pvp_checkDB();

/////////////////////////////////////////////////////

int pvp_killTrack(object oKiller, object oKilled)
{
    string sSQL;
    string killerCDKEY = GetPCPublicCDKey(oKiller);
    string killedCDKEY = GetPCPublicCDKey(oKilled);

    //finds the killer and victim's row, then fetches.
    sSQL= "SELECT * FROM pvp WHERE killer="+Quotes(killerCDKEY)+" AND victim="+Quotes(killedCDKEY)+"LIMIT 1";
    NWNX_SQL_ExecuteQuery(sSQL);
    ///////////////////     */
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        //updates kill count to ++ based on cd key
        sSQL= "UPDATE pvp SET killercount = killercount+1 WHERE killer="+Quotes(killerCDKEY)+" AND victim="+Quotes(killedCDKEY);
        NWNX_SQL_ExecuteQuery(sSQL);
    }
    else
    {   //if no record was found, create one
        sSQL="insert into pvp (killer, victim, killercount) values (" +Quotes(killerCDKEY)+ ", " +Quotes(killedCDKEY)+ ", 1)";
        NWNX_SQL_ExecuteQuery(sSQL);
    }
     return 0;
}

int pvp_truncate()
{
    string nSQL="TRUNCATE TABLE `pvp`";
    NWNX_SQL_ExecuteQuery(nSQL);
    return 0;
}

string checkKillCount(object oKiller, object oKilled)
{
    string nSQL= "SELECT * FROM pvp WHERE killer="+Quotes(GetPCPublicCDKey(oKiller))+" AND victim="+Quotes(GetPCPublicCDKey(oKilled))+ " LIMIT 1";
    NWNX_SQL_ExecuteQuery(nSQL);
    if (!NWNX_SQL_ReadyToReadNextRow())
        return "0";
    NWNX_SQL_ReadNextRow();
    return NWNX_SQL_ReadDataInActiveRow(3);
}

string dbTokenCount(object oPC, string sCdKey)
{
    string nSQL= "SELECT * FROM pvp_tokentracker WHERE cdkey="+Quotes(sCdKey)+" AND count>0 LIMIT 1";
    NWNX_SQL_ExecuteQuery(nSQL);
    if (!NWNX_SQL_ReadyToReadNextRow())
        return NWNX_SQL_GetLastError();

    NWNX_SQL_ReadNextRow();
    return NWNX_SQL_ReadDataInActiveRow(2);
}

void dbUpdateTokenCount(object oPC, float fTotal, string sCdKey)
{
    string sSQL="SELECT * FROM pvp_tokentracker WHERE cdkey="+ Quotes(sCdKey) +" LIMIT 1";
    NWNX_SQL_ExecuteQuery(sSQL);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        //SendMessageToPC(oPC, "You now have "+ IntToString(nTotal)+ " tokens in your account after deposit.");
        sSQL = "update pvp_tokentracker set count="+ FloatToString(fTotal) +" WHERE cdkey="+Quotes(sCdKey);
        NWNX_SQL_ExecuteQuery(sSQL);
    }
    else
    {
        sSQL="insert into pvp_tokentracker (cdkey, count) values (" +Quotes(sCdKey)+ ", " + FloatToString(fTotal)+")";
        NWNX_SQL_ExecuteQuery(sSQL);
    }
}

int pvp_CountTokens(object oPC)
{
    int nTokens = 0;
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        SetIdentified(oItem, TRUE);
        if (GetTag(oItem)=="pvptokens")
            nTokens+=GetItemStackSize(oItem);
        oItem = GetNextItemInInventory(oPC);
    }
    return nTokens;
}

void pvp_TakeTokens(string nTRUEID)
{
    if (pvp_checkDB()==1)   return;  //Stops if DB is down

    object oPC      = GetItemActivator();
    float count     = IntToFloat(pvp_CountTokens(oPC));
    float dbCount   = StringToFloat(dbTokenCount(oPC, nTRUEID));

    string getKey = GetPCPublicCDKey(oPC);

    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem)=="pvptokens")
        {
            Insured_Destroy(oItem);
        }
        oItem = GetNextItemInInventory(oPC);
    }
    count += dbCount;  // Adds inventory count and database count.

    //Update the DB
    dbUpdateTokenCount(oPC, count, nTRUEID);
}

void pvp_dbTrackItem(object oPC, object oItem, string sAction, int nCost = 0, int nCharacterOnly = 0)
{
    string sSQL;
    string comma = "', '";

    if (!pvp_checkDB())
    {
        SendMessageToPC(oPC, "The Database is down. Contact a DM ASAP to restore it.");
        return;
    }

  //string oPC
  //object oItem
  //string sAction
    int    nCost    = GetLocalInt(oItem, "PVP_ITEM_COST");
    int    nTRUEID  = dbGetTRUEID(oPC);
    string sTRUEID  = IntToString(nTRUEID);
    string sPlayer  = GetName(oPC);
    string sTag     = GetTag(oItem);
    string sTagID   = GetStringRight(GetTag(oItem), 5); //example pvp tag = pvp 00234
    string sIP      = GetPCIPAddress(oPC);

    if (sAction=="purchase" || sAction=="boss")
    {
        sSQL = "insert into pvp_itemtracker (trueid, character, actionused, item, cost, tag) values "+
           "('"+ sTRUEID+comma+GetName(oPC)+comma+sAction+comma+GetName(oItem)+comma+IntToString(nCost)+comma+sTag+"')";

        NWNX_SQL_ExecuteQuery(sSQL);

        if (nCharacterOnly==1)
            SetLocalInt(oItem, "CharacterOnly", 1);
    }
    else if (sAction == "aquire" || sAction == "login")
    {
        sSQL = "select * pvp_itemtracker where tag='"+sTag+"'";
        NWNX_SQL_ExecuteQuery(sSQL);

        string sReason;
        while (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sReason = NWNX_SQL_ReadDataInActiveRow(5);
            if (sTRUEID==NWNX_SQL_ReadDataInActiveRow(0))
            {
                if (nCharacterOnly == 1 && sPlayer == NWNX_SQL_ReadDataInActiveRow(2))
                {
                    SendMessageToPC(oPC, "Your "+GetName(oItem)+" has been validated.");
                    SetLocalInt(oItem, "CharacterOnly", 1);
                    return;
                }
                else if (nCharacterOnly == 1 && sPlayer != NWNX_SQL_ReadDataInActiveRow(3))
                    pvp_dbTrackItem(oPC, oItem, "delete");
            }
            else
                pvp_dbTrackItem(oPC, oItem, "delete");
        }
        if (!NWNX_SQL_ReadyToReadNextRow())
            pvp_dbTrackItem(oPC, oItem, "delete");
    }
    else if (sAction=="delete")
    {
        Insured_Destroy(oItem);
        sSQL = "insert into pvp_itemtracker (account, character, cdkey, ip, actionused, item, cost, tag) values "+
           "('"+ GetPCPlayerName(oPC)+comma+GetName(oPC)+comma+GetPCPublicCDKey(oPC)+
           comma+GetPCIPAddress(oPC)+comma+"deleted"+comma+GetName(oItem)+comma+
           IntToString(nCost)+comma+sTag+"')";
        NWNX_SQL_ExecuteQuery(sSQL);
        SendMessageToPC(oPC, "Your item, "+GetName(oItem)+", has been deleted, because it does not comply with the pvp item guidelines. If you feel this is an error, message a DM or DEV.");
    }
}

string pvp_GenerateTagID()
{
    string sSQL = "select last_insert_id() from pvp_itemtracker limit 1";
    NWNX_SQL_ExecuteQuery(sSQL);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        int nID  = StringToInt(NWNX_SQL_ReadDataInActiveRow(0)) + 1;
        int sLength = GetStringLength(IntToString(nID));
        string sTagID;
        switch (sLength)
        {
            case 1: sTagID = "0000" + IntToString(nID); break;
            case 2: sTagID = "000" + IntToString(nID);  break;
            case 3: sTagID = "00" + IntToString(nID);   break;
            case 4: sTagID = "0" + IntToString(nID);    break;
            case 5: sTagID = IntToString(nID);          break;
            default: return "ERROR";
        }
        return sTagID;
    }
    else
        return "Error";
}

int pvp_checkDB()
{
    string sSQL = "select * from account limit 1";
    NWNX_SQL_ExecuteQuery(sSQL);
    return NWNX_SQL_ReadyToReadNextRow();
}

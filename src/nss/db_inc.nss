#include "nwnx_sql"
#include "pc_inc"
#include "_functions"
#include "time_inc"
#include "nwnx_webhook"

////////////////////////////
/////// CONSTANTS //////////
////////////////////////////

const int TRUEID_NOT_FOUND = 0;
const int TRUEID_VALIDATED = 1;

const string TRUEIDNAME = "TRUEIDNAME";

const int BAN_TYPE_NONE = 0;
const int BAN_TYPE_TEMP = 1;
const int BAN_TYPE_PERM = 2;
const int BAN_TYPE_ERROR= 3;

const int LOGIN_TYPE_ACID   = 1;
const int LOGIN_TYPE_CKID   = 2;
const int LOGIN_TYPE_IPID   = 3;
const int LOGIN_TYPE_PLID   = 4;
const int LOGIN_TYPE_TRUEID = 5;
const int LOGIN_TYPE_DEXID  = 6;

const int LOGOUT_TYPE_BANNED = 1;
const int LOGOUT_TYPE_TRUEID = 2;

const int DB_BANKTRANS_XP = 1;
const int DB_BANKTRANS_GOLD = 2;
const string DB_BANK_GOLD       = "BANKGOLD";
const string DB_BANK_XP         = "BANKXP";

const string DB_FACTION_MEMBER      = "Member";
const string DB_FACTION_COMMANDER   = "Commander";
const string DB_FACTION_GENERAL     = "General";
const string DB_FACTION_LIEUTENANT  = "Lieutenant";
const string DB_FAID              = "FAID";
const string DB_FACTION_RANK      = "FACTION_RANK";
const string DB_FACTION_COMMANDER_CNT = "";

const int DB_PLAYERNAME_UNIQUE = FALSE; // PC NAME MUST BE UNIQUE
const int DB_PLAYERNAME_LENGTH = 40;    // PC MAX NAME LENGTH. 0 = ANY LENGTH
const int DB_TRACK_PVM_DETAILS = 0;     // SAVE ALL PLAYERVSMONSTER DETAILS TO DB?
const int PARTIAL_DONATE_XP_VALUE = 40;

////////////////////////////
/////// PROTOTYPES /////////
////////////////////////////


//Encloses a string in Single Quotes '...' to make life easier.
//Highly recommended to use with string data.
string dbQuotes(string sIn);

//Returns a string (for easier SQL queries) with commas.
//eg. s1,s2,s3...
string DelimList(string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="");

//Truncates the table sTable.
void dbTruncateTable(string sTable);

//Function designed to generate useful and detailed information for devs working on the module.
//All parameters are not required, besides the message being sent.
//All data should be pulled previously before sending an SQL query.
//sMessage should be a description and source of the error. eg. "Failed to auth TRUEID because of invalid object"
//sType can be any 30 character string, but should be defined for simplicity.
void dbLogMsg(string sMessage, string sType="error", int nTRUEID=0, int nDEXID=0, int nLIID=0, int nPLID=0, string sTable = "logmsg");

//Fetches the CKID from oPC's LocalInt. If the value is 0, aka not found,
//it searches the DB for oPC's CDKEY and creates a new entry if it is not found.
//returns CKID or 0 on error, and logs in the DB.
int dbGetCKID(object oPC);

//Fetches the IPID from oPC's LocalInt. If the value is 0, aka not found,
//it searches the DB for oPC's IP and creates a new entry if it is not found.
//returns IPID or 0 on error, and logs in the DB.
int dbGetIPID(object oPC);

//Fetches the PLID from oPC's LocalInt. If the value is 0, aka not found,
//it searches the DB for oPC's character name and creates a new entry if it is not found.
//returns PLID or 0 on error, and logs in the DB.
int dbGetPLID(object oPC);

//Fetches the ACID from oPC's LocalInt. If the value is 0, aka not found,
//it searches the DB for oPC's account name and creates a new entry if it is not found.
//returns ACID or 0 on error, and logs in the DB.
int dbGetACID(object oPC);

//Fetches oPC's current fame.
//returns 0 on db error
int dbGetCurrentFame(object oPC);

//Fetches oPC's spent fame.
//returns 0 on db error
int dbGetSpentFame(object oPC);

//Fetches the LIID (Login ID) from LocalInt "LIID" on oPC
//returns 0 on error
int dbGetLIID(object oPC);

//Fetches the TRUEID from LocalInt "TRUEID" on oPC
//returns 0 on error
int dbGetTRUEID(object oPC);

//Fetches the TRUEID from the ingame PC object.
//If object fails to provide a TRUEID from the LocalInt "TRUEID", it
//boots the PC, and logs the message
//in the logmsg table.
//TRUEID should be set on a PC at login. Due to the nature of this function,
//call this only once. Instead, use dbGetTRUEID(oPC).
int dbInitTRUEID(object oPC);

//Updates the login count by +1 with the cooresponding ID:
//LOGIN_TYPE_ACID
//LOGIN_TYPE_CKID
//LOGIN_TYPE_IPID
//LOGIN_TYPE_PLID
//LOGIN_TYPE_TRUEID
//LOGIN_TYPE_DEXID
void dbUpdateLogin(object oPC, int LOGIN_TYPE);

//Boots a PC by displaying a death screen with sMSG
//Sends a message to DM channel with sDMMsg
//Boots PC after fDelay seconds
int dbBootPC(object oPC, string sMsg, string sDMMsg, float fDelay=5.0f);

//Checks the DB for expired temporary bans and moves them to table
//temporarybanhistory if they are expired.
void dbCheckTempBan();

//Checks oPC if the are either perma-banned or temp-banned by TRUEID
//Boots and logs upon boot.
void dbCheckBan(object oPC);

//Bans a person's TRUEID permanently or temporarily
//nBanType options:
//  BAN_TYPE_TEMP
//  BAN_TYPE_PERM
//nBanLength = hours
void dbApplyBan(object oPC, int nBanType=BAN_TYPE_TEMP, int nBanLength = 1, string sReason = "");

//Fetches oPC's TRUEID account XP amount from the DB
//Returns -1 on error
int dbGetXP(object oPC);

//Adds nXP to oPC's TRUEID account
//Logs error and sends message to oPC
void dbSetXP(object oPC, int nXP, string sAction);

//Fetches oPC's TRUEID account XP amount from the DB
//Returns -1 on error
int dbGetGP(object oPC);

//Adds nXP to oPC's TRUEID account
//Logs error and sends message to oPC
void dbSetGP(object oPC, int nGP);

//Generates a detailed string of the oPC.
//Includes physical names and IDs
string dbPCtoString(object oPC);

//Fetches the donated XP from the oPC (local or db if TRUE)
int dbGetDonatedXP(object oPC, int nLoadNew = FALSE);

//Sets oPC's XP by adding the XP to the TRUEID
void dbSetDonatedXP(object oPC, int nIncXP);

//Returns TRUE or FALSE if the server crashed. Accuracy = ?? :o
int dbGetLastSessionCrashed();

//Get or create SEID on the module
int dbGetSEID(int nServer = 1);

//Sets the shoutban on player.
void dbSetShoutBanned(object oPC, int bEnabled = TRUE, int bPerm = FALSE);

//Fetches the LocalInt "SHOUTBAN"
int dbGetIsShoutBanned(object oPC);

//Checks db if oPC is temp. banned. TRUE/FALSE
int dbCheckPCforTempBan(object oPC);

//Updates the db with the player count of the current session.
void dbUpdateSessionCnt(int nVal);

//Formats an SQL segment or field to look something like this: field=5.
//Only for numerical values.
string dbSetField(string sFld, string sVal);

//Updates player stats in the db.
void dbUpdatePlayerStatus(object oPC, string sActive="1");
void dbSessionEnd();

//Updates the highestxp field in player with the highest xp.
void dbSaveHighestXP(object oPC, int nXP);

int dbCheckDatabase();

//Has something to do with the tokentracker table. Find out what this does.
string dbGetNextToken(object oDM, object oPC, string sMsg);

int dbGetBankXP(object oPC);

void dbSetBankXP(object oPC, int nXP);

int dbGetBankGold(object oPC);

void dbSetBankGold(object oPC, int nGold);

void dbBankTransaction(object oPC, int nAmount, int nTranType=DB_BANKTRANS_GOLD);

//Fetches the LocalInt "DEXID". This should be defined in the dbInitTRUEID function.
//Returns 0 if "DEXID" or "TRUEID" ints are 0.
int dbGetDEXID(object oPC);

//Fetches their TRUEID name from the db and stores a LocalString TRUEIDname. Uses that from there on.
string dbGetTRUEIDName(object oPC);

//Fetches a player's bind location.
void dbLoadBindLocation(object oPC);

//Replace special character ' with ~
string SQLEncodeSpecialChars(string sString);

//Replace special character ' with ~
string SQLDecodeSpecialChars(string sString);

// Encodes Special Chars and Encloses a string in Single Quotes. Used for MySQL queries.
string Quotes(string sIn);

// Return a string value when given a location
string APSLocationToString(location lLocation);

// Return a location value when given the string form of the location
location APSStringToLocation(string sLocation);

// Return a string value when given a vector
string APSVectorToString(vector vVector);

// Return a vector value when given the string form of the vector
vector APSStringToVector(string sVector);

// Set oObject's persistent string variable sVarName to sValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void dbSetPersistentString(object oObject, string sVarName, string sValue, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent integer variable sVarName to iValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void dbSetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent float variable sVarName to fValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void dbSetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent location variable sVarName to lLocation
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
//   This function converts location to a string for storage in the database.
void dbSetPersistentLocation(object oObject, string sVarName, location lLocation, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent vector variable sVarName to vVector
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
//   This function converts vector to a string for storage in the database.
void dbSetPersistentVector(object oObject, string sVarName, vector vVector, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent object with sVarName to sValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwobjdata)
void dbSetPersistentObject(object oObject, string sVarName, object oObject2, int iExpiration = 0, string sTable = "pwobjdata");

// Get oObject's persistent string variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: ""
string dbGetPersistentString(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent integer variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
int dbGetPersistentInt(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent float variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
float dbGetPersistentFloat(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent location variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
location dbGetPersistentLocation(object oObject, string sVarname, string sTable = "pwdata");

// Get oObject's persistent vector variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
vector dbGetPersistentVector(object oObject, string sVarName, string sTable = "pwdata");

// Get oObject's persistent object sVarName
// Optional parameters:
//   sTable: Name of the table where object is stored (default: pwobjdata)
// * Return value on error: 0
object dbGetPersistentObject(object oObject, string sVarName, object oOwner = OBJECT_INVALID, string sTable = "pwobjdata");

// Delete persistent variable sVarName stored on oObject
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
void dbDeletePersistentVariable(object oObject, string sVarName, string sTable = "pwdata");


////////////////////////////
/////// FUNCTIONS //////////
////////////////////////////

string dbQuotes(string sIn)
{
    return "'" + SQLEncodeSpecialChars(sIn) + "'";
    //return "'" + sIn + "'";
}

void dbTruncateTable(string sTable)
{
   NWNX_SQL_ExecuteQuery("TRUNCATE TABLE "+sTable);
}

string DelimList(string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="")
{
  if (s2=="") return s1; else s1 = s1 + "," + s2;   if (s3=="") return s1; else s1 = s1 + "," + s3;
  if (s4=="") return s1; else s1 = s1 + "," + s4;   if (s5=="") return s1; else s1 = s1 + "," + s5;
  if (s6=="") return s1; else s1 = s1 + "," + s6;   if (s7=="") return s1; else s1 = s1 + "," + s7;
  if (s8=="") return s1; else s1 = s1 + "," + s8;   if (s9=="") return s1; else s1 = s1 + "," + s9;
  return s1;
}

void dbLogMsg(string sMessage, string sType="error", int nTRUEID=0, int nDEXID=0, int nLIID=0, int nPLID=0, string sTable = "logmsg")
{
   NWNX_SQL_ExecuteQuery("insert into "+ sTable +" (msg,type,trueid,dexid,liid,plid) values ("+
       DelimList(dbQuotes(sMessage),dbQuotes(sType),IntToString(nTRUEID),IntToString(nDEXID),IntToString(nLIID),IntToString(nPLID))+")");
   //NWNX_WebHook_SendWebHookHTTPS(DISCORD_HOST_DBLOG, DISCORD_PATH_DBLOG, sType + ":  " + sMessage, DISCORD_HOST_DBLOG_NAME);
}

int dbGetCKID(object oPC)
{
   if (!GetIsObjectValid(oPC)) return 0;   //If the oPC was booted/left, returns

   int nCKID=GetLocalInt(oPC,"CKID");
   if (nCKID==0)   // NO VARIABLE YET, CREATE IT - PLAYER JUST LOGGED IN
   {
       string sSQL;
       string sCDKEY = GetPCPublicCDKey(oPC);

       //Search the DB for an existing player record.
       //If no record is found, it generates a new one.
       sSQL = "select ckid from cdkey where cdkey="+dbQuotes(sCDKEY);
       NWNX_SQL_ExecuteQuery(sSQL);
       if (NWNX_SQL_ReadyToReadNextRow())
       {
           NWNX_SQL_ReadNextRow();
           nCKID=StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
       }
       else
       {   //Add a new entry to db with cdkey name
           sSQL = "insert into cdkey (cdkey) values ("+dbQuotes(sCDKEY)+")";
           NWNX_SQL_ExecuteQuery(sSQL);
           //Grabs the generated index id
           sSQL = "select last_insert_id() from cdkey limit 1";
           NWNX_SQL_ExecuteQuery(sSQL);
           if (NWNX_SQL_ReadyToReadNextRow())
           {
               NWNX_SQL_ReadNextRow();
               nCKID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
           }
           else
           {   // OH NO - DB PROBLEM?
               dbBootPC(oPC, "A Database Error has occurred.", "dbGetCKID: Record Not Found");
               dbLogMsg("Unable to fetch ckid from DB", "dbGetCKID_error");
           }
       }
   SetLocalInt(oPC, "CKID", nCKID);    //assign the CKID to the oPC
   }
   return nCKID;
}

int dbGetIPID(object oPC)
{
   if (!GetIsObjectValid(oPC)) return 0;   //If the oPC was booted/left, returns

   int nIPID=GetLocalInt(oPC,"IPID");
   if (nIPID==0)   // NO VARIABLE YET, CREATE IT - PLAYER JUST LOGGED IN
   {
       string sSQL;
       string sIP = GetPCIPAddress(oPC);

       //Search the DB for an existing ip record.
       //If no record is found, it generates a new one.
       sSQL = "select ipid from ip where ip="+dbQuotes(sIP);
       NWNX_SQL_ExecuteQuery(sSQL);
       if (NWNX_SQL_ReadyToReadNextRow())
       {
           NWNX_SQL_ReadNextRow();
           nIPID=StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
       }
       else
       {   //Add a new entry to db with the ip
           sSQL =  "insert into ip (ip) values ("+dbQuotes(sIP)+")";
           NWNX_SQL_ExecuteQuery(sSQL);
           //Grabs the generated index id
           sSQL = "select last_insert_id() from ip limit 1";
           NWNX_SQL_ExecuteQuery(sSQL);
           if (NWNX_SQL_ReadyToReadNextRow())
           {
               NWNX_SQL_ReadNextRow();
               nIPID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
           }
           else
           {   // OH NO - DB PROBLEM?
               dbBootPC(oPC, "A Database Error has occurred.", "dbGetIPID: Record Not Found");
               dbLogMsg("Unable to fetch ipid from DB", "dbGetIPID_error");
           }
       }
   SetLocalInt(oPC, "IPID", nIPID);    //assign the IPID to the oPC
   }
   return nIPID;
}

int dbGetPLID(object oPC)
{
   if (!GetIsObjectValid(oPC)) return 0;   //If the oPC was booted/left, returns

   int nPLID = GetLocalInt(oPC,"PLID");
   if (nPLID == 0)   // NO VARIABLE YET, CREATE IT - PLAYER JUST LOGGED IN
   {
       string sSQL;
       string sPlayer = GetName(oPC, TRUE);

       //Search the DB for an existing player record.
       //If no record is found, it generates a new one.
       sSQL = "select plid from player where name="+dbQuotes(sPlayer);
       NWNX_SQL_ExecuteQuery(sSQL);
       if (NWNX_SQL_ReadyToReadNextRow())
       {
           NWNX_SQL_ReadNextRow();
           nPLID=StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
       }
       else
       {   //Add a new entry to db with the player name
           sSQL =  "insert into player (trueid,acid,name,dm) values ("+
                    DelimList(IntToString(dbGetTRUEID(oPC)),IntToString(dbGetACID(oPC)),dbQuotes(sPlayer),IntToString(GetIsDM(oPC)))+")";
           NWNX_SQL_ExecuteQuery(sSQL);
           //Grabs the generated index id
           sSQL = "select last_insert_id() from player limit 1";
           NWNX_SQL_ExecuteQuery(sSQL);
           if (NWNX_SQL_ReadyToReadNextRow())
           {
               NWNX_SQL_ReadNextRow();
               nPLID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
           }
           else
           {   // OH NO - DB PROBLEM?
               dbBootPC(oPC, "A Database Error has occurred.", "dbGetPLID: Record Not Found");
               dbLogMsg("Unable to fetch plid from DB", "dbGetPLID_error");
           }
       }
   SetLocalInt(oPC, "PLID", nPLID);    //assign the PLID to the oPC
   }
   return nPLID;
}

int dbGetACID(object oPC)
{
   if (!GetIsObjectValid(oPC)) return 0;   //If the oPC was booted/left, returns

   int nACID=GetLocalInt(oPC,"ACID");
   if (nACID==0)   // NO VARIABLE YET, CREATE IT - PLAYER JUST LOGGED IN
   {
       string sSQL;
       string sAccount = GetPCPlayerName(oPC);

       //Search the DB for an existing account record.
       //If no record is found, it generates a new one.
       sSQL = "select acid from account where name="+dbQuotes(sAccount);
       NWNX_SQL_ExecuteQuery(sSQL);
       if (NWNX_SQL_ReadyToReadNextRow())
       {
           NWNX_SQL_ReadNextRow();
           nACID=StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
       }
       else
       {   //Add a new entry to db with account name
           sSQL =  "insert into account (name) values ("+dbQuotes(sAccount)+")";
           NWNX_SQL_ExecuteQuery(sSQL);
           //Grabs the generated index id
           sSQL = "select last_insert_id() from account limit 1";
           NWNX_SQL_ExecuteQuery(sSQL);
           if (NWNX_SQL_ReadyToReadNextRow())
           {
               NWNX_SQL_ReadNextRow();
               nACID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
           }
           else
           {   // OH NO - DB PROBLEM?
               dbLogMsg("Unable to fetch acid from DB", "dbGetACID_error");
               dbBootPC(oPC, "A Database Error has occurred.", "dbGetACID: Record Not Found");
           }
       }
   SetLocalInt(oPC, "ACID", nACID);    //assign the ACID to the oPC
   }
   return nACID;
}

int dbGetCurrentFame(object oPC)
{
   NWNX_SQL_ExecuteQuery("select fame from trueid where trueid="+IntToString(dbGetTRUEID(oPC)));
   if (NWNX_SQL_ReadyToReadNextRow())
   {
       NWNX_SQL_ReadNextRow();
       return StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
   }
   else
   {
       dbLogMsg("Unable to fetch current fame from TRUEID","dbGetCurrentFame_error",dbGetTRUEID(oPC),dbGetDEXID(oPC),dbGetLIID(oPC),dbGetPLID(oPC));
       return 0;
   }
}

int dbGetSpentFame(object oPC)
{
   NWNX_SQL_ExecuteQuery("select famespent from trueid where trueid="+IntToString(dbGetTRUEID(oPC)));
   if (NWNX_SQL_ReadyToReadNextRow())
   {
       NWNX_SQL_ReadNextRow();
       return StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
   }
   else
   {
       dbLogMsg("Unable to fetch current fame from TRUEID", "dbGetSpentFame_error",dbGetTRUEID(oPC),dbGetDEXID(oPC),dbGetLIID(oPC),dbGetPLID(oPC));
       return 0;
   }
}

int dbGetLIID(object oPC)
{
   if (!GetIsObjectValid(oPC))     return 0;

   //Pulls the LoginID assigned on login
   int nLIID=GetLocalInt(oPC, "LIID");

   if (nLIID==0)   // NO VARIABLE YET, CREATE IT - PLAYER JUST LOGGED IN
   {
       //Formatted to strings for easy SQL queries.
       string sPLID    = IntToString(dbGetPLID(oPC));      // GET PLAYER TABLE ID
       string sTRUEID  = IntToString(dbGetTRUEID(oPC));    // GET TRUEID TABLE ID
       string sSEID    = IntToString(dbGetSEID());      // GET SESSION ID
       string sDEXID   = IntToString(dbGetDEXID(oPC));      // GET DEX ID
       string sGold    = IntToString(pcGetNetWorth(oPC));
       string sXP      = IntToString(GetXP(oPC));
       string sFame    = IntToString(dbGetCurrentFame(oPC));  //Gets their fame
       string sStatus  = (GetCurrentHitPoints(oPC)>0) ? "OK" : "DEAD";   //Defaults the status to dead or alive
       //If PC is a DM, set sStatus "DM", else if PC is banned, set to "BAN"
       sStatus = GetIsDM(oPC) ? "DM" : (GetLocalString(oPC, "BANNED")!="") ? "BAN" : sStatus;

       NWNX_SQL_ExecuteQuery("insert into login (seid,trueid,dexid,plid,statusin,goldin,xpin,famein) " +
               "values (" +    DelimList(sSEID,sTRUEID,sDEXID,sPLID,dbQuotes(sStatus),sGold,sXP,sFame)  + ")");

       //Grabs the generated login.liid (login index)
       NWNX_SQL_ExecuteQuery("select last_insert_id() from login limit 1");

       if (NWNX_SQL_ReadyToReadNextRow())
       {
           NWNX_SQL_ReadNextRow();
           nLIID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
           SetLocalInt(oPC, "LIID", nLIID);
       }
       else
       {   // OH NO - DB PROBLEM?
           dbBootPC(oPC, "A Database Error has occurred.", "dbGetLIID: Record Not Found");
           dbLogMsg("Unable to fetch liid from DB","dbGetLIID_error");
       }
   }
   return nLIID;
}

int dbGetTRUEID(object oPC)
{
    int nTRUEID = GetLocalInt(oPC,"TRUEID");

    if (!nTRUEID)
        return dbInitTRUEID(oPC);
    else return nTRUEID;
}

int dbInitTRUEID(object oPC)
{
    if (!GetIsObjectValid(oPC))     return 0;

    // TRUEID should be stored on every PC object
    int nTRUEID = GetLocalInt(oPC, "TRUEID");

    if (!nTRUEID)  //Search db and fetch/create a TRUEID
    {
        string sName    = GetName(oPC);
        string sCDKEY   = GetPCPublicCDKey(oPC);
        string sAccount = GetPCPlayerName(oPC);
        string sIP      = GetPCIPAddress(oPC);

        //Loads the oPC with accurate variables
        //all dbGet* functions will generate and verify correct data.
        int nACID = dbGetACID(oPC);     string sACID = IntToString(nACID);
        int nIPID = dbGetIPID(oPC);     string sIPID = IntToString(nIPID);
        int nCKID = dbGetCKID(oPC);     string sCKID = IntToString(nCKID);
        int nDEXID = 0;

        //SendMessageToPC(oPC, "ACID, CKID, IPID");
        //SendMessageToPC(oPC, DelimList(sACID,sCKID,sIPID));

        //Predefined SQL query to add entry to table trueid with their public CKDEY as their name.
        //Only way to identify people properly now.
        string sGenerateTRUEID = "insert into trueid (name) values("+dbQuotes(sAccount)+")";

        int nGenerateDEXID = FALSE;   //Because I cannot know the TRUEID until searching is finished, it will add dexid entry after.
        int nGenerateTRUEID = FALSE;
        int nLAN=FALSE;

        //Search for all 3 in the DB. If found, get it.
        //NWNX_SQL_ExecuteQuery("select trueid,dexid from dexid where acid="+sACID+" and ckid="+sCKID+" and ipid="+sIPID);

        //Search for combinations of CDKEY and IP. If found, fetch it.
        NWNX_SQL_ExecuteQuery("select trueid,dexid from dexid where ckid="+sCKID);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            nTRUEID=StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
            nDEXID=StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
        }
        else
        {   //Search for any of the credentials in the DB
            //Search for CDKEY only.

            //We need to record the ip under the DEXID table.
            nGenerateDEXID=TRUE;

            //If we don't find either CKID or ACID, then create a new TRUEID. They would be on LAN.
            NWNX_SQL_ExecuteQuery("select trueid from dexid where ckid="+sCKID+" LIMIT 1");
            if (!NWNX_SQL_ReadyToReadNextRow())
            {
                nGenerateTRUEID=TRUE;
            }

            /* OLD SHIT from 2015
            //Check IP for LAN - AKA multiple TRUEIDs
            NWNX_SQL_ExecuteQuery("select trueid from dexid where ipid="+sIPID);
            if (SQLFetch())
            {
                string sFirstTRUEID=NWNX_SQL_ReadDataInActiveRow(1);
                while (SQLNextRow())
                {
                    if (sFirstTRUEID!=NWNX_SQL_ReadDataInActiveRow(1))
                        nLAN=TRUE;
                }
            }


            //ACID+CKID. Default verification. Will add the LAN IP to the DEXID.
            NWNX_SQL_ExecuteQuery("select trueid from dexid where acid="+sACID+" and ckid="+sCKID+" LIMIT 1");
            if (SQLFetch())
            {
                nGenerateDEXID=TRUE;
                nTRUEID=StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
            }
            //ACID or CKID. We checked for all above. If we don't find either CKID or ACID, then create a new TRUEID. They would be on LAN.
            NWNX_SQL_ExecuteQuery("select trueid from dexid where acid="+sACID+" or ckid="+sCKID+" LIMIT 1");
            if (!SQLFetch())
            {
                nGenerateTRUEID=TRUE;
                nGenerateDEXID=TRUE;
            }
            if (!nLAN)
            {
                string sTempTRUEID="";
                //ACID+IPID+!LAN
                NWNX_SQL_ExecuteQuery("select trueid from dexid where acid="+sACID+" and ipid="+sIPID+" LIMIT 1");
                if (SQLFetch())
                {
                    sTempTRUEID=NWNX_SQL_ReadDataInActiveRow(1);
                    NWNX_SQL_ExecuteQuery("select trueid from dexid where ckid="+sCKID);
                    if (!SQLFetch())
                    {
                        nGenerateDEXID=TRUE;
                        nTRUEID=StringToInt(sTempTRUEID);
                    }
                }

                //CKID+IPID+!LAN
                NWNX_SQL_ExecuteQuery("select trueid from dexid where ckid="+sCKID+" and ipid="+sIPID+" LIMIT 1");
                if (SQLFetch())
                {
                    sTempTRUEID=NWNX_SQL_ReadDataInActiveRow(1);
                    NWNX_SQL_ExecuteQuery("select trueid from dexid where acid="+sACID);
                    if (!SQLFetch())
                    {
                        nGenerateDEXID=TRUE;
                        nTRUEID=StringToInt(sTempTRUEID);
                    }
                }
            }
            */

            if (nGenerateTRUEID)
            {
                NWNX_SQL_ExecuteQuery(sGenerateTRUEID);
                NWNX_SQL_ExecuteQuery("select last_insert_id() from trueid limit 1");
                if (NWNX_SQL_ReadyToReadNextRow())
                {
                    NWNX_SQL_ReadNextRow();
                    nTRUEID=StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
                }
            }
            if (nGenerateDEXID)
            {
                string sGenerateDEXID  = "insert into dexid (trueid,acid,ckid,ipid) values ("+DelimList(IntToString(nTRUEID),sACID,sCKID,sIPID)+")";
                NWNX_SQL_ExecuteQuery(sGenerateDEXID);
                NWNX_SQL_ExecuteQuery("select last_insert_id() from dexid limit 1");
                if (NWNX_SQL_ReadyToReadNextRow())
                {
                    NWNX_SQL_ReadNextRow();
                    nDEXID=StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
                }
            }
            if (!nTRUEID)
            {
                if (GetIsDM(oPC))
                {
                    SetCutsceneMode(oPC);
                    ActionFloatingTextStringOnCreature("DM TRUEID FAILED. GTFO or contact Ness. Enjoy Chapter 1.", oPC);
                    ActivatePortal(oPC,"jail.dungeonternalx.com:5123","","",TRUE); // jail server
                }
                else
                    dbBootPC(oPC,"TRUEID System Verification Failed. Contact Ness on Discord.  \n",sName+" || "+sCDKEY+" failed to validate TRUEID", 8.0f);
                return 0;
            }
        }
        if (nTRUEID) SetLocalInt(oPC, "TRUEID", nTRUEID);
        if (nDEXID)  SetLocalInt(oPC, "DEXID", nDEXID);
    }
    SetLocalInt(oPC, "TRUEID", nTRUEID);
    //SendMessageToPC(oPC,IntToString(GetLocalInt(oPC,"TRUEID"))+"   "+IntToString(GetLocalInt(oPC,"DEXID")));
    return nTRUEID;
}

void dbUpdateLogin(object oPC, int LOGIN_TYPE=0)
{
   if (!GetIsObjectValid(oPC)) return;

   string sSQL;
   switch (LOGIN_TYPE)
   {
       case LOGIN_TYPE_ACID:
       {
           sSQL="update account set lastlogin=CURRENT_TIMESTAMP, logins=logins+1 where acid="+IntToString(dbGetACID(oPC));
           break;
       }
       case LOGIN_TYPE_CKID:
       {
           sSQL="update cdkey set lastlogin=CURRENT_TIMESTAMP, logins=logins+1 where ckid="+IntToString(dbGetCKID(oPC));
           break;
       }
       case LOGIN_TYPE_IPID:
       {
           sSQL="update ip set lastlogin=CURRENT_TIMESTAMP, logins=logins+1 where ipid="+IntToString(dbGetIPID(oPC));
           break;
       }
       case LOGIN_TYPE_PLID:
       {
           sSQL="update player set lastlogin=CURRENT_TIMESTAMP, logins=logins+1 where plid="+IntToString(dbGetPLID(oPC));
           break;
       }
       case LOGIN_TYPE_TRUEID:
       {
           sSQL="update trueid set lastlogin=CURRENT_TIMESTAMP, logins=logins+1 where trueid="+IntToString(dbGetTRUEID(oPC));
           break;
       }
       case LOGIN_TYPE_DEXID:
{
           sSQL="update dexid set lastlogin=CURRENT_TIMESTAMP, logins=logins+1 where dexid="+IntToString(dbGetDEXID(oPC));
           break;
       }
       default: break;
   }
   if (sSQL!="")   NWNX_SQL_ExecuteQuery(sSQL);
}

void dbBootPC(object oPC, string sMsg, string sDMMsg, float fDelay=5.0f)
{
    if (!GetIsObjectValid(oPC)) return;
    PopUpDeathGUIPanel(oPC, FALSE, FALSE, 0, sMsg + " You will be booted in "+IntToString(FloatToInt(fDelay))+" seconds.");
    string sBoot = "Booted TRUEID/CDKey/Account/Player: " + DelimList("TRUEID:"+IntToString(dbGetTRUEID(oPC)),GetPCPublicCDKey(oPC), GetPCPlayerName(oPC), GetName(oPC), GetPCIPAddress(oPC));
    SendMessageToAllDMs("MESSAGE: " + sDMMsg + sBoot);
    //WriteTimestampedLogEntry("PLAYER BOOTED: " + sDMMsg + sBoot);
    DelayCommand(fDelay, BootPC(oPC));
}

void dbCheckTempBan()
{
    string sSQL,sTBID,sTRUEID,sExpires,sAdded,sReason;
    sSQL="select * from temporaryban where expires<=now()";
    NWNX_SQL_ExecuteQuery(sSQL);
    do
    {
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sTBID    = NWNX_SQL_ReadDataInActiveRow(0);
            //sTRUEID  = NWNX_SQL_ReadDataInActiveRow(1);
            //sExpires = NWNX_SQL_ReadDataInActiveRow(2);
            //sAdded   = NWNX_SQL_ReadDataInActiveRow(3);
            //sReason  = NWNX_SQL_ReadDataInActiveRow(4);
            //Moves found resultset to the history for tracking
            //NWNX_SQL_ExecuteQuery("insert into temporarybanhistory (trueid,created,expired,reason) values ("+trueid+","+added+","+expires+","+dbQuotes(reason)+")");
            NWNX_SQL_ExecuteQuery("delete from temporaryban where tbid="+sTBID);
        }
    } while (NWNX_SQL_ReadyToReadNextRow());

    //Check Temp Shoutbans(values of 1 in the DB)
    sSQL="select trueid,shoutban from trueid where shoutban=1";
    NWNX_SQL_ExecuteQuery(sSQL);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        do
        {
            NWNX_SQL_ReadNextRow();
            NWNX_SQL_ExecuteQuery("update trueid set shoutban=0 where trueid="+NWNX_SQL_ReadDataInActiveRow(0));
        }   while (NWNX_SQL_ReadyToReadNextRow());
    }
}

void dbCheckBan(object oPC)
{
    int TRUEID = dbGetTRUEID(oPC);
    string sSQL;

    //Check Temp Shoutbans(values of 1 in the DB)
    sSQL="select shoutban from trueid where trueid="+IntToString(dbGetTRUEID(oPC));
    NWNX_SQL_ExecuteQuery(sSQL);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        if (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)))
        {
            SetLocalInt(oPC,"SHOUTBAN",TRUE);
        }
    }

    //Check Perma
    sSQL="select ban from trueid where trueid="+IntToString(TRUEID);
    NWNX_SQL_ExecuteQuery(sSQL);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        if (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)))
        {
            SetLocalInt(oPC,"BANNED",TRUE);
            SetLocalInt(oPC,"LOGOUT",LOGOUT_TYPE_BANNED);
            dbBootPC(oPC,"You are perma-banned. Contact Ness if you feel this was a mistake.","Perma-banned player joining:"+dbPCtoString(oPC), 10.0f);
        }
    }
    //Check Temp
    sSQL="select expires, added, reason from temporaryban where trueid="+IntToString(TRUEID);
    NWNX_SQL_ExecuteQuery(sSQL);
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        SetLocalInt(oPC,"BANNED",TRUE);
        SetLocalInt(oPC,"LOGOUT",LOGOUT_TYPE_BANNED);
        dbBootPC(oPC,"You are temp-banned. Contact Ness if you feel this was a mistake.","Temp-banned player joining. Expires "+NWNX_SQL_ReadDataInActiveRow(0)+dbPCtoString(oPC), 10.0f);
    }
}

void dbApplyBan(object oPC, int nBanType=BAN_TYPE_TEMP, int nBanLength = 1, string sReason = "")
{
   int nTRUEID = dbGetTRUEID(oPC); // GET TRUEID LINK TABLE ID
   string sSQL="";
   string sTime;
   switch (nBanType)
   {
       case BAN_TYPE_TEMP:       //adds ban to temporaryban table
       {
           SetLocalInt(oPC,"LOGOUT",LOGOUT_TYPE_BANNED);
           sTime = HoursToDays(nBanLength); //Converts n hours to string "x days and y hours"
           sSQL = "insert into temporaryban (trueid,expires,reason) values ("+IntToString(dbGetTRUEID(oPC))+"DATE_ADD(NOW(), INTERVAL " + IntToString(nBanLength) + " HOUR),"+dbQuotes(sReason)+")";
           dbBootPC(oPC, "You have been temporarily banned for " + sTime + ", during which time you can reflect upon your actions.", "Banned! Temp Ban applied to expire on" + sTime, 10.0f);
           break;
       }
       case BAN_TYPE_PERM:       //changes trueid.ban to 1
       {
           SetLocalInt(oPC,"LOGOUT",LOGOUT_TYPE_BANNED);
           sSQL = "update trueid set ban=1 where trueid=" + IntToString(nTRUEID);
           dbBootPC(oPC, "Your TRUEID has been permanently banned from the module. All future attempts to log in will be denied.", "Perma-Banned! CDkey Ban delivered.", 10.0f);
           break;
       }
   }
   if (sSQL!="")   NWNX_SQL_ExecuteQuery(sSQL);
}

int dbGetXP(object oPC)
{
   NWNX_SQL_ExecuteQuery("select xp from trueid where trueid="+IntToString(dbGetTRUEID(oPC)));
   if (NWNX_SQL_ReadyToReadNextRow())
   {
       NWNX_SQL_ReadNextRow();
       return StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
   }
   else
       return -1;
}

void dbSetXP(object oPC, int nXP, string sAction)
{
  NWNX_SQL_ExecuteQuery("update trueid set xp="+IntToString(nXP)+" where trueid="+IntToString(dbGetTRUEID(oPC)));
  dbLogMsg("Set XP ("+IntToString(nXP)+") on TRUEID", sAction ,dbGetTRUEID(oPC),dbGetDEXID(oPC),dbGetLIID(oPC),dbGetPLID(oPC));
}

int dbGetGP(object oPC)
{
   NWNX_SQL_ExecuteQuery("select gp from trueid where trueid="+IntToString(dbGetTRUEID(oPC)));
   if (NWNX_SQL_ReadyToReadNextRow())
   {
       NWNX_SQL_ReadNextRow();
       return StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
   }
   else
       return 0;
}

void dbSetGP(object oPC, int nGP)
{
  int GP=dbGetGP(oPC);
  NWNX_SQL_ExecuteQuery("update trueid set gp="+IntToString(GP+nGP)+" where trueid="+IntToString(dbGetTRUEID(oPC)));
  dbLogMsg("Set GP to "+IntToString(GP+nGP)+" from "+IntToString(GP),"GP_TRUEID",dbGetTRUEID(oPC),dbGetDEXID(oPC),dbGetLIID(oPC),dbGetPLID(oPC));
}

string dbPCtoString(object oPC)
{
   string sName=GetName(oPC);
   string sCDKEY=GetPCPublicCDKey(oPC);
   string sAccount=GetPCPlayerName(oPC);
   string sIP=GetPCIPAddress(oPC);

   int nLIID = dbGetLIID(oPC);
   int nPLID = dbGetPLID(oPC);
   int nACID = dbGetACID(oPC);
   int nIPID = dbGetIPID(oPC);
   int nCKID = dbGetCKID(oPC);
   int nTRUEID=dbGetTRUEID(oPC);
   string sTRUEID="";

   if (nTRUEID>0)
   {
       NWNX_SQL_ExecuteQuery("select name from trueid where trueid="+IntToString(nTRUEID));
       if (NWNX_SQL_ReadyToReadNextRow())
       {
           NWNX_SQL_ReadNextRow();
           sTRUEID=NWNX_SQL_ReadDataInActiveRow(0);
       }
   }

   string msg =    "\nPlayer Name: "+sName+"    PLID: "+IntToString(nPLID)+
                   "\nTRUEID Name: "+sTRUEID+"   TRUEID: "+IntToString(nTRUEID)+
                   "\nAccount: "+sAccount+" ACID: "+IntToString(nACID)+
                   "\nCDKEY: "+sCDKEY+" CKID: "+IntToString(nCKID);
                   if (GetIsDM(oPC))
                       msg+= "\nIP: "+sIP+" IPID: "+IntToString(nIPID);
                   msg+= "\nLogin ID: "+IntToString(nLIID);
   return msg;
}

int dbGetDonatedXP(object oPC, int nLoadNew = FALSE)
{
    int nXP;

    if (!nLoadNew)
    {
        nXP = GetLocalInt(oPC, "DONATED_XP");
        if (nXP < 0) return 0;
    }

    if (!nXP || nLoadNew)// load new
    {
        NWNX_SQL_ExecuteQuery("select donatedxp from trueid where trueid=" + IntToString(dbGetTRUEID(oPC)));
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            nXP = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        }
        if (nXP < 1) SetLocalInt(oPC, "DONATED_XP", -1);
        else SetLocalInt(oPC, "DONATED_XP", nXP);
    }
    return nXP;
}

void dbSetDonatedXP(object oPC, int nIncXP)
{
    NWNX_SQL_ExecuteQuery("update trueid set donatedxp=donatedxp+" + IntToString(nIncXP) + " where trueid=" + IntToString(dbGetTRUEID(oPC)));
    SendMessageToPC(oPC, "Adjusting total donated XP: " + IntToString(nIncXP));
    DeleteLocalInt(oPC, "DONATED_XP");
}

int dbGetLastSessionCrashed()
{
    int nSEID = dbGetSEID()-1;
    object oModule = GetModule();
    int nCrashed = GetLocalInt(oModule, "LAST_SESSION_CRASHED");
    if (!nCrashed)
    {
        string sSQL = "select year(se_ended) from session where se_seid = " + IntToString(nSEID);
        NWNX_SQL_ExecuteQuery(sSQL);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            if (NWNX_SQL_ReadDataInActiveRow(0) == "0") nCrashed = 1;
            else nCrashed = -1;
        }
        SetLocalInt(oModule, "LAST_SESSION_CRASHED", nCrashed);
    }
    else if (nCrashed == 1) return TRUE;
    return FALSE;
}

int dbGetSEID(int nServer = 1)
{
   int sSEID = GetLocalInt(GetModule(), "SEID");
   if (!sSEID) { // NO VARIABLE YET, CREATE IT
      string sSQL;
      sSQL = "insert into session (se_added, se_module) values (now(), "+ dbQuotes(GetModuleName()+" " + IntToString(nServer)) + ")";
      NWNX_SQL_ExecuteQuery(sSQL);
      sSQL = "select last_insert_id() from session limit 1";
      NWNX_SQL_ExecuteQuery(sSQL);
      if (NWNX_SQL_ReadyToReadNextRow())
      {
         NWNX_SQL_ReadNextRow();
         sSEID = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
         SetLocalInt(GetModule(), "SEID", sSEID);
      }
      else
      {
         WriteTimestampedLogEntry("No database! Session variable not fetched.");
         return 0;
      }
      // SET UP SOME SESSION VARIABLES
      SetLocalInt(GetModule(), "SDB_PC_CNT", 0);
      SetLocalInt(GetModule(), "SDB_PC_MAX", 0);
   }
   return sSEID;
}

void dbSetShoutBanned(object oPC, int bEnabled = TRUE, int bPerm = FALSE)
{
   int bMode = bEnabled;
   if (bPerm)   bMode=2;
   string sSQL = "update trueid set shoutban=" + IntToString(bMode) + " where trueid=" + IntToString(dbGetTRUEID(oPC));
   NWNX_SQL_ExecuteQuery(sSQL);
   SetLocalInt(oPC, "SHOUTBAN", bMode);
}

int dbGetIsShoutBanned(object oPC)
{
    if (!GetLocalInt(oPC, "SHOUTBAN"))
    {
        NWNX_SQL_ExecuteQuery("select shoutban from trueid where trueid="+IntToString(dbGetTRUEID(oPC)));
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            if (StringToInt(NWNX_SQL_ReadDataInActiveRow(0)))
            {
                SetLocalInt(oPC, "SHOUTBAN", StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
                return TRUE;
            }
        }
        return FALSE;
    }
    return FALSE;
}

int dbCheckPCforTempBan(object oPC)
{
   string sTRUEID = IntToString(dbGetTRUEID(oPC)); // GET TRUEID TABLE ID
   NWNX_SQL_ExecuteQuery("select expires from temporaryban where trueid="+sTRUEID);
   if (NWNX_SQL_ReadyToReadNextRow())
   {
      NWNX_SQL_ReadNextRow();
      string sDateTime = NWNX_SQL_ReadDataInActiveRow(0);
      SetLocalString(oPC, "BANNED", sDateTime);
      return TRUE;
   }
   return FALSE;
}

void dbUpdateSessionCnt(int nVal)
{
    string sSEID = IntToString(dbGetSEID());
    int nPCCnt = IncLocalInt(GetModule(), "PC_CNT", nVal);
    int nPCMax = GetMax(nPCCnt, GetLocalInt(GetModule(), "PC_MAX"));
    SetLocalInt(GetModule(), "PC_MAX", nPCCnt);
    string sSQL = "update session set " +
            DelimList(dbSetField("se_pccnt", IntToString(nPCCnt)),
                      dbSetField("se_pcmax", IntToString(nPCMax))) +
                    " where se_seid = " + sSEID;
    NWNX_SQL_ExecuteQuery(sSQL);
}

string dbSetField(string sFld, string sVal)
{
   return sFld + "=" + sVal;
}

void dbUpdatePlayerStatus(object oPC, string sActive="1")
{ // CALL THIS AS OFTEN AS NEEDED
   string sPLID = IntToString(dbGetPLID(oPC)); // GET PLAYER TABLE ID
   string sSQL;
   string sDamage = IntToString(!GetIsDead(oPC) ? GetMaxHitPoints(oPC) - GetCurrentHitPoints(oPC) : GetMaxHitPoints(oPC)+ 420);
   int nTick = GetTick();
   int nTime = nTick - GetLocalInt(oPC, "TIME");
   string sTime = "time+" + IntToString(nTime); // GAME HOURS SINCE LAST SAVE
   IncLocalInt(oPC, "TIME_ON_CHAR", nTime);
   SetLocalInt(oPC, "TIME", nTick);
   //string sPos = APSLocationToString(GetLocation(oPC));
   string sNewKills = "kills+" + IntToString(GetLocalInt(oPC, "KILLS_NEW"));
   SetLocalInt(oPC, "KILLS_NEW", 0);
   string sDeaths = IntToString(GetLocalInt(oPC, "DEATHS"));
   if (sActive!="0") sActive = IntToString(GetLocalInt(GetModule(), "SERVER"));
   //if (GetModuleName()!="deX-port1") sActive="2";
   sSQL = "update player set " +
             DelimList(dbSetField("active", sActive),
                       dbSetField("damage", sDamage),
                       dbSetField("time", sTime),
                       dbSetField("kills", sNewKills),
                       dbSetField("deaths", sDeaths)) +
                        " WHERE plid = " + sPLID;
   NWNX_SQL_ExecuteQuery(sSQL);
}

void dbSessionEnd()
{
    string sSEID = IntToString(dbGetSEID());
    string sSQL = "update session set se_ended = now() where se_seid = " + sSEID;
    NWNX_SQL_ExecuteQuery(sSQL);
}

void dbSaveHighestXP(object oPC, int nXP)
{
    int nCurrentHighest = GetLocalInt(oPC, "HIGHEST_XP");
    if (nCurrentHighest < nXP)
    {
        SetLocalInt(oPC, "HIGHEST_XP", nXP);
        NWNX_SQL_ExecuteQuery("update player set highxp= " + IntToString(nXP) + " where plid=" + IntToString(dbGetPLID(oPC)));
    }
}

int dbCheckDatabase()
{
   NWNX_SQL_ExecuteQuery("select count(*) from session");
   if (NWNX_SQL_ReadyToReadNextRow())
   {
      NWNX_SQL_ReadNextRow();
      int nCnt = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
      if (nCnt) return TRUE;
   }
   return FALSE;
}

string dbGetNextToken(object oDM, object oPC, string sMsg)
{
   string sToken;
   string sSQL = "insert into tokentracker (tt_dmplid, tt_seid, tt_plid, tt_msg) values ("+ DelimList(IntToString(dbGetPLID(oDM)), IntToString(dbGetSEID()), IntToString(dbGetPLID(oPC)), dbQuotes(sMsg)) + ")";
   NWNX_SQL_ExecuteQuery(sSQL);
   sSQL = "select last_insert_id() from tokentracker limit 1";
   NWNX_SQL_ExecuteQuery(sSQL);
   if (NWNX_SQL_ReadyToReadNextRow())
   {
      NWNX_SQL_ReadNextRow();
      sToken = NWNX_SQL_ReadDataInActiveRow(1);
      WriteTimestampedLogEntry("Kewpie #" + sToken + " " + sMsg);
   }
   else
   {
      WriteTimestampedLogEntry("No database! Token not fetched.");
      return "Invalid";
   }
   return sToken;
}

int dbGetBankXP(object oPC)
{
   return GetLocalInt(oPC, DB_BANK_XP);
}

void dbSetBankXP(object oPC, int nXP)
{
   dbBankTransaction(oPC, nXP, DB_BANKTRANS_XP);
   SetLocalInt(oPC, DB_BANK_XP, nXP);
   string sSQL = "update trueid set xp=" + IntToString(nXP) + " where trueid = " + IntToString(dbGetTRUEID(oPC));
   NWNX_SQL_ExecuteQuery(sSQL);
}

int dbGetBankGold(object oPC)
{
   return GetLocalInt(oPC, DB_BANK_GOLD);
}

void dbSetBankGold(object oPC, int nGold)
{
   dbBankTransaction(oPC, nGold, DB_BANKTRANS_GOLD);
   SetLocalInt(oPC, DB_BANK_GOLD, nGold);
   string sSQL = "update trueid set gp=" + IntToString(nGold) + " where trueid = " + IntToString(dbGetTRUEID(oPC));
   NWNX_SQL_ExecuteQuery(sSQL);
}

void dbBankTransaction(object oPC, int nAmount, int nTranType=DB_BANKTRANS_GOLD)
{
   int nGold = -1;
   int nXP = -1;
   if (nTranType==DB_BANKTRANS_GOLD)
   {
      nGold = nAmount;
      nXP = dbGetBankXP(oPC); // NOT PASSED, NO CHANGE, KEEP SAME
   }
   else
   {
      nXP = nAmount;
      nGold = dbGetBankGold(oPC); // NOT PASSED, NO CHANGE, KEEP SAME
   }
   string sLIID = IntToString(dbGetLIID(oPC));   // GET LOG ID
   string sTRUEID=IntToString(dbGetTRUEID(oPC)); // GET ACCOUNT TABLE ID
   string sGold = IntToString(nGold);
   string sXP   = IntToString(nXP);
   string sSQL = "insert into banktransactions (bt_bankxpold, bt_bankgoldold, bt_liid, bt_bankgoldnew, bt_bankxpnew) " +
      "select xp, gp, " + DelimList(sLIID, sGold, sXP) + " from trueid where trueid=" + sTRUEID;
   NWNX_SQL_ExecuteQuery(sSQL);
}

int dbGetDEXID(object oPC)
{
   if (!GetIsObjectValid(oPC)) return 0;   //If the oPC was booted/left, returns

   int nDEXID=GetLocalInt(oPC,"DEXID");
   if (!nDEXID || !dbGetTRUEID(oPC))   return 0;

   return nDEXID;
}

string dbGetTRUEIDName(object oPC)
{
    if (GetLocalString(oPC,"TRUEIDNAME")!="") return  GetLocalString(oPC,TRUEIDNAME);
    else
    {
        NWNX_SQL_ExecuteQuery("select name from trueid where trueid="+IntToString(dbGetTRUEID(oPC)));
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            SetLocalString(oPC,TRUEIDNAME,NWNX_SQL_ReadDataInActiveRow(0));
            return GetLocalString(oPC,"TRUEIDNAME");
        }
        else
        {
            dbBootPC(oPC, "Could not fetch your TRUEID Name. Contact Ness", "Player kicked for not having a TRUEID name. Usually meanys the DB is down.");
            return "Error";
        }
    }
}

void dbLoadBindLocation(object oPC)
{
    NWNX_SQL_ExecuteQuery("select bind from player where plid="+IntToString(dbGetPLID(oPC)));
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        SetLocalString(oPC, "BIND", NWNX_SQL_ReadDataInActiveRow(0));
    }
}

// Problems can arise with SQL commands if variables or values have single quotes
// in their names. These functions are a replace these quote with the tilde character
string SQLEncodeSpecialChars(string sString)
{
    if (FindSubString(sString, "'") == -1)      // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "'")
            sReturn += "~";
        else
            sReturn += sChar;
    }
    return sReturn;
}

string SQLDecodeSpecialChars(string sString)
{
    if (FindSubString(sString, "~") == -1)      // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "~")
            sReturn += "'";
        else
            sReturn += sChar;
    }
    return sReturn;
}


string Quotes(string sIn)
{
   return "'" + SQLEncodeSpecialChars(sIn) + "'";
}

// These functions deal with various data types. Ultimately, all information
// must be stored in the database as strings, and converted back to the proper
// form when retrieved.
string APSVectorToString(vector vVector)
{
    return "#POSITION_X#" + FloatToString(vVector.x) + "#POSITION_Y#" + FloatToString(vVector.y) +
        "#POSITION_Z#" + FloatToString(vVector.z) + "#END#";
}

vector APSStringToVector(string sVector)
{
    float fX, fY, fZ;
    int iPos, iCount;
    int iLen = GetStringLength(sVector);

    if (iLen > 0)
    {
        iPos = FindSubString(sVector, "#POSITION_X#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#POSITION_Y#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#POSITION_Z#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sVector, iPos, iCount));
    }

    return Vector(fX, fY, fZ);
}

string APSLocationToString(location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    vector vPosition = GetPositionFromLocation(lLocation);
    float fOrientation = GetFacingFromLocation(lLocation);
    string sReturnValue;

    if (GetIsObjectValid(oArea))
        sReturnValue =
            "#AREA#" + GetTag(oArea) + "#POSITION_X#" + FloatToString(vPosition.x) +
            "#POSITION_Y#" + FloatToString(vPosition.y) + "#POSITION_Z#" +
            FloatToString(vPosition.z) + "#ORIENTATION#" + FloatToString(fOrientation) + "#END#";

    return sReturnValue;
}

location APSStringToLocation(string sLocation)
{
    location lReturnValue;
    object oArea;
    vector vPosition;
    float fOrientation, fX, fY, fZ;

    int iPos, iCount;
    int iLen = GetStringLength(sLocation);

    if (iLen > 0)
    {
        iPos = FindSubString(sLocation, "#AREA#") + 6;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        oArea = GetObjectByTag(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_X#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_Y#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_Z#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sLocation, iPos, iCount));

        vPosition = Vector(fX, fY, fZ);

        iPos = FindSubString(sLocation, "#ORIENTATION#") + 13;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fOrientation = StringToFloat(GetSubString(sLocation, iPos, iCount));

        lReturnValue = Location(oArea, vPosition, fOrientation);
    }

    return lReturnValue;
}

// These functions are responsible for transporting the various data types back
// and forth to the database.

void dbSetPersistentString(object oObject, string sVarName, string sValue, int iExpiration =
                         0, string sTable = "pwdata")
{
    string sPlayer;
    string sTag;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);
    sValue = SQLEncodeSpecialChars(sValue);

    string sSQL = "SELECT player FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    NWNX_SQL_ExecuteQuery(sSQL);

    if (NWNX_SQL_ReadyToReadNextRow())
    {
        sSQL = "UPDATE " + sTable + " SET val='" + sValue +
            "',expire=" + IntToString(iExpiration) + " WHERE player='" + sPlayer +
            "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    }
    else
    {
        // row doesn't exist
        sSQL = "INSERT INTO " + sTable + " (player,tag,name,val,expire) VALUES" +
            "('" + sPlayer + "','" + sTag + "','" + sVarName + "','" +
            sValue + "'," + IntToString(iExpiration) + ")";
    }
    NWNX_SQL_ExecuteQuery(sSQL);
}

string dbGetPersistentString(object oObject, string sVarName, string sTable = "pwdata")
{
    string sPlayer;
    string sTag;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    NWNX_SQL_ExecuteQuery(sSQL);

if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        return SQLDecodeSpecialChars(NWNX_SQL_ReadDataInActiveRow(0));
    }
    else
    {
        return "";
        // If you want to convert your existing persistent data to APS, this
        // would be the place to do it. The requested variable was not found
        // in the database, you should
        // 1) query it's value using your existing persistence functions
        // 2) save the value to the database using SetPersistentString()
        // 3) return the string value here.
    }
}

void dbSetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration =
                      0, string sTable = "pwdata")
{
    dbSetPersistentString(oObject, sVarName, IntToString(iValue), iExpiration, sTable);
}

int dbGetPersistentInt(object oObject, string sVarName, string sTable = "pwdata")
{
    string sPlayer;
    string sTag;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    NWNX_SQL_ExecuteQuery(sSQL);

    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        return StringToInt(NWNX_SQL_ReadDataInActiveRow());
    }
    else
        return 0;
}

void dbSetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration =
                        0, string sTable = "pwdata")
{
    dbSetPersistentString(oObject, sVarName, FloatToString(fValue), iExpiration, sTable);
}



void dbSetPersistentLocation(object oObject, string sVarName, location lLocation, int iExpiration =
                           0, string sTable = "pwdata")
{
    dbSetPersistentString(oObject, sVarName, APSLocationToString(lLocation), iExpiration, sTable);
}

location dbGetPersistentLocation(object oObject, string sVarName, string sTable = "pwdata")
{
    return APSStringToLocation(dbGetPersistentString(oObject, sVarName, sTable));
}

void dbSetPersistentVector(object oObject, string sVarName, vector vVector, int iExpiration =
                         0, string sTable = "pwdata")
{
    dbSetPersistentString(oObject, sVarName, APSVectorToString(vVector), iExpiration, sTable);
}

vector dbGetPersistentVector(object oObject, string sVarName, string sTable = "pwdata")
{
    return APSStringToVector(dbGetPersistentString(oObject, sVarName, sTable));
}

void dbDeletePersistentVariable(object oObject, string sVarName, string sTable = "pwdata")
{
    string sPlayer;
    string sTag;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        sTag = SQLEncodeSpecialChars(GetName(oObject));
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);
    string sSQL = "DELETE FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    NWNX_SQL_ExecuteQuery(sSQL);
}


//void main(){}

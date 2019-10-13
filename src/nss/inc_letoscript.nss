const string DB_NAME = "prcnwnxleto";
const string DB_GATEWAY_VAR = "prcnwnxleto";

//set this to true if using build 18 or earlier of letoscript.dll
//again this is a PRC switch


/*YOU MUST ADD THE FOLLOWING TO YOUR ON CLIENT EXIT EVENT

    object oPC = GetExitingObject();
    LetoPCExit(oPC);

*/

/*YOU MUST ADD THE FOLLOWING TO YOUR ON CLIENT ENTER EVENT

    object oPC = GetExitingObject();
    LetoPCEnter(oPC);

*/


///* local copies for easy redistribution out of the PRC

//these are the names of local variables, normally ints, to set on the module

//set this if using any letoscript
const string PRC_USE_LETOSCRIPT                      = "PRC_USE_LETOSCRIPT";

 //* Set this to 1 if using build 18
const string PRC_LETOSCRIPT_PHEONIX_SYNTAX           = "PRC_LETOSCRIPT_PHEONIX_SYNTAX";

 //* Letoscript needs a string named PRC_LETOSCRIPT_NWN_DIR set to the
 //* directory of NWN. If it doesnt work, try different slash options: // \\ / \
const string PRC_LETOSCRIPT_NWN_DIR                  = "PRC_LETOSCRIPT_NWN_DIR";

 //* Switch so that Unicorn will use the SQL database for SCO/RCO
 //* Must have the zeoslib.dlls installed for this
 //*
 //* UNTESTED!!!
const string PRC_LETOSCRIPT_UNICORN_SQL              = "PRC_LETOSCRIPT_UNICORN_SQL";

 //* This is a string, not integer.
 //* If the IP is set, Letoscript will use ActivatePortal instead of booting.
 //* The IP and Password must be correct for your server or bad things will happen.
 //* - If your IP is non-static make sure this is kept up to date.
 //*
 //* See the Lexicon entry on ActivatePortal for more information.
 //*
 //* @see PRC_LETOSCRIPT_PORTAL_PASSWORD
const string PRC_LETOSCRIPT_PORTAL_IP                = "PRC_LETOSCRIPT_PORTAL_IP";

 //* This is a string, not integer.
 //* If the IP is set, Letoscript will use ActivatePortal instead of booting.
 //* The IP and Password must be correct for your server or bad things will happen.
 //* - If your IP is non-static make sure this is kept up to date.
 //*
 //* See the Lexicon entry on ActivatePortal for more information.
 //*
 //* @see PRC_LETOSCRIPT_PORTAL_IP
const string PRC_LETOSCRIPT_PORTAL_PASSWORD          = "PRC_LETOSCRIPT_PORTAL_PASSWORD";

 //* If set you must be using Unicorn.
 //* Will use getnewest bic instead of filename reconstruction (which fails if
 //* multiple characters have the same name)
const string PRC_LETOSCRIPT_GETNEWESTBIC             = "PRC_LETOSCRIPT_GETNEWESTBIC";

// * Set this if you are using SQLite (the built-in database in NWNX-ODBC2).
// * This will use transactions and SQLite specific syntax.
const string PRC_DB_SQLLITE                          = "PRC_DB_SQLLITE";

const int PRC_SQL_ERROR = 0;
const int PRC_SQL_SUCCESS = 1;
// Function defintions
int GetPRCSwitch(string sSwitch);
void PRC_SQLExecDirect(string sSQL);

void PRC_SQLInit()
{
    int i;

    // Placeholder for ODBC persistence
    string sMemory;

    for (i = 0; i < 8; i++)     // reserve 8*128 bytes
        sMemory +=
            "................................................................................................................................";

    SetLocalString(GetModule(), "NWNX!ODBC!SPACER", sMemory);
}

void PRC_SQLExecDirect(string sSQL)
{
//PrintString(sSQL);
    SetLocalString(GetModule(), "NWNX!ODBC!EXEC", sSQL);
}

int PRC_SQLFetch()
{
    string sRow;
    object oModule = GetModule();

    SetLocalString(oModule, "NWNX!ODBC!FETCH", GetLocalString(oModule, "NWNX!ODBC!SPACER"));
    sRow = GetLocalString(oModule, "NWNX!ODBC!FETCH");
    if (GetStringLength(sRow) > 0)
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", sRow);
        return PRC_SQL_SUCCESS;
    }
    else
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", "");
        return PRC_SQL_ERROR;
    }
}

string PRC_SQLGetTick()
{
    string sTick;
    if(GetPRCSwitch(PRC_DB_SQLLITE))
        sTick = "";
    else
        sTick = "`";
    return sTick;
}

string PRC_SQLGetData(int iCol)
{
    int iPos;
    string sResultSet = GetLocalString(GetModule(), "NWNX_ODBC_CurrentRow");

    // find column in current row
    int iCount = 0;
    string sColValue = "";

    iPos = FindSubString(sResultSet, "¬");
    if ((iPos == -1) && (iCol == 1))
    {
        // only one column, return value immediately
        sColValue = sResultSet;
    }
    else if (iPos == -1)
    {
        // only one column but requested column > 1
        sColValue = "";
    }
    else
    {
        // loop through columns until found
        while (iCount != iCol)
        {
            iCount++;
            if (iCount == iCol)
                sColValue = GetStringLeft(sResultSet, iPos);
            else
            {
                sResultSet = GetStringRight(sResultSet, GetStringLength(sResultSet) - iPos - 1);
                iPos = FindSubString(sResultSet, "¬");
            }

            // special case: last column in row
            if (iPos == -1)
                iPos = GetStringLength(sResultSet);
        }
    }

    return sColValue;
}


string ReplaceSingleChars(string sString, string sTarget, string sReplace)
{
    if (FindSubString(sString, sTarget) == -1) // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == sTarget)
            sReturn += sReplace;
        else
            sReturn += sChar;
    }
    return sReturn;
}

int GetPRCSwitch(string sSwitch)
{
    return GetLocalInt(GetModule(), sSwitch);
}

void DoDebug(string sString, object oAdditionalRecipient = OBJECT_INVALID)
{
   return;
    SendMessageToPC(GetFirstPC(), sString);
    if(oAdditionalRecipient != OBJECT_INVALID)
        SendMessageToPC(oAdditionalRecipient, sString);
    WriteTimestampedLogEntry(sString);
}

//*/

//instanty runs the letoscript sScript
//for sType see abive
//if sType is POLL, PollThread is atomatically started
//and sPollScript is passed as the script name
string LetoScript(string sScript, string sType = "SCRIPT", string sPollScript = "");

//This command adds the script to the cuttent superscript
//to run the superscript use StackedLetoScripRun
void StackedLetoScript(string sScript);

//poll an existing thread
//when the thread is finished, script sScript is run
void PollThread(string sThreadID, string sScript);

//credit to demux
//gets a bicpath of a pc
//must be servervault to work
string GetBicPath(object oPC);

//credit to demux
//gets the filename of a PCs bic
//must be servervault
string GetBicFileName(object oPC);

//This will automatically add the required code before and after, and will
//adapt based on PC/NPC/etc.
//This overwites the existing object which will break stored references
//such as henchmen. The new object is returned.
//the result of the script is stored on the module in LetoResult for 1 second
//if nDestroyOriginal is set then PCs will be booted and non-pcs will be destroyed
object RunStackedLetoScriptOnObject(object oObject, string sLetoTag = "OBJECT",    string sType = "SCRIPT", string sPollScript = "", int nDestroyOriginal = TRUE);

//const int DEBUG = TRUE;

string GetNWNDir()
{
    string sReturn = GetLocalString(GetModule(), PRC_LETOSCRIPT_NWN_DIR);
    /*
    if(GetStringRight(sReturn, 1) != "\"
        && GetStringRight(sReturn, 1) != "/")
        sReturn += "\";
        //" this is here so textpad doesnt go screwy becasue it escapes the quotes above.
        */
    return sReturn;
}

//credit to demux
string GetBicFileName(object oPC)
{
    string sChar, sBicName;
    string sPCName = GetStringLowerCase(GetName(oPC));
    int i, iNameLength = GetStringLength(sPCName);

    for(i=0; i < iNameLength; i++) {
        sChar = GetSubString(sPCName, i, 1);
        if (TestStringAgainstPattern("(*a|*n|*w|'|-|_)", sChar)) {
            if (sChar != " ") sBicName += sChar;
        }
    }
    return GetStringLeft(sBicName, 16);
}

//credit to demux
string GetBicPath(object oPC)
{
    // Gets a local var stored on oPC on "event client enter". I do this because
    // "on even client leave", function GetPCPlayerName() can not be used. Since
    // a .bic file can not be changed while the owner is logged in, it is typical
    // to execute leto scripts when the client leaves (on event client leave).
    string PlayerName = GetLocalString(oPC, "PlayerName");
    if(PlayerName == "")
        PlayerName = GetPCPlayerName(oPC);

    // Retruns the full path to a .bic file.
    return GetNWNDir()+"servervault/"+PlayerName+"/"+GetBicFileName(oPC)+".bic";
}

void VoidLetoScript(string sScript, string sType = "SCRIPT", string sPollScript = "")
{
    LetoScript(sScript,sType,sPollScript);
}

string LetoScript(string sScript, string sType = "SCRIPT", string sPollScript = "")
{
    string sAnswer;
    DoDebug(sType+" >: "+sScript);
    SetLocalString(GetModule(), "NWNX!LETO!"+sType, sScript);
    sAnswer = GetLocalString(GetModule(), "NWNX!LETO!"+sType);
    DoDebug(sType+" <: "+sAnswer);
    if(sType == "SPAWN")
        DelayCommand(1.0, PollThread(sAnswer, sPollScript));
    return sAnswer;
}

void LetoPCEnter(object oPC)
{
    SetLocalString(oPC, "Leto_Path", GetBicPath(oPC));
    SetLocalString(oPC, "PCPlayerName", GetPCPlayerName(oPC));
    DeleteLocalString(oPC, "LetoScript");
}

void LetoPCExit(object oPC)
{
    string sScript = GetLocalString(oPC, "LetoScript");
    if(sScript != "")
    {
        string sPath = GetLocalString(oPC, "Leto_Path");
        if(sPath == "")
            DoDebug("Path is Null");
        if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        {
            //pheonix syntax
            sScript  = "<file:open CHAR <qq:"+sPath+">>"+sScript;
            sScript += "<file:save CHAR <qq:"+sPath+">>";
            sScript += "<file:close CHAR >";
        }
        else
        {
            if(GetPRCSwitch(PRC_LETOSCRIPT_GETNEWESTBIC))
            {
                sScript  = "%char =  FindNewestBic('"+GetNWNDir()+"servervault/"+GetLocalString(oPC, "PCPlayerName")+"'); "+sScript;
                sScript += "%char = '>'; ";
                sScript += "close %char; ";
            }
            else
            {
                //unicorn syntax
                sScript  = "%char= '"+sPath+"'; "+sScript;
                sScript += "%char = '>'; ";
                sScript += "close %char; ";
            }
        }
        string sScriptResult = LetoScript(sScript);
        SetLocalString(GetModule(), "LetoResult", sScriptResult);
        AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResult")));
    }
}

void StackedLetoScript(string sScript)
{
    DoDebug("SLS :"+sScript);
    SetLocalString(GetModule(), "LetoScript", GetLocalString(GetModule(), "LetoScript")+ sScript);
}

void PollThread(string sThreadID, string sScript)
{
    if(GetLocalInt(GetModule(), "StopThread"+sThreadID) == TRUE)
        return;
    DoDebug("Polling: "+sThreadID);
    //add blank space to capture error messages
    string sResult = LetoScript(sThreadID+"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   "
        +"                                   ", "POLL");
    if(sResult == "Error: "+sThreadID+" not done.")
    {
        DelayCommand(1.0, PollThread(sThreadID, sScript));
        return;
    }
    else
    {
        DoDebug("Poll: Executing: "+sScript);
        SetLocalInt(GetModule(), "StopThread"+sThreadID, TRUE);
        DelayCommand(6.0, DeleteLocalInt(GetModule(), "StopThread"+sThreadID));
        location lLoc = GetLocalLocation(GetModule(), "Thread"+sThreadID+"_loc");
        DelayCommand(1.0, DeleteLocalLocation(GetModule(), "Thread"+sThreadID+"_loc"));
DoDebug("Thread"+sThreadID+"_loc");
DoDebug(GetName(GetAreaFromLocation(lLoc)));
        object oReturn;
        if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        {
            oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLoc);
        }
        else
        {
            if(GetPRCSwitch(PRC_LETOSCRIPT_UNICORN_SQL))
            {
                string sSQL = "SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1";
                SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
                oReturn = RetrieveCampaignObject("NWNX", "-", lLoc);
            }
            else
            {
                oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLoc);
            }
        }
DoDebug(GetName(oReturn));
        SetLocalString(GetModule(), "LetoResult", sResult);
        AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResult")));
        SetLocalObject(GetModule(), "LetoResultObject", oReturn);
        AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalObject(GetModule(), "LetoResultObject")));
        SetLocalString(GetModule(), "LetoResultThread", sThreadID);
        AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResultThread")));
        ExecuteScript(sScript, OBJECT_SELF);
    }
}

void VoidRunStackedLetoScriptOnObject(object oObject, string sLetoTag = "OBJECT",
    string sType = "SCRIPT", string sPollScript = "", int nDestroyOriginal = TRUE)
{
    RunStackedLetoScriptOnObject(oObject,sLetoTag,sType,sPollScript,nDestroyOriginal);
}

object RunStackedLetoScriptOnObject(object oObject, string sLetoTag = "OBJECT",
    string sType = "SCRIPT", string sPollScript = "", int nDestroyOriginal = TRUE)
{
    if(!GetIsObjectValid(oObject))
    {
        WriteTimestampedLogEntry("ERROR: "+GetName(oObject)+"is invalid");
        WriteTimestampedLogEntry("Script was "+GetLocalString(GetModule(), "LetoScript"));
        return OBJECT_INVALID;
    }
    string sCommand;
    object oReturn;
    location lLoc;
    object oWPLimbo = GetObjectByTag("LETO_SPAWN_POINT");
    location lLimbo;
    if(GetIsObjectValid(oWPLimbo))
        lLimbo = GetLocation(oWPLimbo);
    else
        lLimbo = GetStartingLocation();

lLimbo = GetStartingLocation();

    string sScript = GetLocalString(GetModule(), "LetoScript");
    DeleteLocalString(GetModule(), "LetoScript");
    string sScriptResult;
    //check if its a DM or PC
    //these use bic files
    if(GetIsPC(oObject) || GetIsDM(oObject))
    {
        if(!nDestroyOriginal)//dont boot
        {
            string sPath = GetLocalString(oObject, "Leto_Path");
            if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
            {
                sCommand = "<file:open '"+sLetoTag+"' <qq:"+sPath+">>";
                sScript = sCommand+sScript;
                sCommand = "<file:close '"+sLetoTag+"'>";
                sScript = sScript+sCommand;
                //unicorn
            }
            else
            {
                if(GetPRCSwitch(PRC_LETOSCRIPT_GETNEWESTBIC))
                {
                    sScript  = "%"+sLetoTag+" =  FindNewestBic('"+GetNWNDir()+"servervault/"+GetLocalString(oObject, "PCPlayerName")+"'); ";
                }
                else
                {
                    //unicorn syntax
                    sCommand = "%"+sLetoTag+" = '"+sPath+"'; "; //qq{} doesnt work for me at the moment, wrong slashes
                }
                sScript = sCommand+sScript;
                sCommand = "close %"+sLetoTag+"; ";
                sScript = sScript+sCommand;



            }
            sScriptResult = LetoScript(sScript, sType, sPollScript);
        }
        else//boot
        {
            //this triggers the OnExit code to fire the letoscript
            SetLocalString(oObject, "LetoScript", GetLocalString(oObject, "LetoScript")+sScript);
            if(GetLocalString(GetModule(), PRC_LETOSCRIPT_PORTAL_IP) == "")
            {
                BootPC(oObject);
            }
            else
            {
                ActivatePortal(oObject,
                    GetLocalString(GetModule(), PRC_LETOSCRIPT_PORTAL_IP),
                    GetLocalString(GetModule(), PRC_LETOSCRIPT_PORTAL_PASSWORD),
                    "", //waypoint, may need to change
                    TRUE);
            }
            return oReturn;
        }
    }
    //its an NPC/Placeable/Item, go through DB
    else if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE
        || GetObjectType(oObject) == OBJECT_TYPE_ITEM
        || GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE
        || GetObjectType(oObject) == OBJECT_TYPE_STORE
        || GetObjectType(oObject) == OBJECT_TYPE_WAYPOINT)
    {
        if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        {
            //Put object into DB
            StoreCampaignObject(DB_NAME, DB_GATEWAY_VAR, oObject);
            // Reaquire DB with new object in it
            sCommand += "<file:open FPT <qq:" + GetNWNDir() + "database/" + DB_NAME + ".fpt>>";
            //Extract object from DB
            sCommand += "<fpt:extract FPT '"+DB_GATEWAY_VAR+"' "+sLetoTag+">";
            sCommand += "<file:close FPT>";
            sCommand += "<file:use "+sLetoTag+">";
        }
        else
        {
            if(GetPRCSwitch(PRC_LETOSCRIPT_UNICORN_SQL))
            {
                //unicorn
                //Put object into DB
                string sSQL = "SELECT "+DB_GATEWAY_VAR+" FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1";
                PRC_SQLExecDirect(sSQL);

                if (PRC_SQLFetch() == PRC_SQL_SUCCESS)
                {
                    // row exists
                    sSQL = "UPDATE "+DB_NAME+" SET val=%s WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR;
                    SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
                }
                else
                {
                    // row doesn't exist
                    // assume table doesnt exist too
                    sSQL = "CREATE TABLE "+DB_NAME+" ( "+DB_GATEWAY_VAR+" TEXT, blob BLOB )";
                    PRC_SQLExecDirect(sSQL);
                    sSQL = "INSERT INTO "+DB_NAME+" ("+DB_GATEWAY_VAR+", blob) VALUES" +
                        "("+DB_GATEWAY_VAR+", %s)";
                    SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
                }
                StoreCampaignObject ("NWNX", "-", oObject);
                // Reaquire DB with new object in it
                //force data to be written to disk
                sSQL = "COMMIT";
                PRC_SQLExecDirect(sSQL);
                sCommand += "sql.connect 'root', '' or die $!; ";
                sCommand += "sql.query 'SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1'; ";
                sCommand += "sql.retrieve %"+sLetoTag+"; ";
            }
            else
            {
                //Put object into DB
                StoreCampaignObject(DB_NAME, DB_GATEWAY_VAR, oObject);
                sCommand += "%"+sLetoTag+"; ";
                //Extract object from DB
                sCommand += "extract '"+GetNWNDir()+"database/"+DB_NAME+".fpt', '"+DB_GATEWAY_VAR+"', %"+sLetoTag+" or die $!;";
            }
        }
        //store their location
        lLoc = GetLocation(oObject);
        if(!GetIsObjectValid(GetAreaFromLocation(lLoc))) lLoc = GetStartingLocation();

        object oPossessor = GetItemPossessor(oObject);

        sScript = sCommand + sScript;
        sCommand = "";

        //destroy the original
        if(nDestroyOriginal)
        {
            AssignCommand(oObject, SetIsDestroyable(TRUE));
            DestroyObject(oObject);
        //its an NPC/Placeable/Item, go through DB
            if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
            {
                sCommand  = "<file:open FPT <qq:" + GetNWNDir() + "database/" + DB_NAME + ".fpt>>";
                sCommand += "<fpt:replace FPT '" +DB_GATEWAY_VAR+ "' "+sLetoTag+">";
                sCommand += "<file:save FPT>";
                sCommand += "<file:close FPT>";
                sCommand += "<file:close "+sLetoTag+">";
            }
            else
            {
                if(GetPRCSwitch(PRC_LETOSCRIPT_UNICORN_SQL))
                {
                    //unicorn
                    sCommand += "sql.query 'SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1'; ";
                    sCommand += "sql.store %"+sLetoTag+"; ";
                    sCommand += "close %"+sLetoTag+"; ";
                }
                else
                {
                    sCommand += "inject '"+GetNWNDir()+"database/"+DB_NAME+".fpt', '"+DB_GATEWAY_VAR+"', %"+sLetoTag+" or die $!;";
                    sCommand += "close %"+sLetoTag+"; ";
                }
            }
        }
        else
        {
            if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
                sCommand += "<file:close "+sLetoTag+">";
            else
                sCommand += "close %"+sLetoTag+"; ";
        }

        sScript = sScript + sCommand;
        sScriptResult = LetoScript(sScript, sType, sPollScript);

        if(nDestroyOriginal && sType != "SPAWN")
        {
            if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
            {
                if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
                {
                    oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLimbo);
                    AssignCommand(oReturn, JumpToLocation(lLoc));
                }
                else
                    oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLoc);
            }
            else
            {
                if(GetPRCSwitch(PRC_LETOSCRIPT_UNICORN_SQL))
                {
                    string sSQL = "SELECT blob FROM "+DB_NAME+" WHERE "+DB_GATEWAY_VAR+"="+DB_GATEWAY_VAR+" LIMIT 1";
                    SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
                    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
                    {
                        oReturn = RetrieveCampaignObject("NWNX", "-", lLimbo);
                        AssignCommand(oReturn, JumpToLocation(lLoc));
                    }
                    else
                        oReturn = RetrieveCampaignObject("NWNX", "-", lLoc);
                }
                else
                {
                    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
                    {
                        oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLimbo);
                        AssignCommand(oReturn, JumpToLocation(lLoc));
                    }
                    else {
                       oReturn = RetrieveCampaignObject(DB_NAME, DB_GATEWAY_VAR, lLoc, oPossessor);
                    }
                }
            }
        }
        else if(nDestroyOriginal && sType == "SPAWN")
        {
            SetLocalLocation(GetModule(), "Thread"+IntToString(StringToInt(sScriptResult))+"_loc", lLoc);
DoDebug("Thread"+IntToString(StringToInt(sScriptResult))+"_loc");
        }
    }
    SetLocalString(GetModule(), "LetoResult", sScriptResult);
    AssignCommand(GetModule(), DelayCommand(1.0, DeleteLocalString(GetModule(), "LetoResult")));

    return oReturn;
}


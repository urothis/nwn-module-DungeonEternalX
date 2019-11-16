//::///////////////////////////////////////////////
//:: tk_ptool_inc
//:://////////////////////////////////////////////
/*
    Constants for the implementation of the player
    tool framework.
*/
//:://////////////////////////////////////////////
//:: Created By: The Krit
//:: Created On: 2008-10-06
//:://////////////////////////////////////////////


// -----------------------------------------------------------------------------
// CONSTANTS

// The .2da to consult.
const string PTOOL_CONFIG_FILE = "tk_playertools";

// Local variables holding script names. (Append the tool number.)
const string PTOOL_SCRIPT = "TK_PLAYERTOOL_SCRIPT_";


// -----------------------------------------------------------------------------
// PROTOTYPES

// Handles the player tool implementation.
void DoPlayerTool(int nTool);


// -----------------------------------------------------------------------------
// FUNCTIONS

// Handles the player tool implementation.
void DoPlayerTool(int nTool)
{
    /*
    // Check for an overridden script.
    string sScript = GetLocalString(OBJECT_SELF, PTOOL_SCRIPT + IntToString(nTool));

    if ( sScript == "" )
        // No override, so get the script name from the .2da.
        sScript = Get2DAString(PTOOL_CONFIG_FILE, "Script", nTool);

    // Execute the script.
    ExecuteScript(sScript, OBJECT_SELF);
    */
}


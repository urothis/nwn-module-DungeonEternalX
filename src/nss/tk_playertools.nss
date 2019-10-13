//::///////////////////////////////////////////////
//:: tk_playertools
//:://////////////////////////////////////////////
/*
    Assigns player tools to the object running
    this script, based on the contents of
    tk_playertools.2da.

    This should only be executed by PCs.
*/
//:://////////////////////////////////////////////
//:: Created By: The Krit
//:: Created On: 2008-04-29
//:://////////////////////////////////////////////

/*************************************************
 * USE:
 * ---
 * This script should be executed from a module's
 * OnClientEnter and OnPlayerLevelUp events, but
 * this script should *not* be the event handler.
 * The event handlers should call
 *
    ExecuteScript("tk_playertools", oPC);
 *
 * where oPC has been assigned the return value of
 * either GetEnteringObject() (in the OnClientEnter
 * event) or GetPCLevellingUp() (in the OnPlayerLevelUp
 * event). The name of the variable is not important.
 *************************************************/


#include "x3_inc_skin"

/*
// -----------------------------------------------------------------------------
// CONSTANTS

// This script assumes the player tool item property constants are sequential,
// as well as the player tool feat constants.
// To aid this, we use two constants to which the player tool number will be added:
const int FEAT_PLAYER_TOOL_BASE = 1105;
const int IP_CONST_FEAT_PLAYER_TOOL_BASE = 52;

// The .2da to consult.
const string PTOOL_CONFIG_FILE = "tk_playertools";
// The number of player tools.
const int PTOOL_COUNT = 10;


// -----------------------------------------------------------------------------
// PROTOTYPES

// Implements the check to see if we have the skills, feats, or classes required
// for player tool number nTool.
int CheckQualifyForTool(int nTool);

// Removes a permanent item property on oItem that grants the bonus feat nIPFeat.
// nIPFeat must be an IP_CONST_FEAT_* constant.
void RemoveIPFeat(object oItem, int nIPFeat);


// -----------------------------------------------------------------------------
void main()
{
    // Get our skin object.
    object oSkin = SKIN_SupportGetSkin(OBJECT_SELF);
    if ( GetObjectType(oSkin) != OBJECT_TYPE_ITEM )
        // Something went wrong (possibly oPC is not a PC). Abort.
        return;

    // Loop through the player tools.
    int nTool = 0;
    while ( nTool++ < PTOOL_COUNT )
    {
        // Boolean flags.
        int bAddTool = FALSE;
        int bRemoveTool = FALSE;

        // Here we assume the player tool feats are sequentially indexed.
        if ( !GetHasFeat(FEAT_PLAYER_TOOL_BASE + nTool) )
            // Determine if we qualify for this player tool.
            bAddTool = CheckQualifyForTool(nTool);
        else
        {
            // Determine if this player tool should be removed.
            string sData = Get2DAString(PTOOL_CONFIG_FILE, "AutoRemove", nTool);
            if ( StringToInt(sData)  ||  GetStringLowerCase(sData) == "yes" )
                bRemoveTool = !CheckQualifyForTool(nTool);
        }

        // Add or remove the player tool as appropriate.
        if ( bAddTool )
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyBonusFeat(IP_CONST_FEAT_PLAYER_TOOL_BASE + nTool),
                            oSkin);
        else if ( bRemoveTool )
            RemoveIPFeat(oSkin, IP_CONST_FEAT_PLAYER_TOOL_BASE + nTool);
    }
}


// Implements the check to see if we have the skills, feats, or classes required
// for player tool number nTool.
int CheckQualifyForTool(int nTool)
{
    string sData = "";

    // See if everyone gets this tool.
    sData = Get2DAString(PTOOL_CONFIG_FILE, "Everyone", nTool);
    if ( StringToInt(sData)  ||  GetStringLowerCase(sData) == "yes" )
        return TRUE;

    // Check the qualifying skills.
    int nCol = 1;
    sData = Get2DAString(PTOOL_CONFIG_FILE, "Skill1", nTool);
    // Loop through the 2da columns with data.
    while ( sData != "" )
    {
        if ( GetSkillRank(StringToInt(sData), OBJECT_SELF, TRUE) > 0 )
            // We qualify!
            return TRUE;
        // Next column.
        sData = Get2DAString(PTOOL_CONFIG_FILE, "Skill" + IntToString(++nCol), nTool);
    }

    // Check the qualifying feats.
    nCol = 1;
    sData = Get2DAString(PTOOL_CONFIG_FILE, "Feat1", nTool);
    // Loop through the 2da columns with data.
    while ( sData != "" )
    {
        if ( GetHasFeat(StringToInt(sData)) )
            // We qualify!
            return TRUE;
        // Next column.
        sData = Get2DAString(PTOOL_CONFIG_FILE, "Feat" + IntToString(++nCol), nTool);
    }

    // Check the qualifying classes.
    nCol = 1;
    sData = Get2DAString(PTOOL_CONFIG_FILE, "Class1", nTool);
    // Loop through the 2da columns with data.
    while ( sData != "" )
    {
        if ( GetLevelByClass(StringToInt(sData)) > 0 )
            // We qualify!
            return TRUE;
        // Next column.
        sData = Get2DAString(PTOOL_CONFIG_FILE, "Class" + IntToString(++nCol), nTool);
    }

    // If we get to this point, we do not qualify.
    return FALSE;
}


// Removes a permanent item property on oItem that grants the bonus feat nIPFeat.
// nIPFeat must be an IP_CONST_FEAT_* constant.
void RemoveIPFeat(object oItem, int nIPFeat)
{
    // Loop through the item properties on oItem.
    itemproperty ipLoop = GetFirstItemProperty(oItem);
    while ( GetIsItemPropertyValid(ipLoop) )
    {
        // See if ipLoop is a permanent item property granting feat nIPFeat.
        if ( GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_PERMANENT  &&
             GetItemPropertyType(ipLoop) == ITEM_PROPERTY_BONUS_FEAT         &&
             GetItemPropertySubType(ipLoop) == nIPFeat )
        {
            // Remove this property.
            RemoveItemProperty(oItem, ipLoop);
            // Done. (Only remove one item property.)
            return;
        }
        // Update the loop.
        ipLoop = GetNextItemProperty(oItem);
    }
}
*/

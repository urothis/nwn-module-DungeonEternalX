#include "db_inc"
#include "_functions"
#include "nw_i0_plot"

/////////////////////////////////////////////////////////////////////////////
//
// Scripts modified / created for traininghall system:
// IMPORTANT: The trainer must have tag: "TRAINING_HALL_NPC"
//
// item_freetrainin (Free training token onuse script)
// ez_free40trainer (Z-Dialog Trainer)
// trainhall_enter (OnEnter for Training Hall map)
// tavern_enter (OnEnter for Tavern, ports the testchar to the hall)
// _mod_cliententer (Set player as test-char)
// _mod_playerlevel (Rewards the player with training sessions)
// seed_crafter (Doesnt take gold from testchars and makes the items plot and cursed
// seed_bank_run (port testchar to traininghalls)
// trainhall_trans (Transition OnClick, doesnt let testchars out)
// trainhall_store (Free basic items for testchars)
// trainhall_spawn (trigger onenter spawnscript for testdummies)
// trainhall_dmg (On dmg script for testdummies)
//
////////////////////////////////////////////////////////////////////////////

const int XP_PER_SESSION        = 10000;
const int BASE_SESSION_COUNT    = 4;

// Return TRUE if oPC is a test-character
int GetIsTestChar(object oPC);
// declare oPC as test-character for traininghalls
void SetIsTestChar(object oPC);
// Port oPC to training-halls
void JumpToTraininghalls(object oPC, int nForce = FALSE);
// Set nSetLevel amount of XP to oPC
void SetXPLevel(object oPC, int nSetLevel);
// Set session count in DB
void SetTrainingSessions(object oPC, string sTRUEID, int nValue);
// Return sessions count in DB
int GetTrainingSessions(object oPC, string sTRUEID);
// Create a training token and set it LocalVariable "CERTIFIED" = TRUE
void CreateTrainingToken(object oTarget, int nAmount = 1);
int CountDeleteTraintokens(object oInventory, int nDelete = FALSE);


void SetIsTestChar(object oPC)
{
    SetLocalInt(oPC, "TESTCHAR", TRUE);
}

int GetIsTestChar(object oPC)
{
    return GetLocalInt(oPC, "TESTCHAR");
}

void JumpToTraininghalls(object oPC, int nForce = FALSE)
{
    if (nForce || GetTag(GetArea(oPC)) != "MAP_TRAININGHALL")
    {
        AssignCommand(oPC, ClearAllActions(TRUE));
        AssignCommand(oPC, JumpToObject(DefGetObjectByTag("WP_TRAININGHALLS", GetModule())));
    }
}

void SetTrainingSessions(object oPC, string sTRUEID, int nValue) // (+1 because 0 = no data)
{
    NWNX_SQL_ExecuteQuery("update trueid set trainingtokens="+IntToString(nValue)+" where trueid="+sTRUEID);
    SetLocalInt(oPC, "TRAIN_SESSION", nValue);
}

int GetTrainingSessions(object oPC, string sTRUEID)
{
    int nCount = GetLocalInt(oPC, "TRAIN_SESSION"); // resetting this OnAreaEnter in Trainhall
    if (!nCount)
    {
        NWNX_SQL_ExecuteQuery("select trainingtokens from trueid where trueid="+sTRUEID);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            nCount=StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        }
    }
    SetLocalInt(oPC,"TRAIN_SESSION",nCount);
    return nCount;
}

void CreateTrainingToken(object oTarget, int nAmount = 1)
{
    int i;
    object oToken;
    string sToken;
    for (i = 0; i < nAmount; i++)
    {
        oToken = CreateItemOnObject("freetraining", oTarget);
        SetLocalInt(oToken, "CERTIFIED", TRUE);
    }
}

int CountDeleteTraintokens(object oInventory, int nDelete = FALSE)
{
    int nCnt;
    if (HasItem(oInventory, "item_freetraining"))
    {
        object oItem = GetFirstItemInInventory(oInventory);
        while (GetIsObjectValid(oItem))
        {
            if (GetTag(oItem) == "item_freetraining")
            {
                if (GetLocalInt(oItem, "CERTIFIED"))
                {
                    if (nDelete) Insured_Destroy(oItem);
                    nCnt++;
                }
            }
            oItem = GetNextItemInInventory(oInventory);
        }
    }
    return nCnt;
}

void SetXPLevel(object oPC, int nLevel)
{
    effect eLevel;
    int i;
    int nXP = 0;
    int nCurrentXP = GetXP(oPC);

    for (i = 1; i < nLevel; i++)
    {
        nXP += i * 1000;
    }

    if (nCurrentXP >= nXP)
    {
        eLevel = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY, FALSE);
    }
    else if (nCurrentXP < nXP)
    {
        eLevel = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER, FALSE);
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLevel, oPC);
    SetXP(oPC, nXP);
}

//void main(){}

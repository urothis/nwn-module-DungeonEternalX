#include "sfsubr_functs"
/////////////////////
//Prototypes //////// - script is broken.
/////////////////////

//Handles the PC object to check class token feats.
//It adds and then calls the remove checks.
//Edit this to add feats.
void checkTokenFeats(object oPC);

//Handles checks based on class (organization). It checks each class on login
//if they meet the reqs. If not, removes them.
void removeRanger(object oPC);
void removeAssassin(object oPC);
void removeBlackguard(object oPC);

//Handles the removing of feats
void AddUncanny(object oPC);
void RemoveUncanny(object oPC);
void AddImpEvasion(object oPC);
void RemoveImpEvasion(object oPC);
void AddKeen(object oPC);
void RemoveKeen(object oPC);
void AddCripplingStrike(object oPC);
void RemoveCripplingStrike(object oPC);

///////////////////////////////////////////////////

void checkTokenFeats(object oPC)
{
    if (!GetIsDM(oPC)&&!GetIsDMPossessed(oPC))
    {
        int nLevel;

        /*// Checks ranger
        if (GetLevelByClass(CLASS_TYPE_RANGER, oPC))
        {*/
            nLevel = GetLevelByClass(CLASS_TYPE_RANGER, oPC);

            //Add feats if they meet requirements.
            if (!GetHasFeat(FEAT_UNCANNY_DODGE_1, oPC) && nLevel == 40)
            {
                AddUncanny(oPC);
                return;
            }
            if (!GetHasFeat(FEAT_KEEN_SENSE, oPC) && nLevel == 40)
            {
                AddKeen(oPC);
                return;
            }
            if (!GetHasFeat(FEAT_IMPROVED_EVASION, oPC) && nLevel >= 35)
            {
                AddImpEvasion(oPC);
                return;
            }
        // }

        //Check for blackguard
        if (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC)>0)
        {
            nLevel=GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);

            //Adds feat
            if (!GetHasFeat(FEAT_CRIPPLING_STRIKE, oPC) && nLevel == 30)
            {
                AddCripplingStrike(oPC);
                return;
            }
        }

        //Check for Assassin
        if (GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC)>0)
        {
            nLevel=GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);

            //Adds feat
            if (!GetHasFeat(FEAT_CRIPPLING_STRIKE, oPC) && nLevel >= 18)
            {
                AddCripplingStrike(oPC);
                return;
            }
            if (!GetHasFeat(FEAT_IMPROVED_EVASION, oPC) && nLevel == 30)
            {
                AddImpEvasion(oPC);
                return;
            }
        }

        // Calls remove checks
        removeRanger(oPC);
        removeAssassin(oPC);
        removeBlackguard(oPC);

    }
}

/////////////////////////
// Handles the remove check for specific classes
/////////////////////////
void removeRanger(object oPC)
{
    //Removes Ranger feats
    if (GetHasFeat(FEAT_UNCANNY_DODGE_1, oPC) && GetLevelByClass(CLASS_TYPE_RANGER,oPC)<40)
    {
        RemoveUncanny(oPC);
    }
    if (GetHasFeat(FEAT_IMPROVED_EVASION, oPC) && GetLevelByClass(CLASS_TYPE_RANGER,oPC)<35)
    {
        RemoveImpEvasion(oPC);
    }
    if (GetHasFeat(FEAT_KEEN_SENSE, oPC) && GetLevelByClass(CLASS_TYPE_RANGER,oPC)<40)
    {
        RemoveKeen(oPC);
    }
    return;
}


void removeAssassin(object oPC)
{
    if (GetHasFeat(FEAT_IMPROVED_EVASION, oPC) && GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC)<18)
    {
        RemoveImpEvasion(oPC);
                        return;

        //////
        if (GetLevelByClass(CLASS_TYPE_BLACKGUARD,oPC)<30)   // Crippling strike
        {
            if (GetLevelByClass(CLASS_TYPE_ROGUE,oPC)<10 || GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC)<18)
            {
                if (GetHasFeat(FEAT_CRIPPLING_STRIKE, oPC))
                {
                    RemoveCripplingStrike(oPC);
                    return;
                }}}
     }
}


void removeBlackguard(object oPC)
{
    if (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC)>0)
    {
        if (GetLevelByClass(CLASS_TYPE_BLACKGUARD,oPC)<30)   // Crippling strike
        {
            if (GetLevelByClass(CLASS_TYPE_ROGUE,oPC)<10 || GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC)<18)
            {
                if (GetHasFeat(FEAT_CRIPPLING_STRIKE, oPC))
                {
                    RemoveCripplingStrike(oPC);
                    return;
                }}}}
}


////////////////////////////////////////////////////////
// Add/Remove feat scrips below
////////////////////////////////////////////////////////

void AddUncanny(object oPC)
{
   int DeX_LetoScript = GetLocalInt(oPC, "DeX_LetoScript");
   if (!DeX_LetoScript)
   {
      ExportSingleCharacter(oPC);
      NWNX_Creature_AddFeat(oPC, FEAT_UNCANNY_DODGE_1);
      //string Script = ModifyFeat(FEAT_UNCANNY_DODGE_1, 0);
      //ApplyLetoScriptToPC(Script, oPC);
   }
}

void RemoveUncanny(object oPC)
{
   int DeX_LetoScript = GetLocalInt(oPC, "DeX_LetoScript");
   if (!DeX_LetoScript)
   {
      ExportSingleCharacter(oPC);
      NWNX_Creature_RemoveFeat(oPC, FEAT_UNCANNY_DODGE_1);
      //string Script = ModifyFeat(FEAT_UNCANNY_DODGE_1, 1);
      //ApplyLetoScriptToPC(Script, oPC);
   }
}

void AddImpEvasion(object oPC)
{
   int DeX_LetoScript = GetLocalInt(oPC, "DeX_LetoScript");
   if (!DeX_LetoScript)
   {
      ExportSingleCharacter(oPC);
      NWNX_Creature_AddFeat(oPC, FEAT_IMPROVED_EVASION);
      //string Script = ModifyFeat(FEAT_IMPROVED_EVASION, 0);
      //ApplyLetoScriptToPC(Script, oPC);
   }
}
void RemoveImpEvasion(object oPC)
{
   int DeX_LetoScript = GetLocalInt(oPC, "DeX_LetoScript");
   if (!DeX_LetoScript)
   {
      ExportSingleCharacter(oPC);
      NWNX_Creature_RemoveFeat(oPC, FEAT_IMPROVED_EVASION);
      //string Script = ModifyFeat(FEAT_IMPROVED_EVASION, 1);
      //ApplyLetoScriptToPC(Script, oPC);
   }
}

void AddKeen(object oPC)
{
   int DeX_LetoScript = GetLocalInt(oPC, "DeX_LetoScript");
   if (!DeX_LetoScript)
   {
      ExportSingleCharacter(oPC);
      NWNX_Creature_AddFeat(oPC, FEAT_KEEN_SENSE);
      //string Script = ModifyFeat(FEAT_KEEN_SENSE, 0);
      //ApplyLetoScriptToPC(Script, oPC);
   }
}

void RemoveKeen(object oPC)
{
   int DeX_LetoScript = GetLocalInt(oPC, "DeX_LetoScript");
   if (!DeX_LetoScript)
   {
      ExportSingleCharacter(oPC);
      NWNX_Creature_RemoveFeat(oPC, FEAT_KEEN_SENSE);
      //string Script = ModifyFeat(FEAT_KEEN_SENSE, 1);
      //ApplyLetoScriptToPC(Script, oPC);
   }
}

void AddCripplingStrike(object oPC)
{
   int DeX_LetoScript = GetLocalInt(oPC, "DeX_LetoScript");
   if (!DeX_LetoScript)
   {
      ExportSingleCharacter(oPC);
      NWNX_Creature_AddFeat(oPC, FEAT_CRIPPLING_STRIKE);
      //string Script = ModifyFeat(FEAT_CRIPPLING_STRIKE, 0);
      //ApplyLetoScriptToPC(Script, oPC);
   }
}

void RemoveCripplingStrike(object oPC)
{
   int DeX_LetoScript = GetLocalInt(oPC, "DeX_LetoScript");
   if (!DeX_LetoScript)
   {
      ExportSingleCharacter(oPC);
      NWNX_Creature_RemoveFeat(oPC, FEAT_CRIPPLING_STRIKE);
      //string Script = ModifyFeat(FEAT_CRIPPLING_STRIKE, 1);
      //ApplyLetoScriptToPC(Script, oPC);
   }
}

#include "_functions"

// cleanup_inc
void CleanupOnAreaEnter(object oPC, object oArea);
// cleanup_inc
void CleanupOnAreaExit(object oPC, object oArea);
// cleanup_inc - return highest lvl in oArea. Break the loop if lvl >= nLimit and return nLimit.
// return FALSE if no player found
int GetHighestLvlInArea(object oArea, object oPC, int nLimit=40);
// Turn all encoutner on oArea ON or OFF. TRUE = ON, FALSE = OFF
void SwitchEncounter(object oArea, int nON=TRUE);
// cleanup_inc
void CheckJunkAssignDestroy(object oItem);
// cleanup_inc
void DestroyJunk(object oItem);

void DestroyJunk(object oItem)
{
    if (!GetIsObjectValid(oItem)) return;

    // check if someone picked it up
    // some inventory object, like placeable, creature or store
    if (GetIsObjectValid(GetItemPossessor(oItem))) return;

    // burn it
    if (GetItemStackSize(oItem) > 1) SetItemStackSize(oItem, 1);
    Insured_Destroy(oItem);
}

void CheckJunkAssignDestroy(object oItem)
{
    if (!GetIsObjectValid(oItem)) return;

    // some inventory object, like placeable, creature or store
    if (GetIsObjectValid(GetItemPossessor(oItem))) return;
    // Location gives invalid area? (invalid location) return just incase, maybe it is in barter window
    if (!GetIsObjectValid(GetAreaFromLocation(GetLocation(oItem)))) return;

    // burn it
    AssignCommand(oItem, DelayCommand(120.0, DestroyJunk(oItem)));
}


int GetHighestLvlInArea(object oArea, object oPC, int nLimit=40)
{
    int nLvl, nHighestLvl, nStop;
    object oLocator = GetNearestObject(OBJECT_TYPE_ENCOUNTER, oPC); // find a locator
    int nCnt = 1;
    object oSomePC = GetNearestObject(OBJECT_TYPE_CREATURE, oLocator, nCnt);
    while (GetIsObjectValid(oSomePC)) // loop until nothing found
    {
        if (GetIsPC(oSomePC) && oSomePC != oPC)
        {
            nLvl = GetHitDice(oSomePC); // get current lvl
            if (nLvl >= nLimit) return nLimit; // found something that we look for? return
            if (nLvl > nHighestLvl) nHighestLvl = nLvl; // no, store its lvl if its higher than last one
        }
        nStop++; // to prevent big loops
        if (nStop > 10) return 1;

        nCnt++; // increase nCnt for next pc and get him
        oSomePC = GetNearestObject(OBJECT_TYPE_CREATURE, oLocator, nCnt);
    }
    return nHighestLvl; // return the highest lvl (returns FALSE if nothing found)
}

void SwitchEncounter(object oArea, int nON=TRUE)
{
    object oEnc;
    object oLocator = GetFirstObjectInArea(oArea); // get some object
    if (GetObjectType(oLocator) == OBJECT_TYPE_ENCOUNTER) oEnc = oLocator; // if its a encounter, store it
    else oEnc = GetNearestObject(OBJECT_TYPE_ENCOUNTER, oLocator); // else get a encounter
    oLocator = oEnc; // store its location
    int nCnt = 1;
    while (GetIsObjectValid(oEnc))
    {
        if (nON == FALSE) SetEncounterActive(FALSE, oEnc);
        else SetEncounterActive(TRUE, oEnc);
        oEnc = GetNearestObject(OBJECT_TYPE_ENCOUNTER, oLocator, nCnt);
        nCnt++;
    }
    if (nON == FALSE) SetLocalInt(oArea, "ENC_INACTIVE", TRUE);
    else DeleteLocalInt(oArea, "ENC_INACTIVE");
}

// Get LocalInt "AREA_CR" that was set in toolset
// Do not give LocalVariable to non PvP areas!
// High level player could camp and prevent lowbies leveling
// Use the Trigger AVOID_ENCOUNTER for non pvp areas
// and no point to give localvariable to above CR34 areas. CR35 is not effy for 40s

void EncounterOnAreaEnter(object oPC, object oArea)
{
    int nCR = GetLocalInt(oArea, "AREA_CR");
    if (!nCR) return;

    if (GetLocalInt(oArea, "ENC_INACTIVE")) // encounter is inactive
    {
        if (GetHitDice(oPC) < nCR + 6) // we are low enough
        {
            int nHighestLvl = GetHighestLvlInArea(oArea, oPC, nCR + 6);
            if (nHighestLvl < nCR + 6) // all player low enough
            {
                SwitchEncounter(oArea, TRUE); // activate
                return;
            }
        }
        //SendMessageToPC(oPC, "Character Level to high (" + IntToString(nCR + 5) + "+) encounters disabled.");
        return; // do nothing, keep them inactive
    }
    // encounter are active
    if (GetHitDice(oPC) >= nCR + 6) // we are to high
    {
        //SwitchEncounter(oArea, FALSE); // deactivate
        //SendMessageToPC(oPC, "Character Level to high (" + IntToString(nCR + 5) + "+) encounters disabled.");
    }
}

void EncounterOnAreaExit(object oPC, object oArea)
{
    int nCR = GetLocalInt(oArea, "AREA_CR");
    if (!nCR) return;

    if (GetLocalInt(oArea, "ENC_INACTIVE")) // we are leaving, encounters inactive for some reason?
    {
        int nHighestLvl = GetHighestLvlInArea(oArea, oPC, nCR + 6); // get the highest lvl
        if (nHighestLvl > 0 && nHighestLvl < nCR + 6) //check if they are low enough
        {
            SwitchEncounter(oArea, TRUE); //there are player and everyone is low enough, activate encounter
        }
    }
}


//void main(){}

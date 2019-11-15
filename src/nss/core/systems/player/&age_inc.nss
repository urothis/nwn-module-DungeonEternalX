// MIT License
// (c) 2019 urothis
#include "&player_inc"
// age db location
string ageDBLocation(object oPC);
string ageDBLocation(object oPC) { return dbLocationObject(oPC) +":age" }
// Add value to the core age hash
void ageSet(object oPC, string sKey, string sValue);
void ageSet(object oPC, string sKey, string sValue) { HMSET(ageDBLocation(oPC),sKey,sValue); }
// Get int from the core age hash
int ageGetInt(object oPC, string sKey);
int ageGetInt(object oPC, string sKey) { return HashInt(ageDBLocation(oPC),sKey); }

// Get expected seconds until death
int playerGetRemainingLife(object oPC);
int playerGetRemainingLife(object oPC) { return HashInt(ageDBLocation(oPC), "TimeOfDeath") - NWNX_Time_GetTimeStamp(); }

void permadeath(oPC);
void permadeath(oPC) {
    ageSet(ageDBLocation(oPC);,"Dead",IntToString(1));

    // TODO rename character
}

// init values we need to init the system
void initLifeSpan(object oPC);
void initLifeSpan(object oPC) {
    int nExpectedLifespan = 100, // or whatever dynamic stuff
        nIRLDays = 30;
        nTOB = NWNX_Time_GetTimeStamp(),
        nDeathCountDown = IRLDays * 86400;
        nTimeOfDeath = nDeathCountDown + nTOB;
    string sPath = ageDBLocation(oPC);
    ageSet(sPath, "TOB", IntToString(nTOB));
    ageSet(sPath, "ExpectedLifespan",IntToString(nExpectedLifespan));
    ageSet(sPath, "TimeOfDeath",IntToString(nExpectedLifespan));
    ageSet(sPath, "Dead",IntToString(0));
    EXPIRE(sPath, IntToString(nDeathCountDown));
}

// update lifespan ticker, idk best trigger atm
void updateLifeSpan(object oPC);
void updateLifeSpan(object oPC) {
    // die of old age
    if (playerGetRemainingLife(oPC) <= 0) permadeath(oPC); return;

    // if system isn't initialized
    if(!HEXISTS(ageDBLocation(oPC),"TOB") initLifeSpan(object oPC);
}
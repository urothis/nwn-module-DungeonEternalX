#include "pg_lists_i"
#include "db_inc"
#include "seed_faction_inc"
#include "ness_pvp_db_inc"
#include "fame_inc"

// Drops pvp tokens on the killer
string dropPvpLoot(object oKilled, object oKiller, object oArea);
// Compute and return the Character value rating
float ComputeCVRating(object oPC);
// GetLocalFloat the Character value rating
float GetCVRating(object oPC);
// SetLocalFloat the Character value rating
void SetCVRating(object oPC, float fCVR);
//////////////////////////////////////////////////////////
// GetLocalFloat and create token on oPC. SetLocalFloat the remaining.
//void CreatePvPTokenFromChar(object oPC, string sTRUEID);

float ComputeCVRating(object oPC)
{
    float fCVR = 0.0;

    int nMage   = GetLevelByClass(CLASS_TYPE_SORCERER, oPC) + GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    int nCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
    int nDruid  = GetLevelByClass(CLASS_TYPE_DRUID, oPC);
    int nPM     = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);
    int nBard   = GetLevelByClass(CLASS_TYPE_BARD, oPC);
    int nMonk   = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    int nSD     = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);
    int nBarb   = GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);
    int nAA     = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC);
    int nDragon = GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON, oPC);
    int nConstr = GetHasFeat(FEAT_EPIC_CONSTRUCT_SHAPE, oPC);
    int nOutsid = GetHasFeat(FEAT_EPIC_OUTSIDER_SHAPE, oPC);

    if (nMonk >= 3)
    {
        nMonk /= 3; // every 3 levels
        fCVR += IntToFloat(nMonk) * 0.01;
        if (GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) > 24 || nConstr) fCVR *= 6;
        else if (nAA) fCVR *= 3;
    }

    if (nMage >= 10)   fCVR += 0.15;
    if (nMage >= 17)   fCVR += 0.15;
    if (nCleric >= 17) fCVR += 0.2;
    if (nDruid >= 5)   fCVR += 0.1;
    if (nDruid == 40)  fCVR += 0.15;
    if (nPM >= 10)     fCVR += 0.05;
    if (nBarb == 40)   fCVR += 0.1;
    if (nSD)           fCVR += 0.03;

    if (nDragon || nConstr || nOutsid) fCVR += 0.05;

    if (nBard >= 20)
    {
        nBard = nBard/5-4; // every 5 levels after 20
        fCVR += IntToFloat(nBard) * 0.02 + 0.1; // 0.1 at 20 and another 0.02 every 5 levels
    }
    return fCVR;
}

float GetCVRating(object oPC)
{
    return GetLocalFloat(oPC, "CVR_MODIFIER");
}

void SetCVRating(object oPC, float fCVR)
{
    float fMod = 0.0;
    string sFAID = SDB_GetFAID(oPC);
    if (GetTopRichestFAID() == sFAID) fMod = 0.3;
    else if (GetTopRichestFAID("2") == sFAID) fMod = 0.2;
    else if (GetTopRichestFAID("3") == sFAID) fMod = 0.1;

    if (fMod > 0.0) DelayCommand(15.0, ActionSendMessageToPC(oPC, "You are in the top 3 richest faction and earn more fame"));
    if (GetTopFamousFAID() == sFAID || GetTopFamousFAID("2") == sFAID || GetTopFamousFAID("3") == sFAID)
    {
        DelayCommand(16.0, ActionSendMessageToPC(oPC, "You are in the top 3 famous faction and earn more XP/GP"));
    }
    SetLocalFloat(oPC, "CVR_MODIFIER", fCVR-fMod);
}

/*void CreatePvPTokenFromChar(object oPC, string sCdKey)
{
    float fToken = PvPTokenOnChar(oPC);
    float fDbCount = StringToFloat(dbTokenCount(oPC, sCdKey));
    if (fToken > 0.0)
    {
        //CreateItemOnObject("PVPTokens", oPC, nToken);
        dbUpdateTokenCount(oPC, fToken+fDbCount, sCdKey);
        DeleteLocalFloat(oPC, "PVPTOKEN_ON_CHAR");
    }
}*/

string dropPvpLoot(object oKilled, object oKiller, object oArea)
{
    string sMsg;
    if (!GetIsPlayer(oKiller)) return sMsg;

    // No reward for Teamkill
    if (GetFactionEqual(oKiller, oKilled)) return sMsg;

    // Checks if player is in the same faction
    if (SDB_GetFAID(oKiller) == SDB_GetFAID(oKilled) && SDB_FactionIsMember(oKiller)) return sMsg;

    int nLvlKiller = GetHitDice(oKiller);
    int nLvlKilled = GetHitDice(oKilled);
    // Minimum of level 21 to participate - shillow's orders! - rescinded for purposes of increasing fame
    //if (nLvlKiller <= 21 || nLvlKilled <= 21) return sMsg;

    int nTokenReward = 0; // Default reward, meaning you get squat!
    int nLvlDiff     = 0; // Level difference of killer and killed

    //Checks the areas killed person is in. If any of the areas, return.
    if (GetLocalInt(oArea, "NO_PVP_TOKEN_AREA")) return sMsg;

    if (abs(nLvlKiller - nLvlKilled) > 6) return sMsg;

    // After all the checks, designates the according pvp reward.
    switch (nLvlKilled)
    {
        case (1): nTokenReward=1;break;
        case (2): nTokenReward=1;break;
        case (3): nTokenReward=1;break;
        case (4): nTokenReward=1;break;
        case (5): nTokenReward=1;break;
        case (6): nTokenReward=1;break;
        case (7): nTokenReward=1;break;
        case (8): nTokenReward=1;break;
        case (9): nTokenReward=1;break;
        case (10): nTokenReward=1;break;
        case (11): nTokenReward=2;break;
        case (13): nTokenReward=2;break;
        case (14): nTokenReward=2;break;
        case (15): nTokenReward=1;break;
        case (16): nTokenReward=1;break;
        case (17): nTokenReward=1;break;
        case (18): nTokenReward=1;break;
        case (19): nTokenReward=1;break;
        case (20): nTokenReward=1;break;
        case (21): nTokenReward=1;break;
        case (22): nTokenReward=1;break;
        case (23): nTokenReward=1;break;
        case (24): nTokenReward=1;break;
        case (25): nTokenReward=1;break;
        case (26): nTokenReward=1;break;
        case (27): nTokenReward=1;break;
        case (28): nTokenReward=1;break;
        case (29): nTokenReward=1;break;
        case (30): nTokenReward=1;break;
        case (31): nTokenReward=1;break;
        case (32): nTokenReward=1;break;
        case (33): nTokenReward=1;break;
        case (34): nTokenReward=1;break;
        case (35): nTokenReward=2;break;
        case (36): nTokenReward=3;break;
        case (37): nTokenReward=4;break;
        case (38): nTokenReward=5;break;
        case (39): nTokenReward=6;break;
        case (40): nTokenReward=6;break;
    }

    string sKilledCD    = IntToString(dbGetTRUEID(oKilled));
    string sKillerCD    = IntToString(dbGetTRUEID(oKiller));

    // Adjust reward based on kills
    int nCount = GetLocalInt(GetModule(), sKilledCD + sKillerCD);
    SetLocalInt(GetModule(), sKilledCD + sKillerCD, nCount+1);

    if (nCount > 5 && nCount <= 10)
    {
        SendMessageToPC(oKiller, "You got a reduced reward because you own.");
        nTokenReward = nTokenReward/2;
    }
    else if (nCount > 10)
    {
        nTokenReward = 0;
        SendMessageToPC(oKiller, "You recieved no reward for this kill.");
    }

    if (nTokenReward == 0) return sMsg;

    int nMemberCount      = 0;
    float fMemberCVRCount = 0.0;
    object oAreaKiller    = GetArea(oKiller);
    object oAreaMember;

    object oMember = GetFirstFactionMember(oKiller);
    while (GetIsObjectValid(oMember)) // loop through all members in party
    {   // member fought on same area but died?
        oAreaMember = GetLocalObject(oMember, "LAST_DIED_AREA");
        if (!GetIsObjectValid(oAreaMember)) oAreaMember = GetArea(oMember);

        if (oAreaKiller == oAreaMember) // same area?
        {
            // add to list
            nMemberCount = AddObjectElement(oMember, sKilledCD, oAreaKiller);
            fMemberCVRCount += GetCVRating(oMember);
        }
        oMember = GetNextFactionMember(oKiller);
    }

    if (!nMemberCount) // error, or enemy killed different map
    {
        DeleteList(sKilledCD, oAreaKiller); // delete list
        return sMsg;
    }

    // divide reward by members in party
    float fModifiedReward      = IntToFloat(nTokenReward) * (1.0 + GetCVRating(oKilled));
    float fModifiedMemberCount = IntToFloat(nMemberCount) + fMemberCVRCount;
    float fDivided             = fModifiedReward / fModifiedMemberCount;

    if (nMemberCount)
    {
        int i; // loop through all members that earn points
        for (i = 0; i < nMemberCount; i++)
        {   // Store fame and Tokenpoints on every member
            oMember = GetObjectElement(i, sKilledCD, oAreaKiller);
            if (GetIsObjectValid(oMember)) IncFameOnChar(oMember, fDivided);
        }
         sMsg = GetRGB(11,9,11) + "\n(PvP) Rewarding " + IntToString(nMemberCount) +
            " player: " + FloatToString(fDivided, 0, 2) + " Fame " +
            "(" + FloatToString(fModifiedReward, 0, 2) + "/" +
            FloatToString(fModifiedMemberCount, 0, 2) + ")";
    }
    DeleteList(sKilledCD, oAreaKiller); // delete list
    return sMsg;
}

//void main(){}

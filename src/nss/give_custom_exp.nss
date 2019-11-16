#include "seed_faction_inc"
#include "random_event"
#include "fame_inc"
#include "pc_inc"

     /* OLD XP CALCULATION
        if      (nRealLevel<= 5) nXPBase = 200;
        else if (nRealLevel<=10) nXPBase = 300;
        else if (nRealLevel<=15) nXPBase = 400;
        else if (nRealLevel<=20) nXPBase = 500;
        else if (nRealLevel<=25) nXPBase = 600;
        else if (nRealLevel<=30) nXPBase = 700;
        else if (nRealLevel<=35) nXPBase = 800;
        else if (nRealLevel<=39) nXPBase = 900;
        else if (nRealLevel>=40) nXPBase = 700;

        if      (nCRDiff == 1) nXPBase = nXPBase * 60 / 60;
        else if (nCRDiff == 2) nXPBase = nXPBase * 50 / 60;
        else if (nCRDiff == 3) nXPBase = nXPBase * 40 / 60;
        else if (nCRDiff == 4) nXPBase = nXPBase * 20 / 60;
        else if (nCRDiff == 5) nXPBase = nXPBase * 10 / 60;
        else if (nCRDiff >= 6) nXPBase = nXPBase *  1 / 60;*/

int GetIsRewardValid(object oPC, object oDead, object oAreaDead)
{
    if (GetArea(oPC) == oAreaDead)
    {
        if (GetDistanceBetween(oPC, oDead) < 20.0)
        {
            if (GetCurrentHitPoints(oPC) > 0) return TRUE;
        }
    }
    return FALSE;
}

void DEXRewardXP(object oKiller, object oDead)
{
    object oModule = GetModule();
    object oMaster = GetMaster(oKiller);
    object oAreaDead = GetArea(oDead);
    int nMaxLevel, nRealLevel, nPartyCnt;
    int nLeechCap = 10;

    int nCR = FloatToInt(GetChallengeRating(oDead));
    if (nCR < 1) nCR = 1;
    else if (nCR > 40) nCR = 40;

    if (GetIsObjectValid(oMaster)) oKiller = oMaster;

    object oPartyMember = GetFirstFactionMember(oKiller);
    while (GetIsObjectValid(oPartyMember))
    {
        if (GetIsRewardValid(oPartyMember, oDead, oAreaDead))
        {
            nRealLevel = pcGetRealLevel(oPartyMember);
            nMaxLevel = GetMax(nMaxLevel, nRealLevel);
            nPartyCnt++;
            if (nMaxLevel == 40) nLeechCap = 5;
        }
        oPartyMember = GetNextFactionMember(oKiller);
    }
    SetLocalInt(oAreaDead, "PARTY_CNT", nPartyCnt);

    int nCRDiff = nMaxLevel - nCR;
    if (nCRDiff < 0) nCRDiff = 0;

    if (nCRDiff > 5) return; // mob is effy: return, no one in party get XP

    if (nMaxLevel < 40) DoRandomEvent(nCRDiff, nMaxLevel, nPartyCnt, nCR, oDead, oKiller);

    string sText, sSQL, sFAID;
    int iLeech, nXPBase, nXPBonus, nGold, nGoldBonus, nCount;
    int nTitheGold, nTitheXP, nTithePCT, nXP;

    int nMultiplier = GetLocalInt(oDead, "XP_BONUS");
    if (!nMultiplier) nMultiplier = 1;

    oPartyMember = GetFirstFactionMember(oKiller);
    while (GetIsObjectValid(oPartyMember))
    {
        if (GetIsRewardValid(oPartyMember, oDead, oAreaDead))
        {
            nXP = GetXP(oPartyMember);
            nRealLevel = pcGetHDFromXP(nXP, GetHitDice(oPartyMember));
            iLeech = nMaxLevel - nRealLevel;
            if (iLeech <= nLeechCap)
            {
                nXPBase = 8000/nRealLevel;
                if (nXPBase > 200) nXPBase = 200;
                nXPBase += 15 * nRealLevel * (6 - nCRDiff) / 6;
                nXPBase = nXPBase * nMultiplier;
                nGold = nXPBase * 2;

                // Ezramun test lvling
                // nXPBase = nXPBase * 4;

                sFAID = SDB_GetFAID(oPartyMember);
                if (StringToInt(sFAID)) // IN A FACTION
                {
                    nCount = SDB_FactionGetArtifactCount(sFAID);
                    nCount += GetFamousModifier(3, 2, 1, sFAID);
                    if (nCount > 6) nCount = 6;
                    if (nCount)
                    {
                        nXPBonus = nXPBase / 30 * nCount;
                        nGoldBonus = 100 * nCount;
                    }
                    nTitheGold = 0;
                    nTitheXP = 0;
                    if (nRealLevel >= 40) nTithePCT = 30;
                    else nTithePCT = GetLocalInt(oPartyMember, "TITHE_PCT");
                    if (nTithePCT)
                    {
                        nTitheXP = (nXPBase + nXPBonus) / 100 * nTithePCT ;  // CALC TITHE XP
                        nXPBase -= nTitheXP;  // REDUCE THE XP FOR CHAR
                        if (nGold) nTitheGold = (nGold + nGoldBonus) * nTithePCT / 100 ;
                        if (nTitheGold)
                        {
                            nGold = nGold - nTitheGold;
                            IncLocalInt(oModule, "TITHE_GOLD_" + sFAID, nTitheGold);
                        }
                        nTitheXP = IncLocalInt(oModule, "TITHE_XP_" + sFAID, nTitheXP); // SAVE INTO ACCUMLATOR
                        if (nTitheXP > FACTION_TITHE_ACCUM) // IS ACCUM VALUE HIGH ENOUGH? IF SO SAVE TO DB
                        {
                            IncLocalInt(oModule, "TITHE_XP_" + sFAID, -nTitheXP); // REDUCE ACCUM
                            nTitheGold = GetLocalInt(oModule, "TITHE_GOLD_" + sFAID); // GET THE TOTAL ACCUM GOLD
                            IncLocalInt(oModule, "TITHE_GOLD_" + sFAID, -nTitheGold); // CLEAR THE ACCUM GOLD
                            sSQL = "update faction set fa_bankxp=fa_bankxp+" + IntToString(nTitheXP) +
                                   ", fa_bankgold=fa_bankgold+" + IntToString(nTitheGold) + " where fa_faid=" + sFAID;
                            AssignCommand(oModule, SpeakString(GetRGB(11,9,11) + GetLocalString(oModule, "SDB_FACTION_NAME_" + sFAID) +
                                                 " has earned " + IntToString(nTitheXP) + " XP and " + IntToString(nTitheGold) + " Gold", TALKVOLUME_SHOUT));
                            NWNX_SQL_ExecuteQuery(sSQL);
                            FactionLogBankTransfer("", "", FBANK_T1_XP, FBANK_T2_TITHE, nTitheXP, sFAID);
                            FactionLogBankTransfer("", "", FBANK_T1_GP, FBANK_T2_TITHE, nTitheGold, sFAID);
                        }
                    }
                }
                GiveGoldToCreature(oPartyMember, nGold + nGoldBonus);
                GiveXPToCreature(oPartyMember, nXPBase + nXPBonus);
                /*
                nXP = GetXP(oPartyMember) - nXP; // CHECK FOR DELTA
                if (nXP)
                {
                    sText = IntToString(nXP)+"xp";
                    if (nXPBonus) sText += YellowText(" *" + IntToString(nXPBonus) + "xp*");
                    FloatingTextStringOnCreature(sText, oPartyMember, TRUE);
                }
                */
                sText = IntToString(nXPBase + nXPBonus)+"xp";
                if (nXPBonus) sText += YellowText(" *" + IntToString(nXPBonus) + "xp*");
                FloatingTextStringOnCreature(sText, oPartyMember, FALSE);
                nXPBonus = 0;
                nGoldBonus = 0;
            }
            else FloatingTextStringOnCreature("Party leech gap exceeded (" + IntToString(nLeechCap) + " lvl max): no XP rewarded.", oPartyMember);
        }
        oPartyMember = GetNextFactionMember(oKiller);
    }
}

//void main(){}

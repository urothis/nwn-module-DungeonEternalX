#include "random_loot_inc"
#include "dmg_stones_inc"
#include "fame_inc"
#include "inc_traininghall"

void main()
{
    object oPC = GetLastUsedBy();

    if (!GetIsObjectValid(oPC)) return;

    string sQuest = GetLocalString(OBJECT_SELF,"QUEST");

    if (sQuest == "1001") // xmas/easter special
    {
        IncFameOnChar(oPC, 10.0);
        StoreFameOnDB(oPC, SDB_GetFAID(oPC));
        string sStone = PickOne("DMGS_MAGIC", "DMGS_DIVINE", "DMGS_POSITIVE");
        DMGS_CreateStone(oPC, sStone);
        CreateTrainingToken(oPC, 4);
        LootCreateGems(oPC, 1000000, 800000);
        return;
    }

    float fFame = 5.0;
    string sStone = "";
    int nTrainToken = 1;
    if (sQuest == "10") nTrainToken = 5;
    else if (sQuest == "1002") // weekly tombola
    {
        fFame = 10.0;
        sStone = PickOne("DMGS_MAGIC", "DMGS_DIVINE", "DMGS_POSITIVE");
        nTrainToken = 5;
    }
    CreateTrainingToken(oPC, nTrainToken);
    DMGS_CreateStone(oPC);
    LootCreateGold(oPC, 250000, 200000);
    LootCreateGems(oPC, 1500000, 1300000);
    IncFameOnChar(oPC, fFame);
    StoreFameOnDB(oPC, SDB_GetFAID(oPC));

    int nPots = 2 + d4();
    int nScrolls = 6 - nPots;
    LootCreateScrollPot(oPC, 1, nScrolls + d2(), 60);
    LootCreateScrollPot(oPC, 2, nPots + d2(), 20);
    Insured_Destroy(OBJECT_SELF);
}

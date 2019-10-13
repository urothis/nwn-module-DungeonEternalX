#include "random_loot_inc"
#include "dmg_stones_inc"
#include "inc_traininghall"

void main()
{
    object oBag = OBJECT_SELF;
    object oPC = GetLastUsedBy();

    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;
    if (GetIsDMPossessed(oPC)) return;
    if (!GetIsObjectValid(oPC)) return;

    if (GetTag(oBag) != "BOSSBAG") return; // DM created?
    if (GetLocalInt(oBag, "OPENED")) return;
    if (GetLocalInt(oBag, GetPCPublicCDKey(oPC)))  //Check if player used the bag.
    {
        ActionFloatingTextStringOnCreature("You have already looted that bag.", oPC);
        return;
    }
    ////////////////////////////////////////////////////////////////////////////

    //SetLocalInt(oBag, "OPENED", TRUE);
    SetLocalInt(oBag, GetPCPublicCDKey(oPC),1); //records the player looting on the bag.

    string sBoss = GetLocalString(oBag, "BOSS_TAG");
    int nRoll;  int nCnt;
    object oItem;
    float fDelay;

    if (sBoss == "CHAMPION")
    {
        string sStoneTag = "";
        nRoll = Random(100) + 1;
        if (nRoll <= 8) sStoneTag = "DMGS_MAGIC";
        else if (nRoll <= 15) sStoneTag = "DMGS_DIVINE";
        else if (nRoll <= 21) sStoneTag = "DMGS_POSITIVE";
        DMGS_CreateStone(oPC, sStoneTag);
        LootCreateGems(oPC, 120000, 100000);
        if (d6() == 1) LootCreateRareLoot(oPC);

        if (nRoll >= 50) // roll for area loot
        {
            string sAreaTag = GetTag(GetArea(oPC));
            string sAreaTag5 = GetStringLeft(sAreaTag, 5);
            object oAreaItem;
            if (sAreaTag == "NIBEL_BASTION")
            {
                oAreaItem = CreateItemOnObject("fistofnibelungen", oPC, 1, "FIST_OF_NIBELUNGEN");
                SetItemCharges(oAreaItem, 9 + d4());
            }
            else if (sAreaTag5 == "MTMOO")
            {
                oAreaItem = CreateItemOnObject("item_magma", oPC, 1, "ITEM_MAGMA");
                SetItemCharges(oAreaItem, 25 + d4());
            }
        }
    }
    else if (sBoss == "GRUUUD")
    {
        oItem = CreateItemOnObject("item_seeds", oPC);
        SetItemCharges(oItem, 10 + d6());
        SetName(oItem, "Dark Cypress Seeds");
        LootCreateGems(oPC, 1200000, 1000000);
        nRoll = d4();
        if (nRoll == 1) CreateTrainingToken(oPC);
        else if (nRoll == 2) DMGS_CreateStone(oPC);
        SetLocalInt(oBag, GetPCPublicCDKey(oPC),1); //records the player looting.
    }
    else if (sBoss == "OHNOS")
    {
        CreateTrainingToken(oPC);
        LootCreateRareLoot(oPC);
    }
    else if (sBoss == "BOSS_HOBGOBLIN")
    {
        nCnt = 0;
        while (nCnt < 6)
        {
            fDelay += 0.1;
            DelayCommand(fDelay, LootCreateGold(oPC, 50000, 45000));
            nCnt++;
        }
        nRoll = d6();
        if (nRoll == 1) CreateTrainingToken(oPC);
        else if (nRoll == 2) DMGS_CreateStone(oPC);
    }
    else if (sBoss == "NOISOME")
    {
        nRoll = 2 + d2();
        while (nCnt < nRoll)
        {
            nCnt++;
            fDelay += 0.1;
            DelayCommand(fDelay, ActionCreateItemOnObject("skeleton_knuckle", oPC, 1, "SKELETON_KNUCKLE"));
        }
        LootCreateGems(oPC, 1200000, 1000000);
        nRoll = d4();
        if (nRoll == 1) CreateTrainingToken(oPC);
        else if (nRoll == 2) DMGS_CreateStone(oPC);
    }
    else if (sBoss == "BOSS_GNOLL")
    {
        CreateItemOnObject("yeenoghuidol", oPC, 1, "YEENOGHU_IDOL");
        LootCreateGems(oPC, 1200000, 1000000);
        nRoll = d2();
        if (nRoll == 1) DMGS_CreateStone(oPC);
        CreateTrainingToken(oPC, nRoll);
        if (d4() == 1) LootCreateRareLoot(oPC);
    }
    else if (sBoss == "DRYAD_BOSS")
    {
        oItem = CreateItemOnObject("item_seeds", oPC);
        SetItemCharges(oItem, 10 + d6());
        SetName(oItem, "Cornflower Seeds");
        LootCreateGems(oPC, 1200000, 1000000);
        DMGS_CreateStone(oPC);
        CreateTrainingToken(oPC);
        LootCreateRareLoot(oPC);
    }
    else if (sBoss == "NEKROS_SHADOW")
    {
        if (d20() == 20)
        {
            oItem = CreateItemOnObject("item_shadow", oPC, 1, "ITEM_SHADOW");
            SetItemCharges(oItem, 24 + d4());
        }
        else LootCreateCharges(oPC, 1 + d4(), "CHARGE_SHADOW");

        return; // return here, no further loot
    }

    // allways some random pots and scrolls if not returned
    int nPots = 2 + d4();
    int nScrolls = 6 - nPots;
    LootCreateScrollPot(oPC, 1, nScrolls + d2(), 60);
    LootCreateScrollPot(oPC, 2, nPots + d2(), 20);
}

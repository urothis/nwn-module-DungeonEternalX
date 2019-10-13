#include "_functions"
#include "chainwonder_inc"
#include "dmg_stones_inc"
#include "_inc_despawn"

// * TREASURE AMOUTNS
const int TREASURE_LOW = 1;
const int TREASURE_MEDIUM = 2;
const int TREASURE_HIGH = 3;
const int TREASURE_BOSS = 4;

// oTarget - create item in this object's inventory
// sWhich - 1 Scrolls, else Pots
// nAmount - The number of items
// nPercent - Percent chance for different scrolls/Pots. use 1 - 100
void LootCreateScrollPot(object oTarget, int nWhich, int nAmount = 1, int nPercent = 80);

// Create Mob Lootbag at oCreature Location
// nCR - CR of oCreature
// oArea - Current Area
void LootCreateLootbag(object oCreature, int nCR = 40);

void LootCreateStoreLoot(object oTarget);

int LootGetBagCR(object oBag);
// use values in 1000 steps

void LootCreateGems(object oTarget, int nValueMax = 1000, int nValueMin = 1000, int nAddToChain = TRUE);

// dont use high values, it creates 1 object every 50.000 gold (2da cap)
void LootCreateGold(object oTarget, int nValueMax = 1, int nValueMin = 1, int nAddToChain = TRUE);

void LootCreateContainerLoot(object oTarget, int nTreasure = TREASURE_LOW);

void LootCreateRareLoot(object oTarget);

object LootGetItemByTag(string sTag);

object LootCreateBossbag(object oCreature, string sTag);

void ActionLootCreateBossbag(object oCreature, string sTag);

//Simple script to move an item from a container to a PC
void LootMoveFromContainer(object oPC, object oItem);

// Create random charge or pick a sTag
// Existing Charges (sTag): CHARGE_NUBFIST, CHARGE_SHADOW, CHARGE_MAGMA
object LootCreateCharges(object oCreateOn, int nCharges = 1, string sTag = "");

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////


object LootGetVariableHolder()
{
    return GetLocalObject(GetModule(), "VARS_LOOT");
}

void XMas_Special(object oPC, object oCreateOn)
{
    int nState = GetLocalInt(oPC, "NW_JOURNAL_ENTRYQUEST_1001");
    if (nState > 0 && nState < 1000)
    {
        if (nState < GetJournalQuestExperience("QUEST_1001"))
        {
            CreateItemOnObject("eastereggs", oCreateOn, 1, "ITEM_ONACQUIRE");
            //CreateItemOnObject("item_xmas", oCreateOn, 1, "ITEM_ONACQUIRE");
        }
    }
}

int LootCountStores()
{
    int nShop = 1;
    int nCnt;
    object oHolder = LootGetVariableHolder();
    object oStore = GetObjectByTag("MAGICSHOP_" + IntToString(nShop));
    while (GetIsObjectValid(oStore))
    {
        SetLocalObject(oHolder, "MAGICSHOP_" + IntToString(nShop), oStore);
        nCnt++;
        nShop++;
        oStore = GetObjectByTag("MAGICSHOP_" + IntToString(nShop));
    }
    SetLocalInt(oHolder, "MAGICSHOP_COUNT", nCnt);
    return nCnt;
}

void LootLoadContainer(object oContainer)
{
    object oHolder = LootGetVariableHolder();
    string sTag = GetTag(oContainer);

    // Shop items, only scrolls and pots
    int nMagicShop = FALSE;
    if (GetStringLeft(sTag, 9) == "MAGICSHOP") nMagicShop = TRUE;

    int nCnt;
    SetLocalObject(oHolder, sTag, oContainer);
    object oItem = GetFirstItemInInventory(oContainer);
    while(GetIsObjectValid(oItem))
    {
        string sItemTag = GetTag(oItem);
        if (nMagicShop) // Check if Pot or Scroll (regular magicshop items)
        {
            int nBaseType = GetBaseItemType(oItem);
            if (nBaseType == BASE_ITEM_POTIONS || nBaseType == BASE_ITEM_SPELLSCROLL)
            {
                nCnt++;
                SetLocalObject(oContainer, "LOOT_ITEM" + IntToString(nCnt), oItem); // store this for random loot
            }
        }
        else // Without baseitemcheck (items only available as random loots)
        {
            nCnt++;
            SetLocalObject(oContainer, "LOOT_ITEM" + IntToString(nCnt), oItem); // store this for random loot
            // Store Object by TAG To find the item later for Area-Drops
            // dont do it with scrolls, to many and not used anyway
            if (sTag != "LOOT_SCROLLS") SetLocalObject(oHolder, sItemTag, oItem);

        }
        oItem = GetNextItemInInventory(oContainer);
    }
    SetLocalInt(oContainer, "LOOT_ITEM_COUNT", nCnt);
}

void LootLoadData()
{
    object oHolder = GetObjectByTag("VARS_LOOT");
    if (!GetIsObjectValid(oHolder))
    {
        WriteTimestampedLogEntry("Error in LootLoadData(), can not find Variable Holder");
        oHolder = GetAreaFromLocation(GetStartingLocation());
    }
    SetLocalObject(GetModule(), "VARS_LOOT", oHolder);

    int nShop = LootCountStores();
    LootLoadContainer(GetObjectByTag("LOOT_SCROLLS"));
    LootLoadContainer(GetObjectByTag("LOOT_POTS"));
    LootLoadContainer(GetObjectByTag("LOOT_RARE"));

    while (nShop > 0)
    {
        LootLoadContainer(GetLocalObject(oHolder, "MAGICSHOP_" + IntToString(nShop)));
        nShop--;
    }
}

object LootGetRandomStore()
{
    object oHolder = LootGetVariableHolder();
    int nShop = GetLocalInt(oHolder, "MAGICSHOP_COUNT");
    nShop = Random(nShop) + 1;
    return GetLocalObject(oHolder, "MAGICSHOP_" + IntToString(nShop));
}

object LootGetRandomItem(object oContainer)
{
    int nID = GetLocalInt(oContainer, "LOOT_ITEM_COUNT");
    nID = Random(nID) + 1;
    return GetLocalObject(oContainer, "LOOT_ITEM" + IntToString(nID));
}

object LootGetItemByTag(string sTag)
{
    return GetLocalObject(LootGetVariableHolder(), sTag);
}

void LootCreateStoreLoot(object oTarget)
{
    object oStore = LootGetRandomStore();
    CopyItem(LootGetRandomItem(oStore), oTarget, TRUE);
}

void LootCreateRareLoot(object oTarget)
{
    object oStore = GetLocalObject(LootGetVariableHolder(), "LOOT_RARE");
    CopyItem(LootGetRandomItem(oStore), oTarget, TRUE);
}

void LootCreateScrollPot(object oTarget, int nWhich, int nAmount = 1, int nPercent = 80)
{
    if (!GetIsObjectValid(oTarget)) return;
    string sWhich = "LOOT_POTS";
    if (nWhich == 1) sWhich = "LOOT_SCROLLS";
    object oContainer = GetLocalObject(LootGetVariableHolder(), sWhich);
    //object oContainer = GetObjectByTag("LOOT_CACHE");
    if (!GetIsObjectValid(oContainer)) return;

    object oItem = LootGetRandomItem(oContainer);
    float fDelay;
    if (nAmount == 1)
    {
        CopyItem(oItem, oTarget);
        return;
    }
    int nCount;
    while (nCount < nAmount)
    {
        DelayCommand(fDelay, ActionCopyItem(oItem, oTarget));
        if (Random(100) + 1 < nPercent) oItem = LootGetRandomItem(oContainer);
        nCount++;
        fDelay += 0.1;
    }
}

void LootDestroyLootbag(object oBag)
{
    if (!GetIsObjectValid(oBag)) return;
    string sTag;
    object oItem = GetFirstItemInInventory(oBag);
    while (GetIsObjectValid(oItem))
    {
        if (GetStringLeft(GetTag(oItem), 5) == "DMGS_") DMGS_UpdateStoneDB(oItem, oItem);
        Insured_Destroy(oItem);
        oItem = GetNextItemInInventory(oBag);
    }
    DestroyObject(oBag);
}

int LootGetBagCR(object oBag)
{
    return GetLocalInt(oBag, "MOB_CR");
}

void LootCreateLootbag(object oCreature, int nCR = 40)
{
    object oBag = CreateObject(OBJECT_TYPE_PLACEABLE, "lootbag", GetLocation(oCreature), FALSE, "LOOTBAG");
    SetLocalInt(oBag, "MOB_CR", nCR);
    AssignCommand(oBag, DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oBag)));
    AssignCommand(oBag, DelayCommand(40.0, LootDestroyLootbag(oBag)));
}

object LootCreateBossbag(object oCreature, string sTag)
{
    object oBag = CreateObject(OBJECT_TYPE_PLACEABLE, "bossbag", GetLocation(oCreature), FALSE, "BOSSBAG");
    SetLocalString(oBag, "BOSS_TAG", sTag);
    AssignCommand(oBag, DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oBag)));
    AssignCommand(oBag, DelayCommand(50.0, LootDestroyLootbag(oBag)));
    return oBag;
}

void ActionLootCreateBossbag(object oCreature, string sTag)
{
    LootCreateBossbag(oCreature, sTag);
}

string LootPickRandomGemResRef(int nRemain)
{
    int nRoll;
     // GEM_15000, GEM_14000, GEM_13000, GEM_12000, GEM_11000, GEM_10000
    if (nRemain >= 15000)
    {
        nRoll = Random(6) + 10; // 10 - 15
        return "gem_" + IntToString(nRoll) + "000";
    }
     // GEM_09000, GEM_08000, GEM_07000, GEM_06000, GEM_05000
    else if (nRemain >= 9000)
    {
        nRoll = Random(5) + 5; // 5 - 9
        return "gem_0" + IntToString(nRoll) + "000";
    }
    // GEM_04000, GEM_03000, GEM_02000, GEM_01000
    else if (nRemain >= 4000)
    {
        nRoll = Random(4) + 1; // 1 - 4
        return "gem_0" + IntToString(nRoll) + "000";
    }
    // GEM_03000, GEM_02000, GEM_01000
    else return "gem_0" + GetStringLeft(IntToString(nRemain), 1) + "000";
}

void LootCreateGems(object oTarget, int nValueMax = 1000, int nValueMin = 1000, int nAddToChain = TRUE)
{
    int nStacksize;
    int nValue;
    int nGemValue;
    float fDelay;
    string sGemResRef;

    if (nValueMin < 1000) nValueMin = 1000;
    if (nValueMax < nValueMin) nValueMax = 1000;

    nValue = nValueMin + (Random(nValueMax - nValueMin) + 1);

    if (nAddToChain) IncChainOfWonder(nValue);

    while (nValue >= 1000)
    {
        sGemResRef = LootPickRandomGemResRef(nValue);
        nGemValue = StringToInt(GetStringRight(sGemResRef, 5));

        if (nValue > 99 * nGemValue) nStacksize = 99;
        else nStacksize = 1;

        fDelay += 0.1;
        AssignCommand(oTarget, DelayCommand(fDelay, ActionCreateItemOnObject(sGemResRef, oTarget, nStacksize)));
        nValue -= nGemValue * nStacksize;
    }
}

void LootCreateGold(object oTarget, int nValueMax = 1, int nValueMin = 1, int nAddToChain = TRUE)
{
    int nStacksize;
    float fDelay;

    if (nValueMin < 1) nValueMin = 1;
    if (nValueMax < nValueMin) nValueMax = 1;

    int nDiff = nValueMax - nValueMin;
    int nValue = nValueMin + Random(nDiff) + 1;

    if (nAddToChain) IncChainOfWonder(nValue);

    while (nValue >= 1)
    {
        if (nValue > 50000) nStacksize = 50000;
        else nStacksize = nValue;

        fDelay += 0.1;
        AssignCommand(oTarget, DelayCommand(fDelay, ActionCreateItemOnObject("nw_it_gold001", oTarget, nStacksize)));
        nValue -= nStacksize;
    }
}

void LootCreateContainerLoot(object oTarget, int nTreasure = TREASURE_LOW)
{
    int nTick = GetTick();
    int nContainerTick = GetLocalInt(oTarget, "TICK");
    int nTime;
    int nValueMin;
    int nValueMax;

    if (!nContainerTick) nTime = 8; // First time opened, set 8 gamehours
    else nTime = nTick - nContainerTick;

    if (nTime < 2) return;
    SetLocalInt(OBJECT_SELF, "TICK", nTick);

    int nRoll;

    if (nTime >= 8) nTime = 8;

    if (nTreasure == TREASURE_LOW)
    {
        nRoll = 100;
        nValueMin = 5000;
        nValueMax = 10000;
    }
    else if (nTreasure == TREASURE_MEDIUM)
    {
        nRoll = 80;
        nValueMin = 10000;
        nValueMax = 20000;
    }
    else if (nTreasure == TREASURE_HIGH)
    {
        nRoll = 60;
        nValueMin = 20000;
        nValueMax = 30000;
    }

    if (Random(nRoll) + 1 < nTime)
    {
        if (d2() == 1) LootCreateCharges(oTarget);
        else LootCreateRareLoot(oTarget);
    }
    //else if (d2() == 1) XMas_Special(GetLastOpenedBy(), oTarget);
    LootCreateGems(oTarget, nValueMax * nTime, nValueMin * nTime);
}

string LootGetChargeName(string sTag)
{
    if (sTag == "CHARGE_NUBFIST")   return "Fist of Nibelungen Charges";
    if (sTag == "CHARGE_SHADOW")    return "Shadow Essence Charges";
    if (sTag == "CHARGE_MAGMA")     return "Mt. Moonmoore Magma Charges";
    return "[INVALID ITEM]";
}

object LootCreateCharges(object oCreateOn, int nCharges = 1, string sTag = "")
{
    if (sTag == "") sTag = PickOne("CHARGE_NUBFIST", "CHARGE_SHADOW", "CHARGE_MAGMA");
    object oItem = CreateItemOnObject("item_charges", oCreateOn, nCharges, sTag);
    SetName(oItem, LootGetChargeName(sTag));
    return oItem;
}

void LootMoveFromContainer(object oPC, object oItem)
{
    ActionCopyItem(oItem, oPC, 1, TRUE);
    Insured_Destroy(oItem);
}


//void main() {}

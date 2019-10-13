#include "inc_traininghall"
#include "random_loot_inc"
#include "fame_inc"
#include "give_custom_exp"
#include "pc_inc"

int GetRewardCount(object oKiller, object oBoss)
{
    int nCount = pcCountParty(oKiller); // how many currently on map
    int nSpawned = GetLocalInt(oBoss, "COUNT_PLAYER_SPAWNED"); // how many did it spawn
    if (nCount > nSpawned) nCount = nSpawned;
    return nCount;
}

void main()
{
    object oBoss = OBJECT_SELF;
    object oKiller = GetLastKiller();
    if (GetIsObjectValid(GetMaster(oKiller))) oKiller = GetMaster(oKiller);

    if (!GetIsPC(oKiller)) return;
    if (GetIsDM(oKiller)) return;
    if (GetIsDMPossessed(oKiller)) return;
    if (!GetIsObjectValid(oKiller)) return;

    string sTag = GetTag(oBoss);

    if (sTag == "NEKROS_SHADOW")
    {
        Q_UpdateQuest(oKiller, "7");
        DEXRewardXP(oKiller, oBoss);
        LootCreateBossbag(oBoss, sTag);
    }
    if (sTag == "BOSS_GNOLL")
    {
        LootCreateBossbag(oBoss, sTag);
        GiveAllPartyMembersFame(oKiller, 15.0, 5.0, "PvE", TRUE);
    }
    else if (sTag == "BOSS_HOBGOBLIN")
    {
        DEXRewardXP(oKiller, oBoss);
        LootCreateBossbag(oBoss, sTag);
    }
    else if (sTag == "OHNOS")
    {
        DeleteLocalInt(GetLocalObject(oBoss, "OHNOS_AREA"), "OHNOS");
        object oBag = LootCreateBossbag(oBoss, sTag);
        object oItem = GetFirstItemInInventory(oBoss);
        while (GetIsObjectValid(oItem))
        {
            CopyItem(oItem, oBag, TRUE);
            Insured_Destroy(oItem);
            oItem = GetNextItemInInventory(oBoss);
        }
        Q_UpdateQuest(oKiller, "12");
        DEXRewardXP(oKiller, oBoss);
    }
    else if (sTag == "DRYAD_BOSS")
    {
        LootCreateBossbag(oBoss, sTag);
        GiveAllPartyMembersFame(oKiller, 30.0, 10.0, "PvE", TRUE);
    }
    else if (GetIsEncounterCreature(oBoss))
    {
        if (sTag == "GRUUUD" || sTag == "NOISOME")
        {
            LootCreateBossbag(oBoss, sTag);
            GiveAllPartyMembersFame(oKiller, 4.0, 2.0, "PvE", TRUE, TRUE);
        }
    }
    else if (GetLocalInt(oBoss, "BOSS"))
    {
        if (sTag == "swamptrog_boss")
        {
            LootCreateLootbag(oBoss, GetHitDice(oKiller));
        }
        else CreateTrainingToken(oBoss, GetRewardCount(oKiller, oBoss));
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oBoss);
}

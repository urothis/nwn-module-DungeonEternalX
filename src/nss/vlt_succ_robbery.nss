#include "dmg_stones_inc"
#include "random_loot_inc"

void ClearBank()
{
    object oMod = GetModule();
    DeleteLocalInt(oMod, "JustRobbed");
    SpeakString("A fresh shipment of coin has arrived at the bank.", TALKVOLUME_SHOUT);
}

void main()
{
    object oPC  = GetLastOpenedBy();
    object oMod = GetModule();
    object oChest = OBJECT_SELF;
    int nRobbed = GetLocalInt(oMod, "JustRobbed");
    if (!nRobbed)
    {
        int nPots = 2 + d6();
        int nScrolls = 8 - nPots;
        CreateItemOnObject("barofsilver", oChest, 1, "BAR_OF_SILVER");
        LootCreateScrollPot(oChest, 1, nScrolls + d2(), 60);
        LootCreateScrollPot(oChest, 2, nPots + d2(), 20);
        LootCreateGems(oChest, 2500000, 2000000);
        if (d2() == 1) DMGS_CreateStone(oChest);
        if (d6() == 1) LootCreateRareLoot(oChest);
        FloatingTextStringOnCreature("You are quite stealthy...", oPC, FALSE);
        SetLocalInt(oMod, "JustRobbed", TRUE);
        DelayCommand(IntToFloat(3000 + Random(1200)), ClearBank());
        string sTRUEID = IntToString(dbGetTRUEID(oPC));
        NWNX_SQL_ExecuteQuery("select st_bankrob from statistics where st_trueid=" + sTRUEID);
        if (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ExecuteQuery("update statistics set st_bankrob=st_bankrob+1 where st_trueid=" + sTRUEID);
        }
        else NWNX_SQL_ExecuteQuery("insert into statistics (st_trueid,st_bankrob) values (" + sTRUEID + ",1)");
    }
    else
    {
        FloatingTextStringOnCreature("The bank vault is empty!!!", oPC, FALSE);
    }
}

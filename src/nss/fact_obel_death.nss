#include "seed_faction_inc"
#include "fame_inc"
#include "quest_inc"

void main()
{
    object oModule   = GetModule();
    object oObelisk  = OBJECT_SELF;
    string sTag      = GetTag(oObelisk);

    if (sTag == "FACTION_OBELISK")
    {
        object oPC = GetLastDamager(oObelisk);
        if (!GetIsPC(oPC) && GetIsPC(GetMaster(oPC))) oPC = GetMaster(oPC); // summon

        Q_UpdateQuest(oPC, "8");
        int nMod;
        string sFAID = GetLocalString(oObelisk, "FAID");
        string sWhich = GetLocalString(oObelisk, "WHICH_OBELISK"); // rank of obelisk

        int nFameFaction = GetFactionStats(sFAID, 3);
        // Fame of faction in next ranking
        int nFameFactionNext = GetFactionStats(GetTopFamousFAID(IntToString(StringToInt(sWhich) + 1)), 3);
        int nFameLost = nFameFaction/100;

        // never drop ranking by losing fame
        if (nFameFaction - nFameLost <= nFameFactionNext) nFameLost = nFameFaction - nFameFactionNext;

        string sFAIDName = SDB_FactionGetName(sFAID);
        string sPlayer = GetName(oPC);

        object oWp = GetLocalObject(oModule, "WP_OBELISK_0");

        nMod = GetRichModifier(3, 2, 1, sFAID); // we are top richest same time?
        if (nMod)
        {
            nMod = (nMod + 4) * (4 - StringToInt(sWhich) + nMod);
            // 42% for top 1 rich and top 1 fame / 7 * 6
            // 35% for top 1 rich and top 2 fame / 7 * 5
            // 28% for top 1 rich and top 3 fame / 7 * 4

            // 30% for top 2 rich and top 1 fame / 6 * 5
            // 24% for top 2 rich and top 2 fame / 6 * 4
            // 18% for top 2 rich and top 3 fame / 6 * 3

            // 20% for top 3 rich and top 1 fame / 5 * 4
            // 15% for top 3 rich and top 2 fame / 5 * 3
            // 10% for top 3 rich and top 3 fame / 5 * 2

            int nRandom = d100();
            if (nRandom < nMod)
            {
                effect eBoom = EffectVisualEffect(464);
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eBoom, GetLocation(oWp));
                AssignCommand(oModule, DelayCommand(3.0, StealFromFaction(oPC, 1.0, 2.0, sFAID, sFAIDName, "Obelisk", 1)));
            }
        }
        ShoutMsg(GetRGB(15,5,1) + sPlayer + " has destroyed " + sFAIDName + "'s Obelisk");
        SendMessageToAllDMs(IntToString(nFameLost));
        NWNX_SQL_ExecuteQuery("update faction set fa_fame=fa_fame-" + IntToString(nFameLost) + " where fa_faid=" + sFAID);
        DeleteLocalObject(oModule, "OBELISK_" + sWhich);
        AssignCommand(oModule, DelayCommand(1.0, RespawnObeliskLock(oWp)));
        AssignCommand(oModule, DelayCommand(1800.0, RespawnFameObelisk(oModule, sWhich, TRUE)));
    }
    else if (sTag == "FACTION_OBELISK_0")
    {
        object oObeliskLock = oObelisk;
        oObelisk = OBJECT_INVALID;
        //DeleteLocalObject(oModule, "OBELISK_0");
        object oWp = GetLocalObject(oModule, "WP_OBELISK_0");
        int nCnt = 1;
        int nDisabled = GetLocalInt(GetModule(), "RAID_DISABLED");

        while (nCnt <= 3)
        {
            oObelisk = GetLocalObject(oModule, "OBELISK_" + IntToString(nCnt));
            if (GetIsObjectValid(oObelisk))
            {
                if (!nDisabled) SetPlotFlag(oObelisk, FALSE);

                effect eEffect = GetFirstEffect(oObelisk);
                while (GetIsEffectValid(eEffect))
                {
                    RemoveEffect(oObelisk, eEffect);
                    eEffect = GetNextEffect(oObelisk);
                }
            }
            nCnt++;
        }

        if (nDisabled)
        {
            FloatingTextStringOnCreature("DM Event: Raids Disabled", GetLastDamager(oObeliskLock));
        }
        else if (GetIsObjectValid(oObelisk)) ShoutMsg("Someone is destroying Faction Obelisks");
        AssignCommand(oModule, DelayCommand(120.0, RespawnObeliskLock(oWp)));
    }
}

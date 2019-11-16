#include "db_inc"
#include "maglu_inc"
#include "quest_inc"
#include "pc_inc"

void main()
{
    object oPC = GetLastDamager(OBJECT_SELF);
    object oStatue = GetNearestObjectByTag("MAGLUBIYET_STATUE", OBJECT_SELF);
    if (!GetIsObjectValid(oStatue)) return;

    int nCall = GetLocalInt(oStatue, "CALL");
    SetLocalInt(oStatue, "CALL", nCall + 1);
    string sTag = GetTag(OBJECT_SELF);

/*
        2 | 1
      3   |   0
        4 | 5
*/

    sTag = GetStringLeft(sTag, 1);
    if (sTag == "0")        sTag = (d2()-1) ? "1" : "5";
    else if (sTag == "1")   sTag = (d2()-1) ? "0" : "5";
    else if (sTag == "2")   sTag = (d2()-1) ? "3" : "4";
    else if (sTag == "3")   sTag = (d2()-1) ? "2" : "4";
    else if (sTag == "4")   sTag = (d2()-1) ? "2" : "3";
    else if (sTag == "5")   sTag = (d2()-1) ? "1" : "0";
    sTag = sTag + "ANGLE";
    int nDoLastXP;

    location lPos = GetLocalLocation(oStatue, sTag);

    object oArea = GetArea(oPC);
    if (nCall > 400)
    {
        AssignCommand(oArea, DelayCommand(4.0, DestroyRunes(oStatue)));
        nDoLastXP = TRUE;
    }
    else if (nCall % 50 == 0) NWNX_SQL_ExecuteQuery("update pwdata set val='" + IntToString(nCall) + "' where name='MAGLUBIYET'");

    if (!nDoLastXP) AssignCommand(oArea, DelayCommand(2.0, ActionCreateObject(OBJECT_TYPE_PLACEABLE, "maglubiyet_stone", lPos, FALSE, sTag)));

    int nRealLevel;     int nXP;
    MusicBattlePlay(oArea);
    object oPartyMember = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oPartyMember))
    {
        if (oArea == GetArea(oPartyMember))
        {
            if (GetCurrentHitPoints(oPartyMember) > 0)
            {
                if (GetDistanceBetween(OBJECT_SELF, oPartyMember) < 20.0)
                {
                    nRealLevel = pcGetHDFromXP(GetXP(oPartyMember), GetHitDice(oPartyMember));
                    nXP = 4000/nRealLevel;
                    if (nXP > 200) nXP = 200;
                    nXP += 15 * nRealLevel;
                    nXP = nXP / 3 + (nCall/2);
                    if (nDoLastXP)
                    {
                        Q_UpdateQuest(oPartyMember, "6");
                        nXP *= 20;
                    }
                    GiveXPToCreature(oPartyMember, nXP);
                    FloatingTextStringOnCreature(IntToString(nXP) + "xp", oPartyMember, FALSE);
                }
            }
        }
        oPartyMember = GetNextFactionMember(oPC);
    }
}

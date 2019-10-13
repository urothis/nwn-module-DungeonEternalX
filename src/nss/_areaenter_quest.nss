#include "quest_inc"

void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;
    if (GetIsDMPossessed(oPC)) return;

    object oArea = OBJECT_SELF;
    ExploreAreaForPlayer(oArea, oPC, FALSE);

    string sTag = GetTag(oArea);

    if (sTag == "MAP_ENCHASSARA_CAVE_2")
    {
        if (!GetLocalInt(oPC, "DO_GOBLIN_VS_DRYAD"))
        {
            AssignCommand(oPC, JumpToLocation(GetStartingLocation()));
            return;
        }

        if (GetIsObjectValid(GetLocalObject(oArea, "DRYAD_BOSS"))) return;

        BlackScreen(oPC);
        DelayCommand(1.0, FadeFromBlack(oPC));

        DeleteLocalInt(oPC, "DO_GOBLIN_VS_DRYAD");
        SetLocalObject(oArea, "DRYAD_BOSS_PLAYER", oPC);
        SpawnDryadBoss(oPC, oArea);

        object oWP = GetNearestObjectByTag("WP_DRYAD_GOBLINS1", oPC);
        object oGoblin = CreateObject(OBJECT_TYPE_CREATURE, "goblin_witchdoct", GetLocation(oWP), FALSE, "WITCH_DOCTOR");
        oWP = GetNearestObjectByTag("WP_DRYAD_GOBLINS2", oPC);
        oGoblin = CreateObject(OBJECT_TYPE_CREATURE, "goblin_witchdoct", GetLocation(oWP), FALSE, "WITCH_DOCTOR");
    }
    else if (sTag == "MAP_ENCHASSARA_CAVE")
    {
        if (!GetHasTimePassed(oArea, 15, "DRYAD_BOSS")) return;
        else if (GetIsObjectValid(GetLocalObject(oArea, "DRYAD_BOSS"))) return;
        int nNonHostile;
        if (Q_GetHasQuest(oPC, "6", FALSE) || d6() == 1) nNonHostile = TRUE;
        DelayCommand(0.1, SpawnDryadBoss(oPC, oArea, nNonHostile));
    }
    else if (sTag == "MAP_PEACEFUL_GRAVES")
    {
        if (Q_GetHasQuest(oPC, "4", FALSE) || (d6() == 1 && GetHasTimePassed(oArea, 5, "FREDERICK")))
        {
            if (GetIsObjectValid(GetLocalObject(oArea, "FREDERICK"))) return;

            object oWP = GetNearestObjectByTag("WP_BINDSTONE", oPC);
            object oFrederick = CreateObject(OBJECT_TYPE_CREATURE, "frederick", GetLocation(oWP), FALSE, "FREDERICK");
            SetLocalObject(oArea, "FREDERICK", oFrederick);
        }
    }
}


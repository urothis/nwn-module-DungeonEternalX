//spawn our monsters in the vault explicitly and not by encounters... I don't want them despawning.

#include "rune_include"

void main()
{
    object oMod = GetModule();

    object oEnteringObject = GetEnteringObject();
    if(GetIsDM(oEnteringObject) || !GetIsPC(oEnteringObject)) return;

    //boot those entering with a skill bonus rune active on them
    if (GetLocalInt(oEnteringObject, "RUNE_EFFECT") == RUNE_EFFECT_SKILL_INCREASE)
    {
        location lLoft = GetLocation(GetObjectByTag("TELE_Loftenwood"));
        AssignCommand(oEnteringObject, ActionJumpToLocation(lLoft));
        AssignCommand(oEnteringObject, ActionSpeakString( "Havok is so mean... he won't let me exploit the skill rune so I can rob the bank :-(", TALKVOLUME_TALK));
    }

    object oEntrance   = GetObjectByTag("LoftVaultPortal");
    location lEntrance = GetLocation(oEntrance);
    int nPlayersOnMap  = GetLocalInt(oMod, "PlayersOnMap");

    AssignCommand(oEnteringObject, ActionJumpToLocation(lEntrance));

    if (!nPlayersOnMap)
    {
        int i;
        string sWayPoint;
        object oWayPoint;
        object oGuardTemp;
        location lWayPoint;
        string sGuardResRef = "vaultguard";
        float fDelay;

        nPlayersOnMap++;
        SetLocalInt(oMod, "PlayersOnMap", nPlayersOnMap);
        for (i = 1; i < 10; i++)
        {
            sWayPoint = "VAULT_WAYPOINT00"+IntToString(i);
            oWayPoint = GetNearestObjectByTag(sWayPoint, oEntrance);
            if (GetIsObjectValid(oWayPoint))
            {
                lWayPoint = GetLocation(oWayPoint);
                DelayCommand(fDelay, ActionCreateObject(OBJECT_TYPE_CREATURE, sGuardResRef, lWayPoint, FALSE));
                DelayCommand(fDelay, ActionCreateObject(OBJECT_TYPE_CREATURE, sGuardResRef, lWayPoint, FALSE));
                fDelay += 0.5;
            }
        }
        for (i = 10; i < 19; i++)
        {
            fDelay = 0.0;
            sWayPoint = "VAULT_WAYPOINT0"+IntToString(i);
            oWayPoint = GetNearestObjectByTag(sWayPoint, oEntrance);
            if (GetIsObjectValid(oWayPoint))
            {
                lWayPoint = GetLocation(oWayPoint);
                DelayCommand(fDelay, ActionCreateObject(OBJECT_TYPE_CREATURE, sGuardResRef, lWayPoint, FALSE));
                DelayCommand(fDelay, ActionCreateObject(OBJECT_TYPE_CREATURE, sGuardResRef, lWayPoint, FALSE));
                fDelay += 0.5;
            }
        }
    }
    else
    {
        nPlayersOnMap++;
        SetLocalInt(oMod, "PlayersOnMap", nPlayersOnMap);
    }
}

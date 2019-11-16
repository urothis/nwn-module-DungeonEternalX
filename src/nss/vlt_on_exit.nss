//spawn our monsters in the vault explicitly and not by encounters... I don't want them despawning.

void main()
{
    object oExitingObject = GetExitingObject();
    if ((GetIsDM(oExitingObject) == TRUE) || (GetIsPC(oExitingObject) == FALSE)) return;

    object oMod = GetModule();
    int nPlayersOnMap = GetLocalInt( oMod, "PlayersOnMap" );

    nPlayersOnMap = nPlayersOnMap - 1;
    if (nPlayersOnMap < 0) nPlayersOnMap = FALSE;

    if (!nPlayersOnMap)
    {
        //open and unlock all doors. Then close the wooden doors and
        //the actual vault doors. Then lock the vault doors.
        int i;
        object oGuardTemp;
        object oDoorTemp = GetFirstObjectInArea(GetArea(OBJECT_SELF));
        string sDoorTag;

        for (i = 1; i < 12; i++)
        {
            sDoorTag = "VaultDoor" + IntToString(i);
            oDoorTemp = GetNearestObjectByTag(sDoorTag, oDoorTemp);
            AssignCommand(oDoorTemp, ActionCloseDoor(oDoorTemp));
            SetLocked(oDoorTemp, TRUE);
        }

        //despawn the guards
        DeleteLocalInt(oMod, "PlayersOnMap");
        float fDelay;
        for (i = 1; i < 40; i++)
        {
            //start from the last door and grab all the guards
            oGuardTemp = GetNearestObjectByTag("VaultGuard", oDoorTemp, i);
            if (oGuardTemp == OBJECT_INVALID) break;
            DestroyObject(oGuardTemp, fDelay);
            fDelay += 0.5;
        }
    }
    else SetLocalInt(oMod, "PlayersOnMap", nPlayersOnMap);

    ExecuteScript("_mod_areaexit", OBJECT_SELF);
}

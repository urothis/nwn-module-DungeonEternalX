void main()
{
    //Gets who is talking to the death dealer
    object oPC = GetPCSpeaker();

    //Send the player to the waypoint
    AssignCommand (oPC, ActionJumpToObject (GetWaypointByTag ("DeathRespawn")));
}


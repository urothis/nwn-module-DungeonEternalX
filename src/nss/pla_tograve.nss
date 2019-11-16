void main()
{
    object oUser = GetLastUsedBy();
    object oTarget = GetWaypointByTag ("wp_fromcre");
    AssignCommand (oUser,JumpToObject(oTarget));
    AssignCommand(GetObjectByTag("gravewell"),ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE));
}

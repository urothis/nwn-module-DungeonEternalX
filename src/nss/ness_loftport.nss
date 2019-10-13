void main()
{
    object oPC = GetLastUsedBy();
    object oTarget;
    location lTarget;
    oTarget = GetWaypointByTag("NW_GTFO_TAV");
    lTarget = GetLocation(oTarget);
    AssignCommand(oPC, ClearAllActions());

    DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

    oTarget = oPC;

    //Visual effects can't be applied to waypoints, so if it is a WP
    //the VFX will be applied to the WP's location instead

    int nInt;
    nInt = GetObjectType(oTarget);

    if (nInt != OBJECT_TYPE_WAYPOINT) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oTarget);
    else ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTarget));
}

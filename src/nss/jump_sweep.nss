void main()
{
    object oPC = GetClickingObject();
    object oWP = GetLocalObject(OBJECT_SELF, "SWEEPING_WP");
    if (!GetIsObjectValid(oWP))
    {
        object oModule = GetModule();
        string sSweep = GetLocalString(oModule, "WHICH_SWEEP"); // Set at Module Load
        string sWhich = GetTag(OBJECT_SELF) + "_" + sSweep + "_WP";
        oWP = GetWaypointByTag(sWhich);
        SetLocalObject(OBJECT_SELF, "SWEEPING_WP", oWP);
    }
    location lTarget = GetLocation(oWP);
    AssignCommand(oPC, JumpToLocation(lTarget));
}

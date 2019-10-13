void main()
{
    ExecuteScript("_mod_areaenter", OBJECT_SELF);
    object oPC = GetEnteringObject();
    if(GetIsPC(oPC))
    {
        SetLocalInt(oPC, "PORTS_DEACTIVATE", TRUE);
    }
}

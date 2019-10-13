void main()
{
    object oPC = GetPCSpeaker();
    location lTP = GetLocalLocation(oPC, "TP_TARGET");
    string sFAID = GetLocalString(GetAreaFromLocation(lTP), "FAID");
    string sAreaTag = GetTag(GetAreaFromLocation(lTP));
    if ((sFAID != "") || (sAreaTag == "TheFort"))
    {
        SendMessageToPC(oPC, "Sorry, Magical Portals are verboten in this Area!");
        return;
    }
    DeleteLocalLocation(oPC, "TP_TARGET");
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(472), GetLocation(oPC));
    SetLocalInt(oPC, "DO_PORT_FX", TRUE);
    AssignCommand(oPC, DelayCommand(1.0, JumpToLocation(lTP)));
}

void main()
{
    object oPC = GetLastUsedBy();

    ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_DEATH_ARMOR), oPC);
    string sFAID = GetLocalString(GetArea(OBJECT_SELF), "FAID");
    location lTarget = GetLocation(GetObjectByTag("WP_BOSSLAIR_" + sFAID));
    DelayCommand(0.5f, AssignCommand(oPC, JumpToLocation(lTarget)));
}

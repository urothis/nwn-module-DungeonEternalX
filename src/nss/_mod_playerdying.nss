    // Bleeding on Dying script (nearly accurate to 3rd Edition rules)
    // It can be removed if its not wanted

void PopDG(object oPC)
{
    if (GetCurrentHitPoints(oPC) > -10 && GetCurrentHitPoints(oPC) < 0 )
    {
        PopUpDeathGUIPanel(oPC, 1, 1, 0, "Your are bleeding to death, you may either respawn or wait for help.  Logging at this point is considered an exploit, so respawn before logging out.");
    }
}

    // End Bleeding Script

void main()
{
    object oPC = GetLastPlayerDying();
    SetLocalObject(oPC, "KILLER", GetLastAttacker(oPC));
//    Removed for Dying script
//    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC); /* now kill them */

    // Bleeding on Dying script (nearly accurate to 3rd Edition rules)
    // It can be removed if its not wanted
    if (GetIsPC(oPC) == TRUE)
    {
        object iAt = GetLastAttacker(oPC);
        AssignCommand(iAt,ClearAllActions(TRUE));
        AssignCommand(oPC, ClearAllActions(TRUE));
        int iHP = GetCurrentHitPoints(oPC);
        SetLocalInt(oPC,"LAST_HP",iHP);
        DelayCommand(15.0,PopDG(oPC));
    }
    // End Bleeding Script
}

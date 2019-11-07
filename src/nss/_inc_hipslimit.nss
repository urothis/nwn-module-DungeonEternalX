//THis is updated version.  Ima work more on it if it still doesnt work.

const float THINK_DELAY = 0.25;

//limit if they have HIPS but are not an epic shadowdancer
int GetLimitHIPS(object oPC)
{
    if (GetHasFeat(FEAT_EPIC_SHADOWDANCER, oPC))
        return FALSE;
    if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC))
        return TRUE;
    return FALSE;
}

void DoHideCheck(float nTimeLeft)
{
    if (nTimeLeft<=0.0)
        return;

    //Check all players
    object oPC = GetFirstPC();
    while(oPC!=OBJECT_INVALID)
    {
        int nHideMe = FALSE;
        if (GetLimitHIPS(oPC)) //only check certain characters
        {
            int nHiding = GetActionMode(oPC, ACTION_MODE_STEALTH);
            int nAutoHide = GetLocalInt(oPC, "AUTO_HIDE");
            float nTimeHide = GetLocalFloat(oPC, "TIME_HIDDEN");

            if (nHiding)
            {
                if (nTimeHide > 0.0 && nTimeHide!=26.0)
                {
                    SetLocalInt(oPC, "AUTO_HIDE", TRUE);
                    SetActionMode(oPC, ACTION_MODE_STEALTH, FALSE);
                    FloatingTextStringOnCreature("*You will hide in "+IntToString(FloatToInt(nTimeHide))+" seconds*", oPC, FALSE);
                }
                else
                    nHideMe = TRUE;
            }
            else if (nAutoHide && nTimeHide<=0.0)
                nHideMe = TRUE;

            //if they lag, they can still send the command and itll happen once they're ready
            if (nHideMe)
            {
                SetLocalInt(oPC, "AUTO_HIDE", FALSE);
                SetLocalFloat(oPC, "TIME_HIDDEN", 24.0);
                if (!nHiding)
                    SetActionMode(oPC, ACTION_MODE_STEALTH, TRUE);
            }
            else
            {
                if (nTimeHide>0.0)
                    SetLocalFloat(oPC, "TIME_HIDDEN", nTimeHide-THINK_DELAY);
                else if (nTimeHide<0.0)
                    SetLocalFloat(oPC, "TIME_HIDDEN", 0.0);
            }
        }
        else
            SetLocalFloat(oPC, "TIME_HIDDEN", 0.0);

        oPC = GetNextPC();
    }

    //Check again you fag
    DelayCommand(THINK_DELAY, DoHideCheck(nTimeLeft-THINK_DELAY));
}

void main()
{
    DoHideCheck(24.0-THINK_DELAY); //think for persistant checks
}
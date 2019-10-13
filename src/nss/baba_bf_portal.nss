#include "_functions"
#include "_inc_death"

void main()
{
    object oPC = GetLastUsedBy();

    ////////////////////////
    //Disabled for now
    //FloatingTextStringOnCreature("Disabled for now because it doesn't work.", oPC);
    //return;
    ////////////////////////

    if (GetHitDice(oPC) < 40)
    {
        FloatingTextStringOnCreature("You must be level 40 to use this.", oPC);
        return;
    }

    string sTag = GetTag(OBJECT_SELF);
    string sFAID = GetLocalString(GetArea(OBJECT_SELF), "FAID");
    object oTarget;

    oTarget = GetWaypointByTag("WP_BATTLEFIELD_CENTRE_" + IntToString(d4()));
    SetLocalInt(oPC, "DO_PORT_FX", TRUE);
    ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_DEATH_ARMOR), oPC);
    DelayCommand(0.5, AssignCommand(oPC, JumpToObject(oTarget)));
}

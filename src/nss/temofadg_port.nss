#include "_functions"
#include "_inc_death"

// Duplicate of Faction Battlefield port for porting to Temple - Veng

void main()
{
    object oPC = GetLastUsedBy();
    /*if (GetHitDice(oPC) < 40)
    {
        return;
    }  */

    string sTag = GetTag(OBJECT_SELF);
    string sFAID = GetLocalString(GetArea(OBJECT_SELF), "FAID");
    object oTarget;

    oTarget = GetWaypointByTag("WP_Templeportal");
    SetLocalInt(oPC, "DO_PORT_FX", TRUE);
    ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_DEATH_ARMOR), oPC);
    DelayCommand(0.5, AssignCommand(oPC, JumpToObject(oTarget)));
}

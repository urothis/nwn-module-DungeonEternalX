#include "inc_traininghall"
#include "_inc_port"

void main()
{
    object oPC = GetEnteringObject();
    AssignCommand(oPC, ClearAllActions(TRUE));

    if (!GetIsDM(oPC) || !GetIsPC(oPC))
    {
        if (GetTag(oPC) != "DM_GHOST")
        {
            DestroyObject(oPC);
            return;
        }
    }
    SetPortMode(oPC, PORT_NOT_ALLOWED);
    // See file "inc_traininghall" for more informations
    if (GetIsTestChar(oPC))
    {
        JumpToTraininghalls(oPC);
    }
    else if (GetLocalInt(oPC, "JAILED"))
    {
        AssignCommand(oPC, JumpToObject(GetWaypointByTag ("WP_JAIL")));
    }
    SetLocalInt(oPC, "i_TI_LastRest", 0);
    SetLocalInt(oPC, "PORTS_DEACTIVATE", TRUE);
    effect NoMagic = ExtraordinaryEffect(EffectSpellFailure());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, NoMagic, oPC);
    ExecuteScript("_mod_areaenter", OBJECT_SELF);
}

#include "_functions"
#include "_inc_death"

void main()
{
    object oPC = GetLastUsedBy();
    if (!GetIsObjectValid(oPC)) return;

    string sTag = GetTag(OBJECT_SELF);
    string sFAID = GetLocalString(GetArea(OBJECT_SELF), "FAID");
    object oTarget;

    if (sTag == "FACTION_PORTAL_APPROACH")
    {
        oTarget = GetWaypointByTag("WP_FACT_APPROACH_" + sFAID + "_" + IntToString(d3()));
        SetLocalInt(oPC, "DO_PORT_FX", TRUE);
    }
    else if (sTag == "FACTION_PORTAL_BATTLEFIELD")
    {
        return; //Disabling this for now.
        oTarget = GetWaypointByTag("WP_BATTLEFIELD_CENTRE_" + IntToString(d4()));
        SetLocalInt(oPC, "DO_PORT_FX", TRUE);
    }
    else if (sTag == "FACTION_PORTAL_CASTLE")
    {
        float fDelay = 0.5;
        oTarget = GetNearestObjectByTag("WP_FACTION_CASTLE", OBJECT_SELF, d3());

        object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
        if (GetIsObjectValid(oSummon))
        {
            DelayCommand(0.5+fDelay, AssignCommand(oSummon, JumpToObject(oTarget)));
            fDelay += 0.5;
        }
        oSummon = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
        if (GetIsObjectValid(oSummon))
        {
            DelayCommand(0.5+fDelay, AssignCommand(oSummon, JumpToObject(oTarget)));
            fDelay += 0.5;
        }
        oSummon = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
        if (GetIsObjectValid(oSummon))
        {
            DelayCommand(0.5+fDelay, AssignCommand(oSummon, JumpToObject(oTarget)));
            fDelay += 0.5;
        }
        oSummon = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
        if (GetIsObjectValid(oSummon))
        {
            DelayCommand(0.5+fDelay, AssignCommand(oSummon, JumpToObject(oTarget)));
            fDelay += 0.5;
        }
    }
    else if (sTag == "FACTION_PORTAL_LAIR")
    {
        if (GetLocalInt(GetModule(), "RAID_DISABLED"))
        {
            FloatingTextStringOnCreature("DM Event: Raids Disabled", oPC);
            return;
        }
        if (!GetLocalInt(OBJECT_SELF, "PORTAL_DOOR_DESTROYED"))
        {
            object oDoor = GetNearestObjectByTag("FACTION_PORTAL_DOOR");
            if (GetIsObjectValid(oDoor))
            {
                effect eFX = EffectVisualEffect(VFX_FNF_SWINGING_BLADE);
                effect eDamage = EffectDamage(5000);
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC));
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
                DelayCommand(1.0, DeathDoVFX(oPC));
                return;
            }
            else SetLocalInt(OBJECT_SELF, "PORTAL_DOOR_DESTROYED", TRUE);
        }
        SetLocalInt(oPC, "DO_PORT_FX", TRUE);
        oTarget = DefGetObjectByTag("WP_BOSSLAIR_" + sFAID);
    }
    ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_DEATH_ARMOR), oPC);
    DelayCommand(0.5, AssignCommand(oPC, JumpToObject(oTarget)));
}

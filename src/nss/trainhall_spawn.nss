#include "_inc_despawn"

void DestroyDummy(object oToDespawn)
{
    if (GetIsObjectValid(oToDespawn)) DestroyObject(oToDespawn);
}

void main()
{
    string sDummy = GetTag(OBJECT_SELF);
    location lLocation = GetLocation(GetWaypointByTag(sDummy));
    object oObject = GetFirstObjectInShape(SHAPE_SPHERE, 1.0, lLocation);

    while (GetIsObjectValid(oObject)){
        if (GetTag(oObject) == "TRAINHALL_DUMMY") return;
        oObject = GetNextObjectInShape(SHAPE_SPHERE, 1.0, lLocation);
    }

    effect eEffect = EffectCutsceneParalyze();
    string sName;

    if (sDummy == "WP_DUMMY2"){
        eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
        sName = " (Sneak Immune)";
    }
    else if (sDummy == "WP_DUMMY3"){
        eEffect = EffectLinkEffects(eEffect, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
        sName = " (Critical Immune)";
    }

    object oDummy = CreateObject(OBJECT_TYPE_CREATURE, "trainhall_dummy", lLocation);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oDummy);
    SetName(oDummy, GetName(oDummy, TRUE) + sName);
    AssignCommand(GetArea(oDummy), DelayCommand(120.0, DestroyDummy(oDummy)));
}

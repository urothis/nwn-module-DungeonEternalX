#include "seed_faction_inc"

void RespawnDoor(object oDoor, object oInnerDoor)
{
    PlayAnimation(ANIMATION_DOOR_CLOSE);
    AssignCommand(oInnerDoor, PlayAnimation(ANIMATION_DOOR_CLOSE));

    int nHealAmount = GetMaxHitPoints(oDoor) - GetCurrentHitPoints(oDoor);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHealAmount), oDoor);

    nHealAmount = GetMaxHitPoints(oInnerDoor) - GetCurrentHitPoints(oInnerDoor);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHealAmount), oInnerDoor);
    SetPlotFlag(oInnerDoor, TRUE);
}

void main()
{
    object oDoor = OBJECT_SELF;
    string sFAID = GetLocalString(GetArea(OBJECT_SELF), "FAID");
    string sFaction = SDB_FactionGetName(sFAID);
    string sMsg;

    if (GetTag(oDoor) == "FACTION_PORTAL_DOOR")
    {
        sMsg = sFaction + "'s Portal door has been breached.";
    }
    else // The castle door
    {
        SetIsDestroyable(FALSE);
        object oInnerDoor = DefGetObjectByTag("FACT_" + sFAID + "_CASTLE_MAIN");
        AssignCommand(oInnerDoor, SetIsDestroyable(FALSE));
        SetPlotFlag(oInnerDoor, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(9999), oInnerDoor);
        DelayCommand(300.0, RespawnDoor(oDoor, oInnerDoor));
        sMsg = sFaction + "'s Castle door has been breached.";
    }

    DeleteLocalInt(oDoor, "LASTDAMAGE");
    ShoutMsg(sMsg);
}

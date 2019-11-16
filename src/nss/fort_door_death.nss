#include "seed_faction_inc"

void RespawnDoor(object oDoor)
{
    PlayAnimation(ANIMATION_DOOR_CLOSE);

    int nHealAmount = GetMaxHitPoints(oDoor) - GetCurrentHitPoints(oDoor);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHealAmount), oDoor);

    //nHealAmount = GetMaxHitPoints(oInnerDoor) - GetCurrentHitPoints(oInnerDoor);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHealAmount), oInnerDoor);

    //SetPlotFlag(oInnerDoor, TRUE);
}

void main()
{
    object oDoor = OBJECT_SELF;
    //object oInnerDoor;

    string sMsg;

    if ((GetTag(oDoor) == "Fort_Inner_1") || (GetTag(oDoor) == "Fort_Inner_2"))
    {
        sMsg = "The Fort barricade has been breached.";
        SetIsDestroyable(FALSE);

/*        if(GetTag(oDoor) == "Fort_Inner_1")
        {
            oInnerDoor = DefGetObjectByTag("Fort_Outer_1");
            AssignCommand(oInnerDoor, SetIsDestroyable(FALSE));
            SetPlotFlag(oInnerDoor, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(9999), oInnerDoor);
        }
*/

        //DelayCommand(240.0, RespawnDoor(oDoor, oInnerDoor));

        DelayCommand(240.0, RespawnDoor(oDoor));

    }

    DeleteLocalInt(oDoor, "LASTDAMAGE");
    ShoutMsg(sMsg);
}

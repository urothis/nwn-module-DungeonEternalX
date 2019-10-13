//::///////////////////////////////////////////////
//:: Associate: Heartbeat
//:://////////////////////////////////////////////

#include "x0_i0_position"
#include "_functions"

void Disappear()
{
    ClearAllActions();
    ActionJumpToObject(GetLocalObject(OBJECT_SELF, "BASE_WP"));
}

void main()
{
    object oMaster = GetLocalObject(OBJECT_SELF, "MASTER");
    if (!GetIsObjectValid(oMaster))
    {
        Insured_Destroy(OBJECT_SELF);
        return;
    }
    object oAreaSelf = GetArea(OBJECT_SELF);
    object oAreaMaster = GetArea(oMaster);

    if (oAreaSelf != oAreaMaster)
    {
        Insured_Destroy(OBJECT_SELF);
        return;
    }
    if (oAreaSelf != GetLocalObject(OBJECT_SELF, "AREA"))
    {
        Insured_Destroy(OBJECT_SELF);
        return;
    }
    if (IsInConversation(OBJECT_SELF)) return;

    int nCurrentHP = GetCurrentHitPoints(oMaster);
    int nMaxHP = GetMaxHitPoints(oMaster);
    if (nCurrentHP < 0)
    {
        Insured_Destroy(OBJECT_SELF);
        return;
    }
    float fDist = GetDistanceToObject(oMaster);
    if (fDist > 15.0)
    {
        ActionForceMoveToObject(oMaster, TRUE, 8.0);
    }
    else if (nCurrentHP < nMaxHP)
    {
        if (fDist > 6.0) ClearAllActions();
        ActionCastSpellAtObject(SPELL_HEAL, oMaster, METAMAGIC_ANY, TRUE);
    }
    else if (fDist < 1.0)
    {
        ActionMoveAwayFromObject(oMaster, TRUE, 3.0);
    }
}





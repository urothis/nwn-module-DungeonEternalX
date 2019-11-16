//::///////////////////////////////////////////////
//:: End of Combat Round
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"
#include "pg_lists_i"

void main()
{

    string sTag = GetTag(OBJECT_SELF);

    if (sTag == "WITCH_DOCTOR")
    {
        object oArea = GetArea(OBJECT_SELF);
        object oPC = GetLocalObject(oArea, "DRYAD_BOSS_PLAYER");

        if (GetIsObjectValid(oPC))
        {
            int nCurrentHP = GetCurrentHitPoints(oPC);
            if (nCurrentHP < GetMaxHitPoints(oPC) && nCurrentHP > 0)
            {
                ClearAllActions();
                ActionCastSpellAtObject(SPELL_HEAL, oPC, METAMAGIC_ANY, TRUE);
                return;
            }
            else if (nCurrentHP < 1 || GetArea(oPC) != oArea)
            {
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(OBJECT_SELF));
                DestroyObject(OBJECT_SELF);
                return;
            }
        }
    }
    if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
    {
        DetermineSpecialBehavior();
    }
    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
       DetermineCombatRound();
    }
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }
}





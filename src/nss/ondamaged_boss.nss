#include "NW_I0_GENERIC"
#include "quest_inc"

void main()
{
    string sTag = GetTag(OBJECT_SELF);
    object oDamager = GetLastDamager(OBJECT_SELF);

    if (sTag == "WITCH_DOCTOR")
    {
        object oDryad = GetLocalObject(OBJECT_SELF, "DRYAD_BOSS");
        if (!GetIsObjectValid(oDryad))
        {
            oDryad = GetNearestObjectByTag("DRYAD_BOSS", OBJECT_SELF);
            if (!GetIsObjectValid(oDryad))
            {
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(OBJECT_SELF));
                DestroyObject(OBJECT_SELF);
                return;
            } else SetLocalObject(OBJECT_SELF, "DRYAD_BOSS", oDryad);
        }

        SetCommandable(TRUE);
        ClearAllActions();
        SpeakString("*ayeeee*");
        ActionMoveAwayFromObject(oDamager, TRUE);
        SetCommandable(FALSE);
        DelayCommand(3.0, SetCommandable(TRUE));
        DelayCommand(3.0, ActionUseFeat(FEAT_HIDE_IN_PLAIN_SIGHT, OBJECT_SELF));
        DelayCommand(5.5, ClearAllActions());
        DelayCommand(6.0, DetermineCombatRound());
    }
    else if (sTag == "DRYAD_HULK")
    {
        SetCommandable(TRUE);
        ClearAllActions();
        ActionAttack(oDamager);
    }
    else if (sTag == "DRYAD_BOSS")
    {
        ExecuteScript("nw_c2_default6", OBJECT_SELF);
    }
    else if (sTag == "DRYAD_NONHOSTILE")
    {
        if (GetLocalInt(OBJECT_SELF, "GOING_HOSTILE")) return;
        SetLocalInt(OBJECT_SELF, "GOING_HOSTILE", TRUE);
        ClearAllActions();
        object oArea = GetArea(OBJECT_SELF);
        location lLoc = GetLocation(OBJECT_SELF);
        AssignCommand(oArea, DelayCommand(2.0, SpawnDryadBoss(oDamager, oArea)));
        AssignCommand(oArea, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), lLoc));
        DelayCommand(0.1, DestroyObject(OBJECT_SELF));
    }
    else if (sTag == "HEALING_NADIA" || sTag == "FREDERICK")
    {
        ClearAllActions();
        PlayVoiceChat(VOICE_CHAT_FLEE, OBJECT_SELF);
        ActionMoveAwayFromObject(GetLastDamager());
        SetCommandable(FALSE);
        DelayCommand(2.0, DestroyObject(OBJECT_SELF));
    }
}





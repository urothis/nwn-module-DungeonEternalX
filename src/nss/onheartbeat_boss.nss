#include "_functions"
#include "nw_i0_generic"

void main()
{
    string sTag = GetTag(OBJECT_SELF);

    if (sTag == "NEKROS_SHADOW")
    {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
        if (!GetIsObjectValid(oPC))
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(OBJECT_SELF));
            DestroyObject(OBJECT_SELF);
            return;
        }
        else if (d2() == 1)
        {
            if (!GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, OBJECT_SELF))
            {
                ClearAllActions();
                AssignCommand(OBJECT_SELF, ActionCastSpellAtObject(SPELL_INVISIBILITY_SPHERE, OBJECT_SELF, METAMAGIC_ANY, TRUE));
            }
        }
    }
    else if (sTag == "DRYAD_BOSS")
    {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
        if (!GetIsObjectValid(oPC))
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(OBJECT_SELF));
            DestroyObject(OBJECT_SELF);
            return;
        }
    }
    else if (sTag == "DRYAD_HULK")
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

        object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oDryad, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        if (GetIsObjectValid(oTarget))
        {
            if (GetPlotFlag(oTarget)) SetPlotFlag(oTarget, FALSE);
            ActionAttack(oTarget);
        }
        else ActionCastSpellAtObject(SPELL_GREATER_RESTORATION, oDryad, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT);

        SetCommandable(FALSE);
    }
}


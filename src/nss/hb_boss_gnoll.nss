//:://////////////////////////////////////////////////
/*

  Gnoll Boss OnHeartbeat

*/
//:://////////////////////////////////////////////////
#include "x0_i0_match"
#include "_functions"
#include "effect_inc"

void main()
{
    location lLoc;
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    if (GetArea(oPC) != GetArea(OBJECT_SELF))
    {
        lLoc = GetLocation(OBJECT_SELF);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), lLoc);
        DestroyObject(OBJECT_SELF);
        return;
    }
    else if (!GetObjectSeen(oPC)) // same area but nearest player is hiding
    {
        lLoc = GetLocation(GetNearestObjectByTag("WP_HYENA_4", oPC));
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), lLoc);
        CreateObject(OBJECT_TYPE_CREATURE, "dire_hyena", lLoc, FALSE, "DIRE_HYENA_SEARCH");
    }

    if (GetPlotFlag())
    {
        if (!GetIsObjectValid(GetLocalObject(OBJECT_SELF, "HYENA_1")) && !GetIsObjectValid(GetLocalObject(OBJECT_SELF, "HYENA_2")) && !GetIsObjectValid(GetLocalObject(OBJECT_SELF, "HYENA_3")))
        {
            SetPlotFlag(OBJECT_SELF, FALSE);
            StripAllEffects(OBJECT_SELF);
            ClearAllActions();
            SetCommandable(TRUE);
            ActionAttack(oPC, TRUE);
        }
        else
        {
            SetCommandable(TRUE);
            ActionJumpToObject(GetNearestObjectByTag("WP_GNOLL_BOSS"));
            ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 6.0);
            SetCommandable(FALSE);
            return;
        }
    }

    int nMaxHP = GetMaxHitPoints();
    int nGrenze = GetLocalInt(OBJECT_SELF, "LAST_GRENZ_HP");

    if (!nGrenze)
    {
        nGrenze = nMaxHP - nMaxHP/5;
        SetLocalInt(OBJECT_SELF, "LAST_GRENZ_HP", nGrenze);
    }

    if (GetCurrentHitPoints() < nGrenze && nGrenze != nMaxHP/6)
    {
        ClearAllActions(TRUE);
        ActionJumpToObject(GetNearestObjectByTag("WP_GNOLL_BOSS"));
        ActionCastFakeSpellAtObject(695, OBJECT_SELF);
        ActionCastFakeSpellAtObject(695, OBJECT_SELF);
        effect eVFX = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
        DelayCommand(2.0, SetPlotFlag(OBJECT_SELF, TRUE));
        DelayCommand(2.0, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 6.0));
        eVFX = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR));
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, OBJECT_SELF));
        SetCommandable(FALSE);
        SetLocalInt(OBJECT_SELF, "LAST_GRENZ_HP", nGrenze - nMaxHP/6);

        eVFX = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

        lLoc = GetLocation(GetNearestObjectByTag("WP_HYENA_1", OBJECT_SELF, d2()));
        DelayCommand(0.5, ActionCreateObject(OBJECT_TYPE_CREATURE, "dire_hyena", lLoc, FALSE, "DIRE_HYENA"));
        DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lLoc));

        lLoc = GetLocation(GetNearestObjectByTag("WP_HYENA_2", OBJECT_SELF, d2()));
        DelayCommand(1.0, ActionCreateObject(OBJECT_TYPE_CREATURE, "dire_hyena", lLoc, FALSE, "DIRE_HYENA"));
        DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lLoc));

        lLoc = GetLocation(GetNearestObjectByTag("WP_HYENA_3", OBJECT_SELF, d2()));
        DelayCommand(1.5, ActionCreateObject(OBJECT_TYPE_CREATURE, "dire_hyena", lLoc, FALSE, "DIRE_HYENA"));
        DelayCommand(1.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lLoc));
    }
}


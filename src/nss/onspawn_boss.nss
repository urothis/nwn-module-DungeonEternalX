#include "_inc_despawn"
#include "_functions"

void HyenaDespawn(object oHyena)
{
    if (!GetIsObjectValid(oHyena)) return;
    DestroyObject(oHyena);
}

void main()
{
    object oCreature = OBJECT_SELF;
    string sTag = GetTag(oCreature);
    if (sTag == "PALETTE")
    {
        DestroyObject(oCreature);
        return;
    }

    SetAILevel(oCreature, AI_LEVEL_NORMAL);

    if (sTag == "NEKROS_SHADOW")
    {
        effect eFX = EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10);
        eFX = ExtraordinaryEffect(eFX);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oCreature);
        AssignCommand(OBJECT_SELF, ActionCastSpellAtObject(SPELL_INVISIBILITY_SPHERE, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
    }
    else if (sTag == "DIRE_HYENA")
    {
        object oMaster = DefGetObjectByTag("BOSS_GNOLL", oCreature);
        if (!GetIsObjectValid(oMaster))
        {
            DestroyObject(oCreature);
            return;
        }

        if (!GetIsObjectValid(GetLocalObject(oMaster, "HYENA_1"))) SetLocalObject(oMaster, "HYENA_1", oCreature);
        else if (!GetIsObjectValid(GetLocalObject(oMaster, "HYENA_2"))) SetLocalObject(oMaster, "HYENA_2", oCreature);
        else if (!GetIsObjectValid(GetLocalObject(oMaster, "HYENA_3"))) SetLocalObject(oMaster, "HYENA_3", oCreature);
        else
        {
            DestroyObject(oCreature);
            return;
        }
        ActionForceMoveToObject(oMaster, TRUE, 12.0, 10.0);
        AssignCommand(GetArea(oCreature), DelayCommand(60.0, Despawn(oCreature)));
        return;
    }
    else if (sTag == "DIRE_HYENA_SEARCH")
    {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
        if (GetArea(oPC) != GetArea(oCreature))
        {
            DestroyObject(oCreature);
            return;
        }
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), oCreature);
        DelayCommand(2.0, ActionForceMoveToObject(oPC, TRUE, 3.0, 10.0));
        AssignCommand(GetArea(oCreature), DelayCommand(60.0, Despawn(oCreature)));
        return;
    }
    else if (sTag == "DRYAD_BOSS") // do not start autodespawn, it will do at areaexit
    {
        effect eFX = EffectVisualEffect(448);
        eFX = EffectLinkEffects(eFX, EffectDamageShield(50, DAMAGE_BONUS_2d12, DAMAGE_TYPE_ACID));
        eFX = EffectLinkEffects(eFX, EffectUltravision());
        eFX = ExtraordinaryEffect(eFX);
        AssignCommand(oCreature, DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oCreature)));
        return;
    }
    else if (sTag == "WITCH_DOCTOR") // do not start autodespawn, it will do at areaexit
    {
        effect eFX = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
        eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SLOW));
        eFX = ExtraordinaryEffect(eFX);
        AssignCommand(oCreature, DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oCreature)));
        return;
    }
    else if (sTag == "DRYAD_HULK") // do not start autodespawn, it will do at areaexit
    {
        effect eFX = EffectUltravision();
        eFX = ExtraordinaryEffect(eFX);
        AssignCommand(oCreature, DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oCreature)));
        return;
    }
    else if (sTag == "OHNOS") // do not start autodespawn, it will do at areaexit
    {
        SetLocalInt(oCreature, "XP_BONUS", 3);
        return;
    }
    else if (sTag == "HEALING_NADIA")
    {
        effect eFX = EffectCutsceneGhost();
        eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
        eFX = EffectLinkEffects(eFX, EffectTrueSeeing());
        eFX = ExtraordinaryEffect(eFX);
        AssignCommand(oCreature, DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oCreature)));
        DelayCommand(2.0, PlayVoiceChat(VOICE_CHAT_HELLO, oCreature));
        AssignCommand(GetArea(oCreature), DelayCommand(300.0, Despawn(oCreature)));
        return;
    }

    AssignCommand(GetArea(oCreature), DelayCommand(900.0, Despawn(oCreature)));
}

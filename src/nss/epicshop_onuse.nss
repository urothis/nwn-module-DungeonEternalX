#include "_inc_port"
#include "epic_inc"

void SpawnVisionOfAdaghar(object oPC, location lLoc)
{
    object oAdaghar = CreateObject(OBJECT_TYPE_CREATURE, "visionofadaghar", lLoc);
    SetLocalObject(GetArea(OBJECT_SELF), "VISION_OF_ADAGHAR", oAdaghar);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHaste(), oAdaghar);
    AssignCommand(oAdaghar, ActionCastFakeSpellAtObject(SPELL_CREATE_UNDEAD, oAdaghar));
    AssignCommand(oAdaghar, ActionCastFakeSpellAtObject(SPELL_CREATE_UNDEAD, oAdaghar));
    AssignCommand(oAdaghar, ActionCastFakeSpellAtObject(SPELL_CREATE_UNDEAD, oAdaghar));

    AssignCommand(oPC, DelayCommand(2.0, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 30.0)));
    //AssignCommand(oPC, DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oPC)));
    //AssignCommand(oPC, DelayCommand(5.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oPC)));
    //AssignCommand(oPC, DelayCommand(8.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oPC)));
    AssignCommand(oPC, DelayCommand(7.5, FadeToBlack(oPC, FADE_SPEED_SLOWEST)));
}

void main()
{
    object oPC = GetLastUsedBy();
    string sTag = GetTag(OBJECT_SELF);
    object oArea = GetArea(OBJECT_SELF);

    if (!GetIsObjectValid(oPC)) return;
    if (GetLocalString(oPC, "BUY_ITEM_ID") == "") return;
    if (!GetIsPC(oPC)) return;
    if (GetIsDM(oPC)) return;
    if (GetIsDMPossessed(oPC)) return;

    if (GetLocalInt(OBJECT_SELF, "IS_IN_USE"))
    {
        FloatingTextStringOnCreature("Try again in few seconds please", oPC);
        return;
    }

    int nBoundAction = BuyEpicItem(oPC);

    if (!nBoundAction)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL), OBJECT_SELF);
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 5.0));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL), oPC);
        return;
    }
    SetLocalInt(OBJECT_SELF, "IS_IN_USE", TRUE);
    SetPortMode(oPC, PORT_NOT_ALLOWED);
    object oAcolyte = CreateObject(OBJECT_TYPE_CREATURE, "epicitem_shop", GetLocation(GetWaypointByTag("WP_ACOLYTE")));
    location lAdaghar = GetLocation(GetWaypointByTag("WP_ADAGHAR"));

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_RED_15), oAcolyte);
    ActionDoCommand(AssignCommand(oAcolyte, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 15.0)));
    ActionDoCommand(SetCutsceneMode(oPC, TRUE, FALSE));
    ActionDoCommand(FadeToBlack(oPC));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oPC, SetCameraFacing(165.0, 25.0, 20.0)));
    ActionDoCommand(AssignCommand(oPC, JumpToObject(GetWaypointByTag("WP_EISHOP_BUY"))));
    ActionDoCommand(FadeFromBlack(oPC));
    ActionDoCommand(AssignCommand(oPC, SetCameraFacing(195.0, 5.0, 85.0, CAMERA_TRANSITION_TYPE_SLOW)));
    ActionWait(5.0);
    ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_GATE), lAdaghar));
    ActionWait(2.0);
    ActionDoCommand(AssignCommand(oAcolyte, ClearAllActions()));
    ActionDoCommand(AssignCommand(oAcolyte, ActionMoveToObject(GetWaypointByTag("WP_EISHOP_RUN"), TRUE)));
    ActionDoCommand(SpawnVisionOfAdaghar(oPC, lAdaghar));
    ActionWait(11.0);
    ActionDoCommand(AssignCommand(oPC, ClearAllActions()));
    ActionDoCommand(SetCutsceneMode(oPC, FALSE, TRUE));
    ActionDoCommand(AssignCommand(oPC, JumpToObject(GetWaypointByTag("WP_EIBACK"))));
    ActionDoCommand(FadeFromBlack(oPC));
    ActionDoCommand(SetPortMode(oPC, PORT_IS_ALLOWED));
    ActionDoCommand(DestroyObject(oAcolyte));
    ActionDoCommand(DestroyObject(GetLocalObject(oArea, "VISION_OF_ADAGHAR")));
    ActionDoCommand(DeleteLocalObject(oArea, "VISION_OF_ADAGHAR"));
    ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "IS_IN_USE"));
}

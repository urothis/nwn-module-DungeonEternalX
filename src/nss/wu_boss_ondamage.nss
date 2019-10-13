//::///////////////////////////////////////////////
//:: Name x2_def_ondamage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default OnDamaged script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main()
{
    //--------------------------------------------------------------------------
    // GZ: 2003-10-16
    // Make Plot Creatures Ignore Attacks
    //--------------------------------------------------------------------------
    if (GetPlotFlag(OBJECT_SELF))
    {
        return;
    }
    object oAttacker = GetLastHostileActor(OBJECT_SELF);
    int iHP = GetCurrentHitPoints(OBJECT_SELF);
    int iMHP = GetMaxHitPoints(OBJECT_SELF)*2;
    int iSkeleton = GetLocalInt(OBJECT_SELF, "Skeleton");
    int iDamage = GetLocalInt(oAttacker, "iDamage");
    iDamage += GetTotalDamageDealt();
    SetLocalInt (oAttacker, "iDamage", iDamage);
    if (iHP < (iMHP/3)&&(iSkeleton < 1))
    {
    SetLocalInt(OBJECT_SELF, "Skeleton", 1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR)), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DESTRUCTION), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_GLYPH_OF_WARDING), OBJECT_SELF, 1.0f);
    DelayCommand(0.5,SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_SKELETON_WARRIOR_1));
    }
    if (iHP < (iMHP/5)&&(iSkeleton < 2))
    {
    SetLocalInt(OBJECT_SELF, "Skeleton", 2);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DESTRUCTION), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_GLYPH_OF_WARDING), OBJECT_SELF, 1.0f);
    DelayCommand(0.5,SetCreatureAppearanceType(OBJECT_SELF, 430));
    }
    //--------------------------------------------------------------------------
    // Execute old NWN default AI code
    //--------------------------------------------------------------------------
    ExecuteScript("nw_c2_default6", OBJECT_SELF);
}

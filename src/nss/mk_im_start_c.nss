#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    StoreCameraFacing();

    object oPC = GetPCSpeaker();

    // * Make the camera float near the PC
    float fFacing  = GetFacing(oPC) + 315.0;
    if (fFacing > 359.0)
    {
        fFacing -=359.0;
    }
    SetCameraFacing(fFacing, 3.5f, 75.0,CAMERA_TRANSITION_TYPE_FAST ) ;

    CISetCurrentModMode(GetPCSpeaker(),MK_CI_MODMODE_CLOAK );

    object oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
    object oBackup = CopyItem(oItem,IPGetIPWorkContainer());
    CISetCurrentModBackup(oPC, oBackup);
    CISetCurrentModItem(oPC, oItem);

    SetCustomToken(MK_TOKEN_COPYFROM, "cloak");

    MK_GenericDialog_CleanUp();
/*
    SetLocalInt(OBJECT_SELF, "MK_SET_MATERIAL", 0);
    SetLocalInt(OBJECT_SELF, "MK_SET_CGROUP", 0);
    SetLocalInt(OBJECT_SELF, "MK_SET_COLOR", 0);
    SetLocalInt(OBJECT_SELF, "MK_SET_COPY", 0);
*/

    //* TODO: Light model to make changes easier to see
    effect eLight = EffectVisualEffect( VFX_DUR_LIGHT_WHITE_20);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLight,oPC);

    //* Immobilize player while crafting
    effect eImmob = EffectCutsceneImmobilize();
    eImmob = ExtraordinaryEffect(eImmob);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eImmob,oPC);

//    MK_InitColorTokens();
}

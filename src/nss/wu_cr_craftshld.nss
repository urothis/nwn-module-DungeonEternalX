#include "x2_inc_craft"
void main()
{
    StoreCameraFacing();
    object oPC = GetPCSpeaker();
    // * Make the camera float near the PC
    float fFacing  = GetFacing(oPC) + 180.0;
    {
        fFacing += 80.0;
    }
    SetCameraFacing(fFacing, 3.5f, 75.0,CAMERA_TRANSITION_TYPE_FAST ) ;
    CISetCurrentModMode(GetPCSpeaker(),X2_CI_MODMODE_SHIELD );
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, GetPCSpeaker());
    CISetCurrentModItem(oPC, oItem);
    //* Immobilize player while crafting
    effect eImmob = EffectCutsceneImmobilize();
    eImmob = ExtraordinaryEffect(eImmob);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eImmob,oPC);
}


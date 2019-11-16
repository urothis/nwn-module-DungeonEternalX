//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Finish Conversation Script
*/
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
//////////////////////////////////////////////////////////
#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    object oPC = GetPCSpeaker();
    if (CIGetCurrentModMode(GetPCSpeaker()) != X2_CI_MODMODE_INVALID )
    {
        object oBackup = CIGetCurrentModBackup(oPC);

        object oNew = CIGetCurrentModItem(oPC);
        AssignCommand(oPC,ClearAllActions(TRUE));

        int nInventorySlot = MK_GetCurrentInventorySlot(oPC);

        AssignCommand(oPC, ActionEquipItem(oNew,nInventorySlot));

        //----------------------------------------------------------------------
        // This is to work around a problem with temporary item properties
        // sometimes staying around when they are on a cloned item.
        //----------------------------------------------------------------------
        IPRemoveAllItemProperties(oNew,DURATION_TYPE_TEMPORARY);

        DeleteLocalInt(oPC,"X2_TAILOR_CURRENT_COST");
        DeleteLocalInt(oPC,"X2_TAILOR_CURRENT_DC");
        CISetCurrentModMode(oPC,X2_CI_MODMODE_INVALID );

        // remove backup
        DestroyObject(oBackup);
    }
    else
    {
       ClearAllActions();
    }

    // Remove custscene immobilize from player
    effect eEff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEff))
    {
         if (GetEffectType(eEff) == EFFECT_TYPE_CUTSCENEIMMOBILIZE
             && GetEffectCreator(eEff) == oPC
             && GetEffectSubType(eEff) == SUBTYPE_EXTRAORDINARY )
         {
            RemoveEffect(oPC,eEff);
         }
         eEff = GetNextEffect(oPC);
    }
    MK_GenericDialog_CleanUp();

    RestoreCameraFacing() ;
}

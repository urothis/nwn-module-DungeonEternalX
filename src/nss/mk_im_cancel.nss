//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Cancel Conversation Script
*/
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
// updated MK 2006/08/30
//////////////////////////////////////////////////////////

#include "mk_inc_generic"

#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
   object oPC =   GetPCSpeaker();
   if (CIGetCurrentModMode(GetPCSpeaker()) != X2_CI_MODMODE_INVALID )
   {
        object oBackup =    CIGetCurrentModBackup(oPC);
        object oItem  = CIGetCurrentModItem(oPC);

        DeleteLocalInt(oPC,"X2_TAILOR_CURRENT_COST");
        DeleteLocalInt(oPC,"X2_TAILOR_CURRENT_DC");

        //Give Backup to Player
        object oNew = CopyItem(oBackup, oPC,TRUE);
        DestroyObject(oItem);
        DestroyObject(oBackup);

        AssignCommand(oPC,ClearAllActions(TRUE));

        int nInventorySlot = MK_GetCurrentInventorySlot(oPC);

        AssignCommand(oPC, ActionEquipItem(oNew,nInventorySlot));

        CISetCurrentModMode(oPC,X2_CI_MODMODE_INVALID );
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

    RestoreCameraFacing();
}

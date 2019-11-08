//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Finish Conversation Script
*/
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
//////////////////////////////////////////////////////////
#include "x2_inc_craft"
void main()
{
    object oPC = GetPCSpeaker();
    //SetLocalInt(oPC, "Craft", FALSE);
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
    RestoreCameraFacing() ;
}


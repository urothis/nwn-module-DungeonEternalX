//::///////////////////////////////////////////////
//:: Confusion Heartbeat Support Script
//:: NW_G0_Confuse
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   This heartbeat script runs on any creature
   that has been hit with the confusion effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
#include "x0_inc_henai"

void main() {
   //SendForHelp();
   //Make sure the creature is commandable for the round
   SetCommandable(TRUE);
   //Clear all previous actions.
   ClearAllActions(TRUE);
   int nRandom = d10();
   //Roll a random int to determine this rounds effects
   if (nRandom  == 1) {
      ActionRandomWalk();
   } else if (nRandom >= 2 && nRandom  <= 6) {
      ClearAllActions(TRUE);
      switch (d10()) {
         case 1: ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING);           break;
         case 2: ActionPlayAnimation(ANIMATION_FIREFORGET_BOW);                break;
         case 3: ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD); break;
         case 4: ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1);           break;
         case 5: ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM);              break;
         case 6: ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE);             break;
         case 7: ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP,    1.0, 6.0f); break;
         case 8: ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE,   1.0, 6.0f); break;
         case 9: ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS,  1.0, 6.0f); break;
      }
   } else if(nRandom >= 7 && nRandom <= 10) {
      object oNear = GetNearestObject(OBJECT_TYPE_CREATURE);
      ActionMoveToObject(oNear);
      DelayCommand(2.5f, ActionAttack(oNear));
      DelayCommand(3.5f, ActionMoveToObject(oNear));
      DelayCommand(5.0f, ActionAttack(oNear));
   }
   SetCommandable(FALSE);
}

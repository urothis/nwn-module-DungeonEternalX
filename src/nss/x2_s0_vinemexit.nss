//::///////////////////////////////////////////////
//:: Vine Mine, Entangle B: On Exit
//:: X2_S0_VineMExit
//:://////////////////////////////////////////////
/*
   Removes the vine effects after the AOE dies.
*/
#include "pure_caster_inc"

void main() {
   object oTarget = GetExitingObject();
   object oCaster = GetAreaOfEffectCreator();
   effect eAOE;
   int bIsVineEff;  int nReapplyHaste;
   eAOE = GetFirstEffect(oTarget);
   while (GetIsEffectValid(eAOE))
   {
      if (GetEffectCreator(eAOE) == oCaster)
      {
         bIsVineEff = GetEffectSpellId(eAOE);
         if (bIsVineEff>=529 && bIsVineEff<=532)
         {
            bIsVineEff = GetEffectType(eAOE);
            if (bIsVineEff==EFFECT_TYPE_ENTANGLE || bIsVineEff==EFFECT_TYPE_MOVEMENT_SPEED_DECREASE || bIsVineEff==EFFECT_TYPE_SKILL_INCREASE)
            {
               RemoveEffect(oTarget, eAOE);
               nReapplyHaste = TRUE;
            }
         }
      }
      eAOE = GetNextEffect(oTarget);
   }
   if (nReapplyHaste) DelayCommand(0.1, ReapplyPermaHaste(oTarget));
}

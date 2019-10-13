//::///////////////////////////////////////////////
//:: Poison
//:: NW_S0_Poison.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Must make a touch attack. If successful the target
   is struck down with wyvern poison.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nPoison = POISON_LARGE_SCORPION_VENOM;
   if      (nPureBonus==1) nPoison = POISON_IRON_GOLEM;
   else if (nPureBonus==2) nPoison = POISON_WRAITH_SPIDER_VENOM;
   else if (nPureBonus==3) nPoison = POISON_PIT_FIEND_ICHOR;
   else if (nPureBonus==4) nPoison = POISON_BLACK_LOTUS_EXTRACT;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect ePoison = EffectPoison(POISON_LARGE_SCORPION_VENOM);
   int nTouch = 1;//

   if(!GetIsReactionTypeFriendly(oTarget))
   {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POISON));

      //Make touch attack
      if (nTouch > 0)
      {
         //Make SR Check
         if (!MyResistSpell(OBJECT_SELF, oTarget))
         {
            //Apply the poison effect and VFX impact
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
         }
      }
   }
}


//::///////////////////////////////////////////////
//:: [Scare]
//:: [NW_S0_Scare.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is scared for 1d4 rounds.
//:: NOTE THIS SPELL IS EQUAL TO **CAUSE FEAR** NOT SCARE.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   effect eScare  = EffectFrightened();
   effect eSave   = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
   effect eMind   = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);

   int nDuration = d4() + nPureBonus;
   if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration = nDuration * 2;

   effect eDamagePenalty = EffectDamageDecrease(2);
   effect eAttackPenalty = EffectAttackDecrease(2);

   effect eLink  = EffectLinkEffects(eMind, eScare);
   effect eLink2 = EffectLinkEffects(eSave, eDamagePenalty);
   eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);

   //Check the Hit Dice of the creature
   if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
   {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
      {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SCARE));

         //Make SR check
         if(!MyResistSpell(OBJECT_SELF, oTarget))
         {
            //Make Will save versus fear
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_FEAR))
            {
               //Apply linked effects and VFX impact
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
            }
         }
      }
   }
}

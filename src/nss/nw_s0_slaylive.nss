//::///////////////////////////////////////////////
//:: [Slay Living]
//:: [NW_S0_SlayLive.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Caster makes a touch attack and if the target
//:: fails a Fortitude save they die.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: January 22nd / 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "_inc_sneakspells"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   object oTarget = GetSpellTargetObject();
   int nDamage;
   effect eDam;
   effect eVis  = EffectVisualEffect(VFX_IMP_DEATH);
   effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

   if(!GetIsReactionTypeFriendly(oTarget))
   {
      int nTouch = TouchAttackMelee(oTarget);
      int nSneakBonus = 0;//getSneakDamage(OBJECT_SELF, oTarget)*nTouch;
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLAY_LIVING));

      //Make SR check
      if(!MyResistSpell(OBJECT_SELF, oTarget))
      {
         //Make melee touch attack
         if(nTouch)
         {
            //Make Fort save
            if  (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_DEATH))
            {
               //Apply the death effect and VFX impact
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
               //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
            else
            {
               //Roll damage
               nDamage = d6(3 + nPureBonus) + nPureLevel;
               //Make metamagic checks
               if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * (3 + nPureBonus) + nPureLevel;
               if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2);
               //Apply damage effect and VFX impact
               nDamage += nSneakBonus;
               if (BlockNegativeDamage(oTarget)) nDamage = 0;
               eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            }
         }
      }
   }
}

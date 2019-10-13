//::///////////////////////////////////////////////
//:: Negative Energy Burst
//:: NW_S0_NegBurst
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The caster releases a burst of negative energy
   at a specified point doing 1d8 + 1 / level
   negative energy damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 13, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   int Damage2;
   float fDelay;
   effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_20); //Replace with Negative Pulse
   effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
   effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
   effect eDam, eHeal;
   int nStr = GetMax(1,nPureLevel / 4);
   effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
   effect eStr_Low = EffectAbilityDecrease(ABILITY_STRENGTH, nStr);

   if (nPureLevel > 20) Damage2 = 20;
     else Damage2 = nPureLevel;

   //Get the spell target location as opposed to the spell target.
   location lTarget = GetSpellTargetLocation();
   //Apply the explosion at the location captured above.
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
   //Declare the spell shape, size and the location.  Capture the first target object in the shape.
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
   //Cycle through the targets within the spell shape until an invalid object is captured.
   while (GetIsObjectValid(oTarget)) {
      if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         //Roll damage for each target
         nDamage = d8(1 + nPureBonus) + Damage2;
         //Resolve metamagic
         if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 8 * (1 + nPureBonus) + Damage2;
         else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage / 2);
         if (MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay)) nDamage /= 2;
         //Get the distance between the explosion and the target to calculate delay
         fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

         // * any undead should be healed, not just Friendlies
         if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST, FALSE));
            //Set the heal effect
            eHeal = EffectHeal(nDamage);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
            //This visual effect is applied to the target object not the location as above.  This visual effect
            //represents the flame that erupts on the target not on the ground.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStr, oTarget));
         } else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
               //Fire cast spell at event for the specified target
               SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
               //Set the damage effect
               if (BlockNegativeDamage(oTarget)) nDamage = 0;
               eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
               // Apply effects to the currently selected target.
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
               //This visual effect is applied to the target object not the location as above.  This visual effect
               //represents the flame that erupts on the target not on the ground.
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStr_Low, oTarget));
            }
         }
      }

      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
   }
}

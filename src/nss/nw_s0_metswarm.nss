//::///////////////////////////////////////////////
//:: Meteor Swarm
//:: NW_S0_MetSwarm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Everyone in a 50ft radius around the caster
   takes 20d6 fire damage.  Those within 6ft of the
   caster will take no damage.
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   nPureLevel = 2 + nPureLevel/3;

   //Declare major variables
   int nMetaMagic;
   int nDamage;
   int nDamage2;
   effect eFire;
   effect eOther;
   effect eMeteor = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
   effect eVisFire = EffectVisualEffect(VFX_IMP_FLAME_M);
   effect eVisOther = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
   //Apply the meteor swarm VFX area impact
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMeteor, GetLocation(OBJECT_SELF));
   //Get first object in the spell area
   float fDelay;
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
   while(GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF) {
         fDelay = GetRandomDelay();
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_METEOR_SWARM));
         //Make sure the target is outside the 2m safe zone
         if (GetDistanceBetween(oTarget, OBJECT_SELF) > 2.0) {
            //Make SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget, 0.5)) {
               //Roll damage
               nDamage = d8(3 + nPureBonus/2);
               nDamage2 = d8(nPureLevel);
               //int nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_NONE);
               //int nDamage2 = GetReflexAdjustedDamage(nDamage2, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE);

               //Set the damage effect
               if (nDamage > 0) {
                  eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisFire, oTarget));
               }
               if (nDamage2 > 0) {
                  eOther = EffectDamage(nDamage2, DAMAGE_TYPE_BLUDGEONING);
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eOther, oTarget));
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisOther, oTarget));
               }
            }
         }
      }
      //Get next target in the spell area
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
   }
}


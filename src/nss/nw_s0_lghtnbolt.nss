//::///////////////////////////////////////////////
//:: Lightning Bolt
//:: NW_S0_LightnBolt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Does 1d6 per level in a 5ft tube for 30m
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 2, 2001

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nCasterLevel = nPureLevel;
   //Limit caster level
   if (nCasterLevel > 10 + nPureBonus) nCasterLevel = 10 + nPureBonus;
   int nDamage;
   int nMetaMagic = GetMetaMagicFeat();
   //Set the lightning stream to start at the caster's hands
   effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
   effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
   effect eDamage;
   object oTarget = GetSpellTargetObject();
   location lTarget = GetLocation(oTarget);
   object oNextTarget, oTarget2;
   float fDelay;
   int nCnt = 1;

   oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
   while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0) {
      //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
      oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
      while (GetIsObjectValid(oTarget)) {
         //Exclude the caster from the damage effects
         if (oTarget != OBJECT_SELF && oTarget2 == oTarget) {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
               //Fire cast spell at event for the specified target
               SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHTNING_BOLT));
               //Make an SR check
               if (!MyResistSpell(OBJECT_SELF, oTarget)) {
                  //Roll damage
                  nDamage =  d6(nCasterLevel);
                  //Enter Metamagic conditions
                  if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLevel;//Damage is at max
                  if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%
                  //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                  nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_ELECTRICITY);
                  //Set damage effect
                  eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                  if (nDamage > 0) {
                     fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                     //Apply VFX impcat, damage effect and lightning effect
                     DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                     DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                  }
               }
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
               //Set the currect target as the holder of the lightning effect
               oNextTarget = oTarget;
               eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oNextTarget, BODY_NODE_CHEST);
            }
         }
         //Get the next object in the lightning cylinder
         oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
      }
      nCnt++;
      oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
   }
}


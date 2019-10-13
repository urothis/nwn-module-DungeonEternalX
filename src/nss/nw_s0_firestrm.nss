//::///////////////////////////////////////////////
//:: Fire Storm
//:: NW_S0_FireStm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creates a zone of destruction around the caster
   within which all living creatures are pummeled
   with fire.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 21, 2001

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   int nDamage2;
   int nCasterLevel = nPureLevel;
   if(nCasterLevel > 20 + nPureBonus) nCasterLevel = 20 + nPureBonus;

   effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
   effect eFireStorm = EffectVisualEffect(VFX_FNF_FIRESTORM);
   float fDelay;
   //Apply Fire and Forget Visual in the area;
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFireStorm, GetLocation(OBJECT_SELF));
   //Declare the spell shape, size and the location.  Capture the first target object in the shape.
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   //Cycle through the targets within the spell shape until an invalid object is captured.
   while(GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF) {
         fDelay = GetRandomDelay(1.5, 2.5);
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIRE_STORM));
         //Make SR check, and appropriate saving throw(s).
         if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
            //Roll Damage
            nDamage = d6(nCasterLevel);
            //Enter Metamagic conditions
            if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLevel;//Damage is at max
            else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2);//Damage/Healing is +50%
            //Save versus both holy and fire damage
            nDamage2 = GetReflexAdjustedDamage(nDamage/2, oTarget, nPureDC, SAVING_THROW_TYPE_DIVINE);
            nDamage = GetReflexAdjustedDamage(nDamage/2, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE);
            if (nDamage) {
               effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
            }
            if (nDamage2) {
               effect eDivine = EffectDamage(nDamage2, DAMAGE_TYPE_DIVINE);
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDivine, oTarget));
            }
            if (nDamage + nDamage2) DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         }
      }
      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   }
}

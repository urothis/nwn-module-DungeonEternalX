//::///////////////////////////////////////////////
//:: Scintillating Sphere
//:: X2_S0_ScntSphere
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A scintillating sphere is a burst of electricity
// that detonates with a low roar and inflicts 1d6
// points of damage per caster level (maximum of 10d6)
// to all creatures within the area. Unattended objects
// also take damage. The explosion creates almost no pressure.
*/

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oCaster = OBJECT_SELF;
   int nCasterLvl = nPureLevel;
   if (nCasterLvl > 10 + nPureBonus) nCasterLvl = 10 + nPureBonus;

   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   float fDelay;
   effect eExplode = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION);
   effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
   effect eDam;
   location lTarget = GetSpellTargetLocation();
   //Apply the fireball explosion at the location captured above.
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
   //Declare the spell shape, size and the location.  Capture the first target object in the shape.
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   //Cycle through the targets within the spell shape until an invalid object is captured.
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
         //Get the distance between the explosion and the target to calculate delay
         fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
         if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
            //Roll damage for each target
            nDamage = d6(nCasterLvl);
            //Resolve metamagic
            if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLvl;
            else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += nDamage / 2;
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_ELECTRICITY);
            //Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
            if (nDamage > 0) {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
         }
      }
      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   }
}


//::///////////////////////////////////////////////
//:: Horrid Wilting
//:: NW_S0_HorrWilt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All living creatures (not undead or constructs)
   suffer 1d8 damage per caster level to a maximum
   of 25d8 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12 , 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nDamCap = 200;
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   float fDelay;
   effect eExplode = EffectVisualEffect(VFX_FNF_HORRID_WILTING);
   effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
   effect eDam;
   //Get the spell target location as opposed to the spell target.
   location lTarget = GetSpellTargetLocation();
   //Limit Caster level for the purposes of damage
   if (nPureLevel > 25 + nPureBonus) nPureLevel = 25 + nPureBonus;

   //Apply the horrid wilting explosion at the location captured above.
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
   //Declare the spell shape, size and the location.  Capture the first target object in the shape.
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
   //Cycle through the targets within the spell shape until an invalid object is captured.
   while (GetIsObjectValid(oTarget)) {
      // GZ: Not much fun if the caster is always killing himself
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF) {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HORRID_WILTING));
         //Get the distance between the explosion and the target to calculate delay
         fDelay = GetRandomDelay(1.5, 2.5);
         if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
            if(GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD) {
               //Roll damage for each target
               nDamage = d8(nPureLevel);
               //Resolve metamagic
               if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 8 * nPureLevel;
               else if (nMetaMagic == METAMAGIC_EMPOWER){
                    nDamage += nDamage / 2;
                    nDamCap += nDamCap / 2;
               }
               if (MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay)) nDamage /= 2;
               //Set the damage effect
               eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
               // Apply effects to the currently selected target.
               if (nDamage > nDamCap) nDamage = nDamCap;
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
               //This visual effect is applied to the target object not the location as above.  This visual effect
               //represents the flame that erupts on the target not on the ground.
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
          }
      }
      nDamCap = 200;
      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
   }
}

//::///////////////////////////////////////////////
//:: Gust of Wind
//:: [x0_s0_gustwind.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
   This spell creates a gust of wind in all directions
   around the target. All targets in a medium area will be
   affected:
   - Target must make a For save vs. spell DC or be
     knocked down for 3 rounds
   - plays a wind sound
   - if an area of effect object is within the area
   it is dispelled
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   // Special Harper Scout item (Harper Scout's Horn of the Winds)
   object oItem = GetSpellCastItem();
   if (GetBaseItemType(oItem) == BASE_ITEM_MISCSMALL  && GetTag(oItem) == "item_windsong")
   {
      if (!GetLevelByClass(CLASS_TYPE_HARPER, OBJECT_SELF))
      {
         FloatingTextStringOnCreature("You do not have the knowledge about wind instruments", OBJECT_SELF);
         return;
      }
   }


   //Declare major variables
   object oCaster = OBJECT_SELF;
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   float fDelay;
   effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
   effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
   location lTarget = GetSpellTargetLocation();
   //Apply the fireball explosion at the location captured above.
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
   //Declare the spell shape, size and the location.  Capture the first target object in the shape.
   float fRadius = RADIUS_SIZE_HUGE + IntToFloat(nPureBonus / 3);
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
   //Cycle through the targets within the spell shape until an invalid object is captured.
   while (GetIsObjectValid(oTarget)) {
      if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT) {
         DestroyObject(oTarget);
      } else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
         //Get the distance between the explosion and the target to calculate delay
         fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
         // * unlocked doors will reverse their open state
         if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR && !GetLocked(oTarget)) {
            if (!GetIsOpen(oTarget)) AssignCommand(oTarget, ActionOpenDoor(oTarget));
            else                     AssignCommand(oTarget, ActionCloseDoor(oTarget));
         }
         if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC) && nPureLevel > 20) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(3));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         }
      }
      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
   }
}










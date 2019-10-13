//::///////////////////////////////////////////////
//:: Delayed Blast Fireball: On Enter
//:: NW_S0_DelFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The caster creates a trapped area which detects
   the entrance of enemy creatures into 3 m area
   around the spell location.  When tripped it
   causes a fiery explosion that does 1d6 per
   caster level up to a max of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Georg: Removed Spellhook, fixed damage cap
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "pure_caster_inc"

void main() {

   //Declare major variables
   object oTarget = GetEnteringObject();
   object oCaster = GetAreaOfEffectCreator();
   location lTarget = GetLocation(OBJECT_SELF);

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nDamage;
   int nDamCap = 120;
   int nMetaMagic = GetMetaMagicFeat();
   int nCasterLevel = nPureLevel;
   int nFire = GetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL");
   //Limit caster level
   if (nCasterLevel > 20 + nPureBonus) nCasterLevel = 20 + nPureBonus;

   effect eDam;
   effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
   effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
   //Check the faction of the entering object to make sure the entering object is not in the casters faction
   if (nFire == 0) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         SetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL",TRUE);
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
         //Cycle through the targets in the explosion area
         oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
         while(GetIsObjectValid(oTarget)) {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
               //Fire cast spell at event for the specified target
               SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DELAYED_BLAST_FIREBALL));
               //Make SR check
               if (!MyResistSpell(oCaster, oTarget)) {
                  nDamage = d6(nCasterLevel);
                  //Enter Metamagic conditions
                  if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLevel;//Damage is at max
                  else if (nMetaMagic == METAMAGIC_EMPOWER) {
                    nDamage += (nDamage/2);//Damage/Healing is +50%
                    nDamCap += (nDamCap/2);
                  }
                  //Change damage according to Reflex, Evasion and Improved Evasion
                  nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator());
                  //Set up the damage effect
                  if (nDamage > nDamCap) nDamage = nDamCap;
                  eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                  if(nDamage > 0) {
                     //Apply VFX impact and damage effect
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                  }
               }
            }
            nDamCap = 120;
            //Get next target in the sequence
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
         }
         DestroyObject(OBJECT_SELF, 1.0);
      }
   }
}

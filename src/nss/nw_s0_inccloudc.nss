//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloudC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Objects within the AoE take 4d6 fire damage
   per round.
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"

void main() {

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   effect eDam;
   object oTarget;
   //Declare and assign personal impact visual effect.
   effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
   float fDelay;

   object oCaster = GetAreaOfEffectCreator();
   if (!GetIsObjectValid(oCaster)) { // CASTER GONE, KILL AOE
      DestroyObject(OBJECT_SELF);
      return;
   }

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   //Declare the spell shape, size and the location.
   while(GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
         fDelay = GetRandomDelay(0.5, 2.0);
         //Make SR check, and appropriate saving throw(s).
         if (!MyResistSpell(oCaster, oTarget, fDelay)) {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INCENDIARY_CLOUD));
            //Roll damage.
            nDamage = d6(4 + nPureBonus);
            //Enter Metamagic conditions
            if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * (4 + nPureBonus);//Damage is at max
            if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%
            //Adjust damage for Reflex Save, Evasion and Improved Evasion
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE, oCaster);
            // Apply effects to the currently selected target.
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            if(nDamage > 0) {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
         }
      }
      //Select the next target within the spell shape.
      oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   }
}

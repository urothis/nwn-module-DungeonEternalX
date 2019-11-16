//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Person within the AoE take 4d6 fire damage
   per round.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {

   //Declare major variables
   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   effect eDam;
   object oTarget;
   //Declare and assign personal impact visual effect.
   effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
   float fDelay;
   //Capture the first target object in the shape.
   oTarget = GetEnteringObject();
   //Declare the spell shape, size and the location.
   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD));
      //Make SR check, and appropriate saving throw(s).
      if (!MyResistSpell(oCaster, oTarget, fDelay)) {
         fDelay = GetRandomDelay(0.5, 2.0);
         //Roll damage.
         nDamage = d6(4 + nPureBonus);
         //Enter Metamagic conditions
         if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * (4 + nPureBonus);//Damage is at max
         if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
         //Adjust damage for Reflex Save, Evasion and Improved Evasion
         nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE, oCaster);
         // Apply effects to the currently selected target.
         eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
         if (nDamage > 0) {
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         }
      }
      // ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);
   }
}

//::///////////////////////////////////////////////
//:: Acid Fog: Heartbeat
//:: NW_S0_AcidFogC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All creatures within the AoE take 2d6 acid damage
   per round and upon entering if they fail a Fort Save
   their movement is halved.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {

   object oCaster = GetAreaOfEffectCreator();
   if (!GetIsObjectValid(oCaster)) { // CASTER GONE, KILL AOE
      DestroyObject(OBJECT_SELF);
      return;
   }

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nDamage = d6(4 + nPureBonus);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * (4 + nPureBonus);//Damage is at max
   if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%

   effect eDam;
   effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
   object oTarget;
   float fDelay;

   //Set the damage effect
   eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
   //Start cycling through the AOE Object for viable targets including doors and placable objects.
   oTarget = GetFirstInPersistentObject(OBJECT_SELF);
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
         //Fire cast spell at event for the affected target
         SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ACID_FOG));
         //Spell resistance check
         if(!MyResistSpell(oCaster, oTarget))
         {
            fDelay = GetRandomDelay(0.4, 1.2);
            if (MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_ACID, oCaster, fDelay))
            {
                nDamage /= 2;
            }
            //Apply damage and visuals
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         }
      }
      //Get next target.
      oTarget = GetNextInPersistentObject(OBJECT_SELF);
   }
}

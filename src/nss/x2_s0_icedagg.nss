//::///////////////////////////////////////////////
//:: Ice Dagger
//:: X2_S0_IceDagg
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a dagger shapped piece of ice that
// flies toward the target and deals 1d4 points of
// cold damage per level (maximum od 5d4)
*/

#include "NW_I0_SPELLS"
#include "_inc_sneakspells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oCaster = OBJECT_SELF;
   object oTarget = GetSpellTargetObject();
   int nCasterLvl = nPureLevel;
   if (nCasterLvl > 5 + nPureBonus) nCasterLvl = 5 + nPureBonus;

   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   float fDelay;
   effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
   effect eDam;
   //Get the spell target location as opposed to the spell target.
   location lTarget = GetSpellTargetLocation();

   if (!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
      //Get the distance between the explosion and the target to calculate delay
      fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
      if (!MyResistSpell(OBJECT_SELF, oTarget)) {
         //Roll damage for each target
         nDamage = d4(nCasterLvl);
         //Resolve metamagic
         if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 4 * nCasterLvl;
         else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += nDamage / 2;
         //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
         int nSneakBonus = getSneakDamageRanged(OBJECT_SELF, oTarget);
         nDamage = GetReflexAdjustedDamage(nDamage + nSneakBonus, oTarget, nPureDC, SAVING_THROW_TYPE_COLD);
         //Set the damage effect
         eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
         if(nDamage > 0) {
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         }
      }
   }
}


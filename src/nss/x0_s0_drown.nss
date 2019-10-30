//::///////////////////////////////////////////////
//:: Drown
//:: [X0_S0_Drown.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
   if the creature fails a FORT throw.
   Does not work against Undead, Constructs, or Elementals.

January 2003:
 - Changed to instant kill the target.
May 2003:
 - Changed damage to 90% of current HP, instead of instant kill.

*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;


   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nCasterLevel = GetCasterLevel(OBJECT_SELF);
   int nDam = GetCurrentHitPoints(oTarget);
   //Set visual effect
   effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WATER);
   effect eDam;
   //Check faction of target
   if (!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
      //Make SR Check
      if(!MyResistSpell(OBJECT_SELF, oTarget)) {
         // * certain racial types are immune
         if ((GetRacialType(oTarget)!=RACIAL_TYPE_CONSTRUCT) && (GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD) && (GetRacialType(oTarget)!=RACIAL_TYPE_ELEMENTAL)) {
            //Make a fortitude save
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC)) {
               nDam = FloatToInt(nDam * 0.9);
               eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
               //Apply the VFX impact and damage effect
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            }
         }
      }
   }
}






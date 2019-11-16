//::///////////////////////////////////////////////
//:: Flame Lash
//:: NW_S0_FlmLash.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creates a whip of fire that targets a single
   individual
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "_inc_sneakspells"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nCasterLevel = 2 + GetMax(1, nPureLevel/3) + nPureBonus;
   int nDamage = d6(nCasterLevel);
   int nMetaMagic = GetMetaMagicFeat();
   //Enter Metamagic conditions
   if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLevel;//Damage is at max
   else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%
   effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
   effect eRay = EffectBeam(VFX_BEAM_FIRE_LASH, OBJECT_SELF, BODY_NODE_HAND);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
   if (!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FLAME_LASH));
      if (!MyResistSpell(OBJECT_SELF, oTarget, 1.0)) {
         int nSneakBonus = getSneakDamageRanged(OBJECT_SELF, oTarget);
         nDamage = GetReflexAdjustedDamage(nDamage + nSneakBonus, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE);
         effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
         if (nDamage > 0) {
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
         }
      }
   }
}

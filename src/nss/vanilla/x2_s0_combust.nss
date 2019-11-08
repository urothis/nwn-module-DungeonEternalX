//::///////////////////////////////////////////////
//:: Combust
//:: X2_S0_Combust
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The initial eruption of flame causes  2d6 fire damage +1
   point per caster level(maximum +10)
   with no saving throw.

   Further, the creature must make
   a Reflex save or catch fire taking a further 1d6 points
   of damage. This will continue until the Reflex save is
   made.

   There is an undocumented artificial limit of
   10 + casterlevel rounds on this spell to prevent
   it from running indefinitly when used against
   fire resistant creatures with bad saving throws

*/

#include "x2_I0_SPELLS"
#include "x2_inc_toollib"
#include "pure_caster_inc"
#include "_inc_sneakspells"

void RunCombustImpact(object oTarget, object oCaster, int nMetaMagic, int nPureDC, int nBaseDamage, int nPureBonus) {
   if (GZGetDelayedSpellEffectsExpired(SPELL_COMBUST, oTarget, oCaster)) return;
   if (GetIsDead(oTarget) == FALSE) {
      if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE)) {
         int nDamage = nBaseDamage;
         if (nMetaMagic == METAMAGIC_MAXIMIZE) {
            nDamage += 6 * (1+nPureBonus);
         } else {
            nDamage += d6(1+nPureBonus);
            if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2);
         }
         effect eDmg = EffectDamage(nDamage,DAMAGE_TYPE_FIRE);
         effect eVFX = EffectVisualEffect(VFX_IMP_FLAME_S);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
         DelayCommand(6.0f, RunCombustImpact(oTarget, oCaster, nMetaMagic, nPureDC, nBaseDamage, nPureBonus));
      } else {
         GZRemoveSpellEffects(SPELL_COMBUST, oTarget);
      }
   }
}

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   object oTarget = GetSpellTargetObject();
   object oCaster = OBJECT_SELF;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nBaseDamage = GetMin(10, nPureLevel) + nPureBonus;
   int nDamage = nBaseDamage;

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_MAXIMIZE) {
      nDamage += 6 * (2+nPureBonus);
   } else {
      nDamage  += d6(2+nPureBonus);
      if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%
   }

   int nDuration = 10;
   if (!GetIsReactionTypeFriendly(oTarget)) {
      int nSneakBonus = getSneakDamage(OBJECT_SELF, oTarget);
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
      effect eDam     = EffectDamage(nDamage+nSneakBonus, DAMAGE_TYPE_FIRE);
      effect eDur     = EffectVisualEffect(498);

      if(!MyResistSpell(OBJECT_SELF, oTarget)) {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
         TLVFXPillar(VFX_IMP_FLAME_M, GetLocation(oTarget), 5, 0.1f,0.0f, 2.0f);
         if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_INFERNO,oTarget)) {
            FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
            return;
         }
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));
         DelayCommand(6.0, RunCombustImpact(oTarget, oCaster, nMetaMagic, nPureDC, nBaseDamage, nPureBonus));
      }
   }
}


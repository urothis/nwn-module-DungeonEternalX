//::///////////////////////////////////////////////
//:: Enervation
//:: NW_S0_Enervat.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target Loses 1d4 levels for 1 hour per caster
    level
*/
#include "nw_i0_spells"
#include "pure_caster_inc"
#include "spell_sneak_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   object oTarget = GetSpellTargetObject();
   if (GetIsReactionTypeFriendly(oTarget)) return; // NOT AN ENEMY, EXIT
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
   if (MyResistSpell(OBJECT_SELF, oTarget)) return; // SPELL RESISTED, EXIT

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   if (MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_NEGATIVE)) return;  // MADE SAVE, EXIT

   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nDuration = nPureLevel;
   int nDrain = GetMax(d4(), nPureBonus/2);

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_MAXIMIZE) nDrain = 4;//Damage is at max
   else if (nMetaMagic == METAMAGIC_EMPOWER) nDrain += (nDrain/2); //Damage/Healing is +50%
   else if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

   effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
   effect eDrain = EffectNegativeLevel(nDrain);

   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, HoursToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

   //Apply sneak bonus
   int nSneakBonus = getSneakDamageRanged(OBJECT_SELF, oTarget);
   if (nSneakBonus>0)
   {
      if (BlockNegativeDamage(oTarget)) nSneakBonus = 0;
      effect eDam = EffectDamage(nSneakBonus, DAMAGE_TYPE_NEGATIVE);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_HAND), oTarget, 1.0);
   }
}

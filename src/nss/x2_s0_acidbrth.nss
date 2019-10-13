//::///////////////////////////////////////////////
//:: Mestil's Acid Breath
//:: X2_S0_AcidBrth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You breathe forth a cone of acidic droplets. The
// cone inflicts 1d6 points of acid damage per caster
// level (maximum 10d6).
*/

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nCasterLevel = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   float fDelay;
   location lTargetLocation = GetSpellTargetLocation();
   object oTarget;
   //Limit Caster level for the purposes of damage.
   if (nCasterLevel > 10 + nPureBonus) nCasterLevel = 10 + nPureBonus;
   oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   while(GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
         fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
         if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF)) {
            nDamage = d6(nCasterLevel);
            if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLevel;//Damage is at max
            if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_ACID);
            if (nDamage > 0) {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_ACID), oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_L), oTarget));
            }
         }
      }
      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 8.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
   }
}


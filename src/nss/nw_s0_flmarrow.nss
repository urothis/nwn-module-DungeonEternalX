//::///////////////////////////////////////////////
//:: Flame Arrow
//:: NW_S0_FlmArrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Fires a stream of fiery arrows at the selected
   target that do 4d6 damage per arrow.  1 Arrow
   per 4 levels is created.
*/

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
   object oTarget = GetSpellTargetObject();
   int nCasterLvl = nPureLevel;
   int nDamage = 0;
   int nMetaMagic = GetMetaMagicFeat();
   int nCnt;
   effect eMissile; effect eDam;    effect eVis;
   int bHasNekrosis;    int nDam;
   if (nPureBonus && HasNekrosis(OBJECT_SELF)) bHasNekrosis = TRUE;
   int nBlockNegDmg = BlockNegativeDamage(oTarget);
   int nMissiles = GetMax(1, nCasterLvl / 4);
   float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
   float fDelay = fDist/(3.0 * log(fDist) + 2.0);
   if (!GetIsReactionTypeFriendly(oTarget)) {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FLAME_ARROW));
      if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
         for (nCnt = 1; nCnt <= nMissiles; nCnt++) {
            //Roll damage
            nDam = d6(4);
            if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 6 * 4;//Damage is at max
            if (nMetaMagic == METAMAGIC_EMPOWER) nDam += nDam/2; //Damage/Healing is +50%
            nDam = GetReflexAdjustedDamage(nDam, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE);
            //Set damage effect
            eDam = EffectDamage(nDam, DAMAGE_TYPE_FIRE);
            eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
            if (bHasNekrosis && nCnt % 2)
            {
               if (nBlockNegDmg) nDam = 0;
               eDam = EffectDamage(nDam, DAMAGE_TYPE_NEGATIVE);
               eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
            }
            //Apply the MIRV and damage effect
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
            eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
         }
      }
   }
}


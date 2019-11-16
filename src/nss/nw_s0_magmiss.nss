//::///////////////////////////////////////////////
//:: Magic Missile
//:: NW_S0_MagMiss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   int nCasterLvl = GetCasterLevel(OBJECT_SELF);
   int nDamage = 0;
   int nMetaMagic = GetMetaMagicFeat();
   int nCnt;    int nDam;
   effect eDam;     effect eVis;
   effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
   int nMissiles = (nCasterLvl + 1)/2;
   if (nMissiles > 5 + nPureBonus/4) nMissiles = 5 + nPureBonus/4;
   int nBlockNegDmg = BlockNegativeDamage(oTarget);
   int bHasNekrosis;
   if (nPureBonus && HasNekrosis(OBJECT_SELF)) bHasNekrosis = TRUE;

   float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
   float fDelay = fDist/(3.0 * log(fDist) + 2.0);
   float fDelay2, fTime;
   if (!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));
      //Make SR Check
      if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))  {
         //Apply a single damage hit for each missile instead of as a single mass
         for (nCnt = 1; nCnt <= nMissiles; nCnt++) {
            //Roll damage
            nDam = d4(1) + 1;
            //Enter Metamagic conditions
            if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 5;//Damage is at max
            if (nMetaMagic == METAMAGIC_EMPOWER) nDam += nDam/2; //Damage/Healing is +50%
            fTime = fDelay;
            fDelay2 += 0.1;
            fTime += fDelay2;
            //Set damage effect
            eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
            eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
            if (bHasNekrosis && nCnt % 2)
            {
               if (nBlockNegDmg) nDam = 0;
               eDam = EffectDamage(nDam, DAMAGE_TYPE_NEGATIVE);
               eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
            }

            //Apply the MIRV and damage effect
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
            DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
         }
      } else {
         for (nCnt = 1; nCnt <= nMissiles; nCnt++) ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
      }
   }
}

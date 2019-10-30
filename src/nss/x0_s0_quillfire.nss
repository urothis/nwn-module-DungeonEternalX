//::///////////////////////////////////////////////
//:: Quillfire
//:: [x0_s0_quillfire.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Fires a cluster of quills at a target. Ranged Attack.
   2d8 + 1 point /2 levels (max 5)

*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   if (GetHitDice(OBJECT_SELF)==60) {
      nPureLevel = 45;
      nPureBonus = 6;
      nPureDC = 60;
   }

   object oTarget = GetSpellTargetObject();
   int nCasterLvl = nPureLevel;
   int nDamage = 0;
   int nMetaMagic = GetMetaMagicFeat();
   int nCnt;
   effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

   effect eMissile;
   effect eDam;
   int nMissiles = GetMax(1, nCasterLvl / 3);
   float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
   float fDelay = fDist/(3.0 * log(fDist) + 2.0);
   if (!GetIsReactionTypeFriendly(oTarget)) {
      if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FLAME_ARROW));
         for (nCnt = 1; nCnt <= nMissiles; nCnt++) {
            int nDam = d4(1);
            if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 4;//Damage is at max
            if (nMetaMagic == METAMAGIC_EMPOWER) nDam += nDam/2; //Damage/Healing is +50%
            nDam += nPureBonus;
            if (nCnt%3 == 0 && nPureBonus > 0) {
               eMissile = EffectVisualEffect(VFX_IMP_MIRV);
               eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
               eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
            } else {
               eMissile = EffectVisualEffect(VFX_DUR_MIRV_ACID);
               eDam = EffectDamage(nDam, DAMAGE_TYPE_ACID);
               eVis = EffectVisualEffect(VFX_IMP_ACID_S);
            }
            //Apply the MIRV and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
         }
         int nPoison = POISON_LARGE_SCORPION_VENOM;
         if      (nPureBonus==1) nPoison = POISON_IRON_GOLEM;
         else if (nPureBonus==2) nPoison = POISON_WRAITH_SPIDER_VENOM;
         else if (nPureBonus==3) nPoison = POISON_PIT_FIEND_ICHOR;
         else if (nPureBonus>=4) nPoison = POISON_BLACK_LOTUS_EXTRACT;
         effect ePoison = EffectPoison(nPoison);
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget));
      }
   }
}




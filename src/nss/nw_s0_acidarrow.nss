//::///////////////////////////////////////////////
//:: Melf's Acid Arrow
//:: MelfsAcidArrow.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   An acidic arrow springs from the caster's hands
   and does 3d6 acid damage to the target.  For
   every 3 levels the caster has the target takes an
   additional 1d6 per round.
*/

#include "x0_i0_spells"
#include "x2_i0_spells"
#include "pure_caster_inc"
#include "_inc_sneakspells"

void RunImpact(object oTarget, object oCaster, int nMetaMagic, int nPureBonus, int bHasNekrosis = FALSE) {
   if (GZGetDelayedSpellEffectsExpired(SPELL_MELFS_ACID_ARROW, oTarget, oCaster)) return;
   if (!GetIsDead(oTarget))
   {
      int nNegDmg;
      int nDamage = MaximizeOrEmpower(6, 1, nMetaMagic) + nPureBonus;
      effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
      effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

      if (bHasNekrosis)
      {
         if (BlockNegativeDamage(oTarget)) nNegDmg = 0;
         else nNegDmg = nDamage/2;
         eDam = EffectLinkEffects(EffectDamage(nDamage/2, DAMAGE_TYPE_ACID), EffectDamage(nNegDmg, DAMAGE_TYPE_NEGATIVE));
         eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
      }

      eDam = EffectLinkEffects(eVis, eDam); // flare up
      ApplyEffectToObject (DURATION_TYPE_INSTANT, eDam, oTarget);
      DelayCommand(6.0f, RunImpact(oTarget, oCaster, nMetaMagic, nPureBonus));
   }
}

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   if (GetHasSpellEffect(GetSpellId(),oTarget)) { // This spell no longer stacks. If there is one of that type, thats ok
      FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
      return;
   }

   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = 1+GetMin(9, nPureLevel/3);
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
   int nNegDmg;
   effect eVis     = EffectVisualEffect(VFX_IMP_ACID_L);
   effect eArrow   = EffectVisualEffect(VFX_DUR_MIRV_ACID);

   int bHasNekrosis;
   if (nPureBonus && HasNekrosis(OBJECT_SELF)) bHasNekrosis = TRUE;

   if (GetIsReactionTypeFriendly(oTarget) == FALSE)
   {
      //int nSneakBonus = getSneakDamageRanged(OBJECT_SELF, oTarget);
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
      float fDist = GetDistanceToObject(oTarget);
      float fDelay = (fDist/25.0);
      if (MyResistSpell(OBJECT_SELF, oTarget) == FALSE)
      {
         int nDamage = MaximizeOrEmpower(6, 3 + nPureBonus/2, nMetaMagic);
         //nDamage += nSneakBonus;
         effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
         if (bHasNekrosis)
         {
            if (BlockNegativeDamage(oTarget)) nNegDmg = 0;
            else nNegDmg = nDamage/2;
            eDam = EffectLinkEffects(EffectDamage(nDamage/2, DAMAGE_TYPE_ACID), EffectDamage(nNegDmg, DAMAGE_TYPE_NEGATIVE));
         }
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
         object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
         DelayCommand(6.0f, RunImpact(oTarget, oSelf, nMetaMagic, nPureBonus, bHasNekrosis));
      } else {
         effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
         DelayCommand(fDelay+0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, oTarget));
      }
   }
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);
}




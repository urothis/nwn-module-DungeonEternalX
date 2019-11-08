//::///////////////////////////////////////////////
//:: [Dominate Monster]
//:: [NW_S0_DomMon.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Will save or the target monster is Dominated for
   3 turns +1 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();

   effect eDom = EffectDominated();
   effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
   float fDuration = TurnsToSeconds(3 + nPureLevel/2);

   if (GetIsPC(oTarget))
   {
      fDuration = RoundsToSeconds(1 + nPureLevel/8);
      eDom = EffectLinkEffects(EffectDazed(), EffectCutsceneParalyze());
   }

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) fDuration = fDuration * 2.0;

   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);

   //Link domination and persistant VFX
   effect eLink = EffectLinkEffects(eMind, eDom);

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_MONSTER, FALSE));
   //Make sure the target is a monster
   if(!GetIsReactionTypeFriendly(oTarget)) {
      if (!MyResistSpell(OBJECT_SELF, oTarget)) { //Make SR Check
         if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS)) { //Make a Will Save
            if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF)) {
               //Apply linked effects and VFX Impact
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
         }
      }
   }
}

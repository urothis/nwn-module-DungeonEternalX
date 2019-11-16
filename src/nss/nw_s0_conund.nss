//::///////////////////////////////////////////////
//:: [Control Undead]
//:: [NW_S0_ConUnd.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   A single undead with up to 3 HD per caster level
   can be dominated.
*/

#include "nw_i0_spells"
#include "seed_boost_undea"

void main() {

   object oTarget = GetSpellTargetObject();
   if (GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD) return; // NOT UNDEAD, EXIT
   if (GetIsReactionTypeFriendly(oTarget)) return;  // NOT ENEMIES, EXIT

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nMaxDom = GetMin(1+nPureBonus/2,3);
   if (CountUndead(OBJECT_SELF) >= nMaxDom) {
      FloatingTextStringOnCreature("Too many Undead in your service...", OBJECT_SELF, FALSE);
      return;
   }

   if (GetHitDice(oTarget) > (nPureLevel * 2)) return; // ONLY LOWER LEVEL THAN ME * 2

   // VALID TARGET, LET THEM KNOW THEY BEEN CAST UPON
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTROL_UNDEAD));

   if (MyResistSpell(OBJECT_SELF, oTarget)) return; // RESISTED SPELL, EXIT
   if (MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, 1.0)) return; // MADE WILL SAVE, EXIT

   // THEY ARE OURS, APPLY DOMINATE
   effect eControl = EffectDominated();
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
   effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
   effect eLink = EffectLinkEffects(eMind, eControl);

   int nDuration = nPureLevel;

   if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration = nPureLevel * 2;

   //Apply VFX impact and Link effect
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration)));
}

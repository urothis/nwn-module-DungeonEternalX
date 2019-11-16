//::///////////////////////////////////////////////
//:: Expeditious retreat
//:: x0_s0_exretreat.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Increases movement rate to the max, allowing
 the spell-caster to flee.
 Also gives + 2 AC bonus
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   FloatingTextStringOnCreature("This spell is disabled", OBJECT_SELF, FALSE);

   /*
   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();

   if (GetHasSpellEffect(SPELL_HASTE, oTarget) == TRUE) return ; // does nothing if caster already has haste
   RemoveEffectsFromSpell(oTarget, SPELL_EXPEDITIOUS_RETREAT);

   effect eFast = EffectMovementSpeedIncrease(50);

   int nDuration = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EXPEDITIOUS_RETREAT, FALSE));
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFast, oTarget, RoundsToSeconds(nDuration));
   */
}

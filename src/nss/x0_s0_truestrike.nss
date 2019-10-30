//::///////////////////////////////////////////////
//:: Truestrike
//:: x0_s0_truestrike.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
+20 attack bonus for 9 seconds.
CHANGE: Miss chance still applies, unlike rules.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget;
   effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
   // * determine the damage bonus to apply
   effect eAttack = EffectAttackIncrease(20 + nPureBonus);
   oTarget = OBJECT_SELF;
   //Fire spell cast at event for target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 415, FALSE));
   //Apply VFX impact and bonus effects
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oTarget, 9.0 + IntToFloat(nPureBonus));

}


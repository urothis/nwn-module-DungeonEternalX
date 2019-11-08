//::///////////////////////////////////////////////
//:: Displacement
//:: x0_s0_displace
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Target gains a 50% concealment bonus.
*/
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   effect eDisplace;
   effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = nPureLevel;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   int nConceal = 50;
   if (oTarget==OBJECT_SELF) nConceal += nPureBonus;
   eDisplace = EffectConcealment(nConceal);
   if (GetEffectType(eDisplace) != EFFECT_TYPE_INVALIDEFFECT) {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISPLACEMENT, FALSE));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDisplace, oTarget, RoundsToSeconds(nDuration));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   }
}

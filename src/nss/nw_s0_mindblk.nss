//::///////////////////////////////////////////////
//:: Mind Blank
//:: NW_S0_MindBlk.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All allies are granted immunity to mental effects
   in the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   float fRadius;
   object oTarget;
   int nSpellID = GetSpellId();
   if (nSpellID==SPELL_LESSER_MIND_BLANK) { // innate 5
      if (nPureBonus==0) {
         oTarget = GetSpellTargetObject();
         spellApplyMindBlank(GetSpellTargetObject(), GetSpellId());
         return;
      }
      fRadius = RADIUS_SIZE_SMALL + IntToFloat(nPureBonus/2);
   } else if (nSpellID==SPELL_MIND_BLANK) { // innate 8
      fRadius = RADIUS_SIZE_HUGE + IntToFloat(nPureBonus/2);
   }
   effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
   oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetSpellTargetLocation());
   while (GetIsObjectValid(oTarget)) {
      if(GetFactionEqual(oTarget)) {
         spellApplyMindBlank(oTarget, GetSpellId(), GetRandomDelay());
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetSpellTargetLocation());
   }
}

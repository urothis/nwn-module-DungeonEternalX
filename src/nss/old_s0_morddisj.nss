//::///////////////////////////////////////////////
//:: Mordenkainen's Disjunction
//:: NW_S0_MordDisj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Massive Dispel Magic and Spell Breach rolled into one
   If the target is a general area of effect they lose
   6 spell protections.  If it is an area of effect everyone
   in the area loses 2 spells protections.
*/

#include "X0_I0_SPELLS"
#include "inc_dispel"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   location lLocal = GetSpellTargetLocation();
   object oItem = GetSpellCastItem();
   effect eVis;
   effect eImpact;

   int nSpellID = GetSpellId();
   int nStripCnt = nPureBonus;

   if (nSpellID==SPELL_LESSER_DISPEL) {
      nStripCnt += 4;
      nPureLevel -= 15;
      eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
      eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
   } else if (nSpellID==SPELL_DISPEL_MAGIC) {
      nStripCnt += 6;
      nPureLevel -= 10;
      eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
      eImpact = EffectVisualEffect(VFX_FNF_DISPEL);
      if (IPGetIsMeleeWeapon(GetSpellCastItem())) nStripCnt = 1;
   } else if (nSpellID==SPELL_GREATER_DISPELLING) {
      nStripCnt += 8;
      nPureLevel -= 5;
      eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
      eImpact = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
   } else if (nSpellID==SPELL_MORDENKAINENS_DISJUNCTION) {
      nStripCnt += 10;
      eVis = EffectVisualEffect(VFX_IMP_BREACH);
      eImpact = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
   }

   if (GetIsObjectValid(oTarget)) { // SINGLE TARGET
      AltspellsDispelMagic(oTarget, OBJECT_SELF, eVis, nPureLevel, nStripCnt);
      if (nSpellID==SPELL_MORDENKAINENS_DISJUNCTION && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         AltSpellBreach(OBJECT_SELF, oTarget, 6 + nPureBonus/2, 15 + nPureBonus, nSpellID);
      }
   } else { // AS AOE
      //Apply the VFX impact and effects
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
      oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
      while (GetIsObjectValid(oTarget)) {
         if (GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT) {
            spellsDispelAoE(oTarget, OBJECT_SELF, nPureLevel);
         } else {
            AltspellsDispelMagic(oTarget, OBJECT_SELF, eVis, nPureLevel, 2 + nPureBonus/4); // aoe only dispells 2 effects per object
            if (nSpellID==SPELL_MORDENKAINENS_DISJUNCTION && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
               AltSpellBreach(OBJECT_SELF, oTarget, 2 + nPureBonus/4, 10 + nPureBonus/4, nSpellID);
            }
         }
         oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
      }
   }
}

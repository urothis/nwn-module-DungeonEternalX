//::///////////////////////////////////////////////
//:: Crumble
//:: X2_S0_Crumble
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// This spell inflicts 1d6 points of damage per
// caster level to Constructs to a maximum of 15d6.
// This spell does not affect living creatures.
*/

#include "nw_i0_spells"
#include "X2_i0_spells"
//------------------------------------------------------------------------------
// This part is moved into a delayed function in order to alllow it to bypass
// Golem Spell Immunity. Magic works by rendering all effects applied
// from within a spellscript useless. Delaying the creation and application of
// an effect causes it to loose it's SpellId, making it possible to ignore
// Magic Immunity. Hacktastic!
//------------------------------------------------------------------------------
void DoCrumble (int nDam, object oCaster, object oTarget) {
   float  fDist = GetDistanceBetween(oCaster, oTarget);
   float  fDelay = fDist/(3.0 * log(fDist) + 2.0);
   effect eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);
   effect eMissile = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
   effect eCrumb = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
   effect eVis = EffectVisualEffect(135);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, oTarget);
   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
   DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
}

#include "pure_caster_inc"

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus*2;

   object oCaster  = OBJECT_SELF;
   object oTarget  = GetSpellTargetObject();
   int  nCasterLvl = nPureLevel;
   int  nType     = GetObjectType(oTarget);
   int  nRacial   = GetRacialType(oTarget);
   int  nMetaMagic = GetMetaMagicFeat();

   if (nCasterLvl > 20 + nPureBonus) nCasterLvl = 20 + nPureBonus;

   SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
   effect eCrumb = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, oTarget);

   if (nType!=OBJECT_TYPE_CREATURE && nType!=OBJECT_TYPE_PLACEABLE && nType!=OBJECT_TYPE_DOOR ) return;
   if (GetRacialType(oTarget)!=RACIAL_TYPE_CONSTRUCT && GetLevelByClass(CLASS_TYPE_CONSTRUCT, oTarget)==0) return;

   int nDam = d6(nCasterLvl);

   if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 6 * nCasterLvl;
   if (nMetaMagic == METAMAGIC_EMPOWER) nDam += nDam/2;
   if (nDam>0) {
      if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_ALL)){
        nDam = GetCurrentHitPoints(oTarget) + 1;
      }
      DelayCommand(0.1f,DoCrumble(nDam, oCaster, oTarget)); // * Severs the tie between spellId and effect, allowing it to bypass any magic resistance
   }
}

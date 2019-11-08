//::///////////////////////////////////////////////
//:: Globe of Invulnerability
//:: NW_S0_GlobeInv.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Caster is immune to 4th level spells or lower.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   effect eVis;
   int nDuration = nPureLevel;
   if (GetMetaMagicFeat()==METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   int nLevel;
   int nSpellID = GetSpellId();
   if (nSpellID==SPELL_MINOR_GLOBE_OF_INVULNERABILITY) {
      nLevel = 3;
      eVis = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
   } else if (nSpellID==SPELL_GLOBE_OF_INVULNERABILITY) {
      nLevel = 4;
      eVis = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
   }
   nLevel += nPureBonus/4;

   object oTarget = OBJECT_SELF;
   effect eSpell = EffectSpellLevelAbsorption(nLevel, 0);
   effect eLink = EffectLinkEffects(eVis, eSpell);
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

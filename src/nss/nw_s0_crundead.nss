//::///////////////////////////////////////////////
//:: Create Undead
//:: NW_S0_CrUndead.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "seed_boost_undea"

void main() {

   //Declare major variables
   string sResRef;
   effect eSummon;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, OBJECT_SELF)) nPureLevel++;
   if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, OBJECT_SELF)) nPureLevel++;

   int nDuration = GetMin(24, nPureLevel);
   if (GetMetaMagicFeat()==METAMAGIC_EXTEND) nDuration = nDuration * 2;

   //Summon the appropriate creature based on the summoner level

   if      (nPureLevel <= 11) sResRef = "nw_s_ghoul";
   else if (nPureLevel <= 13) sResRef = "nw_s_ghast";
   else if (nPureLevel <= 15) sResRef = "nw_s_wight";
   else                       sResRef = "nw_s_spectre";

   if (nPureBonus > 0) {
      int nMaxDom = GetMin(1+nPureBonus/2,3);
      CreateUndead(sResRef, GetSpellTargetLocation(), nMaxDom);
   } else {
      eSummon = EffectSummonCreature(sResRef,VFX_FNF_SUMMON_UNDEAD);
      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
      DelayCommand(2.0f, BoostUndeadSummon(OBJECT_SELF));
   }
}

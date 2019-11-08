//::///////////////////////////////////////////////
//:: Elemental Swarm
//:: NW_S0_EleSwarm.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   This spell creates a conduit from the caster
   to the elemental planes.  The first elemental
   summoned is a 24 HD Air elemental.  Whenever an
   elemental dies it is replaced by the next
   elemental in the chain Air, Earth, Water, Fire
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eSummon;
   int nMetaMagic = GetMetaMagicFeat();
   int nCasterLevel = nPureLevel;
   int nDuration = 24;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;  //Duration is +100%
   int lvl = 1;
   nPureLevel -= 17;
   if (nPureLevel > 0) {
     lvl = 1 + nPureLevel / 5;
   }
   if (nPureBonus) lvl++;
   if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION)) lvl++;

   if (lvl == 1) {
     eSummon = EffectSwarm(FALSE, "NW_S_AIRGREAT","NW_S_WATERGREAT","NW_S_FIREGREAT","NW_S_EARTHGREAT");
   } else if (lvl == 2) {
     eSummon = EffectSwarm(FALSE, "NW_S_AIRELDER","NW_S_WATERELDER","NW_S_FIREELDER","NW_S_EARTHELDER");
   } else if (lvl == 3) {
     eSummon = EffectSwarm(FALSE, "SU_AIRANCIENT","SU_WATERANCIENT","SU_FIREANCIENT","SU_EARTHANCIENT");
   } else if (lvl == 4) {
     eSummon = EffectSwarm(FALSE, "SU_AIRABORIGINAL","SU_WATERABORIGIN","SU_FIREABORIGINA","SU_EARTHABORIGIN");
   } else if (lvl == 5) {
     eSummon = EffectSwarm(FALSE, "SU_AIRPRIMORDIAL","SU_WATERPRIMORDI","SU_FIREPRIMORDIA","SU_EARTHPRIMORDI");
   } else if (lvl == 6) {
     eSummon = EffectSwarm(FALSE, "SU_AIRPRIMEVAL","SU_WATERPRIMEVAL","SU_FIREPRIMEVAL","SU_EARTHPRIMEVAL");
   } else if (lvl >= 7) {
     eSummon = EffectSwarm(FALSE, "SU_AIRCREATOR","SU_WATERCREATOR","SU_FIRECREATOR","SU_EARTHCREATOR");
     DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_WORD), GetSpellTargetLocation()));
   }

   //Apply the summon effect
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, HoursToSeconds(nDuration));
}



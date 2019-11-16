//::///////////////////////////////////////////////
//:: Summon Greater Undead
//:: X2_S2_SumGrUnd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "seed_boost_undea"

void main() {

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY); // MAX 8 or 10 for PM30/WIZ10
   int nPureLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER, OBJECT_SELF); // MAX 30
   if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, OBJECT_SELF)) nPureLevel++; // MAX 31
   if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, OBJECT_SELF)) nPureLevel+=2;  // MAX 33
   if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF)) nPureLevel+=2; // MAX 35

   if (GetSpellId()==SPELLABILITY_PM_SUMMON_GREATER_UNDEAD) nPureLevel +=nPureBonus; // max 40

   int nDuration = 14 + nPureLevel;
   FloatingTextStringOnCreature("Pure Summon Level " + IntToString(nPureLevel), OBJECT_SELF, FALSE);
   effect eSummon;
   //                                                                                                                                         Sum  PM Sv Abil
   if      (nPureLevel <=  3)  eSummon = EffectSummonCreature("pm_shadow",     VFX_IMP_HARM);                     // * Shadow                 6     3
   else if (nPureLevel <=  4)  eSummon = EffectSummonCreature("pm_ghoul",      VFX_IMP_HARM);                     // * Ghoul                  7     4
   else if (nPureLevel <=  5)  eSummon = EffectSummonCreature("pm_ghast",      VFX_FNF_SUMMON_UNDEAD, 0.0f, 1);   // * Ghast                  8     5
   else if (nPureLevel <=  6)  eSummon = EffectSummonCreature("pm_wight",      VFX_FNF_SUMMON_UNDEAD, 0.0f, 1);   // * Wight                  9     6
   else if (nPureLevel <=  7)  eSummon = EffectSummonCreature("pm_wraith",     VFX_FNF_SUMMON_UNDEAD, 0.0f, 1);   // * Wraith                 10    7
   else if (nPureLevel <=  8)  eSummon = EffectSummonCreature("pm_mummy",      VFX_IMP_HARM, 0.0f, 0);            // * Mummy                * 11    8  2
   else if (nPureLevel <= 10)  eSummon = EffectSummonCreature("pm_spectre",    VFX_FNF_SUMMON_UNDEAD, 0.0f, 1);   // * Spectre              * 12   10  3
   else if (nPureLevel <= 12)  eSummon = EffectSummonCreature("pm_vamprouge",  VFX_FNF_SUMMON_UNDEAD, 0.0f, 1);   // * Vampire Rogue        * 14   12  3
   else if (nPureLevel <= 14)  eSummon = EffectSummonCreature("pm_bodak",      VFX_IMP_HARM, 0.0f, 0);            // * Greater Bodak        * 16   14  3
   else if (nPureLevel <= 16)  eSummon = EffectSummonCreature("pm_ghoullord",  VFX_IMP_HARM, 0.0f, 0);            // * Ghoul King           * 18   16  4
   else if (nPureLevel <= 18)  eSummon = EffectSummonCreature("pm_vamppriest", VFX_FNF_SUMMON_UNDEAD, 0.0f, 1);   // * Vampire Mage         * 20   18  4
   else if (nPureLevel <= 20)  eSummon = EffectSummonCreature("pm_bguard",     VFX_IMP_HARM, 0.0f, 0);            // * Skeleton Blackguard  * 22   20  5 24
   else if (nPureLevel <= 22)  eSummon = EffectSummonCreature("pm_bguard2",    VFX_IMP_HARM, 0.0f, 0);            // * Skeleton BlackKnight * 24   22  5 26
   else if (nPureLevel <= 24)  eSummon = EffectSummonCreature("pm_doomknight", VFX_IMP_HARM, 0.0f, 0);            // * Doom Knight          * 26   24  6 28
   else if (nPureLevel <= 26)  eSummon = EffectSummonCreature("pm_alhoon",     496, 0.0f, 1);                     // * Alhoon               * 28   26  6 30
   else if (nPureLevel <= 28)  eSummon = EffectSummonCreature("pm_lich",       496, 0.0f, 1);                     // * Lich                 * 30   28  7 32
   else if (nPureLevel <= 30)  eSummon = EffectSummonCreature("pm_lich2"  ,    496, 0.0f, 1);                     // * Lich                 * 32   30  7 34
   else if (nPureLevel <= 33)  eSummon = EffectSummonCreature("pm_demilich",   496, 0.0f, 1);                     // * Demi Lich            * 34   34  8 36
   else if (nPureLevel <= 43)  eSummon = EffectSummonCreature("pm_demilich2",  496, 0.0f, 1);                     // * Demi Lich            * 36   38  8 38
   else if (nPureLevel >  43)  eSummon = EffectSummonCreature("pm_dracolich",  496, 0.0f, 1);                     // * Draco Lich           * 40   42  9 40

   eSummon = SupernaturalEffect(eSummon);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_10), GetSpellTargetLocation());
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));

   DelayCommand(2.0f, BoostUndeadSummon(OBJECT_SELF));

}







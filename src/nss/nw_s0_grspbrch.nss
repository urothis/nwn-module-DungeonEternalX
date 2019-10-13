//::///////////////////////////////////////////////
//:: Greater Spell Breach
//:: NW_S0_GrSpBrch.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes 4 spell defenses from an enemy mage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "inc_dispel"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nBreachCnt;
   int nSRDrop;
   int nSpellID = GetSpellId();
   if (nSpellID == SPELL_LESSER_SPELL_BREACH) { // innate 4
      nBreachCnt = 2 + nPureBonus/2;
      nSRDrop    = 5 + nPureBonus;
   } else if (nSpellID==SPELL_GREATER_SPELL_BREACH) { // innate 6
      nBreachCnt = 4 + nPureBonus/2;
      nSRDrop    = 10 + nPureBonus;
   }
   AltSpellBreach(OBJECT_SELF, GetSpellTargetObject(), nBreachCnt, nSRDrop, nSpellID);
}

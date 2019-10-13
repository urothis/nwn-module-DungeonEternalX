//::///////////////////////////////////////////////
//:: Isaacs Lesser Missile Storm
//:: x0_s0_MissStorm1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 10 missiles, each doing 1d6 damage to all
 targets in area.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Last Updated By:

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   int nDice = 1;
   int nCnt = 10;
   int bHasNekrosis;
   if (nPureBonus && HasNekrosis(OBJECT_SELF)) bHasNekrosis = TRUE;

   DoMissileStorm(nDice, nCnt, SPELL_ISAACS_LESSER_MISSILE_STORM, VFX_IMP_MIRV, DAMAGE_TYPE_MAGICAL, FALSE, FALSE, 0, bHasNekrosis);
}



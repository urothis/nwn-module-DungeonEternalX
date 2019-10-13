//::///////////////////////////////////////////////
//:: Isaacs Greater Missile Storm
//:: x0_s0_MissStorm2
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 20 missiles, each doing 3d6 damage to each
 target in area.
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
   int nCnt = 20 + nPureBonus;
   int bHasNekrosis;
   if (nPureBonus && HasNekrosis(OBJECT_SELF)) bHasNekrosis = TRUE;


   DoMissileStorm(nDice, nCnt, SPELL_ISAACS_GREATER_MISSILE_STORM, VFX_IMP_MIRV, VFX_IMP_MAGBLUE, DAMAGE_TYPE_MAGICAL, FALSE, FALSE, 0, bHasNekrosis);
}



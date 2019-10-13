//::///////////////////////////////////////////////
//:: Firebrand
//:: x0_x0_Firebrand
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// * Fires a flame arrow to every target in a
// * colossal area
// * Each target explodes into a small fireball for
// * 1d6 damage / level (max = 15 levels)
// * Only nLevel targets can be affected
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 29 2002
//:://////////////////////////////////////////////
//:: Last Updated By:
#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   if (nPureLevel > 15 + nPureBonus) nPureLevel = 15 + nPureBonus;
   int bHasNekrosis;
   if (nPureBonus && HasNekrosis(OBJECT_SELF)) bHasNekrosis = TRUE;

   DoMissileStorm(nPureLevel, 15, SPELL_FIREBRAND, VFX_IMP_MIRV_FLAME, VFX_IMP_FLAME_M, DAMAGE_TYPE_FIRE, TRUE, TRUE, nPureDC, bHasNekrosis);
}

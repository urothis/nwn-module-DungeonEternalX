//::///////////////////////////////////////////////
//:: Ball Lightning
//:: x0_s0_balllghtng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 15 missiles, each doing 1d6 damage to all
 targets in area.
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int bHasNekrosis;
   if (nPureBonus && HasNekrosis(OBJECT_SELF)) bHasNekrosis = TRUE;

   DoMissileStorm(2, 10 + nPureBonus/2, GetSpellId(), 503, VFX_IMP_LIGHTNING_S, DAMAGE_TYPE_ELECTRICAL, FALSE, TRUE, nPureDC, bHasNekrosis);
}

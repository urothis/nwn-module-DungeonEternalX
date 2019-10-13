//::///////////////////////////////////////////////
//:: Cure Serious Wounds
//:: NW_S0_CurSerW
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// As cure light wounds, except cure moderate wounds
// cures 3d8 points of damage plus 1 point per caster
// level (up to +15).
*/

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    spellsCure(d8(3), 15, 24, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_L, GetSpellId());
}


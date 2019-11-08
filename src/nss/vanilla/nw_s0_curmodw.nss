//::///////////////////////////////////////////////
//:: Cure Moderate Wounds
//:: NW_S0_CurModW
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// As cure light wounds, except cure moderate wounds
// cures 2d8 points of damage plus 1 point per
// caster level (up to +10).
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    object oItem = GetSpellCastItem();
    object oPC = OBJECT_SELF;
    if (GetIsObjectValid(oItem) && GetTag(oItem) == "QUEST_CRYPT_RING")
    {
        if (GetHitDice(oPC) >= 40)
        {
            FloatingTextStringOnCreature("To high level for this item", oPC);
            return;
        }
    }

    int nPureBonus = GetPureCasterBonus(oPC, SPELL_SCHOOL_CONJURATION);
    int nPureLevel = GetPureCasterLevel(oPC, SPELL_SCHOOL_CONJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    spellsCure(d8(2), 10, 16, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_M, GetSpellId());
}


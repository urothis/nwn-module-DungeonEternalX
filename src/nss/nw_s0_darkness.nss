//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S0_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"
#include "assn_bonus"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
    location lTarget = GetSpellTargetLocation();
    int nDuration = 1+GetMin(9, GetCasterLevel(OBJECT_SELF)/3);
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;  //Duration is +100%
    //Create an instance of the AOE Object using the Apply Effect function
    int nSpell     = GetSpellId();

    if (nSpell == 606) // Cory - Assassin Invisibilty - "Mark Target"
    {
        AssnDarkness(lTarget);
        return;
    }

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

//::///////////////////////////////////////////////
//:: Storm of Vengeance
//:: NW_S0_StormVeng.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an AOE that decimates the enemies of
    the cleric over a 30ft radius around the caster
*/
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    object oCaster = OBJECT_SELF;
    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;
    int nToClose;
    //Declare major variables
    effect eAOE = EffectAreaOfEffect(AOE_PER_STORM, "nw_s0_stormvena", "nw_s0_stormvenc", "nw_s0_stormvenb"); // fixed by RedACE
    location lTarget = GetSpellTargetLocation();
    effect eImpact = EffectVisualEffect(VFX_FNF_STORM);
    int nDuration = 1+GetMin(9, nPureLevel/3);

    object oTrigger = GetNearestObject(OBJECT_TYPE_TRIGGER);
    if (GetIsObjectValid(oTrigger))
    {
        if (GetDistanceBetween(oTrigger, oCaster) < 15.0) nDuration = 1;
    }
    else
    {
        int nMetaMagic = GetMetaMagicFeat();
        if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
    }
    //Apply the AOE object to the specified location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

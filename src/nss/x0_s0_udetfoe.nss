//::///////////////////////////////////////////////
//:: Undeath's Eternal Foe
//:: x0_s0_udetfoe.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants many protections against undead
    to allies in a small area
    of effect (everyone gets negative energy protection)
    immunity to poison and disease too
    +4 AC bonus to all creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    object oTarget;
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 50);
    effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
    effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
    effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
    effect eDisease = EffectImmunity(IMMUNITY_TYPE_DISEASE);
    //effect eAC = EffectACIncrease(4);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Link Effects
    effect eLink = EffectLinkEffects(eNeg, eLevel);
    eLink = EffectLinkEffects(eLink, ePoison);
    eLink = EffectLinkEffects(eLink, eDisease);

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    //Get the first target in the radius around the caster
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    while(GetIsObjectValid(oTarget))
    {
        if (GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 444, FALSE));
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    }
}




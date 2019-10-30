//::///////////////////////////////////////////////
//:: Healing Circle
//:: NW_S0_HealCirc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Positive energy spreads out in all directions
// from the point of origin, curing 1d8 points of
// damage plus 1 point per caster level (maximum +20)
// to nearby living allies.
//
// Like cure spells, healing circle damages undead in
// its area rather than curing them.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureCaster = GetIsPureCaster(OBJECT_SELF);
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_DRUID)+ GetLevelByClass(CLASS_TYPE_CLERIC)+ GetLevelByClass(CLASS_TYPE_BARD);

    //  Max's Healing at 40 + random 20 - 40 pts.
    int nAmount = nCasterLevel + d2(nCasterLevel/2);

    //  Adds an additional Max of 20 pts for meta
    if (GetMetaMagicFeat()==METAMAGIC_MAXIMIZE || GetMetaMagicFeat()==METAMAGIC_EMPOWER) nAmount += nCasterLevel/2;
    //  Adds an additional Max of 20 pts for pureclass.
    if (nPureCaster) nAmount += nCasterLevel/2;
    //  Adds an additional Max of 40 pts for healing domain.
    if (GetHasFeat(FEAT_HEALING_DOMAIN_POWER, OBJECT_SELF)) nAmount += d2(nCasterLevel/2);

    //  Setup the Healing visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    //  Setup the Healing Visual vs Undead.
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_M);
    //  Determin the radius of the Heal and apply its effect.
    float fDelay;
    float fRadius = RADIUS_SIZE_MEDIUM + IntToFloat(nCasterLevel);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_20), GetSpellTargetLocation());
    location lLoc = GetSpellTargetLocation();
    //  Get first target in shape
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
    //  Set the Event.
    while (GetIsObjectValid(oTarget))
    {
        if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            if (!GetIsReactionTypeFriendly(oTarget))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEALING_CIRCLE));
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nAmount, DAMAGE_TYPE_DIVINE), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEALING_CIRCLE, FALSE));
            if (GetFactionEqual(oTarget))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nAmount), oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
    }
}

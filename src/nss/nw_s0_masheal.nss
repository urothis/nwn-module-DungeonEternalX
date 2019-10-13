//::///////////////////////////////////////////////
//:: Mass Heal
//:: [NW_S0_MasHeal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals all friendly targets within 10ft to full
//:: unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureCaster  = GetIsPureCaster(OBJECT_SELF);
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_DRUID)+ GetLevelByClass(CLASS_TYPE_CLERIC);
    location lLoc = GetSpellTargetLocation();
    float fDelay = 0.75;

    //Apply VFX area impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_10), lLoc);

    //Get first target in spell area
    float fRadius = RADIUS_SIZE_MEDIUM + IntToFloat(nCasterLevel/10);

    //  Max's Healing at 160 + random 40 - 80 pts.
    int nAmount = 4 * nCasterLevel + d2(nCasterLevel);

    //  Adds an additional Max of 60 pts for pureclass.
    if (nPureCaster) nAmount += d2(nCasterLevel/2+10);

    //  Adds an additional Max of 80 pts for healing domain.
    if (GetHasFeat(FEAT_HEALING_DOMAIN_POWER, OBJECT_SELF)) nAmount += d2(nCasterLevel/2+20);

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
    while(GetIsObjectValid(oTarget))
    {
        if (GetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
        {
            if (!GetIsReactionTypeFriendly(oTarget))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL));
                if (TouchAttackMelee(oTarget))
                {
                    if (!MyResistSpell(OBJECT_SELF, oTarget))
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nAmount, DAMAGE_TYPE_DIVINE), oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTarget));
                    }
                }
            }
        }
        else
        {
            if (GetFactionEqual(oTarget))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G), oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nAmount), oTarget));
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
    }

}

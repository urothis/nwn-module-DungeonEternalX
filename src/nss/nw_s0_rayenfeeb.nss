//::///////////////////////////////////////////////
//:: Ray of EnFeeblement
//:: [NW_S0_rayEnfeeb.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Fort save or take ability
//:: damage to Strength equaling 1d6 +1 per 2 levels,
//:: to a maximum of +5.  Duration of 1 round per
//:: caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "_inc_sneakspells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration  = nPureLevel;
    int nBonus     = GetMax(1, GetMin(nDuration / 2, 5));
    int nLoss      = GetMax(nPureBonus, d6()) + GetMax(nPureBonus, nBonus);

    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_MAXIMIZE)     nLoss = 6 + nBonus;
    else if (nMetaMagic == METAMAGIC_EMPOWER) nLoss = nLoss + (nLoss/2);
    else if (nMetaMagic == METAMAGIC_EXTEND)  nDuration = nDuration * 2;

    int nInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) - 3;
    nLoss = GetMin(nInt, nLoss);

    effect eFeeb;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eRay;

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        int nSneakBonus = getSneakDamageRanged(OBJECT_SELF, oTarget);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));
        eRay = EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_HAND);

        //Make SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Make a Fort save to negate
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_NEGATIVE))
            {
                //Set ability damage effect
                eFeeb = EffectAbilityDecrease(ABILITY_STRENGTH, nLoss);

                //Apply the ability damage effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFeeb, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);

                //Apply sneak bonus
                if (nSneakBonus>0)
                {
                    if (BlockNegativeDamage(oTarget)) nSneakBonus = 0;
                    effect eDam = EffectDamage(nSneakBonus, DAMAGE_TYPE_NEGATIVE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
            }
        }
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
}

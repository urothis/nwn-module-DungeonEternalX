//::///////////////////////////////////////////////
//:: Healing Sting
//:: X2_S0_HealStng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   You inflict 1d6 +1 point per level damage to
   the living creature touched and gain an equal
   amount of hit points. You may not gain more
   hit points then your maximum with the Healing
   Sting.
*/

#include "nw_i0_spells"

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    object oTarget = GetSpellTargetObject();

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage = d6(1 + nPureBonus) + nPureLevel;

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * (1 + nPureBonus) + nPureLevel;//Damage is at max
    else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += nDamage / 2;

    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        int nRacialType = GetRacialType(oTarget);
        if (!GetIsReactionTypeFriendly(oTarget) && nRacialType != RACIAL_TYPE_UNDEAD && nRacialType != RACIAL_TYPE_CONSTRUCT &&
         !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {
            //Signal spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Spell resistance
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_NEGATIVE))
                {
                    nDamage /= 2;
                }
                if (BlockNegativeDamage(oTarget)) nDamage = 0;
                effect eHeal = EffectHeal(nDamage);
                effect eVis  = EffectVisualEffect(VFX_IMP_HEALING_M);
                effect eLink = EffectLinkEffects(eVis,eHeal);

                effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                effect eLink2 = EffectLinkEffects(eVis2,eDamage);

                ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, OBJECT_SELF);
                SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
            }
        }
    }
}

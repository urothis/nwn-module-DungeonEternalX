//::///////////////////////////////////////////////
//:: Heal
//:: [NW_S0_Heal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals the target to full unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureCaster = GetIsPureCaster(OBJECT_SELF);
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_DRUID)+ GetLevelByClass(CLASS_TYPE_CLERIC);

    object oTarget = GetSpellTargetObject();

    //  Max's Healing at 240 + random 40 - 80 pts.
    int nAmount = 6 * nCasterLevel + d2(nCasterLevel);

    //  Adds an additional Max of 60 pts for pureclass.
    if (nPureCaster) nAmount += d2(nCasterLevel/2+10);

    //  Adds an additional Max of 80 pts for healing domain.
    if (GetHasFeat(FEAT_HEALING_DOMAIN_POWER, OBJECT_SELF)) nAmount += d2(nCasterLevel/2+20);

    if (GetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
    {
        if (!GetIsReactionTypeFriendly(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL));
            if (TouchAttackMelee(oTarget))
            {
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nAmount, DAMAGE_TYPE_DIVINE), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oTarget);
                }
            }
        }
    }
    else
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nAmount), oTarget);
    }
}

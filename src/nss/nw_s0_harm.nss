//::///////////////////////////////////////////////
//:: [Harm]
//:: [NW_S0_Harm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Reduces target to 1d4 HP on successful touch
//:: attack.  If the target is undead it is healed.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: Last Update: Georg Zoeller On: Oct 10, 2004
//:://////////////////////////////////////////////


#include "x0_I0_SPELLS"
#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;
    object oTarget = GetSpellTargetObject();
    if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) return;

    int nPureCaster = GetIsPureCaster(OBJECT_SELF);
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_DRUID)+ GetLevelByClass(CLASS_TYPE_CLERIC);

    int nDamageCap = 350;

    int nAmount = d2(4) * nCasterLevel;

    if (nPureCaster || GetHasFeat(FEAT_EVIL_DOMAIN_POWER, OBJECT_SELF))
    {
        nAmount = (d2(5) * nCasterLevel) + nCasterLevel;
    }

    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));
        if (TouchAttackMelee(oTarget))
        {
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nAmount), oTarget);
            }
        }
    }
    else
    {
        //if (!GetIsReactionTypeFriendly(oTarget))
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, TRUE));
            if (TouchAttackMelee(oTarget))
            {
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    if (nAmount > GetCurrentHitPoints(oTarget)) nAmount = GetCurrentHitPoints(oTarget) - 5;
                    if (nAmount > nDamageCap) nAmount = nDamageCap;
                    if (BlockNegativeDamage(oTarget)) nAmount = 0;
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nAmount, DAMAGE_TYPE_NEGATIVE), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oTarget);
                }
            }
        }
    }
}

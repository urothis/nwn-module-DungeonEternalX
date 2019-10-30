//:://////////////////////////////////////////////
/*
    DeX Divine Favor
    Does NOT stack with Divine Wrath and Blade Thirst.
    1 AB and Damage / 3 levels (max 5)
    Clerics recieve less damage: 1 / 5 levels (max 3)
    Double duration (4x with extend spell) and indispelable if cast without monkspeed
*/
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "x2_inc_spellhook"
void main()
{

    if (!X2PreSpellCastCode()) return;

    if (GetHasSpellEffect(SPELL_BLADE_THIRST, OBJECT_SELF))
    {
        FloatingTextStringOnCreature("This Spell does not stack with Blade Thirst", OBJECT_SELF);
        return;
    }



    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

    int nLvl = (GetCasterLevel(OBJECT_SELF));
    int nAB = nLvl/3;
    if (nAB < 1) nAB = 1;
    if (nAB > 5) nAB = 5;

    int nDamage; effect eDamage;
    if (GetLevelByClass(CLASS_TYPE_CLERIC))
    {
        nDamage = nLvl/5;
        if (nDamage < 1) nDamage = 1;
        if (nDamage > 3) nDamage = 3;
        eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_MAGICAL);
    }
    else
    {
        nDamage = nAB;
        eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_MAGICAL);
    }

    // Cory - Reduced power with divine wrath
    if (GetHasFeatEffect(FEAT_DIVINE_WRATH, OBJECT_SELF))
    {
        FloatingTextStringOnCreature("This Spell does not stack with Divine Wrath", OBJECT_SELF);
        return;
    }

    effect eAttack = EffectAttackIncrease(nAB);
    effect eLink = EffectLinkEffects(eAttack, eDamage);

    int nDur = 1; // * Duration 1 turn
    if (!GetHasFeat(FEAT_MONK_ENDURANCE))
    {
        nDur = 2*nDur;
        eAttack = ExtraordinaryEffect(eAttack);
        eLink = ExtraordinaryEffect(eLink);
    }

    if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDur = 2*nDur;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    oTarget = OBJECT_SELF;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 414, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);



    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDur));
}

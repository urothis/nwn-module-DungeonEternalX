//::///////////////////////////////////////////////
//:: Divine Power
//:: NW_S0_DivPower.nss
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;


    //Declare major variables
    object oTarget = GetSpellTargetObject();

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemoveTempHitPoints();

    int nCasterLevel = GetCasterLevel(OBJECT_SELF);

    int nStr = GetAbilityScore(oTarget, ABILITY_STRENGTH);
    int nStrengthIncrease = (nStr - 18) * -1;
    if (nStrengthIncrease < 0)
    {
        nStrengthIncrease = 0;
    }

    effect eStrength = EffectAbilityIncrease(ABILITY_STRENGTH, nStrengthIncrease);
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eHP = ExtraordinaryEffect(EffectTemporaryHitpoints(2 * nCasterLevel));

    //Meta-Magic
    int nMetaMagic = GetMetaMagicFeat();
    if( nMetaMagic == METAMAGIC_EXTEND )
    {
        nCasterLevel *= 2;
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_POWER, FALSE));

    //Make sure that the strength modifier is a bonus
    if (nStrengthIncrease > 0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStrength, oTarget, RoundsToSeconds(nCasterLevel));
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nCasterLevel));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


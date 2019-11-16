#include "x2_inc_switches"

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ONHITCAST) return;

    int nRoll = d4();
    if (nRoll == 1) return;

    object oTarget = GetSpellTargetObject();
    if (!GetIsObjectValid(oTarget)) return;

    int nDmg = nRoll + 10;
    effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_COLD);
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);

    if (nRoll == 4)
    {
        if (!GetHasSpellEffect(700, oTarget)) // do not stack this effect
        {
            eVis = EffectVisualEffect(VFX_IMP_DOOM);
            effect ePenalty = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
            ePenalty = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenalty, oTarget, 60.0);
        }
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
}

#include "x2_inc_switches"

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ONHITCAST) return;

    int nRoll = d4();
    if (nRoll == 1) return;

    object oTarget = GetSpellTargetObject();
    if (!GetIsObjectValid(oTarget)) return;

    int nDmg = nRoll + 10;
    effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_ACID);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    if (nRoll == 4)
    {
        if (!GetHasSpellEffect(700, oTarget)) // do not stack this effect
        {
            eVis = EffectVisualEffect(VFX_IMP_DOOM);
            effect ePenalty = EffectSkillDecrease(SKILL_DISCIPLINE, 4);
            ePenalty = EffectLinkEffects(ePenalty, EffectDamageDecrease(5, DAMAGE_TYPE_PIERCING));
            ePenalty = EffectLinkEffects(ePenalty, EffectDamageDecrease(5, DAMAGE_TYPE_SLASHING));
            ePenalty = EffectLinkEffects(ePenalty, EffectDamageDecrease(5, DAMAGE_TYPE_BLUDGEONING));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenalty, oTarget, 60.0);
        }
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
}

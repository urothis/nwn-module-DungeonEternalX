#include "x2_inc_switches"

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ONHITCAST) return;

    int nRoll = d4();
    if (nRoll == 1) return;

    object oTarget = GetSpellTargetObject();
    if (!GetIsObjectValid(oTarget)) return;

    int nDmg = nRoll + 10;
    int nVis = VFX_IMP_LIGHTNING_S;
    if (nRoll == 4)
    {
        if (!GetHasSpellEffect(700, oTarget)) // do not stack this effect
        {
            nDmg += 16 + d4();
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, 30.0);
            nVis = VFX_IMP_LIGHTNING_M;
        }
    }
    effect eVis = EffectVisualEffect(nVis);
    effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_ELECTRICAL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
}

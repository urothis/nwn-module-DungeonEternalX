#include "pure_caster_inc"

void main()
{
    object oTarget = GetSpellTargetObject();

    int nLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    int nHeal, nDam;

    int nCurrentHp = GetCurrentHitPoints(oTarget);
    int nAmount    = (d3()+1) * nLevel;
    if (nCurrentHp < nAmount) nAmount = nCurrentHp - 5;

    effect eVisNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BG_CONTAGION));

    if (GetIsEnemy(oTarget) || GetIsEnemy(OBJECT_SELF, oTarget))
    {
        nDam  = nAmount;
        nHeal = nAmount/2;
    }
    else
    {
        nDam  = nAmount/2;
        nHeal = nAmount;
    }

    if (nDam > 40) nDam = 40;
    if (BlockNegativeDamage(oTarget)) nDam = 0;
    effect eDam  = EffectDamage(nDam, DAMAGE_TYPE_NEGATIVE);
    effect eHeal = EffectHeal(nHeal);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisNeg, oTarget);
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF));
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, OBJECT_SELF));
}

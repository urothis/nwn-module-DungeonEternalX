//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTide
//:://////////////////////////////////////////////
/*
    DeX Battletide
    Changed to a Prayer-like functionality
    +2 AB and saves for caster (No Damagebonus. No Savebonus with Monkspeed)
    -2 AB, saves and damage for enemies
*/
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode()) return;

    effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    effect eNegSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect ePlusAttack = EffectAttackIncrease(2);
    effect eMinusAttack = EffectAttackDecrease(2);
    effect eMinusDMG = EffectDamageDecrease(2, DAMAGE_TYPE_BLUDGEONING);

    effect ePlusEffect = ePlusAttack;
    if (!GetHasFeat(FEAT_MONK_ENDURANCE)) ePlusEffect = EffectLinkEffects(ePlusEffect, eSaves);

    effect eMinusEffect = EffectLinkEffects(eMinusAttack, eNegSave);
    eMinusEffect = EffectLinkEffects(eMinusEffect, eMinusDMG);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    if (nDuration < 1) nDuration = 1;
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2; //Duration is +100%

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePlusEffect, OBJECT_SELF, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

    float fDelay;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE);

    while(GetIsObjectValid(oTarget))
    {
       if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
       {
          fDelay = GetRandomDelay(0.2, 0.8);
          if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
          {
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMinusEffect, oTarget, RoundsToSeconds(nDuration)));
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L),oTarget));
          }
       }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    }
}

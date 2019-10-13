#include "x0_i0_spells"

void main()
{
    object oPC = GetLastUsedBy();
    // testing new dropsystem
    if (GetPCPlayerName(oPC) != "Ezramun") return;
    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_STRENGTH, 20), oPC);
    //RemoveSpecificEffect(EFFECT_TYPE_MOVEMENT_SPEED_DECREASE, oPC);

                effect eABLoss    = EffectAttackDecrease(10);
                effect eVis       = EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND);
                effect eSkillLoss = EffectSkillDecrease(SKILL_DISCIPLINE, 5);
                effect eSpeed     = EffectMovementSpeedDecrease(50);

                effect eLink = EffectLinkEffects(eABLoss, eVis);
                eLink        = EffectLinkEffects(eLink, eSkillLoss);
                eLink        = EffectLinkEffects(eLink, eSpeed);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(1));
                DelayCommand(RoundsToSeconds(1)+0.5, ReapplyPermaHaste(oPC));

}

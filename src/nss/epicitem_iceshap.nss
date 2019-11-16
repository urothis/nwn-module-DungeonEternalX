#include "x2_inc_switches"

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ONHITCAST) return;
    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    if (!GetIsObjectValid(oTarget)) return;

    effect eDmg = EffectDamage(d6() + 10, DAMAGE_TYPE_COLD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);

    if (d10() >= 9)
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            int nCheck = GetLocalInt(oCaster, "ICESHAPER_DC");
            if (nCheck != -1) // -1 means caster can not use this effect
            {
                if (nCheck > 0) // there was a check made before
                {
                    if (!GetHasSpellEffect(700, oTarget)) // do not stack this effect
                    {
                        if (FortitudeSave(oTarget, nCheck, SAVING_THROW_TYPE_COLD) == 0)
                        {
                            float fDur = RoundsToSeconds(3);
                            effect eFreeze = EffectCutsceneParalyze();
                            effect eImpact = EffectVisualEffect(VFX_IMP_FROST_L);

                            eFreeze = EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), eFreeze);
                            eFreeze = EffectLinkEffects(EffectVisualEffect(VFX_DUR_ICESKIN), eFreeze);
                            eFreeze = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50), eFreeze);
                            eFreeze = EffectLinkEffects(EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 25), eFreeze);
                            eFreeze = EffectLinkEffects(EffectDamageImmunityDecrease(DAMAGE_TYPE_BLUDGEONING, 25), eFreeze);

                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oTarget, fDur);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                        }
                    }
                }
                else // first time executed, do a check and save for next time
                {
                    if (GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KATANA, oCaster))
                    {
                        SetLocalInt(oCaster, "ICESHAPER_DC", -1); // save disallow freeze for this char
                    }
                    else if (!GetHasFeat(FEAT_IMPROVED_CRITICAL_KATANA, oCaster))
                    {
                        SetLocalInt(oCaster, "ICESHAPER_DC", -1);
                    }
                    else if (!GetHasFeat(FEAT_GREAT_CLEAVE, oCaster))
                    {
                        SetLocalInt(oCaster, "ICESHAPER_DC", -1);
                    }
                    else
                    {
                        nCheck = 30 + (GetAbilityScore(oCaster, ABILITY_STRENGTH, TRUE) - 10) / 2;
                        if (GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA, oCaster)) nCheck += 2;
                        SetLocalInt(oCaster, "ICESHAPER_DC", nCheck); // save DC for next time
                    }
                }
            }
        }
    }
}

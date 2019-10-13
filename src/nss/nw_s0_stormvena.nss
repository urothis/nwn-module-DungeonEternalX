//::///////////////////////////////////////////////
//:: Storm of Vengeance: Enter
//:: NW_S0_StormVenA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Modified the heartbeat script for entering creatures only
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 8, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pure_caster_inc"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
    int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    // effect eAcid    = EffectDamage(d6(3 + nPureBonus/2), DAMAGE_TYPE_ACID);
    effect eElec    = EffectDamage(d6(6) + nPureLevel/4, DAMAGE_TYPE_ELECTRICAL);
    effect eStun    = EffectStunned();
    effect eVisAcid = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eVisElec = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    effect eVisStun = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eLink    = EffectLinkEffects(eStun, eVisStun);
    float fDelay;

    object oTarget = GetEnteringObject();
    if (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STORM_OF_VENGEANCE));
            fDelay = GetRandomDelay(1.0, 2.0);
            if (!MyResistSpell(oCaster, oTarget))
            {
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
                //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster, fDelay))
                {
                    //if (d2()==1) DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eElec, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
                }
            }
        }
    }
}

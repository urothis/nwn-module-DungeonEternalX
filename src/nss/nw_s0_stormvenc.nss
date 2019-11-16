//::///////////////////////////////////////////////
//:: Storm of Vengeance: Heartbeat
//:: NW_S0_StormVenC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creates an AOE that decimates the enemies of
   the cleric over a 30ft radius around the caster
*/

#include "x0_i0_spells"
#include "pure_caster_inc"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(oCaster)) // CASTER GONE, KILL AOE
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

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

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
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
        //Get next target in spell area
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    }
}

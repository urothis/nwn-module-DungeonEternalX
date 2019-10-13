//::///////////////////////////////////////////////
//:: Undeath to Death
//:: X2_S0_Undeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

  This spell slays 1d4 HD worth of undead creatures
  per caster level (maximum 20d4). Creatures with
  the fewest HD are affected first;

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On:  August 13,2003
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_toollib"
#include "pure_caster_inc"


void DoUndeadToDeath(object oCreature, int nDC)
{

    SetLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD", TRUE);

    if (!MySavingThrow(SAVING_THROW_WILL, oCreature, nDC, SAVING_THROW_TYPE_NONE,OBJECT_SELF))
    {
        float fDelay = GetRandomDelay(0.2f,0.4f);
        if (!MyResistSpell(OBJECT_SELF, oCreature, fDelay))
        {
            effect eDeath = EffectDamage(GetCurrentHitPoints(oCreature),DAMAGE_TYPE_DIVINE,DAMAGE_POWER_ENERGY);
            effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
            DelayCommand(fDelay+0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oCreature));
            DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oCreature));
        }
        else
        {
            DelayCommand(1.0f,DeleteLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD"));
        }
    }
    else
    {
        DelayCommand(1.0f,DeleteLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD"));
    }
}

#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    int nToAffect = 2;
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY)) nToAffect += 6;
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY)) nToAffect += 4;
    else if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY)) nToAffect += 2;

    location lLoc = GetSpellTargetLocation();
    int nSpellID = GetSpellId();
    int nCnt = 1;
    effect eDeath;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    float fDelay;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_STRIKE_HOLY),lLoc);
    TLVFXPillar(VFX_FNF_LOS_HOLY_20, lLoc, 3);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, lLoc);
    while (GetIsObjectValid(oTarget) && nCnt <= nToAffect)
    {
        if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            nCnt++;
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_NONE,OBJECT_SELF))
                {
                    fDelay = GetRandomDelay();
                    if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                    {
                        eDeath = EffectDamage(GetCurrentHitPoints(oTarget), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
                        DelayCommand(fDelay + 0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0 ,lLoc);
    }
}

//::///////////////////////////////////////////////
//:: Wail of the Banshee
//:: NW_S0_WailBansh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  You emit a terrible scream that kills enemy creatures who hear it
  The spell affects up to one creature per caster level. Creatures
  closest to the point of origin are affected first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  Dec 12, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001


#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
    int nPureDC   = GetSpellSaveDC() + nPureBonus;

    int nToAffect = 2;
    if (nPureBonus >= 8)
    {
        nToAffect = 100;
    }
    else
    {
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY)) nToAffect += 6;
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY)) nToAffect += 4;
        else if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY)) nToAffect += 2;
    }

    float fTargetDistance;
    float fDelay;
    location lTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eWail = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
    effect eDeath = EffectDeath();

    int nCnt = 1;
    location lSpellLoc = GetSpellTargetLocation();

    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWail, lSpellLoc);

    //Get the closet target from the spell target location
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lSpellLoc);

    while (GetIsObjectValid(oTarget) && nCnt <= nToAffect)
    {
        //Get the distance of the target from the center of the effect
        fDelay = GetRandomDelay(3.0, 4.0);
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            nCnt++;
            //Fire cast spell at event for the specified target
            DelayCommand(fDelay-0.1, SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE)));
            //Make SR check
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Make a fortitude save to avoid death
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_DEATH))
                {
                    //Apply the delay VFX impact and death effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget)); // no delay
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lSpellLoc);
    }
}

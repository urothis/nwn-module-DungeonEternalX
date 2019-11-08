//::///////////////////////////////////////////////
//:: Implosion
//:: NW_S0_Implosion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons within a 5ft radius of the spell must
    save at +3 DC or die.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 13, 2001
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nToAffect = 2;
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION)) nToAffect += 3;
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION)) nToAffect += 2;
    else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION)) nToAffect += 1;

    //Declare major variables
    object oTarget;
    effect eDeath;
    effect eImplode = EffectVisualEffect(VFX_FNF_IMPLOSION);
    float fDelay;
    location lSpellTarget = GetSpellTargetLocation();
    int nCnt = 1;
    int nDC = GetSpellSaveDC() + 3;
    //Apply the implose effect
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImplode, lSpellTarget);
    //Get the first target in the shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lSpellTarget);
    while (GetIsObjectValid(oTarget) && nCnt <= nToAffect)
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
                nCnt++;
                //Fire cast spell at event for the specified target
                fDelay = GetRandomDelay();
                DelayCommand(fDelay-0.1, SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMPLOSION)));
                //Make SR check
                if (oTarget == OBJECT_SELF)
                {
                    if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                        eDeath = EffectDamage(GetCurrentHitPoints(oTarget) + 500, DAMAGE_TYPE_MAGICAL);
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    }
                }
                else if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                        eDeath = EffectDamage(GetCurrentHitPoints(oTarget) + 500, DAMAGE_TYPE_MAGICAL);
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    }
                }
            }
        }
        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lSpellTarget);
    }
}


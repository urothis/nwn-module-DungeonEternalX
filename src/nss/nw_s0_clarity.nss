//::///////////////////////////////////////////////
//:: Clarity
//:: NW_S0_Clarity.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   This spell removes Charm, Daze, Confusion, Stunned
   and Sleep.  It also protects the user from these
   effects for 1 turn / level.  Does 1 point of
   damage for each effect removed.
*/

// ezramun, people somehow managed to spam clarity potion and remove it while disabled
int ClarityCheckDisabled(object oTarget)
{
    int nEffectType;
    effect eCheck = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eCheck))
    {
        nEffectType = GetEffectType(eCheck);
        if (nEffectType == EFFECT_TYPE_CONFUSED || nEffectType == EFFECT_TYPE_STUNNED || nEffectType == EFFECT_TYPE_SLEEP || nEffectType == EFFECT_TYPE_CHARMED)
        {
             return TRUE;
        }
        else if (nEffectType == EFFECT_TYPE_DAZED)
        {
            SetLocalInt(oTarget, "CLARITY_CHECK_DAZED", TRUE);
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
    if (!X2PreSpellCastCode()) return;

    //Declare major variables
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eVis  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);

    effect eLink = EffectLinkEffects(eImm1, eVis);

    object oTarget = GetSpellTargetObject();
    object oItem   = GetSpellCastItem();

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    int nDuration = nPureLevel;
    int nDisabled = ClarityCheckDisabled(oTarget);

    if (GetBaseItemType(oItem) == BASE_ITEM_POTIONS)
    {
        if (nDisabled)
        {
            DeleteLocalInt(oTarget, "CLARITY_CHECK_DAZED");
            return;
        }
        if (GetLevelByClass(CLASS_TYPE_HARPER, oTarget) > 4) nDuration *= 2;
    }

    //Enter Metamagic conditions
    if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2;

    int bValid; int bVisual; int nEffectType;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLARITY, FALSE));

    if (nDisabled || GetLocalInt(oTarget, "CLARITY_CHECK_DAZED"))
    {
        effect eSearch = GetFirstEffect(oTarget);
        if(!GetHasSpellEffect(SPELL_CLARITY, oTarget))
        {
            //Search through effects
            while(GetIsEffectValid(eSearch))
            {
                bValid = FALSE;
                nEffectType = GetEffectType(eSearch);
                //Check to see if the effect matches a particular type defined below
                if      (nEffectType == EFFECT_TYPE_DAZED)    bValid = TRUE;
                else if (nEffectType == EFFECT_TYPE_CHARMED)  bValid = TRUE;
                else if (nEffectType == EFFECT_TYPE_SLEEP)    bValid = TRUE;
                else if (nEffectType == EFFECT_TYPE_CONFUSED) bValid = TRUE;
                else if (nEffectType == EFFECT_TYPE_STUNNED)  bValid = TRUE;
                //Apply damage and remove effect if the effect is a match
                if (bValid == TRUE)
                {
                    RemoveEffect(oTarget, eSearch);
                    bVisual = TRUE;
                }
                eSearch = GetNextEffect(oTarget);
            }
        }
    }
    float fTime = 30.0  + RoundsToSeconds(nDuration);
    //After effects are removed we apply the immunity to mind spells to the target
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fTime);
    DeleteLocalInt(oTarget, "CLARITY_CHECK_DAZED");
}


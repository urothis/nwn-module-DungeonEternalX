//::///////////////////////////////////////////////
//:: Amplify
//:: x0_s0_amplify.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster or target is able to hear sounds better.
    Listen skill increases by 20.
    DURATION: 1 round/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 30, 2002
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"
#include "nw_i0_spells"

void main()
{

    if (!X2PreSpellCastCode()) return;

    object oTarget = GetSpellTargetObject();
    object oItem   = GetSpellCastItem();
    effect eVis    = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    int nMetaMagic = GetMetaMagicFeat();
    int nListen    = 20;
    int nDur = 3; // Turn
    int nSkill = SKILL_LISTEN;

    if (GetBaseItemType(oItem) == BASE_ITEM_POTIONS)
    {
        if (GetLevelByClass(CLASS_TYPE_HARPER, oTarget) > 4)
        { // Increase if Harper use Pots
            nListen += 10;
            nDur    *= 2;
        }
        else if (GetTag(oItem) == "PTN_SCRYING") nSkill = SKILL_SPOT;
    }

    effect eListen = EffectSkillIncrease(nSkill, nListen);

    if (nMetaMagic == METAMAGIC_EXTEND) nDur *= 2; //Duration is +100%


    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_AMPLIFY, FALSE));

    RemoveEffectsFromSpell(oTarget, SPELL_AMPLIFY);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eListen, oTarget, TurnsToSeconds(nDur));
}








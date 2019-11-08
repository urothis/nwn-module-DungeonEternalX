//::///////////////////////////////////////////////
//:: Darkvision
//:: NW_S0_DarkVis
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies the darkvision effect to the target for
    1 hour per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////
//Needed: New effect

#include "x2_inc_spellhook"
#include "nw_i0_spells"

void main()
{

    if (!X2PreSpellCastCode()) return;

    object oTarget = GetSpellTargetObject();

    effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
    effect eUltra = EffectUltravision();
    effect eLink = EffectLinkEffects(eVis, eUltra);

    if (GetLevelByClass(CLASS_TYPE_HARPER, oTarget) > 4)
    { // Add See invisibility if Harper use Pot
        if (GetBaseItemType(GetSpellCastItem()) == BASE_ITEM_POTIONS)
        {
            effect eHarperSight = EffectSeeInvisible();
            effect eVis2 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
            eLink = EffectLinkEffects(eHarperSight, eLink);
            eLink = EffectLinkEffects(eVis2, eLink);
        }
    }
    eLink = ExtraordinaryEffect(eLink);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2; //Duration is +100%

    RemoveEffectsFromSpell(oTarget,SPELL_DARKNESS);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKVISION, FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oTarget, HoursToSeconds(nDuration));
}

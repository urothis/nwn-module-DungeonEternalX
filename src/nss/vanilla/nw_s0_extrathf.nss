//::///////////////////////////////////////////////
//:: Rogues Cunning AKA Potion of Extra Theiving
//:: NW_S0_ExtraThf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the user +10 Search, Disable Traps and
    Move Silently, Open Lock (+5), Pick Pockets
    Set Trap for 5 Turns
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: November 9, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    object oItem = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();
    if (GetBaseItemType(oItem) == BASE_ITEM_POTIONS)
    {
        if (GetLevelByClass(CLASS_TYPE_HARPER, oTarget) < 5  && GetTag(oItem) == "it_harpercunning")
        {
            FloatingTextStringOnCreature("Only for level 5 Harper Scout", oTarget);
            return;
        }
    }

    //Declare major variables
    effect eSearch = EffectSkillIncrease(SKILL_SEARCH, 10);
    effect eDisable = EffectSkillIncrease(SKILL_DISABLE_TRAP, 10);
    effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 10);
    effect eOpen = EffectSkillIncrease(SKILL_OPEN_LOCK, 10);
    effect ePick = EffectSkillIncrease(SKILL_PICK_POCKET, 10);
    effect eTrap = EffectSkillIncrease(SKILL_SET_TRAP, 10);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, 10);

    //Link Effects
    effect eLink = EffectLinkEffects(eSearch, eDisable);
    eLink = EffectLinkEffects(eLink, eMove);
    eLink = EffectLinkEffects(eLink, eOpen);
    eLink = EffectLinkEffects(eLink, ePick);
    eLink = EffectLinkEffects(eLink, eTrap);
    eLink = EffectLinkEffects(eLink, eHide);

    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(10));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

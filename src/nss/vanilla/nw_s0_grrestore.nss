//::///////////////////////////////////////////////
//:: Greater Restoration
//:: NW_S0_GrRestore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all negative effects of a temporary nature
    and all permanent effects of a supernatural nature
    from the character. Does not remove the effects
    relating to Mind-Affecting spells or movement alteration.
    Heals target for 5d8 + 1 point per caster level.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"
#include "nw_i0_plot"

int GetIsOkToRemove(object oTarget, effect eEff)
{
   object oCreator = GetEffectCreator(eEff);
   //if(GetTag(oCreator) == "WorkContainer") return FALSE; // IF WorkContainer CREATED IT SKIP (ORC LIQUOR)
   if (oCreator==oTarget && GetEffectSubType(eEff)!=SUBTYPE_MAGICAL)
   {
        return FALSE; // IF THE TARGET CREATED THIS EFFECT AND IT'S NOT A NORMAL EFFECT, DON'T REMOVE IT (IE BARB RAGE)
   }
   // Cory - Assassin and BG have improved abilities that restore should not remove
   if (GetLevelByClass(CLASS_TYPE_ASSASSIN, oCreator)>=7 || GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCreator)>=10)// Make BG and assn abilities non-restorable
   {
        // Must also not be higher lvl spell caster
        if ((GetLevelByClass(CLASS_TYPE_WIZARD, oCreator)<5) && (GetLevelByClass(CLASS_TYPE_SORCERER, oCreator)<5) && (GetLevelByClass(CLASS_TYPE_CLERIC, oCreator)<5) && (GetLevelByClass(CLASS_TYPE_DRUID, oCreator)<5) && (GetLevelByClass(CLASS_TYPE_BARD, oCreator)<11))
        {
            // Only certain class effects should be undispellable
            if (GetEffectType(eEff) == EFFECT_TYPE_AC_DECREASE || GetEffectType(eEff) == EFFECT_TYPE_SAVING_THROW_DECREASE || GetEffectType(eEff) == EFFECT_TYPE_SKILL_DECREASE)
            {
                return FALSE;
            }

        }
   }

    // Cory - Don't restore DM event ring penalties
   if (HasItem(oTarget, "GeneralOtmansRing"))
   {
        if (GetHasFeat(FEAT_MONK_ENDURANCE, oTarget))
        {
            return FALSE;
        }
   }

   return TRUE;
}

void main()
{
    if (!X2PreSpellCastCode())    return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
    int nPureDC   = GetSpellSaveDC() + nPureBonus;

    int nSpellID = GetSpellId();
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);
    int nEffectType;
    effect eBad = GetFirstEffect(oTarget);

    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        nEffectType = GetEffectType(eBad);
        if (nEffectType == EFFECT_TYPE_ABILITY_DECREASE ||
            nEffectType == EFFECT_TYPE_AC_DECREASE ||
            nEffectType == EFFECT_TYPE_ATTACK_DECREASE ||
            nEffectType == EFFECT_TYPE_DAMAGE_DECREASE ||
            nEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            nEffectType == EFFECT_TYPE_SKILL_DECREASE ||
            nEffectType == EFFECT_TYPE_BLINDNESS ||
            nEffectType == EFFECT_TYPE_DEAF ||
            nEffectType == EFFECT_TYPE_CURSE ||
            nEffectType == EFFECT_TYPE_DISEASE ||
            nEffectType == EFFECT_TYPE_POISON ||
            nEffectType == EFFECT_TYPE_PARALYZE ||
            nEffectType == EFFECT_TYPE_CHARMED ||
            nEffectType == EFFECT_TYPE_DOMINATED ||
            nEffectType == EFFECT_TYPE_DAZED ||
            nEffectType == EFFECT_TYPE_CONFUSED ||
            nEffectType == EFFECT_TYPE_FRIGHTENED ||
            nEffectType == EFFECT_TYPE_NEGATIVELEVEL ||
            nEffectType == EFFECT_TYPE_PARALYZE ||
            nEffectType == EFFECT_TYPE_SLOW ||
            nEffectType == EFFECT_TYPE_STUNNED ||          // a paladin with epic helmet, add entangle and mov.speed.decr.
            (nSpellID == SPELLABILITY_REMOVE_DISEASE && nEffectType == EFFECT_TYPE_ENTANGLE) ||
            (nSpellID == SPELLABILITY_REMOVE_DISEASE && nEffectType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE))
        {
            //Remove effect if it is negative.
            if (GetIsOkToRemove(oTarget, eBad)) RemoveEffect(oTarget, eBad);
        }
        eBad = GetNextEffect(oTarget);
    }

    DelayCommand(0.1, ReapplyPermaHaste(oTarget));

    if (nSpellID != SPELLABILITY_REMOVE_DISEASE)
    {
        if (GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD)
        {
            //Apply the VFX impact and effects
            int nHeal = nPureLevel * 4 + d6(nPureLevel);
            effect eHeal = EffectHeal(nHeal);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        }
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}

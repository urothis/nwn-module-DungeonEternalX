//::///////////////////////////////////////////////
//:: Restoration
//:: NW_S0_Restore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Removes all negative effects unless they come
   from Poison, Disease or Curses.
*/
#include "x2_inc_spellhook"
#include "nw_i0_plot"
//Checks the creator oTarget for the effect eEff if they created it.
int GetIsOkToRemove(object oTarget, effect eEff)
{
   object oCreator = GetEffectCreator(eEff);
   if (oCreator == oTarget && GetEffectSubType(eEff) != SUBTYPE_MAGICAL) return FALSE; // IF THE TARGET CREATED THIS EFFECT AND IT'S NOT A NORMAL EFFECT, DON'T REMOVE IT (IE BARB RAGE)
   //if (GetTag(oCreator) == "WorkContainer") return FALSE; // IF WorkContainer CREATED IT SKIP (ORC LIQUOR)

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
    object oTarget = GetSpellTargetObject();
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
    int bValid;
    int nSpellID = GetSpellId();
    int nEffectType;
    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    int bOkToRemove;
    while(GetIsEffectValid(eBad))
    {
        bOkToRemove = FALSE;
        nEffectType = GetEffectType(eBad);
        if (nEffectType == EFFECT_TYPE_ABILITY_DECREASE ||
            nEffectType == EFFECT_TYPE_AC_DECREASE ||
            nEffectType == EFFECT_TYPE_ATTACK_DECREASE ||
            nEffectType == EFFECT_TYPE_DAMAGE_DECREASE ||
            nEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            nEffectType == EFFECT_TYPE_SKILL_DECREASE)
        {
            bOkToRemove = GetIsOkToRemove(oTarget, eBad);
        }
        if (nSpellID == SPELL_RESTORATION)
        {
            if (nEffectType == EFFECT_TYPE_BLINDNESS ||
                nEffectType == EFFECT_TYPE_DEAF ||
                nEffectType == EFFECT_TYPE_PARALYZE ||
                nEffectType == EFFECT_TYPE_NEGATIVELEVEL)
            {
                bOkToRemove = GetIsOkToRemove(oTarget, eBad);
            }
        }
        if (bOkToRemove) RemoveEffect(oTarget, eBad);
        eBad = GetNextEffect(oTarget);
    }
    DelayCommand(0.1, ReapplyPermaHaste(oTarget));
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}



//::///////////////////////////////////////////////
//:: Bigby's Forceful Hand
//:: [x0_s0_bigby2]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    dazed vs strength check (+14 on strength check); Target knocked down.
    Target dazed down for 1 round per level of caster

*/
/*
   Bigby Nerf
    -Bigby's Interposing Hand (x0_s0_bigby1)
    -Bigby's Forceful Hand (x0_s0_bigby2)
    -Bigby's Grasping Hand (x0_s0_bigby3)
    -Bigby's Clenched Fist (x0_s0_bigby4)
    -Bigby's Crushing Hand (x0_s0_bigby5)

    - Based on discipline check.
    - DC = Caster Level + Spell Level - 15 + Caster Ability Modifier + Spell Focus Bonus + Size Modifier (vs. Large Size) + d20.
    - Arcane Defense lowers the DC by 2.
    - The duration of all bigby hands have been changed to 2 rounds + 1/3 levels to a maximum of 15 rounds (10 rounds on Forceful Hand).
    - The damage from Clenched Fist and Crushing Hand is 2x to compensate for the reduced duration.
*/
#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetMin(10, 2 + nPureLevel/5);
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    if(!GetIsReactionTypeFriendly(oTarget)) {
        // Apply the impact effect
        effect eImpact = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 460, TRUE));
        if(!MyResistSpell(OBJECT_SELF, oTarget)) {
            int nCasterRoll = GetMin(20, d20()+nPureBonus);
            int nCasterLvl = GetCasterLevel(OBJECT_SELF);
            int nBaseDC = GetCasterAbilityModifier(OBJECT_SELF)-9;
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION)) nBaseDC += 6;
            else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION)) nBaseDC += 4;
            else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION)) nBaseDC += 2;
            int nFinalDC = nCasterRoll + nCasterLvl + nBaseDC;

            int nTargetRanks = GetSkillRank(SKILL_DISCIPLINE,oTarget);
            int nTargetRoll = d20();
            if (GetHasFeat(FEAT_ARCANE_DEFENSE_EVOCATION,oTarget)) nTargetRanks += 2;
            int nFinalRoll = nTargetRanks + nTargetRoll;

            string sMessage = "";
            // * bullrush succesful, knockdown target for duration of spell
            if (nFinalDC > nFinalRoll) {
                effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                effect eKnockdown = EffectDazed();
                effect eKnockdown2 = EffectKnockdown();
                //Link effects
                effect eLink = EffectLinkEffects(eKnockdown, eKnockdown2);
                //Apply the penalty
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nDuration));
                sMessage = "Bullrush Sucess!: " + IntToString(nTargetRanks) + " + " + IntToString(nTargetRoll) + " vs DC: " + IntToString(nCasterLvl) + " + " + IntToString(nBaseDC) + " + " + IntToString(nCasterRoll) + " = " + IntToString(nFinalDC);
                // * Bull Rush succesful
                FloatingTextStrRefOnCreature(8966, OBJECT_SELF, FALSE);
            } else {
                sMessage = "Bullrush Failed. " + IntToString(nTargetRanks) + " + " + IntToString(nTargetRoll) + " vs DC: " + IntToString(nCasterLvl) + " + " + IntToString(nBaseDC) + " + " + IntToString(nCasterRoll) + " = " + IntToString(nFinalDC);
            }
            SendMessageToPC(OBJECT_SELF, sMessage);
            SendMessageToPC(oTarget, sMessage);
            //SendMessageToAllDMs("FORCEFULL HAND: " + GetName(OBJECT_SELF) + " vs. " + GetName(oTarget) + " - " + sMessage);
        }
    }
}



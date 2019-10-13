//::///////////////////////////////////////////////
//:: Player Tool 1 Instant Feat
//:: x3_pl_tool01
//:://////////////////////////////////////////////
/*
    This simply executes the script indicated by
    tk_playertools.2da.
*/
//:://////////////////////////////////////////////
//:: Created By: The Krit
//:: Created On: 2008-10-06
//:://////////////////////////////////////////////

#include "tk_ptool_inc"
#include "nw_i0_spells"

void main()
{
    /*
    object oPC = OBJECT_SELF;
    // Check Timer to prevent stacking
    if (GetLocalInt(oPC, "FeatEnhancerActive")) return;
    if (GetHasSpellEffect(830, oPC)) return;

    int nFighter = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC);
    int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    int nDD = GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oPC);
    if (!nFighter && !nDD) return;

    int nAttackBonus;   int nAcBonus;       int nDiscBonus;
    int nFort;          int nWillBonus;     int nRfxBonus;
    int nDDAC;

    int nBaseStr     = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    int nRdd         = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC);
    float fDur       = TurnsToSeconds(30);
    effect eImpactFx = EffectVisualEffect(VFX_IMP_PULSE_COLD);
    effect eLink;

    if (nFighter && nFighter + nDD >= 4)
    {
        if (GetHasFeat(FEAT_SKILL_FOCUS_DISCIPLINE, oPC)) nDiscBonus += 2;
        if (GetHasFeat(FEAT_GREAT_FORTITUDE, oPC)) nFort += 2;
        if (GetHasFeat(FEAT_IRON_WILL, oPC)) nWillBonus += 2;
        if (GetHasFeat(FEAT_LIGHTNING_REFLEXES, oPC)) nRfxBonus += 2;
    }
    if (nFighter && nFighter + nDD >= 20)
    {
        if (GetHasFeat(FEAT_EPIC_WILL, oPC)) nWillBonus += 4;
        if (GetHasFeat(FEAT_EPIC_REFLEXES, oPC)) nRfxBonus += 4;
    }
    if (nBaseStr > 24 && !nRdd && !nMonk)
    {
        if (GetHasFeat(FEAT_IMPROVED_PARRY, oPC) && nFighter) nAcBonus = (nFighter+nDD)/5;
    }
    if (nDD >= 6)
    {
        int nWisdom = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);
        int nDex = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
        nDiscBonus += 4;
        if (nWisdom > 11) nDiscBonus += (nWisdom - 10) / 2;
        if (nDex > 11) nDiscBonus += (nDex - 10) / 2;
        if (nDiscBonus > nDD) nDiscBonus = nDD;
        if (nDiscBonus > 18) nDiscBonus = 18;

        if (!GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) && nBaseStr > 24 && !nMonk)
        {
            if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) > 21)
            {
                nDDAC = 1;
                if      (nDD >= 22) nDDAC = 9;
                else if (nDD >= 18) nDDAC = 7;
                else if (nDD >= 14) nDDAC = 5;
                else if (nDD >= 10) nDDAC = 3;
            }
        }
    }
    if (nAcBonus || nDDAC)
    {
        if (nDDAC > nAcBonus) nAcBonus = nDDAC;
        eLink = EffectLinkEffects(eLink, EffectACIncrease(nAcBonus+5, AC_NATURAL_BONUS));
    }

    if (GetHasFeat(FEAT_DIRTY_FIGHTING, oPC) && nBaseStr > 24 && !nRdd && nFighter) nAttackBonus = (nFighter+nDD)/10;

    if (nAttackBonus) eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nAttackBonus));
    if (nDiscBonus)   eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DISCIPLINE, nDiscBonus));
    if (nFort)        eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT, nFort));
    if (nRfxBonus)    eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nRfxBonus));
    if (nWillBonus)   eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, nWillBonus));

    // Set Timer to prevent stacking
    SetLocalInt(oPC, "FeatEnhancerActive", TRUE);

    eLink = ExtraordinaryEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

    if (nDD >= 6)
    {
        effect eVFX1 = EffectLinkEffects(EffectVisualEffect(VFX_IMP_SUPER_HEROISM), EffectVisualEffect(354));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_STONESKIN), oPC, 1.0);
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX1, oPC));
    }
    else ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpactFx, oPC);

    */
}

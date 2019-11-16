// These set of functions are meant to apply stats on top of summons based on
// character builds. Creatures should have base stats, and get adjusted based on
// feats, skills, attributes, etc.
// Pures are factored into it.

#include "pure_caster_inc"
#include "nwnx_creature"

//Calculates the summon's base attack bonus based on the caster's stats and pure caster levels.
//Note: nCalcWithCasterLevel is meant for non-pure arcane casters.
int GetSummonBaseAttackBonus(object oSummoner, int nClass, int nSpellSchool, int nSpellLevel = 1, int nCalcWithFeats = TRUE, int nCalcSkillType = FALSE, int nCalcWithCasterLevel = FALSE);

//Sets a summon's base attack bonus, overriding its previous stats.
void SetSummonBaseAttackBonus(object oSummon, int nBaseAttackBonus);
void AddSummonBaseAttackBonus(object oSummon, int nAmount);
void SubtractSummonBaseAttackBonus(object oSummon, int nAmount);

//Returns the ABILITY_* based on CLASS_TYPE_*
int GetSummonCastingAttribute(int nClass);

void SetSummonBaseAttribute(object oSummon, int nAttributeType, int nAmount);

//Checks for both spell focus feats by school and returns 0-6 depending on what feats the oSummer has for given school.
//Used in calculating caster bonuses for summons.
int GetSummonSpellFocusFeatBonusBySchool(object oSummoner, int nSpellSchool);

//Returns a number based on the given SKILL_*
//Skills: SKILL_ANIMAL_EMPATHY, SKILL_SPELLCRAFT
int GetSummonSkillBonusBySkill(object oSummoner, int nSkill, int nBaseSkillRank = FALSE);

//Calculates the oSummon's base AC based off the class, oCaster's attributes, etc...
//This returns the monster's base AC + Calculated modifer
int GetSummonBaseAC(object oSummoner, object oSummon, int nClass, int nSpellSchool, int nCalcWithFeats = FALSE, int nCalcSkillType = FALSE);

//Applies the oSummon's new base AC. Only call this once per summon.
void SetSummonBaseAC(object oSummon, int nBaseAC);

//Adds nBonusAC to the oSummon.
void AddSummonBaseAC(object oSummon, int nBonusAC);


///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

int GetSummonBaseAttackBonus(object oSummoner, int nClass, int nSpellSchool, int nSpellLevel = 1, int nCalcWithFeats = TRUE, int nCalcSkillType = FALSE, int nCalcWithCasterLevel = FALSE)
{
    int nCasterLevel       = GetCasterLevel(oSummoner);
    int nCasterSpellSchool = GetLocalInt(oSummoner, "SPELL_SCHOOL");
    int nCastingAttribute  = GetSummonCastingAttribute(nClass);
    int nAttributeModifier = GetAbilityModifier(nCastingAttribute, oSummoner) - 12;
    int nPureBonus         = 0;
    int nCasterLevelBonus  = 0;
    int nFinalBonus        = 0;


    /////////////////////////////////
    //Wizard/PM/Druid - Pure bonuses
    /////////////////////////////////

    //Get the PureCasterBonus based on the wizard school of the oSummoner
    if (nCasterSpellSchool && GetIsPureCaster(oSummoner))
        nPureBonus = GetPureCasterBonus(oSummoner, nSpellSchool);

    if (nCalcWithCasterLevel)
    {
        nCasterLevelBonus = nCasterLevel/8;
        if (nCasterLevelBonus < 0)
            nCasterLevelBonus = 0;
    }


    //Make sure nPureBonus isn't out of bounds.
    if (nPureBonus < 0 || nPureBonus > 8)
        nPureBonus = 0;

    if (nAttributeModifier < 0)
        nAttributeModifier = 0;

    ////////////////
    //Calc the total
    ////////////////

    //Modifiers to add with focus feats up to +6
    if (nCalcWithFeats)
        nFinalBonus += GetSummonSpellFocusFeatBonusBySchool(oSummoner, nSpellSchool);

    //Calculates a modifier based on certain skills
    if (nCalcSkillType)
        nFinalBonus += GetSummonSkillBonusBySkill(oSummoner, nCalcSkillType);

    nFinalBonus += nSpellLevel;
    nFinalBonus += nAttributeModifier;
    nFinalBonus += nPureBonus;
    nFinalBonus += nCasterLevelBonus;

    return nFinalBonus;
}

void SetSummonBaseAttackBonus(object oSummon, int nBaseAttackBonus)
{
    NWNX_Creature_SetBaseAttackBonus(oSummon, nBaseAttackBonus);
}

void AddSummonBaseAttackBonus(object oSummon, int nAmount)
{
    SetSummonBaseAttackBonus(oSummon, GetBaseAttackBonus(oSummon) + nAmount);
}

void SubtractSummonBaseAttackBonus(object oSummon, int nAmount)
{
    SetSummonBaseAttackBonus(oSummon, GetBaseAttackBonus(oSummon) - nAmount);
}

int GetSummonCastingAttribute(int nClass)
{
    switch (nClass)
    {
        case CLASS_TYPE_WIZARD:
            return ABILITY_INTELLIGENCE;
            break;
        case CLASS_TYPE_SORCERER:
            return ABILITY_CHARISMA;
            break;
        case CLASS_TYPE_DRUID:
            return ABILITY_WISDOM;
            break;
        case CLASS_TYPE_RANGER:
            return ABILITY_WISDOM;
            break;
        case CLASS_TYPE_SHIFTER:
            return ABILITY_WISDOM;
            break;
        case CLASS_TYPE_CLERIC:
            return ABILITY_WISDOM;
            break;
        case CLASS_TYPE_BARD:
            return ABILITY_CHARISMA;
            break;
        default:
            return 0;
    }
    return 0;
}

void SetSummonBaseAttribute(object oSummon, int nAttributeType, int nAmount)
{
    NWNX_Creature_SetAbilityScore(oSummon, nAttributeType, nAmount);
}

int GetSummonSpellFocusFeatBonusBySchool(object oSummoner, int nSpellSchool)
{
    int nBonus = 0;
    switch (nSpellSchool)
    {
        case SPELL_SCHOOL_ABJURATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oSummoner))
                nBonus += 1;
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oSummoner))
                nBonus += 2;
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oSummoner))
                nBonus += 3;
            break;

        case SPELL_SCHOOL_CONJURATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oSummoner))
                nBonus += 1;
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oSummoner))
                nBonus += 2;
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oSummoner))
                nBonus += 3;
            break;

        case SPELL_SCHOOL_DIVINATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oSummoner))
                nBonus += 1;
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, oSummoner))
                nBonus += 2;
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oSummoner))
                nBonus += 3;
            break;

        case SPELL_SCHOOL_ENCHANTMENT:
            if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oSummoner))
                nBonus += 1;
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oSummoner))
                nBonus += 2;
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oSummoner))
                nBonus += 3;
            break;

        case SPELL_SCHOOL_EVOCATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oSummoner))
                nBonus += 1;
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oSummoner))
                nBonus += 2;
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oSummoner))
                nBonus += 3;
            break;

        case SPELL_SCHOOL_ILLUSION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oSummoner))
                nBonus += 1;
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oSummoner))
                nBonus += 2;
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oSummoner))
                nBonus += 3;
            break;

        case SPELL_SCHOOL_NECROMANCY:
            if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oSummoner))
                nBonus += 1;
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oSummoner))
                nBonus += 2;
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oSummoner))
                nBonus += 3;
            break;

        case SPELL_SCHOOL_TRANSMUTATION:
            if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oSummoner))
                nBonus += 1;
            if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oSummoner))
                nBonus += 2;
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oSummoner))
                nBonus += 3;
            break;

        default: nBonus = 0; break;
    }

    return nBonus;
}

int GetSummonSkillBonusBySkill(object oSummoner, int nSkill, int nBaseSillRank = FALSE)
{
    int nBonus = 0;

    switch (nSkill)
    {
        case (SKILL_SPELLCRAFT):
            if (GetHasSkill(SKILL_SPELLCRAFT, oSummoner))
                nBonus = GetSkillRank(SKILL_ANIMAL_EMPATHY, oSummoner, nBaseSillRank);
            break;
        case (SKILL_ANIMAL_EMPATHY):
            if (GetHasSkill(SKILL_ANIMAL_EMPATHY, oSummoner))
                nBonus = GetSkillRank(SKILL_ANIMAL_EMPATHY, oSummoner, nBaseSillRank);
            break;
        default:
            break;
    }


    if (nBonus)
        nBonus /= 10;

    if (nBonus < 0)
        nBonus = 0;

    if (nBonus > 8)
        nBonus = 8;

    return nBonus;
}


int GetSummonBaseAC(object oSummoner, object oSummon, int nClass, int nSpellSchool, int nCalcWithFeats = FALSE, int nCalcSkillType = FALSE)
{
    int nCasterLevel = GetCasterLevel(oSummoner);
    int nCasterSpellSchool = GetLocalInt(oSummoner, "SPELL_SCHOOL");
    int nCastingAttribute  = GetSummonCastingAttribute(nClass);
    int nAttributeModifier = GetAbilityModifier(nCastingAttribute, oSummoner) - 12;
    int nPureBonus = 0;
    int nFinalBonus = 0;

    /////////////////////////////////
    //Wizard/PM/Druid - Pure bonuses
    /////////////////////////////////

    //Get the PureCasterBonus based on the wizard school of the oSummoner
    if (nCasterSpellSchool && GetIsPureCaster(oSummoner))
        nPureBonus = GetPureCasterBonus(oSummoner, nSpellSchool);

    //Make sure nPureBonus isn't out of bounds.
    if (nPureBonus < 0 || nPureBonus > 8)
        nPureBonus = 0;

    if (nAttributeModifier < 0)
        nAttributeModifier = 0;


    ////////////////
    //Calc the total
    ////////////////

    //Modifiers to add with focus feats up to +6
    if (nCalcWithFeats)
        nFinalBonus += GetSummonSpellFocusFeatBonusBySchool(oSummoner, nSpellSchool);

    //Calculates a modifier based on certain skills
    if (nCalcSkillType)
        nFinalBonus += GetSummonSkillBonusBySkill(oSummoner, nCalcSkillType);

    nFinalBonus += nAttributeModifier;
    nFinalBonus += nPureBonus;

    return NWNX_Creature_GetBaseAC(oSummon) + nFinalBonus;
}

void SetSummonBaseAC(object oSummon, int nBaseAC)
{
    if (nBaseAC < 10)
        nBaseAC = 10;
    NWNX_Creature_SetBaseAC(oSummon, nBaseAC);
}

void AddSummonBaseAC(object oSummon, int nBonusAC)
{
    if (nBonusAC < 0)
        nBonusAC = 0;
    SetSummonBaseAC(oSummon, NWNX_Creature_GetBaseAC(oSummon) + nBonusAC);
}


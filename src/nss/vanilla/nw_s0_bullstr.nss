/////////////////////////////////////////////////
// Bull's Strength
//-----------------------------------------------

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nAmount    = 4;
    int nModify    = GetMin(12, nAmount + nPureBonus);
    int nDuration  = nPureLevel;
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nModify = nAmount + nPureBonus;//Damage is at max
    if (nMetaMagic == METAMAGIC_EMPOWER)  nModify += (nModify/2);
    if (nMetaMagic == METAMAGIC_EXTEND)   nDuration *= 2;   //Duration is +100%

    int nAbility;
    int nSpell = GetSpellId();
    switch (nSpell)
    {
        case SPELLABILITY_BG_BULLS_STRENGTH:
        case SPELL_BULLS_STRENGTH:
            nAbility = ABILITY_STRENGTH;
            RemoveEffectsFromSpell(oTarget, SPELLABILITY_BG_BULLS_STRENGTH);
            RemoveEffectsFromSpell(oTarget, SPELL_BULLS_STRENGTH);
            RemoveEffectsFromSpell(oTarget, SPELL_GREATER_BULLS_STRENGTH);
            break;
        case SPELL_CATS_GRACE:
            nAbility = ABILITY_DEXTERITY;
            RemoveEffectsFromSpell(oTarget, 481); // Harper Cat's Grace
            break;
        case SPELL_EAGLE_SPLEDOR:
            nAbility = ABILITY_CHARISMA;
            RemoveEffectsFromSpell(oTarget, 482); // Harper Eagles Splendor
            break;
        case SPELL_ENDURANCE:
            nAbility = ABILITY_CONSTITUTION;
            break;
        case SPELL_FOXS_CUNNING:
            nAbility = ABILITY_INTELLIGENCE;
            break;
        case SPELL_OWLS_WISDOM:
            nAbility = ABILITY_WISDOM;
            break;
        case 481: // Harper Cat's Grace
            nAbility = ABILITY_DEXTERITY;
            RemoveEffectsFromSpell(oTarget, SPELL_CATS_GRACE);
            break;
        case 482: // Harper Eagles Splendor
            nAbility = ABILITY_CHARISMA;
            RemoveEffectsFromSpell(oTarget, SPELL_EAGLE_SPLEDOR);
            break;
    }
    if (GetStringLeft(GetTag(OBJECT_SELF), 4)=="KEG_")
    {
        nDuration = 15;
        nModify = 12 - GetHitDice(oTarget)/5;
        FloatingTextStringOnCreature("+" + IntToString(nModify), oTarget);
    }

    effect eVis   = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eBoost = EffectAbilityIncrease(nAbility, nModify);


    // HARPER SCOUT ABILITY
    if (nSpell == 481 || nSpell == 482)
    {
        eBoost = ExtraordinaryEffect(eBoost);
        if (nSpell == 481)           DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HARPER_CATS_GRACE);
        if (nSpell == 482)           DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HARPER_EAGLES_SPLENDOR);
    }

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    // Blackguard Bullstrength
    if (nSpell == SPELLABILITY_BG_BULLS_STRENGTH && GetSpellTargetObject() == OBJECT_SELF)
    {
        if (GetAbilityScore(OBJECT_SELF, ABILITY_CHARISMA, TRUE) >= 13 && GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH, TRUE) >= 13)
        {
            ExecuteScript("bg_bullstr", OBJECT_SELF);
            eBoost = ExtraordinaryEffect(eBoost);
        }
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBoost, oTarget, HoursToSeconds(nDuration));
}

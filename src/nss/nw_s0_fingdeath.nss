//::///////////////////////////////////////////////
//:: Finger of Death
//:: NW_S0_FingDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You can slay any one living creature within range.
// The victim is entitled to a Fortitude saving throw to
// survive the attack. If he succeeds, he instead
// sustains 3d6 points of damage +1 point per caster
// level.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 17, 2000
//:://////////////////////////////////////////////
//:: Updated By: Georg Z, On: Aug 21, 2003 - no longer affects placeables

#include "x0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    int nSpamLimit = 2;
    if (nPureBonus >= 8)
    {
        nSpamLimit = 100;
    }
    else
    {
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY)) nSpamLimit += 3;
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY)) nSpamLimit += 2;
        else if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY)) nSpamLimit += 1;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage, nPureDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eDeath = EffectDeath();
    int nPalemaster = GetLevelByClass(CLASS_TYPE_PALEMASTER, OBJECT_SELF);
    int nDoDeath = CheckDeathSpam(OBJECT_SELF, oTarget, nSpamLimit);

    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE,OBJECT_SELF))
    {
        //GZ: I still signal this event for scripting purposes, even if a placeable
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FINGER_OF_DEATH));
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                if (nDoDeath && !MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_DEATH))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
                }
                else if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                {
                    //Roll damage
                    if (!nPalemaster) nPureDamage = nPureBonus;
                    else nPureDamage = nPureBonus/2;
                    nDamage = d6(3+nPureDamage) + nPureLevel;

                    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = (3+nPureDamage) * 6 + nPureLevel;
                    if (nMetaMagic == METAMAGIC_EMPOWER)  nDamage += (nDamage/2);
                    if (BlockNegativeDamage(oTarget)) nDamage = 0;
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                }
            }
        }
    }
}

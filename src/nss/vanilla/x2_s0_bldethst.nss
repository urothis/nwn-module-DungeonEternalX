///////////////////////////////////////////////////////
//
//  DeX Bladethirst change
//  1 AB every 5 levels of Ranger (max 3)
//
///////////////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
    object oPC = OBJECT_SELF;

    if (!X2PreSpellCastCode()) return;

    if (GetHasSpellEffect(SPELL_DIVINE_FAVOR, oPC)){
        FloatingTextStringOnCreature("This Spell does not stack with Divine Favor", OBJECT_SELF);
        return;
    }

    // Cory - Disabled stacking bonuses with divine wrath
    if (GetHasFeatEffect(FEAT_DIVINE_WRATH, oPC)){
        FloatingTextStringOnCreature("This Spell does not stack with Divine Wrath", OBJECT_SELF);
        return;
    }
    if (GetHasFeatEffect(FEAT_BARBARIAN_RAGE, OBJECT_SELF) || GetHasFeatEffect(FEAT_MIGHTY_RAGE, OBJECT_SELF)){
        FloatingTextStringOnCreature("This Spell does not stack with Barbarian Rage", OBJECT_SELF);
        return;
    }
    if (GetSpellTargetObject() != oPC){
        FloatingTextStringOnCreature("This Spell is only to self allowed", OBJECT_SELF);
        return;
    }

    int nLevel     = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
    int nMetaMagic = GetMetaMagicFeat();
    int nDur       = nLevel;


    int nAb = nLevel/5;
    if (nAb > 3) nAb = 3;

    effect eAb   = EffectAttackIncrease(nAb);
    effect eVis  = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    if (!GetHasFeat(FEAT_MONK_ENDURANCE))
    {
        nDur = 2*nDur;
        eAb = ExtraordinaryEffect(eAb);
    }
    if (nMetaMagic == METAMAGIC_EXTEND) nDur = 2*nDur;

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAb, oPC, RoundsToSeconds(nDur));
}

/*
Barbarian Rage:
No AC penalty with Dwarfen Defender levels

Mighty Rage:
Additional +1 AB and +2 Elemental Resist with Dwarfen Defender levels

Feat Enhancer:
Dwarfen defender can use Feat enhancer without taking Fighter levels. Fighter bonuses only work with at least 1 fighter level.
The dwarfen defender levels adds up into fighter levels when determining figter bonuses or prerequisites
Dwarfen Defender gain +6 AC at level 6 and additional +2 AC every 4 levels after 6 (max 16 AC)
AC does not stack with Item (Amulet) and not with Fighter imp.Parry. (the highest bonus only count)
AC works only if base STR > 24, base tumble skill > 21, no Palemaster levels, no Monk levels
Dwarfen Defender gain Discipline Bonus: 4 + base dexterity modifier + base wisdom modifier (max is Dwarfen Defender level, capped at 1Cool

Fighter Dodge:
The Dwarfen Defender can use Fighter dodge without minimum STR and INT requirement and without any Fighter levels.

////////////////////////////////




Fighter Feat-Enhancer (Item)
Taking feats grants the fighter various bonuses. They stack with the feat itself.
(All bonuses are magical enhancements and count toward the magical enhancement caps.)
Activate with Item. 30 Turns duration.

Skillfocus: Discipline
+2 Discipline
Prerequisite: 4 Fighter

Great Fortitude
+2 Fortitude
Prerequisite: 4 Fighter

Iron Will
+2 Will
Prerequisite: 4 Fighter

Lightning Reflexes
+2 Reflex
Prerequisite: 4 Fighter

Improved Parry
5 + (1 Natural AC every 5 Fighter)
5 + (1 Natural AC every 10 Fighter without the feat)
Prerequisite: 25 STR/DEX
Limitations: No RDD or Monk

Dirty Fighting
+1 Attack Bonus every 10 Fighter
Prerequisite: 25 STR/DEX
Limitations: No RDD

Epic Will
+4 Will
Prerequisite: 20 Fighter

Epic Reflexes
+4 Reflex
Prerequisite: 20 Fighter

>>>>>>>>>>>>>>>>>>>>>>>>>

Fighter Dodge (Item)

Prerequisite: 25 Str, 13 Con, 13 Int, 16 Fighter, no Monk, no PM
Specifics: The character add his constitution bonus to his Dodge AC for a number of rounds equal to the constitution bonus. This ability may be activated 3x/day, plus the character's constitution modifier.
RDDs and Clerics receive -2 AC penalty






*/




void main()
{
    object oPC = OBJECT_SELF;
    // Check Timer to prevent stacking
    int nFighter = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC);
    if (!nFighter) return;
    nFighter += GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oPC);

    if (GetLocalInt(oPC, "FeatEnhancerActive")) return;

    int nAttackBonus;   int nAcBonus;       int nDiscBonus;
    int nFort;          int nWillBonus;     int nRfxBonus;

    int nBaseStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    int nBaseDex = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
    int nHasImpParry = GetHasFeat(FEAT_IMPROVED_PARRY, oPC);
    int nRdd = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC);
    int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    float fDur = TurnsToSeconds(30);
    effect eImpactFx = EffectVisualEffect(VFX_IMP_PULSE_COLD);
    effect eLink;

    if (nFighter >= 4)
    {
        if (GetHasFeat(FEAT_SKILL_FOCUS_DISCIPLINE, oPC)) nDiscBonus += 2;
        if (GetHasFeat(FEAT_GREAT_FORTITUDE, oPC)) nFort += 2;
        if (GetHasFeat(FEAT_IRON_WILL, oPC)) nWillBonus += 2;
        if (GetHasFeat(FEAT_LIGHTNING_REFLEXES, oPC)) nRfxBonus += 2;
    }
    if (nFighter >= 20)
    {
        if (GetHasFeat(FEAT_EPIC_WILL, oPC)) nWillBonus += 4;
        if (GetHasFeat(FEAT_EPIC_REFLEXES, oPC)) nRfxBonus += 4;
    }

    if (nBaseDex > 24 || nBaseStr > 24)
    {
        if (nHasImpParry && !nRdd && !nMonk)    nAcBonus = nFighter/5;
        else    nAcBonus = nFighter/10;
        if (GetHasFeat(FEAT_DIRTY_FIGHTING, oPC) && !nRdd)    nAttackBonus = nFighter/10;
    }

    if (nAttackBonus) eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nAttackBonus));
    if (nAcBonus)     eLink = EffectLinkEffects(eLink, EffectACIncrease(nAcBonus+5, AC_NATURAL_BONUS));
    if (nDiscBonus)   eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DISCIPLINE, nDiscBonus));
    if (nFort)        eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT, nFort));
    if (nRfxBonus)    eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nRfxBonus));
    if (nWillBonus)   eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, nWillBonus));

    // Set Timer to prevent stacking
    SetLocalInt(oPC, "FeatEnhancerActive", TRUE);
    DelayCommand(fDur, DeleteLocalInt(oPC, "FeatEnhancerActive"));

    eLink = ExtraordinaryEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpactFx, oPC);
}

void main()
{
    object oPC = OBJECT_SELF;
    // Check Timer to prevent stacking
    int nFighter = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC);
    int nDD = GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oPC);
    if (!(nFighter+nDD)) return;

    if (GetLocalInt(oPC, "FeatEnhancerActive")) return;

    int nAttackBonus=0;   int nAcBonus=0;       int nDiscBonus;
    int nFort;          int nWillBonus;     int nRfxBonus;

    int nBaseStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    int nBaseDex = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
    int nBaseWis = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);
    int nHasImpParry = GetHasFeat(FEAT_IMPROVED_PARRY, oPC);
    int nRdd = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC);
    int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    int nPale = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);
    int nDDdmg = nDD/8;
    float fDur = TurnsToSeconds(30);

    //Use item effect
    effect eImpactFx = EffectVisualEffect(VFX_IMP_PULSE_COLD);
    effect eLink;

    if (nFighter+nDD >= 4)
    {
        if (GetHasFeat(FEAT_SKILL_FOCUS_DISCIPLINE, oPC))   nDiscBonus += 2;
        if (GetHasFeat(FEAT_GREAT_FORTITUDE, oPC))          nFort += 2;
        if (GetHasFeat(FEAT_IRON_WILL, oPC))                nWillBonus += 2;
        if (GetHasFeat(FEAT_LIGHTNING_REFLEXES, oPC))       nRfxBonus += 2;
    }
    if (nFighter+nDD >= 20)
    {
        if (GetHasFeat(FEAT_EPIC_WILL, oPC)) nWillBonus += 4;
        if (GetHasFeat(FEAT_EPIC_REFLEXES, oPC)) nRfxBonus += 4;
    }
    //AC
    if (nBaseDex > 24 || nBaseStr > 24)
    {
        int nDDdisc=0;

        if (nHasImpParry && !nRdd && !nMonk && !nPale && nBaseStr > 24)    nAcBonus = nFighter/5;
        if (nHasImpParry && !nRdd && !nMonk && !nPale && nBaseDex > 24) nAcBonus += nFighter/10;


        //DD
        if (nDD>5)
        {
            if (GetHasFeat(FEAT_DIRTY_FIGHTING, oPC) && !nRdd && !nMonk)    nAttackBonus += (nDD)/4;
            //nAcBonus += (2*((nDD-6)/6));
            if (nDD >= 6)
            {
                nAcBonus = 1;
                if (nDD >= 12)
                {
                    nAcBonus += 1;
                    if (nDD >= 18)
                    {
                        nAcBonus += 1;
                        if (nDD >= 24)
                        {
                            nAcBonus += 2;
                            if (nDD == 30)
                            nAcBonus += 2;
                        }
                    }
                }
            }
            int nDDdmg = nDD/8;
            if (nBaseStr>24)
            {
                nDDdisc = 4;
            }
            else if (nBaseDex>24)
            {
                nDDdisc = 4 + GetAbilityModifier(ABILITY_WISDOM,oPC) + GetAbilityModifier(ABILITY_DEXTERITY,oPC);
                if (nDDdisc > 10)   nDDdisc = 10;
            }
        }
        nDiscBonus += nDDdisc;

        //AB
        if (GetHasFeat(FEAT_DIRTY_FIGHTING, oPC) && !nRdd && !nMonk)    nAttackBonus += (nFighter)/10;
    }


    if (nAttackBonus) eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nAttackBonus));
    if (nAcBonus)     eLink = EffectLinkEffects(eLink, EffectACIncrease(nAcBonus+5, AC_NATURAL_BONUS));
    if (nDiscBonus)   eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DISCIPLINE, nDiscBonus));
    if (nFort)        eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT, nFort));
    if (nRfxBonus)    eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nRfxBonus));
    if (nWillBonus)   eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, nWillBonus));
    if (nDDdmg)       eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nDDdmg, DAMAGE_TYPE_MAGICAL));

    // Set Timer to prevent stacking
    SetLocalInt(oPC, "FeatEnhancerActive", TRUE);
    DelayCommand(fDur, DeleteLocalInt(oPC, "FeatEnhancerActive"));

    eLink = ExtraordinaryEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpactFx, oPC);
}

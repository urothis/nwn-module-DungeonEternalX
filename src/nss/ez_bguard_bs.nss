void BlackGuardPulse(int nMaxAttack, int nDur, object oPC, float fRadius)
{
    if (!GetIsObjectValid(oPC)) return;

    int nPulseCount = GetLocalInt(oPC, "BgPulseCount");
    if (nPulseCount > nDur) // More than 1 pulse is active
    {    // reset the counter
        SetLocalInt(oPC, "BgPulseCount", nDur);
        nPulseCount = nDur;
        return; // and stop one frenzy.
    }

    if (nPulseCount < 1)
    {
        FloatingTextStringOnCreature("Blackguard Bull Strength has worn out", oPC, FALSE);
        DeleteLocalInt(oPC, "BgPulseCount");
        return;
    }
    SetLocalInt(oPC, "BgPulseCount", nPulseCount - 1);

    int nAttack = 1;
    float fCurrentHp, fMaxHp, fPercent;
    float fDelay = 0.2;

    effect eBeam = EffectBeam(VFX_BEAM_EVIL, oPC, BODY_NODE_CHEST);
    effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC));
    // Continue Loop until Max AB is reached or no Objects left.
    while(GetIsObjectValid(oTarget) && nAttack < nMaxAttack)
    {
        if (GetIsPC(oTarget))
        {
            //SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_BG_BULLS_STRENGTH));
            fCurrentHp = IntToFloat(GetCurrentHitPoints(oTarget));
            fMaxHp = IntToFloat(GetMaxHitPoints(oTarget));
            fPercent = (fCurrentHp/fMaxHp)*100.0;
            if (fPercent < 20.0) nAttack += 1;
            if (fPercent < 60.0) nAttack += 1;
            if (fPercent < 90.0)
            {
                nAttack += 2;
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.0);
                fDelay += 0.2;
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC));
    }
    if (nAttack > nMaxAttack) nAttack = nMaxAttack; // Max AB cap
    effect eAttack = EffectAttackIncrease(nAttack);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, RoundsToSeconds(nAttack)-0.1);
    if (nAttack > 1) FloatingTextStringOnCreature("Blackguard " + IntToString(nAttack) + " AB", oPC, FALSE);
    AssignCommand(oPC, DelayCommand(RoundsToSeconds(nAttack), BlackGuardPulse(nMaxAttack, nDur, oPC, fRadius)));
}

void main()
{
    object oPC = OBJECT_SELF;
    int nPulseCount = GetLocalInt(oPC, "BgPulseCount");

    int nBgLvl = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    int nMaxAttack = nBgLvl/10 + 1; //+1 AB, and another +1 with 10 BG levels
    int nDur = 10; // Number of pulses or the Duration of AB increase if only +1 AB
    if (nBgLvl > 10)
    {
        nDur = nBgLvl;
        nMaxAttack = (nBgLvl-10)/3 + 2; // increase +1 AB every 3 levels after 10
    }
    float fRadius = IntToFloat(nBgLvl);
    if (fRadius > 15.0) fRadius = 15.0;
    effect eImpact = EffectVisualEffect(VFX_IMP_HARM);

    // Max AB Modifier
    if (GetLevelByClass(CLASS_TYPE_FIGHTER)) nMaxAttack += 2;
    if (GetLevelByClass(CLASS_TYPE_RANGER)) nMaxAttack -= 1;
    if (GetLevelByClass(CLASS_TYPE_DRUID)) nMaxAttack -= 2;
    if (GetLevelByClass(CLASS_TYPE_BARBARIAN)) nMaxAttack -= 3;
    if (GetLevelByClass(CLASS_TYPE_CLERIC)) nMaxAttack -= 5;
    if (GetLevelByClass(CLASS_TYPE_PALADIN)) nMaxAttack -= 5;
    if (nMaxAttack < 1) nMaxAttack = 1; // Allways at least +1 AB

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oPC);

    if (nMaxAttack > 1) // Start pulsing if BG can gain more than +1 AB
    {   //+nPulseCount to Check later in void if pulse is stacked.
        SetLocalInt(oPC, "BgPulseCount", nDur+nPulseCount); // CLEAR THIS ON DEATH, REST
        DelayCommand(0.2, BlackGuardPulse(nMaxAttack, nDur, oPC, fRadius));
    }
    else // No pulse needed if BG cant gain more than +1 AB
    {
        effect eAttack = EffectAttackIncrease(1);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, RoundsToSeconds(nDur));
    }
}

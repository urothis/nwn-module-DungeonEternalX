// In the hopes of adding more depth and variety to builds, a +2 ac bonus
// is given to characters with no cross-skill access to tumble (that is, they cant
// get more than 21 ranks of tumble).
void NoTumbleAcBonus(object oPC)
{

    // Local int to check if the bonus is active (delete on rest/unequip)
    int nTumAcCheck = GetLocalInt(oPC, "TumbleAcBonus");

    if (nTumAcCheck != 0) // If the bonus is already active, do nothing
    {
        return;
    }

    // Check if any tumble classes are taken
    int nRog = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
    int nBard = GetLevelByClass(CLASS_TYPE_BARD, oPC);
    int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    int nAssn = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
    int nHS = GetLevelByClass(CLASS_TYPE_HARPER, oPC);
    int nSD = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC);

    // Tally up possible tumble classes
    int nTumbleCheck = nRog + nBard + nMonk + nAssn + nHS + nSD;

    // The character has tumble available, do nothing
    if  (nTumbleCheck > 0)
    {
        return;
    }
    else if (GetHitDice(oPC)>12) // Tumble skill unavailable, Enable Bonus
    {
        effect eAC = EffectACIncrease(7, AC_DEFLECTION_BONUS);
        eAC = ExtraordinaryEffect(eAC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
        SetLocalInt(oPC, "TumbleAcBonus", 1);
    }
}

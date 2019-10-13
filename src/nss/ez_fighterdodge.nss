////////////////////////////////////////////////////////////////////////////////
//
//  DeX Fighter Dodge
//  Prerequisite: 25 Str, 13 Con, 13 Int, 16 Fighter, no Monk levels, no PM levels
//  Specifics: The character add his constitution bonus to his Dodge AC
//  for a number of rounds equal to the constitution bonus.
//  This ability may be activated 3x/day, plus the character's constitution modifier.
//  RDDs, Blackguards, and Clerics receive -2 AC penalty, DDs receive a -4 penalty.
//
////////////////////////////////////////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    float fDelay   = 1.0; // Delay for simulating Cast Spell. Because using item is faster than casting spell

    // Check Timer to prevent stacking
    if (GetLocalInt(oPC, "RangerDodgeActive")) return;

    int nValue = GetAbilityModifier(ABILITY_CONSTITUTION);
    int nCount = GetLocalInt(oPC, "RangerDodgeCount"); //Counter for max Dodge AC uses/day
    int nUses  = nValue + 3;

    // Check prerequisites if nCount empty. Dont have to check everything allways again.
    int nDD = GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER);
    if (!nCount)
    {
        if ((GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) < 25) || (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < 13) || (GetLevelByClass(CLASS_TYPE_FIGHTER) < 16) || GetLevelByClass(CLASS_TYPE_MONK) || GetLevelByClass(CLASS_TYPE_PALE_MASTER))
        {
            FloatingTextStringOnCreature("You can't use this ability", oPC);
            return;
        }
    }

    if (nCount >= nUses)
    {
         FloatingTextStringOnCreature("You can't use this ability anymore today", oPC);
         return;
    }

    int nAC    = nValue;
    int nDur   = nValue;

    // Cory - Nerfed ac when Pal levels present, BG penalty removed
    //if (GetLevelByClass(CLASS_TYPE_BLACKGUARD)) nAC -= 1;
    if (GetLevelByClass(CLASS_TYPE_PALADIN)) nAC -= 1;
    if (GetLevelByClass(CLASS_TYPE_CLERIC)) nAC -= 2;
    if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE)) nAC -= 2;
    if (GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER)) nAC -= 4;

    effect eBonus = ExtraordinaryEffect(EffectACIncrease(nAC));
    effect eVis   = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, RoundsToSeconds(nDur)));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    SendMessageToPC(oPC, IntToString(nUses-(nCount+1)) + " Fighter Dodge uses left for today");

    // Set Timer to prevent stacking
    SetLocalInt(oPC, "RangerDodgeActive", TRUE);
    DelayCommand(RoundsToSeconds(nDur)+fDelay, DeleteLocalInt(oPC, "RangerDodgeActive"));

    //Counter for max Dodge AC uses/day
    SetLocalInt(oPC, "RangerDodgeCount", nCount+1); // Delete this after rest!
}

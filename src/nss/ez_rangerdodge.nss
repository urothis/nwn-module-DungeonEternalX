////////////////////////////////////////////////////////////////////////////////
//
//  DeX Ranger Dodge
//  Prerequisite: 13 Wis, 4 Ranger, no Monk levels
//  Specifics: The character add his wisdom bonus to his Dodge AC
//  for a number of rounds equal to the charisma bonus.
//  This ability may be activated 3x/day, plus the character's wisdom modifier.
//
////////////////////////////////////////////////////////////////////////////////

#include "arres_inc"

void main()
{
    object oTarget = OBJECT_SELF;
    float fDelay   = 1.0; // Delay for simulating Cast Spell. Because using item is faster than casting spell

    // Check Timer to prevent stacking
    if (GetLocalInt(oTarget, "RangerDodgeActive")) return;

    int nValue = GetAbilityModifier(ABILITY_WISDOM, oTarget);
    int nCount = GetLocalInt(oTarget, "RangerDodgeCount"); //Counter for max Dodge AC uses/day
    int nUses  = nValue + 3;

    // Check prerequisites if nCount empty. Dont have to check everything allways again.
    if (!nCount){
        if (GetLevelByClass(CLASS_TYPE_RANGER) < 14 || GetLevelByClass(CLASS_TYPE_MONK, oTarget))
        {
            FloatingTextStringOnCreature("You can't use this ability. See the class changes.", oTarget);
            return;
        }
    }

    if (nCount >= nUses)
    {
         FloatingTextStringOnCreature("You can't use this ability anymore today", oTarget);
         return;
    }

    int nAC    = nValue;
    int nDur   = nValue;

    effect eBonus = ExtraordinaryEffect(EffectACIncrease(nAC));
    effect eVis   = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oTarget, RoundsToSeconds(nDur)));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SendMessageToPC(oTarget, IntToString(nUses-(nCount+1)) + " Ranger Dodge uses left for today");

    // Set Timer to prevent stacking
    SetLocalInt(oTarget, "RangerDodgeActive", TRUE);
    DelayCommand(RoundsToSeconds(nDur)+fDelay, DeleteLocalInt(oTarget, "RangerDodgeActive"));

    //Counter for max Dodge AC uses/day
    SetLocalInt(oTarget, "RangerDodgeCount", nCount+1); // Delete this after rest!
}

//::///////////////////////////////////////////////
//:: Divine Shield
//:: x0_s2_divshield.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Up to [turn undead] times per day the character may add his Charisma bonus to his armor
    class for a number of rounds equal to the Charisma bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13, 2002
//:://////////////////////////////////////////////
#include "x0_i0_spells"

void main()
{
   object oPC = OBJECT_SELF;
   if (!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
   {
        SpeakStringByStrRef(40550);
   }
   else if (GetHasFeatEffect(414) == FALSE)
   {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nLevel = GetCasterLevel(oPC);

        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
        effect eAC = ExtraordinaryEffect(EffectACIncrease(nCharismaBonus));

         // * Do not allow this to stack
        RemoveEffectsFromSpell(oTarget, GetSpellId());

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oPC, 474, FALSE));

        //Apply Link and VFX effects to the target
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
    }
}




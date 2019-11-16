//::///////////////////////////////////////////////
//:: Shadow Evade
//:: X0_S2_ShadEvade    .nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:: Updated for Epic Level: 2003-07-24 Georg
//:://////////////////////////////////////////////


void main()
{
    //Declare major variables
    int nLevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER);
    int nConceal, nDRAmount, nDRPower, nAC;
    int nDuration = nLevel;

    switch (nLevel) {
        case 4: case 5: nConceal = 5; nDRAmount = 5; nDRPower = DAMAGE_POWER_PLUS_ONE; nAC = 1; break;
        case 6: case 7: nConceal = 10; nDRAmount = 5; nDRPower = DAMAGE_POWER_PLUS_TWO; nAC = 2; break;
        case 8: case 9:  nConceal = 15; nDRAmount = 10; nDRPower = DAMAGE_POWER_PLUS_TWO; nAC = 3; break;
        case 10: case 11: case 12: case 13: case 14: nConceal = 20; nDRAmount = 10; nDRPower = DAMAGE_POWER_PLUS_THREE; nAC = 4; break;
        case 15: case 16: case 17: case 18: case 19: nConceal = 20; nDRAmount = 12; nDRPower = DAMAGE_POWER_PLUS_FOUR; nAC = 4; break;
        case 20: case 21: case 22: case 23: case 24: nConceal = 20; nDRAmount = 14; nDRPower = DAMAGE_POWER_PLUS_FIVE; nAC = 4; break;
        case 25: case 26: case 27: case 28: case 29: nConceal = 20; nDRAmount = 16; nDRPower = DAMAGE_POWER_PLUS_SIX; nAC = 4; break;
        case 30: nConceal = 20; nDRAmount = 18; nDRPower = DAMAGE_POWER_PLUS_SEVEN; nAC = 4; break;
    }

    //Declare effects
    effect eConceal = EffectConcealment(nConceal);
    effect eDR = EffectDamageReduction(nDRAmount, nDRPower);
    effect eAC = EffectACIncrease(nAC);
    effect eVis2 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);

    //Link effects
    effect eLink = EffectLinkEffects(eConceal, eDR);

    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eVis2);

    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, 477, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), OBJECT_SELF, RoundsToSeconds(nDuration));
}

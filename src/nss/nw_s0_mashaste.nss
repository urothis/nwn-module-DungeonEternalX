//::///////////////////////////////////////////////
//:: Mass Haste
//:: NW_S0_MasHaste.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All allies in a 30 ft radius from the point of
   impact become Hasted for 1 round per caster
   level.  The maximum number of allies hasted is
   1 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
    if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;
    int nEnchanter;
    if (nPureBonus >= 8) nEnchanter = TRUE;


    //Declare major variables
    object oTarget;
    effect eVis   = EffectVisualEffect(VFX_IMP_HASTE);

    effect eSlow  = EffectSlow();
    effect eVis2  = EffectVisualEffect(VFX_IMP_SLOW);

    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    int nMetaMagic = GetMetaMagicFeat();
    float fDelay;
    int nDuration = nPureLevel;
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;

    location lSpell = GetSpellTargetLocation();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    float fDuration = RoundsToSeconds(nDuration);
    while(GetIsObjectValid(oTarget))
    {
        //Make faction check on the target
        if (GetIsFriend(oTarget))
        {
            RemoveSpecificEffect(EFFECT_TYPE_SLOW, oTarget);
            fDelay = GetRandomDelay(0.0, 1.0);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HASTE, FALSE));
            DelayCommand(fDelay, ReapplyPermaHaste(oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        else if (GetIsEnemy(oTarget) && nEnchanter)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLOW));
            fDelay = GetRandomDelay(0.0, 1.0);
            if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, fDuration));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                DelayCommand(fDelay, ReapplyPermaHaste(oTarget, fDuration + 0.5));
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    }
}

//::///////////////////////////////////////////////
//:: Cone of Cold
//:: NW_S0_ConeCold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Cone of cold creates an area of extreme cold,
// originating at your hand and extending outward
// in a cone. It drains heat, causing 1d6 points of
// cold damage per caster level (maximum 15d6).
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    //Declare major variables
    int nCasterLevel = GetMin(15+nPureBonus, nPureLevel); //Limit caster level to 15+PureBonus
    int nMetaMagic = GetMetaMagicFeat();

    effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
   int bHasNekrosis;
   if (nPureBonus && HasNekrosis(OBJECT_SELF)) bHasNekrosis = TRUE;
    if (bHasNekrosis) eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    int nDamage;
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    int nNegDmg;
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONE_OF_COLD));
            //Get the distance between the target and caster to delay the application of effects
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
            //Make SR check, and appropriate saving throw(s).
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                if(oTarget != OBJECT_SELF)
                {
                    //Detemine damage
                    nDamage = d6(nCasterLevel);
                    //Enter Metamagic conditions
                    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLevel;//Damage is at max
                    else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                    //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_COLD);
                    // Apply effects to the currently selected target.
                    effect eCold = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                    if (bHasNekrosis)
                    {
                       if (BlockNegativeDamage(oTarget)) nNegDmg = 0;
                       else nNegDmg = nDamage/2;
                       eCold = EffectLinkEffects(EffectDamage(nDamage/2, DAMAGE_TYPE_COLD), EffectDamage(nNegDmg, DAMAGE_TYPE_NEGATIVE));
                    }

                    if(nDamage > 0)
                    {
                        //Apply delayed effects
                       DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                       DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}


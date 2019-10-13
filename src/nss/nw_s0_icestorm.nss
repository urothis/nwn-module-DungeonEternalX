//::///////////////////////////////////////////////
//:: Ice Storm
//:: NW_S0_IceStorm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Everyone in the area takes 3d6 Bludgeoning
   and 2d6 Cold damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
    if (!X2PreSpellCastCode()) return;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
    int nVaasa;
    if (HasVaasa(OBJECT_SELF))
    {
        nVaasa = TRUE;
        nPureBonus = 8;
    }
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = nPureLevel;
    if (nCasterLvl > 39) nCasterLvl = 39;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage, nDamage2;
    int nVariable = 2 + nCasterLvl/3;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_ICESTORM); //USE THE ICESTORM FNF
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam, eDam2;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Apply the ice storm VFX at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.

    effect eMind, eLink, eCharm, eVis2;
    if (nVaasa)
    {
        eCharm = EffectDazed();
        eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        eLink = EffectLinkEffects(eMind, eCharm);
        eVis2 = EffectVisualEffect(VFX_IMP_DAZED_S);
    }

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            fDelay = GetRandomDelay(0.75, 2.25);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ICE_STORM));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d6(3);
                nDamage2 = d6(nVariable);
                //Resolve metamagic
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 18; // 3*6
                    nDamage2 = 6 * nVariable;
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage  += (nDamage  / 2);
                    nDamage2 += (nDamage2 / 2);
                }
                // Fix max/empower icestorm for shifter raks. Maximize spell will override empower spell.
                else if ((GetRacialType(oCaster)==RACIAL_TYPE_OUTSIDER) && (GetLevelByClass(CLASS_TYPE_SHIFTER, oCaster)>9))
                {
                    if (GetHasFeat(FEAT_EMPOWER_SPELL, oCaster) && (!GetHasFeat(FEAT_MAXIMIZE_SPELL, oCaster)))
                    {
                        nDamage  += (nDamage  / 2);
                        nDamage2 += (nDamage2 / 2);
                    }
                    if (GetHasFeat(FEAT_MAXIMIZE_SPELL, oCaster))
                    {
                        nDamage = 18; // 3*6
                        nDamage2 = 6 * nVariable;
                    }
                }
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
                eDam2 = EffectDamage(nDamage2, DAMAGE_TYPE_COLD);
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the impact that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                if (nVaasa)
                {
                    if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3)));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}


//::///////////////////////////////////////////////
//:: Chain Lightning
//:: NW_S0_ChLightn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The primary target is struck with 1d6 per caster,
    1/2 with a reflex save.  1 secondary target per
    level is struck for 1d6 / 2 caster levels.  No
    repeat targets can be chosen.
*/

#include "x0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())    return;

    //Declare pure class variables.
    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    //Declare major variables
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDamage;
    int nDamCap = 120;
    int nDamStrike;
    int nNumAffected = 0;
    int nMetaMagic   = GetMetaMagicFeat();
    int nCasterLvl   = nPureLevel;

    //Declare lightning effect connected the casters hands
    effect eLightning   = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);;
    effect eVis         = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eDamage;
    object oFirstTarget = GetSpellTargetObject();
    object oHolder;
    object oTarget;
    location lSpellLocation;

    //Sets the max caster level
    if (nCasterLvl > 20) nCasterLvl = 20;
    int iDice = nCasterLvl + nPureBonus; // Number of dice to roll

    //Roll damage for each target
    nDamage = d6(iDice);

    //Resolve metamagic
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * iDice;
    else if (nMetaMagic == METAMAGIC_EMPOWER) {
        nDamage = nDamage + nDamage / 2;
        nDamCap = nDamCap + nDamCap / 2;
    }
    //Damage the initial target
    if (spellsIsTarget(oFirstTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
        //Make an SR Check
        if (!MyResistSpell(OBJECT_SELF, oFirstTarget))
        {
            //Adjust damage via Reflex Save or Evasion or Improved Evasion
            nDamStrike = GetReflexAdjustedDamage(nDamage, oFirstTarget, nPureDC, SAVING_THROW_TYPE_ELECTRICITY);
            //Set the damage effect for the first target
            if (nDamStrike > nDamCap) nDamStrike = nDamCap;
            eDamage = EffectDamage(nDamStrike, DAMAGE_TYPE_ELECTRICAL);
            //Apply damage to the first target and the VFX impact.
            if(nDamStrike > 0)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oFirstTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);
            }
        }
    }
    //Apply the lightning stream effect to the first target, connecting it with the caster
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);

    //Reinitialize the lightning effect so that it travels from the first target to the next target
    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oFirstTarget, BODY_NODE_CHEST);

    float fDelay = 0.2;
    int nCnt = 0;
    nDamCap = 120;

    // *
    // * Secondary Targets
    // *

    //Get the first target in the spell shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget) && nCnt < nCasterLevel)
    {
        //Make sure the caster's faction is not hit and the first target is not hit
        if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Connect the new lightning stream to the older target and the new target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 0.5));

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
            //Do an SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d6(iDice);
                //Resolve metamagic
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 6 * iDice;
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + nDamage / 2;
                    nDamCap = nDamCap + nDamCap / 2;

                }

                //Adjust damage via Reflex Save or Evasion or Improved Evasion
                nDamStrike = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_ELECTRICITY) / 2;
                //Apply the damage and VFX impact to the current target
                if (nDamStrike > nDamCap) nDamStrike = nDamCap;
                eDamage = EffectDamage(nDamStrike, DAMAGE_TYPE_ELECTRICAL);
                if(nDamStrike > 0) //age > 0)
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                }
            }
            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
            eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
            }
            else
            {
                // * April 2003 trying to make sure beams originate correctly
                effect eNewLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
                if(GetIsEffectValid(eNewLightning))
                {
                    eLightning =  eNewLightning;
                }
            }

            fDelay += 0.1f;
        }
        //Count the number of targets that have been hit.
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            nCnt++;
        }

        //Get the next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
      }
 }




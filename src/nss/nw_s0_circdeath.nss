//::///////////////////////////////////////////////
//:: Circle of Death
//:: NW_S0_CircDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The caster slays a number of HD worth of creatures
   equal to 1d4 times level.  The creature gets a
   Fort Save or dies.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;

    //Declare major variables
    object oTarget;
    object oLowest;
    effect eDeath =  EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);
    int bContinueLoop = FALSE; //Used to determine if we have a next valid target
    int nMetaMagic = GetMetaMagicFeat();
    int nCurrentHD;
    int bAlreadyAffected;
    float fDelay;

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;

    int nMax = 10 + nPureBonus * 4; // maximum hd creature affected, set this to 9 so that a lower HD creature is chosen automatically

    string sIdentifier = GetTag(OBJECT_SELF);

    int nHD = d4(nPureLevel); //Roll to see how many HD worth of creature will be killed
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nHD = 4 * nPureLevel; //Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nHD = nHD + (nHD/2); //Damage/Healing is +50%
    }
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetSpellTargetLocation());

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    //Check for at least one valid object to start the main loop
    if (GetIsObjectValid(oTarget)) bContinueLoop = TRUE;
    // The above checks to see if there is at least one valid target.  If no value target exists we do not enter the loop.

    while ((nHD > 0) && (bContinueLoop))
    {
        int nLow = nMax; //Set nLow to the lowest HD creature in the last pass through the loop
        bContinueLoop = FALSE; //Set this to false so that the loop only continues in the case of new low HD creature
        //Get first target creature in loop
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {
            //Make sure the currect target is not an enemy
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
            {
                //Get a local set on the creature that checks if the spell has already allowed them to save
                bAlreadyAffected = GetLocalInt(oTarget, "bDEATH");
                if (!bAlreadyAffected)
                {
                    nCurrentHD = GetHitDice(oTarget);
                    //If the selected creature is of lower HD then the current nLow value and
                    //the HD of the creature is of less HD than the number of HD available for
                    //the spell to affect then set the creature as the current primary target
                    if(nCurrentHD < nLow && nCurrentHD <= nHD)
                    {
                        nLow = nCurrentHD;
                        oLowest = oTarget;
                        bContinueLoop = TRUE;
                    }
                }
            }
            //Get next target in shape to test for a new
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
        }
        //Check to make sure that oLowest has changed
        if (bContinueLoop == TRUE)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oLowest, EventSpellCastAt(OBJECT_SELF, SPELL_CIRCLE_OF_DEATH));
            fDelay = GetRandomDelay();
            if(!MyResistSpell(OBJECT_SELF, oLowest))
            {
                //Make a Fort Save versus death effects
                if(!MySavingThrow(SAVING_THROW_FORT, oLowest, nPureDC, SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oLowest);
                }
            }
            //Even if the target made their save mark them as having been affected by the spell
            SetLocalInt(oLowest, "bDEATH", TRUE);
            //Destroy the local after 1/4 of a second in case other Circles of Death are cast on the creature later
            DelayCommand(fDelay + 0.25, DeleteLocalInt(oLowest, "bDEATH"));
            //Adjust the number of HD that have been affected by the spell
            nHD = nHD - GetHitDice(oLowest);
            oLowest = OBJECT_INVALID;
        }
    }
}


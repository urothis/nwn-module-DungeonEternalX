//::///////////////////////////////////////////////
//:: Dismissal
//:: NW_S0_Dismissal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "pure_caster_inc"
void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ABJURATION);
    int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ABJURATION) + nPureBonus;
    int nPureDC    = GetSpellSaveDC() + nPureBonus;


    //Declare major variables
    object oMaster;
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    location lLoc = GetSpellTargetLocation();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lLoc);
    int nSpellDC;
    //Get the first object in the are of effect
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    while(GetIsObjectValid(oTarget))
    {
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
        //Is that master valid and is he an enemy
        if(GetIsObjectValid(oMaster))
        {
            if (spellsIsTarget(oMaster,SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
                //Is the creature a summoned associate
                if(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
                    GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
                    GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget )
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISMISSAL));
                    //Determine correct save
                    nSpellDC = nPureDC;
                    //Make SR and will save checks
                    if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                    {
                        //Apply the VFX and delay the destruction of the summoned monster so
                        //that the script and VFX can play.
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        DestroyObject(oTarget, 0.5);
                    }
                }
            }
        }
        //Get next creature in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    }
}

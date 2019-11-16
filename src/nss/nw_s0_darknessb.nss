//::///////////////////////////////////////////////
//:: Darkness: On Exit
//:: NW_S0_DarknessB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
#include "x0_i0_spells"
//#include "sha_subr_methds"
#include "x2_inc_spellhook"

void main()
{

    object oTarget = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();
//Shayan's Subrace Engine
  //  SetIsInDarkness(oTarget, FALSE);
//End
    int bValid = FALSE;
    effect eAOE;
    //Search through the valid effects on the target.
    eAOE = GetFirstEffect(oTarget);
    int nID;

    while (GetIsEffectValid(eAOE))
    {
        nID = GetEffectSpellId(eAOE);
        //If the effect was created by the spell then remove it
        if (nID== SPELL_DARKNESS || nID == SPELLABILITY_AS_DARKNESS  || nID == SPELL_SHADOW_CONJURATION_DARKNESS || nID == 688)
        {
            if (GetEffectCreator(eAOE) == oCreator)
            {
                RemoveEffect(oTarget, eAOE);
                return;
            }
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
}

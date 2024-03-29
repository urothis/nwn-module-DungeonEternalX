//::///////////////////////////////////////////////
//:: Entangle B: On Exit
//:: NW_S0_EntangleB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes the entangle effect after the AOE dies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 25, 2002
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    effect eAOE;
    object oAOECreator = GetAreaOfEffectCreator();
    if (GetHasSpellEffect(SPELL_ENTANGLE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectType(eAOE) == EFFECT_TYPE_ENTANGLE)
            {
                if (GetEffectCreator(eAOE) == oAOECreator)
                {
                    if (GetEffectSpellId(eAOE) == SPELL_ENTANGLE)
                    {
                        RemoveEffect(oTarget, eAOE);
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}


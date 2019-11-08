//::///////////////////////////////////////////////
//:: Dirge: On Exit
//:: x0_s0_dirgeET.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    MARCH 2003
    Remove the negative effects of the dirge.
    Modified by : Rabidness
             on : June 20 , 2004
    Changes:
        - Fixed an issue where the AOE would dispell if the CASTER left the AOE
            ...when the AOE was supposed to be centered ON the caster.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
//:: Update Pass By:

#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();

    //VvVvV Rabidness addition VvVvV
    if ( GetAreaOfEffectCreator() == oTarget )
        return;

    effect eAOE;
 //   SpawnScriptDebugger();
    if(GetHasSpellEffect(SPELL_DIRGE, oTarget))
    {
        DeleteLocalInt(oTarget, "X0_L_LASTPENALTY");

        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);

        while (GetIsEffectValid(eAOE) )
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the Dirge spell then remove it
                if(GetEffectSpellId(eAOE) == SPELL_DIRGE)
                {
                    RemoveEffect(oTarget, eAOE);
                    //bValid = TRUE;
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}




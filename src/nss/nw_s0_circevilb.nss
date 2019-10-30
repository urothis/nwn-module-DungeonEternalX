//::///////////////////////////////////////////////
//:: Magic Cirle Against Evil
//:: NW_S0_CircEvilB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from evil effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:: Modified By: Rabidness
//:: Modified On: June 20, 2004
//::        - Fixed an issue where the AOE would dispell if the CASTER left the AOE
//::            ...when the AOE was supposed to be centered ON the caster.
//:://////////////////////////////////////////////
#include "nw_i0_spells"


#include "x2_inc_spellhook"

void main()
{


    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oTarget))
    {
        //The main script sets this int to the origin of the AoE. If this is the
        //Origin, they are disabled from leaving it.
        //VvVvV If added by Rabidness VvVvV
        if( GetLocalObject(oTarget , "oProtEvilSource") == oTarget )
            return;

        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MAGIC_CIRCLE_AGAINST_EVIL)
                {
                    RemoveEffect(oTarget, eAOE);
                    //only dispell one, this is to prevent a stacked group of
                    //AoEs all being dispelled by exiting one.
                    //VvV Rabidness addition VvV
                    return;
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

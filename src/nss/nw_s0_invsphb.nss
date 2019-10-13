//::///////////////////////////////////////////////
//:: Invisibility Sphere: On Exit
//:: NW_S0_InvSphA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Modified By: Rabidness
//:: Modified On: June 20, 2004
//::        - Fixed an issue where the AOE would dispell if the CASTER left the AOE
//::            ...when the AOE was supposed to be centered ON the caster.
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    effect eAOE;
    if(GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oTarget))
    {
        //Rabidness addition, it shouldn't be possible for the creator to leave
        //the AOE that is centered on their body.
        if ( GetLocalObject( oTarget , "oInvisSphereSource" ) == oTarget )
            return;

        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_INVISIBILITY)
                {
                    //If the effect was created by the Invisibility Sphere then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_INVISIBILITY_SPHERE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        //only dispell one, this is to prevent a stacked group of
                        //AoEs all being dispelled by exiting one.
                        //VvV Rabidness addition VvV
                        return;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

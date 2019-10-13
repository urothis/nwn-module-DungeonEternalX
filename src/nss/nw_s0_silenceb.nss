//::///////////////////////////////////////////////
//:: Silence: On Exit
//:: NW_S0_SilenceB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Modified By: Rabidness
//:: Modified On: August 05, 2004
//::        - Fixed an issue where the AOE would dispell if the CASTER left the AOE
//::            ...when the AOE was supposed to be centered ON the caster.
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

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


    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;

    if(GetHasSpellEffect(SPELL_SILENCE, oTarget))
    {
        //The main script sets this int to the origin of the AoE. If this is the
        //Origin, they are disabled from leaving it.
        //VvVvV If added by Rabidness VvVvV

        if( 1 == GetLocalInt(oTarget , "nSilenceSource") )
        {
            return;
        }

        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_SILENCE)
                {
                    //If the effect was created by the Silence then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_SILENCE)
                    {
                        //AssignAOEDebugString("Removing Effects");
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

//::///////////////////////////////////////////////
//:: Magic Circle Against Evil
//:: NW_S0_CircEvil.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Modified by : Rabidness
             on : 05/18/04
    Changes:
        - Removed duration effects to reduce lag and for PnP authenticity

    Modified by : Rabidness
             on : June 20 , 2004
    Changes:
        - Fixed an issue where the AOE would dispell if the CASTER left the AOE
            ...when the AOE was supposed to be centered ON the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001

#include "x2_inc_spellhook"

//Function called to remove the AOE effect when it is dead, since the normal
//AOE onExit script is disabled against the creator of the effect
//VvVvV This whole function has been added by Rabidness VvVvV
void delayDispell( object oTarget )
{
    effect eAOE;
    if(GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            //If the effect was created by the AOE then remove it
            if(GetEffectSpellId(eAOE) == SPELL_MAGIC_CIRCLE_AGAINST_EVIL)
            {
                RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    DeleteLocalObject( oTarget , "oProtEvilSource" );
}

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


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD);
    effect eVis2 = EffectVisualEffect(VFX_IMP_GOOD_HELP);

    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_EVIL, FALSE));

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, HoursToSeconds(nDuration));

    //VvVvV Rabidness additions VvVvV
    SetLocalObject( oTarget , "oProtEvilSource" , oTarget );
    DelayCommand( HoursToSeconds(nDuration) , delayDispell( oTarget ) );
}

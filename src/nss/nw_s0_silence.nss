//::///////////////////////////////////////////////
//:: Silence
//:: NW_S0_Silence.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
    Modified by : Rabidness
             on : August 05 , 2004
    Changes:
        - It's an area of silence, so you should auto succeed move silently checks.
            +50 to Move Silently
        - Fixed an issue where the AOE would dispell if the center left the AOE
            ...when the AOE was supposed to be centered ON the center.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "nw_i0_spells"

#include "x2_inc_spellhook"

//Function called to remove the AOE effect when it is dead, since the normal
//AOE onExit script is disabled against the creator of the effect
//VvVvV This whole function has been added by Rabidness VvVvV
void delayDispell( object oTarget )
{
    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        //If the effect was created by the AOE then remove it
        if(GetEffectSpellId(eAOE) == SPELL_SILENCE)
        {
            RemoveEffect(oTarget, eAOE);
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
    DeleteLocalInt( oTarget , "nSilenceSource" );
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
    effect eAOE    = EffectAreaOfEffect(AOE_MOB_SILENCE);
    int nDuration  = GetCasterLevel(OBJECT_SELF);
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();

    /*  The spell is supposed to be castable on others. - Ness
    if (oTarget != OBJECT_SELF)
    {
        SendMessageToPC(OBJECT_SELF,"You may not target others with this spell");
        return;
    }*/

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

    if(!GetIsFriend(oTarget))
    {
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE));

                //Create an instance of the AOE Object using the Apply Effect function
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, RoundsToSeconds(nDuration));
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE, FALSE));
        //Create an instance of the AOE Object using the Apply Effect function
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, RoundsToSeconds(nDuration));
    }

        //VvVvV Rabidness additions VvVvV
    SetLocalInt(oTarget, "nSilenceSource", 1);
    DelayCommand(RoundsToSeconds(nDuration), delayDispell(oTarget));
}

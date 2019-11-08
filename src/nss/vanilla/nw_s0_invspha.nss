//::///////////////////////////////////////////////
//:: Invisibility Sphere: On Enter
//:: NW_S0_InvSphA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.

    Modified On: June 20, 2004
        - If the target already has the effect, then do not give them another.
            This is to prevent incorrect loss of effects.
            An example: Mage A and Mage B, both have this AoE on them.
                Mage B enters Mage A's AoE, so normally it would give him Mage A's
                AoE effects, even if Mage B already had said effects.
                This is fine, but when Mage B leaves Mage A's AoE, the effects
                will be dispelled and will be kept off untill their AoE refreshes...
                when clearly Mage B has his own AoE of the same type.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
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
    object oTarget = GetEnteringObject();

    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);

    effect eLink = EffectLinkEffects(eInvis, eVis);

    effect eAOE;

    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
        //VvVvV Rabidness addition, this if block VvVvV
        //IF they are the creator of an identical effect do not give it to them,
        //this is to prevent overlapping in effects and incorrect loss of them.
        //Let the creator of THIS spell/AoE get the effect.
        if( GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oTarget)
            && ( GetLocalObject( oTarget , "oInvisSphereSource" ) != oTarget ) )
        {
            eAOE = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eAOE))
            {
                //If the effect is invisibility and was created by the Invisibility Sphere
                if( GetEffectSpellId(eAOE) == SPELL_INVISIBILITY_SPHERE )
                {
                    //if the EffectCreator is the Target AND it isn't this
                    if ( GetEffectCreator(eAOE) == oTarget )
                        return;
                }
                //Get next effect on the target
                eAOE = GetNextEffect(oTarget);
            }
        }

        // * don't try and make dead people invisible
        if (GetIsDead(oTarget) == FALSE)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY_SPHERE, FALSE));
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }
    }
}

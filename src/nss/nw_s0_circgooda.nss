//::///////////////////////////////////////////////
//:: Magic Cirle Against Good
//:: NW_S0_CircGoodA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from good effects to
    entering allies.

    Modified By: Rabidness
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
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetEnteringObject();
    effect eAOE;

    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
        //VvVvV Rabidness addition, this if block VvVvV
        //IF they are the creator of an identical effect do not give it to them,
        //this is to prevent overlapping in effects and incorrect loss of them.
        //Let the creator of THIS spell/AoE get the effect.
        if( GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, oTarget)
            && ( GetLocalObject( oTarget , "oProtGoodSource" ) != oTarget ) )
        {
            eAOE = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eAOE))
            {
                //if they already have effects from the AoE
                if( GetEffectSpellId(eAOE) == SPELL_MAGIC_CIRCLE_AGAINST_GOOD )
                {
                    //if the EffectCreator is the Target AND it isn't this
                    if ( GetEffectCreator(eAOE) == oTarget )
                        return;
                }

                //Get next effect on the target
                eAOE = GetNextEffect(oTarget);
            }
        }

        //Declare major variables
        int nDuration = GetCasterLevel(OBJECT_SELF);
        //effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
        effect eLink = CreateProtectionFromAlignmentLink(ALIGNMENT_GOOD);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, FALSE));

        //Apply the VFX impact and effects
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
     }
}

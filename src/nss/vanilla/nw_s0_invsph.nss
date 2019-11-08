//::///////////////////////////////////////////////
//:: Invisibility Sphere
//:: NW_S0_InvSph.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
    Modified by : Rabidness
             on : June 20 , 2004
    Changes:
        - Fixed an issue where the AOE would dispell if the CASTER left the AOE
            ...when the AOE was supposed to be centered ON the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

//Function called to remove the AOE effect when it is dead, since the normal
//AOE onExit script is disabled against the creator of the effect
//VvVvV This whole function has been added by Rabidness VvVvV
void delayDispell( object oTarget )
{
    effect eAOE;
    if(GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            //If the effect was created by the AOE then remove it
            if(GetEffectSpellId(eAOE) == SPELL_INVISIBILITY_SPHERE)
            {
                RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    DeleteLocalObject( oTarget , "oInvisSphereSource" );
}

void main()
{
    if (!X2PreSpellCastCode()) return;

    object oTarget = OBJECT_SELF;
    effect eAOE;
    int nDuration = GetCasterLevel(oTarget);
    int nMetaMagic = GetMetaMagicFeat();
    if (nDuration < 1) nDuration = 1;
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;

    if (!GetIsPC(oTarget))
    {
        string sTag = GetTag(oTarget);
        if (sTag == "NEKROS_SHADOW")
        {
            eAOE = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
            eAOE = EffectLinkEffects(eAOE, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
            int nCnt = 1;
            object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oTarget, nCnt);
            while (GetIsObjectValid(oCreature))
            {
                if (GetDistanceBetween(oCreature, oTarget) > 10.0) break;
                AssignCommand(oCreature, ClearAllActions());
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oCreature, 3.0);
                nCnt++;
                oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oTarget, nCnt);
            }
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY), GetLocation(oTarget));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, TurnsToSeconds(nDuration));
            return;
        }
    }

    eAOE = EffectAreaOfEffect(AOE_PER_INVIS_SPHERE);
    SetLocalObject( oTarget , "oInvisSphereSource" , oTarget );
    DelayCommand( TurnsToSeconds(nDuration) , delayDispell( oTarget ) );

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, TurnsToSeconds(nDuration));

}

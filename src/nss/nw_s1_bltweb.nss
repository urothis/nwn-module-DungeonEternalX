//::///////////////////////////////////////////////
//:: Bolt: Web
//:: NW_S1_BltWeb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Glues a single target to the ground with
    sticky strands of webbing.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 28, 2002
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_switches"
void main()
{
    object oTarget = GetSpellTargetObject();
    if (GetIsReactionTypeHostile(oTarget) == FALSE) return;
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_DUR_WEB);
    effect eStick = EffectEntangle();

    int nCount = (nHD + 1) / 2;
    if (nCount < 1) nCount = 1;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_WEB));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
       if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
       {
       //Apply the VFX impact and effects
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1));
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStick, oTarget, RoundsToSeconds(nCount));
       }
    }
    RemoveSpellEffects(SPELLABILITY_BOLT_WEB, OBJECT_SELF, oTarget);
}

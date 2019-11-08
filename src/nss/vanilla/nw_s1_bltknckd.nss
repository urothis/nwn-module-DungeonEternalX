//::///////////////////////////////////////////////
//:: Bolt: Knockdown
//:: NW_S1_BltKnckD
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.  Reflex or Will save is
    needed to halve damage or avoid effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11 , 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////

#include "nw_i0_spells"
void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    if (GetIsReactionTypeHostile(oTarget) == FALSE) return;
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eBolt = EffectKnockdown();
    int nCasterRoll = d20();
    int nDC = 15;
    int nTargetRoll = d20();
    int nStr = GetAbilityScore(oTarget, ABILITY_STRENGTH);
    effect eDam = EffectDamage(d6(), DAMAGE_TYPE_BLUDGEONING);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_KNOCKDOWN));
    //Make a saving throw check
    if (TouchAttackRanged(oTarget))
    {
       if ((nTargetRoll + nStr) > (nCasterRoll + nDC) && nTargetRoll != 1 && nTargetRoll == 20)
       {}
       else if ((nTargetRoll + nStr) < (nCasterRoll + nDC) && nTargetRoll == 1 && nTargetRoll != 20)
       {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, RoundsToSeconds(3));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
       }
    }
}

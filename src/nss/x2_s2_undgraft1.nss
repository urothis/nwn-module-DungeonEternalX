//::///////////////////////////////////////////////
//:: Undead Graft
//:: X2_S2_UndGraft1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Pale Master may use their undead arm to paralyze
    foes for 1d6+2 rounds on a successful melee touch attack

    Save is 14 + pale master level/2


    Elves immune to this effect
    TaB pg 66;
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated On: 2003-07-24, Georg Zoeller (added elf immunity, touch attack check, fixed duration)
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "_functions"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();

    int nCasterLvl = GetLevelByClass(CLASS_TYPE_PALEMASTER);

    int nRounds = nCasterLvl/5 + 2;
    int nDC = 5 + nCasterLvl + GetMax(GetAbilityModifier(ABILITY_CHARISMA), GetAbilityModifier(ABILITY_INTELLIGENCE));
    if (GetHasSpellSchool(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY)) nDC += 5;

    //Declare effects
    effect ePara = EffectParalyze();
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eDur2 = EffectVisualEffect(VFX_DUR_ICESKIN);
    effect eDur3 = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    effect eDur = EffectLinkEffects(eDur2, eDur3);

    //Link effects
    effect eLink = EffectLinkEffects(ePara, eDur);
    if (TouchAttackMelee(oTarget,TRUE)>0)
    {
        //GZ: whimpy elves are not effected by this spell, aarrg
        if (GetRacialType(oTarget) !=  RACIAL_TYPE_ELF)
        {
            //Signal spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Saving Throw
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
            {
                //Apply effects to target and caster
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nRounds));
            }
        }
        else
        {
            FloatingTextStrRefOnCreature(85591,oTarget,FALSE);
            FloatingTextStrRefOnCreature(85591,OBJECT_SELF,FALSE);
        }
    } else
    {
         // * GZ: According to TaB missed attacks are not wasted.
         int nId = GetSpellId();

         if (nId == 625)
         {
             IncrementRemainingFeatUses(OBJECT_SELF,892);
         }
            else if (nId == 626   )
         {
             IncrementRemainingFeatUses(OBJECT_SELF,893);
         }
    }
}

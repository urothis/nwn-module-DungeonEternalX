//::///////////////////////////////////////////////
//:: War Cry
//:: NW_S0_WarCry
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The bard lets out a terrible shout that gives
    him a +2 bonus to attack and damage and causes
    fear in all enemies that hear the cry
*/
//:: DeX Change lvl/8 + 1 AB
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////

#include "X2_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode()) return;

    //Declare major variables
    object oTarget;
    int nLevel = GetCasterLevel(OBJECT_SELF);
    effect eAttack = EffectAttackIncrease((nLevel/8)+1);
    effect eDamage = EffectDamageIncrease((nLevel/8)+1, DAMAGE_TYPE_SLASHING);
    effect eFear = EffectFrightened();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    effect eVisFear = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eLOS;
    int nDC = GetSpellSaveDC();
    if (HasVaasa(OBJECT_SELF)) nDC += 8;

    if(GetGender(OBJECT_SELF) == GENDER_FEMALE)
    {
        eLOS = EffectVisualEffect(290);
    }
    else
    {
        eLOS = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
    }

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    effect eLink2 = EffectLinkEffects(eVisFear, eFear);

    //Meta Magic
    if(GetMetaMagicFeat() == METAMAGIC_EXTEND)
    {
       nLevel *= 2;
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLOS, OBJECT_SELF);
    //Determine enemies in the radius around the bard
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY));
            //Make SR and Will saves
            if(!MyResistSpell(OBJECT_SELF, oTarget)  && !MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
            {
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(4)));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    //Apply bonus and VFX effects to bard.

    if (!GetHasFeat(FEAT_MONK_ENDURANCE))
    {
        eLink = ExtraordinaryEffect(eLink);
    }

    RemoveSpellEffects(GetSpellId(),OBJECT_SELF,OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nLevel)));
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY, FALSE));
}

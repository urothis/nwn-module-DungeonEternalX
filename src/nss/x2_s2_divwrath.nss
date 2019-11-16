//::///////////////////////////////////////////////
//:: Divine Wrath
//:: x2_s2_DivWrath
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Divine Champion is able to channel a portion
    of their gods power once per day giving them a +3
    bonus on attack rolls, damage, and saving throws
    for a number of rounds equal to their Charisma
    bonus. They also gain damage reduction of +1/5.
    At 10th level, an additional +2 is granted to
    attack rolls and saving throws.

    Epic Progression
    Every five levels past 10 an additional +2
    on attack rolls, damage and saving throws is added. As well the damage
    reduction increases by 5 and the damage power required to penetrate
    damage reduction raises by +1 (to a maximum of /+5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated On: Jul 21, 2003 Georg Zoeller -
//                            Epic Level progession
//:://////////////////////////////////////////////

#include "nw_i0_spells"

void main()
{
    //Declare major variables
    object oTarget = OBJECT_SELF;
    int nDuration = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    //Check that if nDuration is not above 0, make it 1.
    if(nDuration <= 0)
    {
        FloatingTextStrRefOnCreature(100967,OBJECT_SELF);
        return;
    }

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    eVis = EffectLinkEffects(EffectVisualEffect(VFX_FNF_LOS_HOLY_30),eVis);
    effect eAttack, eDamage, eSaving, eReduction, eAc, eDmgVulnB, eDmgVulnP, eDmgVulnS, eDmgVulnE;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 621, FALSE));

    int nAttackB = 3;
    int nDamageB = DAMAGE_BONUS_3;
    int nSaveB = 3 ;
    int nDmgRedB = 5;
    int nDmgRedP = DAMAGE_POWER_PLUS_ONE;
    int nAcPen = 1;   // Cory - Ac reduction penalty

    // --------------- Epic Progression ---------------------------

    int nLevel = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,oTarget) ;
    int nLevelB = (nLevel / 5)-1;
    if (nLevelB <=0)
    {
        nLevelB =0;
    }
    else
    {
        nAttackB += (nLevelB*2); // +2 to attack every 5 levels past 5
        nSaveB += (nLevelB*2); // +2 to saves every 5 levels past 5
        nAcPen += (nLevelB); // Cory - -1 ac every 5 levels past 5
    }

    if (nLevelB >6 )
    {
        nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
        nDmgRedB = 7*5;
        nDamageB = DAMAGE_BONUS_17;
    }
    else if (nLevelB >5 )
    {
        nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
        nDmgRedB = 6*5;
        nDamageB = DAMAGE_BONUS_15;
    }
    else if (nLevelB >4 )
    {
        nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
        nDmgRedB = 5*5;
        nDamageB = DAMAGE_BONUS_13;
    }
    else if (nLevelB >3)
    {
        nDmgRedP = DAMAGE_POWER_PLUS_FOUR;
        nDmgRedB = 4*5;
        nDamageB = DAMAGE_BONUS_11;
    }
    else if (nLevelB >2)
    {
        nDmgRedP = DAMAGE_POWER_PLUS_THREE;
        nDmgRedB = 3*5;
        nDamageB = DAMAGE_BONUS_9;
    }
    else if (nLevelB >1)
    {
        nDmgRedP = DAMAGE_POWER_PLUS_TWO;
        nDmgRedB = 2*5;
        nDamageB = DAMAGE_BONUS_7;
    }
    else if (nLevelB >0)
    {
        nDamageB = 15;    // Cory - Not sure why, but setting to 15 actually fixes this
        //nDamageB = DAMAGE_BONUS_5;
    }
    //--------------------------------------------------------------
    //
    //--------------------------------------------------------------

    // Cory - Disabled stacking with blade thirst
    if (GetHasSpellEffect(SPELL_BLADE_THIRST, OBJECT_SELF))
    {
        FloatingTextStringOnCreature("This Spell does not stack with Blade Thirst", OBJECT_SELF);
        return;
    }
    // Cory - Reduced power with divine favor
    if (GetHasSpellEffect(SPELL_DIVINE_FAVOR, OBJECT_SELF))
    {
        FloatingTextStringOnCreature("This Spell does not stack with Divine Favor", OBJECT_SELF);
        return;
    }
    eAttack = EffectAttackIncrease(nAttackB,ATTACK_BONUS_MISC);

    // Cory - Add bonus damage (class focus on offense over defense)
    nDamageB += 5;
    eDamage = EffectDamageIncrease(nDamageB, DAMAGE_TYPE_DIVINE);

    // Cory - Ac penalty effect
    eAc = EffectACDecrease(nAcPen);

    // Cory - Removed save increase
    //eSaving = EffectSavingThrowIncrease(SAVING_THROW_ALL,nSaveB, SAVING_THROW_TYPE_ALL);

    // Cory - Add will penalty (equal to half of old save bonus from wrath)
    nSaveB = nSaveB/2;
    eSaving = EffectSavingThrowDecrease(SAVING_THROW_WILL,nSaveB, SAVING_THROW_TYPE_ALL);

    eReduction = EffectDamageReduction(nDmgRedB, nDmgRedP);

    // Cory - Elemental weaknesses added (amount equal to CoT level)
    eDmgVulnB = EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, nLevel/2);
    eDmgVulnS = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, nLevel/2);
    eDmgVulnP = EffectDamageImmunityDecrease(DAMAGE_TYPE_ACID, nLevel/2);
    eDmgVulnE = EffectDamageImmunityDecrease(DAMAGE_TYPE_ELECTRICAL, nLevel/2);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eSaving,eLink);
    eLink = EffectLinkEffects(eReduction,eLink);
    eLink = EffectLinkEffects(eAc, eLink);
    eLink = EffectLinkEffects(eDmgVulnB, eLink);
    eLink = EffectLinkEffects(eDmgVulnS, eLink);
    eLink = EffectLinkEffects(eDmgVulnP, eLink);
    eLink = EffectLinkEffects(eDmgVulnE, eLink);
    eLink = SupernaturalEffect(eLink);

    // Three uses
    if (GetLocalInt(oTarget, "wrath_uses")<3)
    {
        // prevent stacking with self
        RemoveEffectsFromSpell(oTarget, GetSpellId());

        // Cory - Increase duration by 60 seconds
        nDuration += 5;

        //Apply the armor bonuses and the VFX impact
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

        // Spell should have three uses per rest, increase use count
        SetLocalInt(oTarget, "wrath_uses", GetLocalInt(oTarget, "wrath_uses")+1);

        // Increment uses if less the three wraths used
        if (GetLocalInt(oTarget, "wrath_uses")<3)
        {
            IncrementRemainingFeatUses(oTarget, FEAT_DIVINE_WRATH);
        }
    }
    else // Player has used the ability 3 times already
    {
        FloatingTextStringOnCreature("No uses remaining.", oTarget, TRUE);
    }



}

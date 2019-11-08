//::///////////////////////////////////////////////
//:: Associate: On Spawn In
//:: NW_CH_AC9
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////

#include "x2_i0_spells"

int BuffDruidSummonItem(object oSum, int nSlot, int nSkill, int nDamBonus)
{
    object oItem = GetItemInSlot(nSlot, oSum); // ENCHANT THE CLAWS
    object oMaster = GetMaster(oSum);
    if (oItem!=OBJECT_INVALID)
    {
        IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(nSkill));
        if (nDamBonus) IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, nDamBonus));
        return TRUE;
    }
    return FALSE;
}

void BoostDruidSummon(object oSum)
{
    int nBuffSummon;   int nDamBonus;

    object oMaster = GetMaster(oSum);
    int nSkill = GetLevelByClass(CLASS_TYPE_DRUID, oMaster) / 8;
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oMaster)) nSkill += 1;
    if (GetHasFeat(FEAT_SKILL_FOCUS_ANIMAL_EMPATHY, oMaster)) nSkill += 1;
    if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY, oMaster)) nSkill += 1;

    if (nSkill == 1)        nDamBonus = DAMAGE_BONUS_1d4;
    else if (nSkill == 2)   nDamBonus = DAMAGE_BONUS_1d6;
    else if (nSkill == 3)   nDamBonus = DAMAGE_BONUS_1d8;
    else if (nSkill == 4)   nDamBonus = DAMAGE_BONUS_1d10;
    else if (nSkill == 5)   nDamBonus = DAMAGE_BONUS_2d6;
    else if (nSkill == 6)   nDamBonus = DAMAGE_BONUS_2d8;
    else if (nSkill == 7)   nDamBonus = DAMAGE_BONUS_2d10;
    else if (nSkill >= 8)   nDamBonus = DAMAGE_BONUS_2d12;

    if (BuffDruidSummonItem(oSum, INVENTORY_SLOT_CWEAPON_R, nSkill, nDamBonus)) BuffDruidSummonItem(oSum, INVENTORY_SLOT_CWEAPON_L, nSkill, nDamBonus);
    else if (BuffDruidSummonItem(oSum, INVENTORY_SLOT_RIGHTHAND, nSkill, nDamBonus)) BuffDruidSummonItem(oSum, INVENTORY_SLOT_LEFTHAND, nSkill, nDamBonus);
    if (nSkill > 0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(nSkill), oSum);
}

void BoostAlly(object oSum, string sTag)
{
    if (sTag == "HASHISHS_BGOLEM")
    {
        object oMaster = GetMaster(oSum);
        int nLvl = GetHitDice(oMaster);

        int nDamBonus = DAMAGE_BONUS_2d12;
        if (nLvl <= 15) nDamBonus = DAMAGE_BONUS_1d6;
        else if (nLvl <= 30) nDamBonus = DAMAGE_BONUS_2d6;

        effect eLink = EffectHaste();

        if (nLvl > 20) eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nLvl-20));
        // nothing at lvl 20...
        else if (nLvl < 20) eLink = EffectLinkEffects(eLink, EffectAttackDecrease(20-nLvl));

        eLink = EffectLinkEffects(eLink, EffectACIncrease(nLvl/2));
        eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nDamBonus));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSum);
    }
}

#include "X0_INC_HENAI"

void main()
{


    SetAssociateListenPatterns();//Sets up the special henchmen listening patterns

    bkSetListeningPatterns();      // Goes through and sets up which shouts the NPC will listen to.
    TalentAdvancedBuff(30.0, TRUE);
    string sTag = GetTag(OBJECT_SELF);
    if (GetStringLeft(sTag,4) == "ds_0") // DRUID SUMMON
    {
        DelayCommand(2.0, BoostDruidSummon(OBJECT_SELF));
    }
    else DelayCommand(2.0, BoostAlly(OBJECT_SELF, sTag));

    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
    SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    SetAssociateState(NW_ASC_DISARM_TRAPS);
    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE); //User ranged weapons by default if true.
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);

    // April 2002: Summoned monsters, associates and familiars need to stay
    // further back due to their size.
    int nType = GetAssociateType(OBJECT_SELF);
    switch (nType)
    {
        case ASSOCIATE_TYPE_ANIMALCOMPANION:
        case ASSOCIATE_TYPE_DOMINATED:
        case ASSOCIATE_TYPE_FAMILIAR:
        case ASSOCIATE_TYPE_SUMMONED:
            SetAssociateState(NW_ASC_DISTANCE_4_METERS);
            break;

    }

    // * Feb 2003: Set official campaign henchmen to have no inventory
    SetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY", 10) ;

    //SetAssociateState(NW_ASC_MODE_DEFEND_MASTER);
    SetAssociateStartLocation();
}



#include "flel_crafter_inc"
#include "db_inc"

void RemoveIllegalProperties(object oItem, object oPC)
{
    itemproperty ipLoop = GetFirstItemProperty(oItem);
    int nTotalAbilityBonus = 0;
    int nTotalSkillBonus = 0;
    while (GetIsItemPropertyValid(ipLoop))
    {
        int nProperty = GetItemPropertyType(ipLoop);

        if (nProperty == ITEM_PROPERTY_TRUE_SEEING ||
            nProperty == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE ||
            nProperty == ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS ||
            nProperty == ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL ||
            nProperty == ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL ||
            nProperty == ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL ||
            nProperty == ITEM_PROPERTY_DAMAGE_REDUCTION ||
            nProperty == ITEM_PROPERTY_DAMAGE_RESISTANCE ||
            nProperty == ITEM_PROPERTY_DAMAGE_VULNERABILITY ||
            nProperty == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP ||
            nProperty == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP ||
            nProperty == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT ||
            nProperty == ITEM_PROPERTY_HOLY_AVENGER ||
            nProperty == ITEM_PROPERTY_BONUS_FEAT ||
            nProperty == ITEM_PROPERTY_IMPROVED_EVASION ||
            nProperty == ITEM_PROPERTY_MIND_BLANK ||
            nProperty == ITEM_PROPERTY_FREEDOM_OF_MOVEMENT ||
            nProperty == ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP ||
            nProperty == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE ||
            nProperty == ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP ||
            nProperty == ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT ||
            nProperty == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP ||
            nProperty == ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP ||
            nProperty == ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT ||
            nProperty == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP ||
            nProperty == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP ||
            nProperty == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT ||
            nProperty == ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION ||
            nProperty == ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT ||

            (nProperty == ITEM_PROPERTY_REGENERATION_VAMPIRIC && GetItemPropertyCostTableValue(ipLoop)>MAX_VAMP_REGEN) ||

            (nProperty == ITEM_PROPERTY_MIGHTY && GetItemPropertyCostTableValue(ipLoop)>MAX_MIGHTY) ||

            (nProperty == ITEM_PROPERTY_REGENERATION_VAMPIRIC && GetItemPropertyCostTableValue(ipLoop)>MAX_VAMP_REGEN) ||

            (nProperty == ITEM_PROPERTY_AC_BONUS && GetItemPropertyCostTableValue(ipLoop)>MAX_AC_BONUS) ||

            ( (nProperty == ITEM_PROPERTY_ENHANCEMENT_BONUS || nProperty == ITEM_PROPERTY_ATTACK_BONUS)
                && GetItemPropertyCostTableValue(ipLoop)>MAX_AB_EB_BONUS))
        {
            GiveGoldToCreature(oPC,GetGoldPieceValue(oItem)*2);
            DestroyObject(oItem);
            return;
        }

        if(nProperty=ITEM_PROPERTY_ABILITY_BONUS)
        {
            int nCurrentBonus = GetItemPropertyCostTableValue(ipLoop);
            nTotalAbilityBonus += nCurrentBonus;
            if (nTotalAbilityBonus > MAX_ABILITY_BONUS)
            {
                GiveGoldToCreature(oPC,GetGoldPieceValue(oItem)*2);
                DestroyObject(oItem);
                return;
            }
        }

        if(nProperty=ITEM_PROPERTY_SKILL_BONUS)
        {
            int nCurrentBonus = GetItemPropertyCostTableValue(ipLoop);
            nTotalSkillBonus += nCurrentBonus;
            if (nTotalSkillBonus > MAX_SKILL_BONUS)
            {
                GiveGoldToCreature(oPC,GetGoldPieceValue(oItem)*2);
                DestroyObject(oItem);
                return;
            }
        }
        ipLoop=GetNextItemProperty(oItem);
    }
}

void PlayerCheckupLoop(object oPC)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC) || dbGetPersistentInt(oPC,"STRIPPED_ONCE"))
        return;

    int iSlot=0;
    for(;iSlot < NUM_INVENTORY_SLOTS;iSlot++)
    {
        object oItem = GetItemInSlot(iSlot, oPC);
        if (GetIsObjectValid(oItem))
            RemoveIllegalProperties(oItem,oPC);
    }

    object oItem=GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        RemoveIllegalProperties(oItem, oPC);
        oItem = GetNextItemInInventory(oPC);
    }

    dbSetPersistentInt(oPC,"STRIPPED_ONCE", TRUE);
}

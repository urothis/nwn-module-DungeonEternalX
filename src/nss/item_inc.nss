
itemproperty CreateItemProperty(int iPropType, int iSubType, int iBonus);



itemproperty CreateItemProperty(int iPropType, int iSubType, int iBonus)
{
    switch(iPropType)
    {
        case ITEM_PROPERTY_ABILITY_BONUS:                return ItemPropertyAbilityBonus(iSubType, iBonus);
        case ITEM_PROPERTY_AC_BONUS:                     return ItemPropertyACBonus(iBonus);
        case ITEM_PROPERTY_ATTACK_BONUS:                 return ItemPropertyAttackBonus(iBonus);
        case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:  return ItemPropertyBonusLevelSpell(iSubType, iBonus);
        case ITEM_PROPERTY_DAMAGE_BONUS:                 return ItemPropertyDamageBonus(iSubType, iBonus);
        case ITEM_PROPERTY_DARKVISION:                   return ItemPropertyDarkvision();
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:            return ItemPropertyEnhancementBonus(iBonus);
        case ITEM_PROPERTY_HASTE:                        return ItemPropertyHaste();
        case ITEM_PROPERTY_KEEN:                         return ItemPropertyKeen();
        case ITEM_PROPERTY_LIGHT:                        return ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, iBonus);
        case ITEM_PROPERTY_MASSIVE_CRITICALS:            return ItemPropertyMassiveCritical(iBonus);
        case ITEM_PROPERTY_MIGHTY:                       return ItemPropertyMaxRangeStrengthMod(iBonus);
        case ITEM_PROPERTY_ON_HIT_PROPERTIES:            return ItemPropertyOnHitProps(iSubType, iBonus, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS);
        case ITEM_PROPERTY_REGENERATION:                 return ItemPropertyRegeneration(iBonus);
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:        return ItemPropertyVampiricRegeneration(iBonus);
        case ITEM_PROPERTY_SAVING_THROW_BONUS:           return ItemPropertyBonusSavingThrowVsX(iSubType, iBonus);
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:  return ItemPropertyBonusSavingThrow(iSubType, iBonus);
        case ITEM_PROPERTY_SKILL_BONUS:                  return ItemPropertySkillBonus(iSubType, iBonus);
        case ITEM_PROPERTY_VISUALEFFECT:                 return ItemPropertyVisualEffect(iBonus);
    }
    return ItemPropertyAttackPenalty(iBonus);
}

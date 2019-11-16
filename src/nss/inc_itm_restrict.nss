#include "x2_inc_itemprop"

void CheckSpecialItemRestrictions(object oPC, object oItem) {

    // Ignore this if the player is a DM
    if (GetIsDM(oPC) == TRUE) return;

    // vorpal
    if (IPGetItemHasItemOnHitPropertySubType(oItem, 24)) {
        int nFighterTypeLevels =
            GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) +
            GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) +
            GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oPC) +
            GetLevelByClass(CLASS_TYPE_FIGHTER, oPC) +
            GetLevelByClass(CLASS_TYPE_PALADIN, oPC) +
            GetLevelByClass(CLASS_TYPE_RANGER, oPC) +
            GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC);

        // check for 40 levels in the above classes
        if (nFighterTypeLevels < 40) {
            FloatingTextStringOnCreature("Only a level 40 pure warrior may wield this weapon.", oPC);
            DelayCommand(0.5, AssignCommand(oPC, ActionUnequipItem(oItem)));
            DelayCommand(1.0, AssignCommand(oPC, ActionUnequipItem(oItem)));
            DelayCommand(1.5, AssignCommand(oPC, ActionUnequipItem(oItem)));
        }
        else {
            FloatingTextStringOnCreature("Being a level 40 pure warrior allows you to wield this magical weapon.", oPC);
        }
    }
}

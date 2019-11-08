//::///////////////////////////////////////////////
//:: Associate: On Spawn In
//:: NW_CH_AC9
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

This must support the OC henchmen and all summoned/companion
creatures.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////
//:: Updated By: Georg Zoeller, 2003-08-20: Added variable check for spawn in animation


#include "X0_INC_HENAI"
#include "x2_inc_switches"

void BoostElemental() {
   string sTag = GetStringLeft(GetTag(OBJECT_SELF),6);
   int nDamageType = 0;
   int nShieldType = 0;
   int nShieldAmt = GetHitDice(OBJECT_SELF)/5;
   if (sTag=="SU_AIR") {
      nDamageType = IP_CONST_DAMAGETYPE_SONIC;
      nShieldType = DAMAGE_TYPE_SONIC;
   } else if (sTag=="SU_EAR") {
      nDamageType = IP_CONST_DAMAGETYPE_ACID;
      nShieldType = DAMAGE_TYPE_ACID;
   } else if (sTag=="SU_WAT") {
      nDamageType = IP_CONST_DAMAGETYPE_POSITIVE;
      nShieldType = DAMAGE_TYPE_POSITIVE;
   } else if (sTag=="SU_FIR") {
      nDamageType = IP_CONST_DAMAGETYPE_FIRE;
      nShieldType = DAMAGE_TYPE_FIRE;
   } else {
      return; // WHAT WAS THAT THING?
   }
   int nDamageAmt = 16+(GetHitDice(OBJECT_SELF)-20)/3; // 16= + 6 DAMAGE, 23=13 DAMAGE
   object oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, OBJECT_SELF);
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(5), oItem);
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(nDamageType, nDamageAmt), oItem);
   oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, OBJECT_SELF);
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(5), oItem);
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(nDamageType, nDamageAmt), oItem);
   effect eShield = EffectDamageShield(nShieldAmt, DAMAGE_BONUS_1d4, nShieldType);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShield, OBJECT_SELF);
}

void main() {
   BoostElemental();
     //Sets up the special henchmen listening patterns
    SetAssociateListenPatterns();

    // Set additional henchman listening patterns
    bkSetListeningPatterns();

    // Default behavior for henchmen at start
    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
    SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    SetAssociateState(NW_ASC_DISARM_TRAPS);
    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);

    //Use melee weapons by default
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);

    // Distance: make henchmen stick closer
    SetAssociateState(NW_ASC_DISTANCE_4_METERS);
    if (GetAssociate(ASSOCIATE_TYPE_HENCHMAN, GetMaster()) == OBJECT_SELF) {
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);
    }

    // * If Incorporeal, apply changes
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) == TRUE)
    {
        effect eConceal = EffectConcealment(50, MISS_CHANCE_TYPE_NORMAL);
        eConceal = ExtraordinaryEffect(eConceal);
        effect eGhost = EffectCutsceneGhost();
        eGhost = ExtraordinaryEffect(eGhost);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConceal, OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, OBJECT_SELF);
    }


    // Set starting location
    SetAssociateStartLocation();
}



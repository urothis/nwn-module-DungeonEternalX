#include "seed_random_magi"

void SRM_LevelWeapon(object oPC, object oItem) {
   int nLvl = GetHitDice(oPC);
   int nDamageType = IP_CONST_DAMAGETYPE_ACID;
   int nDamageBonus = 0;
   int nToHit = 0;
   int nNewDamageType = IP_CONST_DAMAGETYPE_ACID;
   int nNewDamageBonus = IP_CONST_DAMAGEBONUS_1d4;
   int nNewToHit = 0;
   int nFirstTime = 1;
   itemproperty ipLoop=GetFirstItemProperty(oItem);
   while (GetIsItemPropertyValid(ipLoop)) {
      if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_DAMAGE_BONUS) {
         nDamageType = GetItemPropertySubType(ipLoop);
         nDamageBonus = GetItemPropertyCostTableValue(ipLoop);
         RemoveItemProperty(oItem, ipLoop);
         nFirstTime = 0;
      }
      if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_ATTACK_BONUS) {
         nToHit = GetItemPropertyCostTableValue(ipLoop);
         RemoveItemProperty(oItem, ipLoop);
      }
      ipLoop=GetNextItemProperty(oItem);
   }
   nNewDamageType = SMS_RotateDamage(nDamageType);
   int nVisual = SMS_DamageTypeEffect(nNewDamageType);
   string sMsg = DamageTypeString(nNewDamageType);
   if (nLvl < 5)         { // lvl 1-4, USE DEFAULTS ABOVE
   } else if (nLvl < 7)  { // lvl 5-6
      nNewToHit = 1;
   } else if (nLvl < 9)  { // lvl 7-8
      nNewToHit = 1;
      nNewDamageBonus = IP_CONST_DAMAGEBONUS_1d6;
   } else if (nLvl < 11) { // lvl 9-10
      nNewToHit = 1;
      nNewDamageBonus = IP_CONST_DAMAGEBONUS_1d8;
   } else if (nLvl < 13) { // lvl 11-12
      nNewToHit = 2;
      nNewDamageBonus = IP_CONST_DAMAGEBONUS_1d8;
   } else if (nLvl < 15) { // lvl 13-14
      nNewToHit = 3;
      nNewDamageBonus = IP_CONST_DAMAGEBONUS_1d10;
   } else                { // lvl 15+
      nNewToHit = 4;
      nNewDamageBonus = IP_CONST_DAMAGEBONUS_2d6;
   }
   sMsg = sMsg + " " + DamageBonusString(nNewDamageBonus);
   if (nDamageBonus != nNewDamageBonus || nNewToHit != nToHit) { // NEW DAMAGE/ATTACK LEVEL
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oPC);
      sMsg = "Your Weapon has Leveled!";
      nNewDamageType = nDamageType; // REMAIN ON CURRENTLY SET DAMAGE TYPE
      AssignCommand(oPC, ActionUnequipItem(oItem));
   } else {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisual), oPC);
      sMsg = sMsg + " activated!";
      if (nToHit>0) sMsg = "+" + IntToString(nToHit) + " " + sMsg;
   }
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(nNewToHit), oItem);
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(nNewDamageType, nNewDamageBonus), oItem);
   FloatingTextStringOnCreature(sMsg, oPC, TRUE);
   if (nFirstTime) {
      SendMessageToPC(oPC, "You have found a leveling weapon! This weapon will level with your character. As you gain power, this weapon will also. As often as you like, you can use the unique power of the weapon to cycle through it's magical damage properties.\n\n* cycle through acid, cold, electric, fire, negative, positive, and sonic damage.\n\n* weapon gains power at lvls 5, 7, 9, 11, 13, and 15.\n\n* must cycle the damage type to level the weapon.");
   }
}

void main() {
   SRM_LevelWeapon(OBJECT_SELF, GetItemActivated());
}

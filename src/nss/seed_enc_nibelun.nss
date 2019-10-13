#include "seed_enc_inc"

void main() {
   return;
   if (!GetEncounterActive(OBJECT_SELF)) return;
   if (GetLocalInt(OBJECT_SELF, "SpawnOK")!=0) return; // WAITING FOR ENCOUNTER RESET TIMER
   object oMinion;
   object oPC=GetEnteringObject();
   object oLocator;
   object oItem;
   object oTarget;
   itemproperty ipAdd;
   location lSpawn;
   effect eEffect;
   int i;
   int j;
   int k;
   float l;
   string sRef;
   int PartyCnt;
   int nChance;

   string sWhich=GetTag(OBJECT_SELF);
   if (sWhich=="ENC_NIBELUNG_BOSS") {
      if (!OkToSpawn(500, oPC, 38)) return;
      oLocator = GetObjectByTag("WP_NIBELUNG_THRONE");
      oMinion = SpawnBoss("alberich", oLocator);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND);
      SetName(oItem, "Axe of Alberich");
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d8), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_COLD), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen(), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8), oItem);

      CreateItemOnObject("starsapphire", oMinion, 10);
      AssignCommand(oMinion, ActionMoveToObject(oLocator));
      AssignCommand(oMinion, ActionSit(oLocator));
      SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);
      if (d2()==1) CreateItemOnObject("starsapphire", oLocator, 10);
      if (d2()==1) CreateItemOnObject("perfectruby", oLocator, 10);
      SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);
      SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);
      oItem = DropEquippedItem(oMinion, 2, INVENTORY_SLOT_RIGHTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_6, IP_CONST_DAMAGESOAK_10_HP), oItem);
      SetName(oItem, "The Ring of Nibelung");
   }

//   if(GetIsObjectValid(oMinion)) SpeakString(GetName(oMinion) + " has spawned!", TALKVOLUME_SHOUT);
   // FLAG THE ENCOUNTER AS SPAWNED
   SetLocalInt(OBJECT_SELF, "SpawnOK", 1); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER

}

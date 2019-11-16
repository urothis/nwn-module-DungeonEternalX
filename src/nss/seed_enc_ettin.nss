#include "seed_enc_inc"

void main() {
   if (!GetEncounterActive(OBJECT_SELF)) return;
   if (GetLocalInt(OBJECT_SELF, "SpawnOK")!=0) return; // WAITING FOR ENCOUNTER RESET TIMER
   object oMinion;
   object oPC=GetEnteringObject();
   object oLocator;
   object oItem;
   object oObject;
   itemproperty ipAdd;
   location lSpawn;
   effect eEffect;
   int i;
   int j;
   int k;
   float l;
   string sRef;
   int PartyCnt;

   string sWhich=GetTag(OBJECT_SELF);
   if (sWhich=="EH_BOSS_ENC") {
      if (!OkToSpawn(10, oPC, 28)) return;
      oLocator = GetObjectByTag("EH_BOSS_WP");
      oMinion = SpawnBoss("foureyes", oLocator);
      oLocator = GetObjectByTag("EH_THRONE");
      AssignCommand(oMinion, ActionMoveToObject(oLocator));
      AssignCommand(oMinion, ActionSit(oLocator));
      SRM_RandomTreasure(TREASURE_HIGH, oMinion, oLocator);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oMinion);
      oItem = DropEquippedItem(oMinion, 20, INVENTORY_SLOT_RIGHTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_2d8), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(PickOneInt(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGETYPE_DIVINE), IP_CONST_DAMAGEBONUS_2d8), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), oItem);
      oItem = DropEquippedItem(oMinion, 20, INVENTORY_SLOT_LEFTHAND);
      for (i=0; i<3; i++) {
         oLocator = GetObjectByTag("EH_CHEST",i);
         SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      }
      oMinion = MakeCreature("charcoal",oLocator);
      SRM_RandomTreasure(TREASURE_HIGH, oMinion, oMinion);
      oMinion = MakeCreature("charcoal",oLocator);
      SRM_RandomTreasure(TREASURE_HIGH, oMinion, oMinion);
      SetName(oMinion, "Propane");

   }
   else if (sWhich=="EL_CHEST_ENC") {
      if (!OkToSpawn(3, oPC, 28)) return;
      oMinion = MakeCreature("ettin003",oLocator);
      oItem = DropEquippedItem(oMinion, 50, INVENTORY_SLOT_LEFTHAND);
      for (i=0; i<2; i++) {
         oLocator = GetObjectByTag("EL_CHEST",i);
         SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);
         SRM_CreateGem(oLocator, TREASURE_LOW, 20);
      }
   }

//   if(GetIsObjectValid(oMinion)) SpeakString(GetName(oMinion) + " has spawned!", TALKVOLUME_SHOUT);
   // FLAG THE ENCOUNTER AS SPAWNED
   SetLocalInt(OBJECT_SELF, "SpawnOK", 1); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER

}

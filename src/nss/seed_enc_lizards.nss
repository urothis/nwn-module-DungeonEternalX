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
   if (sWhich=="LJ_BOSS_ENC") {
      if (!OkToSpawn(6, oPC, 12)) return;
      for (i=0; i<3; i++) {
         oLocator = GetObjectByTag("LJ_ALTAR_WP",i);
         oMinion = MakeCreature(PickOne("sauriaseer","sauriaseer001"), oLocator);
         HideWeapons(oMinion);
         AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0f, 600.0f));
         SRM_RandomTreasure(TREASURE_LOW, oMinion, oMinion);
      }
      oLocator = GetObjectByTag("LJ_ALTAR");
      SRM_CreateGem(oLocator, TREASURE_LOW, 15);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
   }
   else if (sWhich=="ENC_WITHFISH") {
      if (!OkToSpawn(1, oPC, 6)) return;
      oLocator = GetObjectByTag("ENC_WITHFISH_WP");
      oMinion = MakeCreature("sauriafisherman", oLocator);
      CreateItemOnObject("nw_it_msmlmisc20", oMinion);
      SRM_CreatePotion(oMinion, 3);
      AssignCommand(oMinion, ActionAttack(oPC));
   }
   else if (sWhich=="ST_SEATS_ENC") {
      if (!OkToSpawn(6, oPC, 15)) return;
      for (i=0; i<3; i++) {
         oLocator = GetObjectByTag("ST_CHAIR",i);
         oMinion = MakeCreature("sauriaseer002", oLocator);
         HideWeapons(oMinion);
         AssignCommand(oMinion, ActionMoveToObject(oLocator));
         AssignCommand(oMinion, ActionSit(oLocator));
         SRM_RandomTreasure(TREASURE_LOW, oMinion, oMinion);
         SRM_CreateGem(oLocator, TREASURE_LOW, 10);
      }
   }
   else if (sWhich=="ST_BOSS_ENC") {
      return;
      if (!OkToSpawn(6, oPC, 12)) return;
      oLocator = GetObjectByTag("ST_THRONE");
      oMinion = SpawnBoss("lizardking", oLocator);
      SRM_RandomTreasure(TREASURE_HIGH, oMinion, oLocator);

      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(PickOneInt(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGETYPE_DIVINE), IP_CONST_DAMAGEBONUS_1d6), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(PickOneInt(ITEM_VISUAL_COLD, ITEM_VISUAL_HOLY)), oItem);
      SRM_RandomTreasure(TREASURE_HIGH, oMinion, oMinion);

      AssignCommand(oMinion, ActionMoveToObject(oLocator));
      AssignCommand(oMinion, ActionSit(oLocator));
      for (i=0; i<4; i++) {
         oLocator = GetObjectByTag("ST_CHEST",i);
         SRM_CreateGem(oLocator, TREASURE_LOW, 10);
     }
   }
   else if (sWhich=="SAHUAGIN_BOSS_ENC") {
      if (!OkToSpawn(6, oPC, 16)) return;
      oLocator = GetObjectByTag("SUV_THRONE");
      oMinion = SpawnBoss("sahuaginboss", oLocator);
      SRM_RandomTreasure(TREASURE_HIGH, oMinion, oLocator);
      SRM_RandomTreasure(TREASURE_HIGH, oMinion, oMinion);
      oItem = DropEquippedItem(oMinion, 70, INVENTORY_SLOT_RIGHTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(3), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(PickOneInt(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGETYPE_MAGICAL), IP_CONST_DAMAGEBONUS_1d6), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(PickOneInt(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGETYPE_PIERCING), IP_CONST_DAMAGEBONUS_1d6), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(PickOneInt(ITEM_VISUAL_EVIL, ITEM_VISUAL_ACID)), oItem);
      AssignCommand(oMinion, ActionMoveToObject(oLocator));
      AssignCommand(oMinion, ActionSit(oLocator));
      for (i=0; i<4; i++) {
         oLocator = GetObjectByTag("SUV_CHEST",i);
         SRM_CreateGem(oLocator, TREASURE_LOW, 20);
         SRM_RandomTreasure(TREASURE_LOW, oMinion, oMinion);
     }
   }
   else if (sWhich=="TROGDEN_BOSS_ENC")
   {
      if (!OkToSpawn(6, oPC, 14)) return;
      oLocator = GetObjectByTag("TROGDEN_THRONE");
      oMinion = SpawnBoss("swamptrogboss", oLocator);
      SRM_RandomTreasure(TREASURE_HIGH, oMinion, oLocator);
      SRM_RandomTreasure(TREASURE_HIGH, oMinion, oMinion);
      oItem = DropEquippedItem(oMinion, 70, INVENTORY_SLOT_RIGHTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(2), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(PickOneInt(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGETYPE_POSITIVE), IP_CONST_DAMAGEBONUS_1d6), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(PickOneInt(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGETYPE_POSITIVE)), oItem);
      AssignCommand(oMinion, ActionMoveToObject(oLocator));
      AssignCommand(oMinion, ActionSit(oLocator));
      for (i=0; i<3; i++)
      {
         oLocator = GetObjectByTag("TROGDEN_CHEST",i);
         SRM_CreateGem(oLocator, TREASURE_LOW, 20);
         SRM_RandomTreasure(TREASURE_LOW, oMinion, oMinion);
     }
   }

//   if(GetIsObjectValid(oMinion)) SpeakString(GetName(oMinion) + " has spawned!", TALKVOLUME_SHOUT);
   // FLAG THE ENCOUNTER AS SPAWNED
   SetLocalInt(OBJECT_SELF, "SpawnOK", 1); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER

}

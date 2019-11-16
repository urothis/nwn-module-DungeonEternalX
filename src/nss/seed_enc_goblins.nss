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
   if (sWhich=="GC_BOSS_ENC") {
      if (!OkToSpawn(6, oPC, 8)) return;
      oLocator = GetObjectByTag("GC_CHAIR");
      oMinion = SpawnBoss(PickOne("goblinshaman003","goblinbarb001"), oLocator);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      AssignCommand(oMinion, ActionMoveToObject(oLocator));
      AssignCommand(oMinion, ActionSit(oLocator));
   }
   else if (sWhich=="GC_CHEST_ENC") {
      if (!OkToSpawn(6, oPC, 8)) return;
      oLocator = GetObjectByTag("GC_CHEST");
      SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);
   }
   else if (sWhich=="GL_BOSS_ENC") {
      if (!OkToSpawn(6, oPC, 10)) return;
      oLocator = GetObjectByTag("GL_CHEST");
      oMinion = SpawnBoss(PickOne("goblinshaman004","goblinbarb002"), oLocator);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      oLocator = GetObjectByTag("GL_RACK");
      SRM_PickWeapon(oLocator, GetHitDice(oMinion) + Random(3), TREASURE_MEDIUM, PickOne("simple","martial","martial","exotic"));
   }
   else if (sWhich=="GL_TREASURE_ENC") {
      if (!OkToSpawn(6, oPC, 10)) return;
      for (i=0; i<4; i++) {
         oLocator = GetObjectByTag("GL_TREASURE",i);
         SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);
         SRM_CreateGem(oLocator, TREASURE_LOW, 10);
      }
   }
   else if (sWhich=="GD_BOSS_ENC") {
      if (!OkToSpawn(6, oPC, 12)) return;
      oLocator = GetObjectByTag("GD_STOOL");
      oMinion = SpawnBoss("goblinscout006", oLocator);
      AssignCommand(oMinion, ActionMoveToObject(oLocator));
      AssignCommand(oMinion, ActionSit(oLocator));
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      oItem = DropEquippedItem(oMinion, 50, INVENTORY_SLOT_RIGHTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(PickOneInt(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGETYPE_FIRE), IP_CONST_DAMAGEBONUS_1d4), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(PickOneInt(ITEM_VISUAL_ACID, ITEM_VISUAL_EVIL, ITEM_VISUAL_FIRE)), oItem);
      oItem = DropEquippedItem(oMinion, 50, INVENTORY_SLOT_LEFTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(PickOneInt(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGETYPE_DIVINE), IP_CONST_DAMAGEBONUS_1d4), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(PickOneInt(ITEM_VISUAL_COLD, ITEM_VISUAL_SONIC, ITEM_VISUAL_HOLY)), oItem);
      for (i=0; i<3; i++) {
         oLocator = GetObjectByTag("GD_CHEST",i);
         SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      }
      //SRM_CreateLevelingWeapon(oMinion, oPC);
   }
   else if (sWhich=="GD_CHEST_ENC") {
      if (!OkToSpawn(6, oPC, 12)) return;
      for (i=0; i<4; i++) {
         oLocator = GetObjectByTag("GD_STORAGE",i);
         SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);
         SRM_CreateGem(oLocator, TREASURE_LOW, 20);
      }
      SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);
   }

//   if(GetIsObjectValid(oMinion)) SpeakString(GetName(oMinion) + " has spawned!", TALKVOLUME_SHOUT);
   // FLAG THE ENCOUNTER AS SPAWNED
   SetLocalInt(OBJECT_SELF, "SpawnOK", 1); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER

}

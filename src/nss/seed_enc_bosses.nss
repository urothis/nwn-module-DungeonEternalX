#include "seed_enc_inc"
#include "pc_inc"

void main()
{
   if (!GetEncounterActive(OBJECT_SELF)) return;
   if (GetLocalInt(OBJECT_SELF, "SpawnOK") != 0) return; // WAITING FOR ENCOUNTER RESET TIMER
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

   string sWhich=GetTag(OBJECT_SELF);
   if (sWhich=="ENC_BLOODHOOF") {
      return;
      if (!OkToSpawn(1000, oPC, 39)) return;
      oMinion = SpawnBoss("generalotman", OBJECT_SELF);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d10), oItem);
      int nRanDam = PickOneInt(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGETYPE_NEGATIVE);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(nRanDam, IP_CONST_DAMAGEBONUS_2d6) , oItem);
      for (i=0;i<6;i++)
      {
         oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oMinion, i);
         if (oTarget!=OBJECT_INVALID)
         {
            if (FindSubString(GetName(oTarget),"Bloodhoof")!=-1)
            {
               oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
               AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oItem);
               AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(nRanDam, IP_CONST_DAMAGEBONUS_2d12) , oItem);
               if (d4()==1) SetDroppableFlag(oItem, TRUE);
            }
         }
      }

   } else if (sWhich=="ENC_LAZY") {
      return;
      if (!OkToSpawn(500, oPC, 39)) return;
      oMinion = SpawnBoss("lazy", OBJECT_SELF);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d8), oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2d8) , oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen() , oItem);
      for (i=0;i<6;i++) {
         oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oMinion, i);
         if (oTarget!=OBJECT_INVALID) {
            if (GetTag(oTarget)=="NW_DEMON") {
               oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
               AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oItem);
               AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2d8) , oItem);
            }
         }
      }

   } else if (sWhich=="ENC_LIZARD") {
      return;
      if (!OkToSpawn(1000, oPC, 39)) return;
      oMinion = SpawnBoss("thelizardking", OBJECT_SELF);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND);
      int nRanDam = PickOneInt(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGETYPE_NEGATIVE);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(nRanDam, IP_CONST_DAMAGEBONUS_2d8) , oItem);
      //AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(IP_CONT_ONHIT_STUN, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS) , oItem);
      for (i=0;i<6;i++) {
         oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oMinion, i);
         if (oTarget!=OBJECT_INVALID) {
            if (!GetIsPC(oTarget) && !GetIsPC(GetMaster(oTarget))) {
               oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
               AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oItem);
               AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2d8) , oItem);
            }
         }
      }
   } else if (sWhich=="ENC_YUANTI") {
      return;
      if (!OkToSpawn(1500, oPC, 39)) return;
      oMinion = SpawnBoss("x_yauntiboss", OBJECT_SELF);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND);
      //AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps(IP_CONT_ONHIT_STUN, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS) , oItem);
      for (i=0;i<6;i++) {
         oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oMinion, i);
         if (oTarget!=OBJECT_INVALID) {
            if (!GetIsPC(oTarget) && !GetIsPC(GetMaster(oTarget))) {
                oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
               AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySchool(IP_CONST_SPELLSCHOOL_EVOCATION) , oItem);
            }
         }
      }
   } else if (sWhich=="Slaads") {
      return;
      if (!OkToSpawn(3000, oPC, 39)) return;
      oMinion = SpawnBoss("masterslaad", OBJECT_SELF);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_ARMS);
      int nRanDam = PickOneInt(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGETYPE_NEGATIVE);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(nRanDam, IP_CONST_DAMAGEBONUS_2d6) , oItem);
      nRanDam = PickOneInt(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGETYPE_ACID);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(nRanDam, IP_CONST_DAMAGEBONUS_2d6) , oItem);
      MakeCreature("slaaddthboss001",OBJECT_SELF, 600.0);
      MakeCreature("slaadgryboss001",OBJECT_SELF, 600.0);
      eEffect = EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
      eEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_NEGATIVE), eEffect);
      eEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_POSITIVE), eEffect);
      eEffect = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_SONIC), eEffect);
      for (i=0;i<6;i++) {
         oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oMinion, i);
         if (oTarget!=OBJECT_INVALID) {
            if (!GetIsPC(oTarget) && !GetIsPC(GetMaster(oTarget))) {
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 240.0);
            }
         }
      }

   } else if (sWhich=="ENC_BLIGHTED") {
      if (!OkToSpawn(20)) return;
      oLocator = GetObjectByTag("BLIGHTED_AGONY_WP", Random(5));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_UNDEAD_DRAGON), oLocator);
      oMinion = SpawnBoss(PickOne("agony_fighter","agony_mage"), oLocator);
      AssignCommand(oMinion, ActionAttack(oPC));
      oLocator = GetObjectByTag("BLIGHTED_AGONY_WP", Random(5));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_UNDEAD_DRAGON), oLocator);
      oMinion = SpawnBoss(PickOne("agony_fighter","agony_mage"), oLocator);
      AssignCommand(oMinion, ActionAttack(oPC));

   } else if (sWhich=="ENC_UNDEADELF") {
      if (!OkToSpawn(75)) return;
      oLocator = GetNearestObjectByTag("UNDEADELF_WP", OBJECT_SELF, Random(3));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_UNDEAD_DRAGON), oLocator);
      oMinion = SpawnBoss("agony_fighter", oLocator);

      SetLocalInt(oMinion, "TRIGGER_SPAWN", TRUE);
      SetLocalInt(oMinion, "COUNT_PLAYER_SPAWNED", pcCountParty(oPC));

      AssignCommand(oMinion, ActionAttack(oPC));

   } else if (sWhich=="TROLL_BOSS_ENC") {
      if (!OkToSpawn(25, oPC, 18)) return;
      oLocator = GetObjectByTag("TROLL_BOSS_WP");
      oMinion = SpawnBoss("regalia", oLocator);
      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTRING);
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oMinion);

   } else if (sWhich=="ENC_CRYPT1_BOSS") {
      if (!OkToSpawn(4, oPC, 4)) return;
      oLocator = GetObjectByTag("CRYPT1_CHEST");
      oMinion = SpawnBoss("necromancer", oLocator);
      oItem = DropEquippedItem(oMinion, 50, INVENTORY_SLOT_RIGHTHAND);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oMinion);
   } else if (sWhich=="ENC_CRYPT2_BOSS") {
      if (!OkToSpawn(6, oPC, 8)) return;
      oLocator = GetObjectByTag("CRYPT2_BOSS_WP");
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oLocator);
      oMinion = SpawnBoss("zombiebattler002", oLocator);
      AssignCommand(oMinion, ActionCastSpellAtObject(SPELLABILITY_TYRANT_FOG_MIST, oMinion, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
      oItem = DropEquippedItem(oMinion, 5, INVENTORY_SLOT_RIGHTHAND);
      oLocator = GetObjectByTag("CRYPT2_CHEST", 0);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      oLocator = GetObjectByTag("CRYPT2_CHEST", 1);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oMinion);
   } else if (sWhich=="ENC_CRYPT3_BOSS") {
      if (!OkToSpawn(6, oPC, 12)) return;
      oLocator = GetObjectByTag("CRYPT3_CHEST");
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), oLocator);
      oMinion = SpawnBoss("mummifiedelite", oLocator);
      AssignCommand(oMinion, ActionCastSpellAtObject(SPELL_STINKING_CLOUD, oLocator, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
      oItem = DropEquippedItem(oMinion, 50, INVENTORY_SLOT_RIGHTHAND);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oMinion);
   } else if (sWhich=="ENC_CRYPT4_BOSS") {
      if (!OkToSpawn(6, oPC, 14)) return;
      oLocator = GetObjectByTag("CRYPT4_CHEST");
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_10), oLocator);
      oMinion = SpawnBoss("skeletonelite", oLocator);
      AssignCommand(oMinion, ActionCastSpellAtObject(SPELL_CLOUDKILL, oLocator, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
      oItem = DropEquippedItem(oMinion, 50, INVENTORY_SLOT_RIGHTHAND);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oMinion);
   } else if (sWhich=="ENC_CRYPT5_BOSS") {
      if (!OkToSpawn(6, oPC, 16)) return;
      oLocator = GetObjectByTag("CRYPT5_BOSS_WP");
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_20), oLocator);
      oMinion = SpawnBoss("cryptghoulboss", oLocator);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_GHOST_SMOKE_2), oMinion);
      AssignCommand(oMinion, ActionCastSpellAtObject(SPELL_GREAT_THUNDERCLAP, oLocator, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oMinion);
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oMinion);
      SMS_CreateStone(oMinion, "SMS_DAM_SONIC");
   } else if (sWhich=="ENC_CRYPT6_BOSS") {
      if (!OkToSpawn(6, oPC, 18)) return;
      oLocator = GetObjectByTag("CRYPT6_CHEST");
      SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);
      SRM_RandomTreasure(TREASURE_LOW, oPC, oLocator);

      oLocator = GetObjectByTag("CRYPT6_BOSS_WP");
      AssignCommand(oTarget, DelayCommand(4.7f, voidSpawnBoss("colossalskeleton", oLocator, oPC)));
   }

//   if(GetIsObjectValid(oMinion)) SpeakString(GetName(oMinion) + " has spawned!", TALKVOLUME_SHOUT);
   // FLAG THE ENCOUNTER AS SPAWNED
   SetLocalInt(OBJECT_SELF, "SpawnOK", 1); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER

}

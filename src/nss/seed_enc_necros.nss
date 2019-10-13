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
   if (sWhich=="ENC_NECRO_BOSS") {
      if (!OkToSpawn(500, oPC, 38)) return;
      oLocator = GetObjectByTag("WP_NECRO_THRONE");
   } else {
      if (!OkToSpawn(3000, oPC, 38)) return;
      oLocator = OBJECT_SELF;
   }
   oMinion = SpawnBoss("nekrosis", oLocator);
   oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), GetLocation(oMinion));
   if (sWhich=="ENC_NECRO_BOSS") {
      AssignCommand(oMinion, ActionMoveToObject(oLocator));
      AssignCommand(oMinion, ActionSit(oLocator));
      if (d2()==1) CreateItemOnObject("starsapphire", oLocator, 20);
      if (d2()==1) CreateItemOnObject("perfectruby", oLocator, 20);
   }

//   if(GetIsObjectValid(oMinion)) SpeakString(GetName(oMinion) + " has spawned!", TALKVOLUME_SHOUT);
   // FLAG THE ENCOUNTER AS SPAWNED
   SetLocalInt(OBJECT_SELF, "SpawnOK", 1); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER

}

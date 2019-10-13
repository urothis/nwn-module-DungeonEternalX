#include "seed_enc_inc"

// IF THESE AREAS GIVE TOO MUCH TREASURE, CHANGE THIS CONSTANT
const int GOLDPERLVL = 300;

void KBM_SpawnBosses(object oLocator, int iBleuPCT=0, int iMoebiusPCT=0, int iBorerPCT=0) {
   object oMinion;
   if (d100()<=iBleuPCT) { // % chance of Bleu here
      if (GetObjectByTag("KBM_KOBOLQUEEN")==OBJECT_INVALID) { // Only one Bleu at a time
         oMinion = SpawnBoss("kbm_kobolqueen", oLocator);
         DropEquippedItem(oMinion, 30, INVENTORY_SLOT_RIGHTHAND);
      }
   }
   if (d100()<=iMoebiusPCT) { // % chance of Moebius here
      if (GetObjectByTag("KBM_KOBOLKING")==OBJECT_INVALID) { // Only one Moebius at a time
         oMinion = SpawnBoss("kbm_kobolking", oLocator);
         DropEquippedItem(oMinion, 30, INVENTORY_SLOT_RIGHTHAND);
      }
   }
   if (d100()<=iBorerPCT) { // % chance of Tunneller here
      oMinion = SpawnBoss("kbm_borer", oLocator);
   }
}

void FillGemWagon(object oChest, int iValue) {
   int iAmt;
   int iCnt = 0;
   if (Random(50)==1) CreateItemOnObject("x2_is_"+PickOne("sandblue","pandblue","pink","paleblue","drose","deepred"), oChest, 1);
   while (iValue > 0 && iCnt<=8) { // LOOP UNTIL VALUE EXCEEDED OR 8 GEMS PLACED
      int iGem = Random(9)+1;
      iCnt = iCnt + 1;
      iAmt = d10();
      switch (iGem) {
         case 1: // 002 1500 Fire Agate
            if (iValue > 1500) {
               CreateItemOnObject("nw_it_gem002", oChest, 1);
               iValue = iValue - 1500;
            }
            break;
         case 2: // 005 2000 Diamond
            if (iValue > 2000) {
               CreateItemOnObject("nw_it_gem005", oChest, 1);
               iValue = iValue - 2000;
            }
            break;
         case 3: // 006 3000 Ruby
            if (iValue > 3000) {
               CreateItemOnObject("nw_it_gem006", oChest, 1);
               iValue = iValue - 3000;
            }
            break;
         case 4: // 008 1000 Sapphire
            if (iValue > 1000) {
               CreateItemOnObject("nw_it_gem008", oChest, 1);
               iValue = iValue - 1000;
            }
            break;
         case 5: // 009 1500 Fire Opal
            if (iValue > 1500) {
               CreateItemOnObject("nw_it_gem009", oChest, 1);
               iValue = iValue - 1500;
            }
            break;
         case 6: // 010  250 Topaz
            CreateItemOnObject("nw_it_gem010", oChest, iAmt);
            iValue = iValue - (250 * iAmt);
            break;
         case 7: // 011  120 Garnet
            CreateItemOnObject("nw_it_gem011", oChest, iAmt);
            iValue = iValue - (120 * iAmt);
            break;
         case 8: // 012 4000 Emerald
            if (iValue > 4000) {
               CreateItemOnObject("nw_it_gem012", oChest, 1);
               iValue = iValue - 4000;
            }
            break;
         case 9: // 013  145 Alexandrite
            CreateItemOnObject("nw_it_gem013", oChest, iAmt);
            iValue = iValue - (145 * iAmt);
            break;
      }
   }
}

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
// add spawns for bosses in office
   if (sWhich=="KBM_DEEPMINE_BUTTE") {
      oPC = GetLastUsedBy();
      oLocator = GetObjectByTag("KBM_BUTTE_DEEPMINE");
      lSpawn = GetLocation(oLocator);
      ActionCastSpellAtObject(SPELL_HEAL, oPC, METAMAGIC_ANY, TRUE);
      AssignCommand(oPC, JumpToLocation(lSpawn));
   }
   else if (sWhich=="KBM_GONG" || sWhich=="KBM_ARCHERS_GONG") {
      oLocator = GetObjectByTag("KBM_GONG");
      eEffect=EffectVisualEffect(VFX_FNF_SOUND_BURST);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffect,oLocator);
      AssignCommand(oLocator,PlaySound("as_cv_gongring1"));
      DelayCommand(0.5,AssignCommand(oLocator,PlaySound("as_cv_gongring1")));
      DelayCommand(1.0,AssignCommand(oLocator,PlaySound("as_cv_gongring1")));
   }
   else if (GetStringLeft(sWhich,17)=="KBM_WAGON_MINE_00") {
      if (d3()!=1) return;
      sWhich = GetStringLeft(sWhich,18);
      oLocator = GetObjectByTag(sWhich);
      i = GetMax(5, 15-GetHitDice(oPC));
      FillGemWagon(oLocator, i * GOLDPERLVL);
      KBM_SpawnBosses(oLocator, 1, 1, 1); // %1 Bleu, 2% Moebius, 4% Borer
   }
   else if (GetStringLeft(sWhich,17)=="KBM_WAGON_DEEP_00") {
      if (d3()!=1) return;
      sWhich = GetStringLeft(sWhich,18);
      oLocator = GetObjectByTag(sWhich);
      i = GetMax(5, 20-GetHitDice(oPC));
      FillGemWagon(oLocator,i * GOLDPERLVL);
      KBM_SpawnBosses(oLocator,1, 2, 4);
   }
   else if (sWhich=="KBM_BOSSES") {
      if (d3()!=1) return;
      for (j=0; j<6; j++) {
         oLocator = GetObjectByTag("KBM_CHEST_OFFICE_002",j);
         i = GetMax(5, 20-GetHitDice(oPC));
         if (GetLocalInt(oLocator,"SinceBoot")==0) {
            SetLocalInt(oLocator,"SinceBoot",1);
            if (d10()<=5) { // 50% disabled
               SetTrapDisabled(oLocator);
            } else {
              i=i+d10(); // Trapped one more valuable
            }
         }
         FillGemWagon(oLocator,i * GOLDPERLVL);
      }
      KBM_SpawnBosses(oLocator, 60, 60, 0);
   }
   else if (sWhich=="KBM_GEMSTORAGE") {
      if (d3()!=1) return;
      for (j=0; j<16; j++) {
         oLocator = GetObjectByTag("KBM_CHEST_OFFICE_001",j);
         i = GetMax(5, 15-GetHitDice(oPC));
         if (GetLocalInt(oLocator,"SinceBoot")==0) {
            SetLocalInt(oLocator,"SinceBoot",1);
            if (d10()<=8) {  // 80% disabled
               SetTrapDisabled(oLocator);
            } else {
              i=i+d6(); // Trapped ones are more valuable
            }
         }
         FillGemWagon(oLocator,i * GOLDPERLVL / 3);
      }
   }

//   if(GetIsObjectValid(oMinion)) SpeakString(GetName(oMinion) + " has spawned!", TALKVOLUME_SHOUT);
   // FLAG THE ENCOUNTER AS SPAWNED
   SetLocalInt(OBJECT_SELF, "SpawnOK", 1); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER
}

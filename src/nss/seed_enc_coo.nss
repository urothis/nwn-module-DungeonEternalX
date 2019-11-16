#include "seed_enc_inc"

// ************************************
// CULT OF OUTCASTS SCRIPTED ENCOUNTERS
// ************************************

const int COO_RECRUIT  = 0;
const int COO_RED      = 1;
const int COO_ORANGE   = 2;
const int COO_BROWN    = 3;
const int COO_GREY     = 4;
const int COO_WHITE    = 5;
const int COO_ACOLYTE  = 6;

void OC_AddBuff(object oMinion, int iSlot, itemproperty ipAdd) {
   object oItem = GetItemInSlot(iSlot, oMinion);
   if (GetIsObjectValid(oItem)) AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oItem);
}

void OC_BuffEmUp(object oMinion, int iRank) {
   if (d10()<iRank) { // %10 CHANCE PER OUTCAST RANK OF A BUFF TO THIS WEAPON
      OC_AddBuff(oMinion, INVENTORY_SLOT_RIGHTHAND, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, iRank+5));
   }
   if (d10()<iRank) { // %10 CHANCE PER OUTCAST RANK OF A BUFF TO THIS WEAPON
     int iDamType = PickOneInt(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGETYPE_SONIC);
     OC_AddBuff(oMinion, INVENTORY_SLOT_LEFTHAND, ItemPropertyDamageBonus(iDamType, Random(iRank)+6));
   }
   if (d2()==1 && iRank>=COO_GREY) { // 50% CHANCE OF KEEN
     OC_AddBuff(oMinion, INVENTORY_SLOT_RIGHTHAND, ItemPropertyKeen());
   }
   if (d4()==1 && iRank>=COO_GREY) { // 25% CHANCE OF KEEN
     OC_AddBuff(oMinion, INVENTORY_SLOT_LEFTHAND, ItemPropertyKeen());
   }
}

string PickOutCast(int lvl=1) {
   int i;
   if (lvl!=COO_RECRUIT && Random(50)==1) lvl=lvl+1; // Increase to next level %2
   if (lvl!=COO_RECRUIT && Random(100)==1) lvl=lvl+1; // wow, do it again for some killing!
   if (lvl==COO_RECRUIT) {
      return "coo_newrecruit_1";
   } else if (lvl==COO_RED) {
      i=Random(6)+1;
      if (i== 1)      return "coo_he_cl7_ro3";      else if (i== 2) return "coo_ho_mo7_ro3";
      else if (i== 3) return "coo_ha_ba7_ro3";      else if (i== 4) return "coo_el_ra7_ro3";
      else if (i== 5) return "coo_hu_f3m4_ro3";                     return "coo_gn_wi7_ro3";
   } else if (lvl==COO_ORANGE) { // ORANGE
      i=Random(6)+1;
      if (i== 1)      return "coo_gn_wi9_ro7";      else if (i== 2) return "coo_ha_ba9_ro7";
      else if (i== 3) return "coo_ha_br9_ro7";      else if (i== 4) return "coo_ho_f4bg5_ro7";
      else if (i== 5) return "coo_ho_mo9_ro7";                      return "coo_hu_f3m6_ro7";
   } else if (lvl==COO_BROWN) { // BROWN
      i=Random(5)+1;
      if (i== 1)      return "coo_dw_cl8_ro5";      else if (i== 2) return "coo_dw_ra8_ro5";
      else if (i== 3) return "coo_gn_so8_ro5";      else if (i== 4) return "coo_ha_br8_ro5";
                      return "coo_hu_f3m5_ro5";
   } else if (lvl==COO_GREY) { // GREY
      i=Random(6)+1;
      if (i== 1)      return "coo_dw_cl9_ro10";     else if (i== 2) return "coo_dw_ra9_ro10";
      else if (i== 3) return "coo_gn_so9_r10";      else if (i== 4) return "coo_ha_ba9_ro10";
      else if (i== 5) return "coo_ho_mo9_ro10";                     return "coo_hu_f3m7_ro9";
   } else if (lvl==COO_WHITE) { // WHITE
      i=Random(9)+1;
      if (i== 1)      return "coo_ho_mo11_ro11";    else if (i== 2) return "coo_dw_cl11_ro11";
      else if (i== 3) return "coo_el_ra11_ro11";    else if (i== 4) return "coo_gn_wi11_ro11";
      else if (i== 5) return "coo_ha_ba11_ro11";    else if (i== 6) return "coo_gn_so11_r11";
      else if (i== 7) return "coo_ha_br11_ro11";    else if (i== 8) return "coo_hu_f3m8_ro11";
                      return "coo_ho_f4bg7_ro1";
   } else if (lvl>=COO_ACOLYTE) { // ACOLYTE
      i=Random(7)+1;
      return "coo_acolyte_0"+IntToString(i);
   }
   return "nw_nymph";
} // end PickOutcast

void NewWeapon(object oMinion, string sWhich) {
   object oWeapon;
   DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMinion));
   DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMinion));
   oWeapon=CreateItemOnObject(sWhich, oMinion, 1);
   SetDroppableFlag(oWeapon, FALSE);
   AssignCommand(oMinion,ActionEquipItem(oWeapon,INVENTORY_SLOT_RIGHTHAND));
}

void AddRobe(object oMinion, int nType = 5) {
   object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST, oMinion);
   object oNewArmor = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE, nType);
   SetDroppableFlag(oNewArmor, FALSE);
   AssignCommand(oMinion,ActionEquipItem(oNewArmor,INVENTORY_SLOT_CHEST));
   DestroyObject(oArmor);
}

void HolySit(object oPC, object oChair) {
   HideWeapons(oPC);
   AssignCommand(oPC, ActionMoveToObject(oChair));
   AssignCommand(oPC, ActionSit(oChair));
}

void TakeUpSnakes(object oPC) {
   HideWeapons(oPC);
   int i;
   int j;
   for (i=1; i<=8; i++) {
      AssignCommand(oPC, ActionDoCommand(PlaySound("as_pl_evilchantm")));
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0f, IntToFloat(d2(i))));
      for (j=1; j<=3; j++) DoPrayer(oPC);
      if (d2()==1) {
         AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
         AssignCommand(oPC, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ACID), oPC)));
         AssignCommand(oPC, ActionSpeakString(PickOne("Praise Her Beauty!","oooh...it...burns!","Hear My Prayers!","Down I Go!","I drink to Thee!","Oh yeah, that's the stuff.")));
         if (d4()==1) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0f, IntToFloat(d4()+i)));
         else AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, IntToFloat(d4()+i)));
      }
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0f, IntToFloat(d2(i))));
      for (j=1; j<=3; j++) DoPrayer(oPC);
   }
   AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0f, 600.0f));
} // Take up snakes

void FlyIn(string sBluePrint, location lGate) {
   object oNew = CreateObject(OBJECT_TYPE_CREATURE, sBluePrint, lGate, TRUE);
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oNew);
   AssignCommand(oNew, ActionAttack(oPC));
   CreateItemOnObject("coo_ta_lvl1_key", oNew, 1);
   CreateItemOnObject("coo_flaskofruin", oNew, 1);
}

object MakeOutCast(int iLvl, object oLocation, int bFlyIn=TRUE, string sNewTag="")
{
   object oMinion = MakeCreature(PickOutCast(iLvl), oLocation);
   OC_BuffEmUp(oMinion, iLvl);
   return oMinion;
}

void main() {
   // temporary disabled by ezramun. testing placeable lag
   /*
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
   if (sWhich=="COO_KE_SPAWN_ALCOVE") {
      if (!OkToSpawn(6, oPC, 16)) return;
      oLocator = GetObjectByTag("COO_FM_PREIST_MAIN_01");
      oMinion = MakeOutCast(COO_BROWN, oLocator, TRUE);
      oObject=CreateItemOnObject("COO_FLASKOFRUIN", oMinion, 1);
      SetIdentified(oObject, TRUE);
      NewWeapon(oMinion,"COO_POKESTICK");
      AddRobe(oMinion);
      HolySit(oMinion, oLocator);
      for (i=1; i<=20; i++) {
        AssignCommand(oMinion, ActionWait(IntToFloat(d6()+1)));
        AssignCommand(oMinion, ActionSpeakString(PickOne("She will be pleased!","Drink it down!","Power is yours!","Submit to her!","I love you all!","Aass! This we offer to you!")));
      }
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oMinion);
      oLocator = GetObjectByTag("ACD_CHEST1");
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      oLocator = GetObjectByTag("ADC_LECTURN");
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      oLocator = GetObjectByTag("ADC_BAGOFGOLD");
      SRM_CreateGem(oLocator, TREASURE_LOW, 20);
      oLocator = GetObjectByTag("COO_FM_PREIST_MAIN_01");
      SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      for (i=1; i<=2; i++) {
        oLocator = GetObjectByTag("COO_FM_PREIST_0"+IntToString(i));
        oMinion = MakeOutCast(COO_ORANGE, oLocator, TRUE);
        AddRobe(oMinion);
        HolySit(oMinion, oLocator);
        int j;
        for (j=1; j<=20; j++) {
           AssignCommand(oMinion, ActionSpeakString(PickOne("Such Loyalty!","Drink it down!","Aass! Hear My Prayers!","See The Glory!","Feel Her Power!","Give your soul to her!")));
           AssignCommand(oMinion, ActionWait(IntToFloat(d8()+1)));
        }
     }
     k = GetMin(PartyCnt, 2);
     for (i=1; i<=k; i++) {
        oLocator = GetObjectByTag("COO_FM_PRAY2_0"+IntToString(i));
        oMinion = MakeOutCast(COO_RED, oLocator, TRUE);
        TakeUpSnakes(oMinion);
     }
     k = GetMin(PartyCnt, 4);
     for (i=1; i<=k; i++) {
        oLocator = GetObjectByTag("COO_FM_PRAY1_0"+IntToString(i));
        oMinion = MakeOutCast(COO_RED, oLocator, TRUE);
        TakeUpSnakes(oMinion);
     }
     k = GetMin(PartyCnt * 2, 6);
     for (i=1; i<=k; i++) {
        if (d4()!=1) { // 75% chance of a recruit on this bench
           oLocator = GetObjectByTag("COO_FM_RECRUIT_0"+IntToString(i));
           oMinion = MakeOutCast(COO_RECRUIT, oLocator, TRUE);
           SetCreatureAppearanceType(oMinion, Random(93)+210);
           oLocator = GetObjectByTag("COO_FM_PEW_0"+IntToString(i));
           HolySit(oMinion, oLocator);
        }
      }
   }
   // ***************
   // TEMPLE SPAWNS
   // ***************
   else if (GetStringLeft(sWhich,20)=="COO_TA_SPAWN_LETROOM") {
      if (!OkToSpawn(3, oPC, 16)) return;
      int side=0;
      if (sWhich=="COO_TA_SPAWN_LETROOM_RIGHT") side=4; // 0 for left, 4 for right
      k = GetMin(PartyCnt, 3);
      for (i=1; i<=k; i++) {
        oLocator = GetObjectByTag("COO_TA_LET_0"+IntToString(i+side));
        oMinion = MakeOutCast(COO_ORANGE, oLocator, FALSE);
        AddRobe(oMinion);
        HideWeapons(oMinion);
        if (d2()==1) TakeUpSnakes(oMinion);
        else AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0f, 120.0f));
      }
      oLocator = GetObjectByTag("COO_TA_LET_0"+IntToString(4+side));
      oMinion = MakeOutCast(COO_BROWN, oLocator, TRUE);
      HideWeapons(oMinion);
      AssignCommand(oMinion, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oMinion)));
      AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 120.0f));
   }
   else if (sWhich=="COO_TA_SPAWN_DINER") {
      if (!OkToSpawn(3, oPC, 16)) return;
      k = GetMin(PartyCnt, 6);
      for (i=1; i<=k; i++) {
        if (d2()==1) { // 50% chance of someone in seat
           oLocator = GetObjectByTag("COO_TA_DINE_0"+IntToString(i));
           oMinion = MakeOutCast(COO_ORANGE, oLocator, FALSE);
           HideWeapons(oMinion);
           HolySit(oMinion, oLocator);
        }
      }
   }
   else if (sWhich=="COO_TA_SPAWN_TEMPLE") {
      if (!OkToSpawn(3)) return;
      if (!GetIsObjectValid(GetObjectByTag("COO_AASSVISION"))) {
         oLocator = GetObjectByTag("COO_TA_PRAY4_01");
         oMinion = MakeCreature("coo_aassvision", oLocator);
         effect e1=EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, e1, oMinion);
         AssignCommand(oMinion, SetFacing(DIRECTION_WEST));
         NewWeapon(oMinion,"COO_GREATPOKE");
         for (i=1; i<=12; i++) {
            AssignCommand(oMinion, ActionWait(IntToFloat(d4()+1)));
            AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0f, 8.0f));
            AssignCommand(oMinion, ActionSpeakString(PickOne("Your soul is mine!","Drink it down my Pretties!","Your reward is Power!","Submit!","I love you all!","Orcus! This I offer to you!")));
         }
         k = GetMin(PartyCnt, 4);
         for (i=1; i<=k; i++) {
            oLocator = GetObjectByTag("COO_TA_PRAY3_0"+IntToString(i));
            oMinion = MakeOutCast(COO_ORANGE, oLocator, FALSE);
            AddRobe(oMinion);
            TakeUpSnakes(oMinion);
         }
         k = GetMin(PartyCnt, 4);
         for (i=1; i<=k; i++) {
            oLocator = GetObjectByTag("COO_TA_PRAY2_0"+IntToString(i));
            oMinion = MakeOutCast(COO_ORANGE, oLocator, FALSE);
            HideWeapons(oMinion);
            AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0f, 120.0f));
         }
         k = GetMin(PartyCnt, 4);
         for (i=1; i<=k; i++) {
            oLocator = GetObjectByTag("COO_TA_PRAY1_0"+IntToString(i));
            oMinion = MakeOutCast(COO_ORANGE, oLocator, FALSE);
            HideWeapons(oMinion);
            oLocator = GetObjectByTag("COO_TA_PEW_0"+IntToString(i));
            HolySit(oMinion, oLocator);
         }
         for (i=1; i<=2; i++) {
            oLocator = GetObjectByTag("COO_TA_PRAY5_0"+IntToString(i));
            oMinion = MakeOutCast(COO_BROWN, oLocator, FALSE);
            AddRobe(oMinion);
            HideWeapons(oMinion);
            AssignCommand(oMinion, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oMinion)));
            int j;
            for (j=1; j<=20; j++) {
              AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0f, IntToFloat(d4()+2)));
              AssignCommand(oMinion, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ACID), oMinion)));
              AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, IntToFloat(d4()+2)));
            }
         }
         oLocator = GetObjectByTag("TA_PODIUM");
         SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
         oLocator = GetObjectByTag("COO_TA_CHEST1");
         SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
         oLocator = GetObjectByTag("COO_TA_CHEST2");
         SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
         oLocator = GetObjectByTag("COO_TA_CHEST3");
         SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
      }

   }
   else if (sWhich=="COO_TA_DOOR_GREY") {
      if (d3()!=1) return; // ONCE EVERY X SPAWNS
      oLocator = GetObjectByTag("COO_TA_GREY");
      oMinion = MakeOutCast(COO_GREY, oLocator, FALSE);
   }
   else if (sWhich=="COO_AASSVISION") { // VISION IS ATTACKED
      if (GetLocalInt(OBJECT_SELF, "ATTACKED")==0) { // in case of multi-attack
         SetLocalInt(OBJECT_SELF, "ATTACKED", 1);
         PlaySound("c_succubus_bat1");
         lSpawn = GetLocation(OBJECT_SELF);
         effect eEff=EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES); // VFX_FNF_LOS_EVIL_30 coo_ta_lvl1_key
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEff, lSpawn);
         eEff=EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEff, lSpawn);
         effect eBye = EffectDisappear();
         oMinion = OBJECT_SELF;
         lSpawn = GetLocation(GetLastAttacker(OBJECT_SELF));
         AssignCommand(oMinion, ActionDoCommand(PlaySound("c_succubus_bat1")));
         DelayCommand(1.0f, AssignCommand(oMinion, ActionDoCommand(PlaySound("c_succubus_bat1"))));
         DelayCommand(4.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBye, oMinion));
         DelayCommand(5.0f, FlyIn(PickOutCast(COO_GREY), lSpawn));
      }
   }
   // ******************
   // TORTURE SPAWNS
   // ***************
   else if (GetStringLeft(sWhich,20)=="COO_TC_SPAWN_TORTURE") {
      if (!OkToSpawn(3, oPC, 18)) return;
      effect eInc = EffectACIncrease(28, AC_NATURAL_BONUS, AC_VS_DAMAGE_TYPE_ALL);
      effect eDam = EffectDamage(25);
      sRef="L";
      if (sWhich=="COO_TC_SPAWN_TORTURE_RIGHT") sRef="R";
      k = GetMin(PartyCnt * 2, 7);
      for (i=1; i<=k; i++) {
        oLocator = GetObjectByTag("COO_TC_SHACKLE"+sRef+"_0"+IntToString(i));
        oMinion = MakeOutCast(COO_RECRUIT, oLocator, FALSE);
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oMinion));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectKnockdown(), oMinion);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectParalyze(), oMinion);
        if (d4()<2) ChangeToStandardFaction(oMinion, STANDARD_FACTION_COMMONER); // 25% chance of resistance
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInc, oMinion, 300.0f);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDam, oMinion);
      }
      k = GetMin(PartyCnt, 4);
      for (i=1; i<=k; i++) {
         oLocator = GetObjectByTag("COO_TC_WHIPPER"+sRef+"_0"+IntToString(i));
         oMinion = MakeOutCast(COO_BROWN, oLocator, FALSE);
         NewWeapon(oMinion,"COO_ACID_WHIP");
         AddRobe(oMinion);
      }
   }
   else if (sWhich=="COO_TC_SPAWN_BOSS") {
      if (!OkToSpawn(2)) return;
      int HasKey=d4(); // Pick a Grey to have key
      HasKey = GetMin(PartyCnt, HasKey);
      k = GetMin(PartyCnt, 4);
      for (i=1; i<=k; i++) {
         oLocator = GetObjectByTag("COO_TC_SEAT_GREY_0"+IntToString(i));
         if (i==HasKey) {
            oMinion = MakeOutCast(COO_GREY, oLocator, FALSE);
            CreateItemOnObject("coo_ta_lvl1_key", oMinion, 1);
            CreateItemOnObject("coo_flaskofruin", oMinion, 1);
            oLocator = GetObjectByTag("COO_IC_CHEST1");
            SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
            oLocator = GetObjectByTag("COO_IC_BAR");
            SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
         } else {
            oMinion = MakeOutCast(COO_BROWN, oLocator, FALSE);
         }
         HolySit(oMinion, oLocator);
      }
      k = GetMin(PartyCnt, 4);
      for (i=1; i<=k; i++) {
         oLocator = GetObjectByTag("COO_TC_SEAT_ORANGE_0"+IntToString(i));
         oMinion = MakeOutCast(COO_BROWN, oLocator, FALSE);
         if (d4()==1) AddRobe(oMinion);
         HideWeapons(oMinion);
         if (d2()==1) AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0f, 300.0f));
         else AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0f, 300.0f));
      }
      k = GetMin(PartyCnt, 6);
      for (i=1; i<=k; i++) {
         oLocator = GetObjectByTag("COO_TC_SEAT_BROWN_0"+IntToString(i));
         oMinion = MakeOutCast(COO_BROWN, oLocator, FALSE);
         if (d6()==1) {
            NewWeapon(oMinion,"COO_POKESTICK");
            AddRobe(oMinion);
         }
         HolySit(oMinion, oLocator);
      }

   }
   else if (sWhich=="COO_TC_DOOR_WHITE") {
      if (!OkToSpawn(4)) return;
      oLocator = GetObjectByTag("COO_TC_WHITE");
      oMinion = MakeOutCast(COO_WHITE, oLocator, FALSE);
   }
   else if (sWhich=="COO_TC_SPAWN_CLASS") {
      if (!OkToSpawn(3, oPC, 18)) return;
      k = GetMin(PartyCnt, 4);
      for (i=1; i<=PartyCnt; i++) {
         oLocator = GetObjectByTag("COO_TC_SEAT_CLASS_0"+IntToString(i));
         oMinion = MakeOutCast(COO_BROWN, oLocator, FALSE);
         AddRobe(oMinion);
         HolySit(oMinion, oLocator);
      }
      oLocator = GetObjectByTag("COO_IC_DESK1");
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
      oLocator = GetObjectByTag("COO_IC_LECTURN");
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
   }
   // ****************
   // PROCESSOR SPAWNS
   // ****************
   else if (GetStringLeft(sWhich,12)=="COO_PC_SPAWN") {
      if (!OkToSpawn(3, oPC, 22)) return;
      if (d6()!=1) return; // ONCE EVERY X SPAWNS
      sRef="L";
      if (FindSubString(sWhich,"RIGHT")>-1) sRef="R";
      if (FindSubString(sWhich,"TOP")>-1) sRef="TOP"+sRef;
      else sRef="BOT"+sRef;
      k = GetMin(PartyCnt, 3);
      for (i=1; i<=k; i++) {
         oLocator = GetObjectByTag("COO_PC_BROWN_"+sRef+"_0"+IntToString(i));
         oMinion = MakeOutCast(COO_GREY, oLocator, FALSE);
         NewWeapon(oMinion,"COO_POKESTICK");
         AddRobe(oMinion);
         for (j=1; j<=30; j++) {
            if (d2()==1) AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0f, 10.0f));
            else AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0f, 10.0f));
         }
      }
      k = GetMin(PartyCnt, 5);
      for (i=1; i<=k; i++) {
         oLocator = GetObjectByTag("COO_PC_GREY_"+sRef+"_0"+IntToString(i));
         j=COO_GREY;
         if (i==5) j=COO_WHITE;
         oMinion = MakeOutCast(j, oLocator, FALSE);
         if (j==COO_WHITE) {
            NewWeapon(oMinion,"COO_GREATPOKE");
            AddRobe(oMinion);
         }
         for (j=1; j<=30; j++) {
            if (d2()==1) AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 1.0f, 10.0f));
            else AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0f, 10.0f));
         }
      }
      k = GetMin(PartyCnt, 2);
      if (FindSubString(sWhich,"TOP")>-1) {
         for (i=1; i<=k; i++) {
            oLocator = GetObjectByTag("COO_PC_WHITE_"+sRef+"_0"+IntToString(i));
            oMinion = MakeOutCast(COO_WHITE, oLocator, FALSE, "COO_PC_WALKER");
            NewWeapon(oMinion,"COO_GREATPOKE");
            AddRobe(oMinion);
            for (j=1; j<=30; j++) {
               if (d2()==1) AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0f, 10.0f));
               else AssignCommand(oMinion, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0f, 10.0f));
            }
         }
      }
      k = GetMin(PartyCnt * 2, 8);
      if (sWhich=="COO_PC_SPAWN_BOT_RIGHT") {
         for (i=1; i<=k; i++) {
            oLocator = GetObjectByTag("COO_FP_CHEST"+IntToString(i));
            SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
         }
      }
   }
   // ***************
   // QUARTERS SPAWNS
   // ***************
   else if (sWhich=="COO_MQ_CHESTS") {
      if (!OkToSpawn(3, oPC, 26)) return;
      if (d6()!=1) return; // ONCE EVERY X SPAWNS
      oLocator = GetObjectByTag("COO_MQ_CHEST",Random(7));
      oMinion = MakeOutCast(COO_ACOLYTE, oLocator, FALSE, "COO_MQ_WALKER");
      for (j=0; j<7; j++) {
         oLocator = GetObjectByTag("COO_MQ_CHEST",j);
         SRM_RandomTreasure(TREASURE_LOW, oMinion, oLocator);
      }
   }
   else if (sWhich=="COO_MQ_SPAWN_KITCHEN") {
      if (!OkToSpawn(4, oPC, 26)) return;
      i=d2();
      if (d20()==1) i=3; // Sneak up from behind
      oLocator = GetObjectByTag("COO_MQ_KITCHEN_0"+IntToString(i));
      oMinion = MakeCreature("coo_chefemerald", oLocator);
   }
   else if (sWhich=="COO_MQ_SPAWN_RECROOM") {
      if (!OkToSpawn(3, oPC, 26)) return;
      k = GetMin(PartyCnt, 4);
      for (i=1; i<=k; i++) {
         if (d4()!=4) { // 75% chance of this seat taken
            oLocator = GetObjectByTag("COO_MQ_REC_SIT_0"+IntToString(i));
            oMinion = MakeOutCast(COO_WHITE, oLocator, FALSE);
            if (d6()==1) {
               NewWeapon(oMinion,"COO_GREATPOKE");
               AddRobe(oMinion);
            }
            CreateItemOnObject("COO_FLASKOFRUIN", oMinion, 1);
            HideWeapons(oMinion);
            HolySit(oMinion, oLocator);
         }
      }
   }
   else if (sWhich=="COO_MQ_SPAWN_TRAINBOT") {
      if (!OkToSpawn(3, oPC, 26)) return;
      for (i=1; i<=2; i++) {
        oLocator = GetObjectByTag("COO_MQ_TARGET_0"+IntToString(i));
        sRef=PickOutCast(5);
        if (d20()==1) sRef="coo_acolyte_04"; // rarely have an acolyte in here 5%
        oMinion = MakeCreature(sRef, oLocator);
        AssignCommand(oMinion, ActionEquipMostDamagingRanged());
      }
   }
   // ****************
   // SEPULCHER SPAWNS
   // ****************
   else if (sWhich=="COO_SA_SPAWN_MAIN") {
      if (!OkToSpawn(500, oPC, 34)) return;

      oItem = DropEquippedItem(oMinion, 100, INVENTORY_SLOT_RIGHTHAND);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d8), oItem);
      oLocator = GetObjectByTag("COO_SA_AASS");
      oMinion = SpawnBoss("coo_aass", oLocator);
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
      HolySit(oMinion, oLocator);
      oLocator = GetObjectByTag("COO_SA_ALTAR");
      SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);

      for (i=1; i<=4; i++) {
        oLocator = GetObjectByTag("COO_SA_ACOLYTE_0"+IntToString(i));
        j=COO_ACOLYTE;
        if (i>2 && d8()!=8) j=COO_WHITE;
        oMinion = MakeOutCast(j, oLocator, FALSE);
        if (j==COO_ACOLYTE) {
           if (d6()==1) NewWeapon(oMinion,"COO_GREATPOKE");
           AddRobe(oMinion);
        }
        HideWeapons(oMinion);
        HolySit(oMinion, oLocator);
        SRM_RandomTreasure(TREASURE_MEDIUM, oMinion, oLocator);
      }
   }
   else if (GetStringLeft(sWhich,6)=="COO_SA") { // ALL OTHER SPAWNS ON SA LEVEL
      if (!OkToSpawn(4, oPC, 30)) return;
      sRef=GetTag(OBJECT_SELF)+"_0";
      for (i=1; i<=9; i++) {
        oLocator = GetObjectByTag(sRef+IntToString(i));
        oMinion = MakeOutCast(COO_WHITE, oLocator, FALSE);
        if (d6()==1) AddRobe(oMinion);
        if (d6()==1) NewWeapon(oMinion,"COO_GREATPOKE");
        HideWeapons(oMinion);
        HolySit(oMinion, oLocator);
      }
   }

   // FLAG THE ENCOUNTER AS SPAWNED
   SetLocalInt(OBJECT_SELF, "SpawnOK", 1); // FLAG AS ACTIVE, RESET BY TIMER IN EXHAUSTED TRIGGER
   */
}

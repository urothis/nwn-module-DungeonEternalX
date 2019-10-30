#include "_functions"
#include "seed_magic_stone"
#include "random_loot_inc"

object SRM_AddBonuses(object oItem, int nLvl, int nTreasureValue, int nClass, string sMagicType = "");
void   SRM_AddName(string sNew);
int    SRM_AddProperty(object oItem, int nLvl, int nProp, string sMagicType, int nBonus, int nSubBonus = 0);
int    SRM_BasicClasses(int Class1, int Class2);
object SRM_CreateAmmo(object oTarget, int nHD = 1);
object SRM_CreateArcaneScroll(object oTarget, int nHD = 1);
object SRM_CreateDivineScroll(object oTarget, int nHD = 1);
void   SRM_CreateGem(object oTarget, int nTreasureType, int nHD = 1);
object SRM_CreateGold(object oTarget, int nTreasureType, int nHD = 1);
object SRM_CreateHealingKit(object oTarget, int nHD = 1);
object SRM_CreateJewel(object oTarget, int nTreasureType, int nHD = 1);
object SRM_CreateJunk(object oTarget);
object SRM_CreateKit(object oTarget, int nHD = 1);
object SRM_CreateLevelingWeapon(object oMinion, object oKiller);
object SRM_CreateLockPick(object oTarget, int nHD = 1);
object SRM_CreatePoison(object oTarget);
object SRM_CreatePotion(object oTarget, int nHD = 1, int nStack = 1);
object SRM_CreateTable2Item(object oTarget, object oMinion, int nTreasureType, int nClass);
object SRM_CreateTrapKit(object oTarget, int nHD = 1);
void   SRM_Debug(string sMsg);
void   SRM_RandomTreasure(int nTreasureType, object oMinion, object oCreateOn);
object SRM_GenerateTreasure(object oMinion, object oKiller);
int    SRM_GetGoldValue(int nHD = 1, int nTreasureType = 1);
int    SRM_GetNumberOfItems(int nTreasureType);
int    SRM_GetRange(int nCategory, int nHD);
int    SRM_GoldToGem(object oTarget, int iGold = 0, int iGemValue = 0, string sRef = "");
int    SRM_DetermineClassToUse(object oCharacter);
string SRM_PickArcaneScroll(int nLvl = 1);
object SRM_PickArmor(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="");
object SRM_PickClothes(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="");
string SRM_PickDivineScroll(int nLvl = 1);
object SRM_PickMagic(object oTarget, int nLvl, int nTreasureValue, string sType="", int nClass=CLASS_TYPE_INVALID, string sMagicType="");
int    SRM_PickScrollLevel(int nHD = 1);
int    SRM_PickSkillByClass(int nClass);
int    SRM_PickSpell(int nLvl);
object SRM_PickWeapon(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="");
object SRM_SetName(object oItem);
void   SRM_vPickArmor(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="");
void   SRM_vPickClothes(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="");
void   SRM_vPickMagic(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="");
void   SRM_vPickWeapon(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="");
void   voidCreateItemOnObject(string sItemTemplate, object oTarget = OBJECT_SELF, int nStackSize = 1);

string sNameBonus = "";
string sNamePlus = "";
string sNameDam = "";
string sNameClass = "";
string sNameKeenAv = "";
string sNameOnHit = "";
string sNameHaste = "";
string sNameBoss = "";
int bAddedClass = FALSE;

const int DEBUG_SRM = TRUE;

// * SIX LEVEL RANGES
int RANGE_1_MIN = 0;
int RANGE_1_MAX = 4;

int RANGE_2_MIN = 5;
int RANGE_2_MAX = 8;

int RANGE_3_MIN = 9;
int RANGE_3_MAX = 12;

int RANGE_4_MIN = 13;
int RANGE_4_MAX = 16;

int RANGE_5_MIN = 16;
int RANGE_5_MAX = 20;

int RANGE_6_MIN = 21;
int RANGE_6_MAX = 100;

// * NUMBER OF ITEMS APPEARING
int NUMBER_LOW_ONE   = 95; int NUMBER_MED_ONE    = 85; int NUMBER_HIGH_ONE   = 70; int NUMBER_BOSS_ONE   = 40;
int NUMBER_LOW_TWO   = 5;  int NUMBER_MED_TWO    = 10; int NUMBER_HIGH_TWO   = 20; int NUMBER_BOSS_TWO   = 40;
int NUMBER_LOW_THREE = 0;  int NUMBER_MED_THREE  =  5; int NUMBER_HIGH_THREE = 10; int NUMBER_BOSS_THREE = 20;


// * AMOUNT OF GOLD BY VALUE
float LOW_MOD_GOLD = 1.0;   float MEDIUM_MOD_GOLD = 2.0; float HIGH_MOD_GOLD = 4.0;

// * FREQUENCY OF ITEM TYPE APPEARING BY TREASURE TYPE (if total not 100, junk takes remaining
int LOW_PROB_JUNK    =  0;  int MEDIUM_PROB_JUNK   =  0;  int HIGH_PROB_JUNK   =  0;
int LOW_PROB_AMMO    =  3;  int MEDIUM_PROB_AMMO   =  2;  int HIGH_PROB_AMMO   =  2;
int LOW_PROB_GOLD    = 25;  int MEDIUM_PROB_GOLD   = 20;  int HIGH_PROB_GOLD   = 15;
int LOW_PROB_GEM     = 25;  int MEDIUM_PROB_GEM    = 20;  int HIGH_PROB_GEM    = 15;
int LOW_PROB_KIT     = 15;  int MEDIUM_PROB_KIT    = 18;  int HIGH_PROB_KIT    = 21;
int LOW_PROB_POTION  = 15;  int MEDIUM_PROB_POTION = 18;  int HIGH_PROB_POTION = 21;
int LOW_PROB_SCROLL  = 15;  int MEDIUM_PROB_SCROLL = 18;  int HIGH_PROB_SCROLL = 21;
int LOW_PROB_STONE   =  0;  int MEDIUM_PROB_STONE  =  1;  int HIGH_PROB_STONE  =  1;
int LOW_PROB_TABLE2  =  2;  int MEDIUM_PROB_TABLE2 =  3;  int HIGH_PROB_TABLE2 =  4;

void SRM_Debug(string sMsg) {
   if (DEBUG_SRM) WriteTimestampedLogEntry("SRM: " + sMsg);
}

void SRM_AddName(string sNew) {
   if (FindSubString(sNameBonus, sNew)==-1) sNameBonus = sNew + ":" + sNameBonus;
}

object SRM_SetName(object oItem) {
   sNameBonus = Trim(GetStringLeft(sNameBonus, GetStringLength(sNameBonus) - 1)); // take off last colon from string of sk:re:vr:etc:
   string sBase = GetName(oItem);
   sBase = Trim(GetStringRight(sBase, GetStringLength(sBase) - FindSubString(sBase, " ") - 1)); // amulet

   if (sNameOnHit!="") sBase = sBase + " of " + sNameOnHit;                                     // amulet of sleep
   if (sNameBonus!="") sBase =  sBase + " [" + sNameBonus + "]";                               // amulet of sleep [sk:sv:sr]
   string sAdds = "";
   if (sNameKeenAv!="") sAdds = sNameKeenAv + " " + sAdds;                                     // Keen Avenger amulet of sleep
   if (sNameDam   !="") sAdds = sNameDam + " " + sAdds;                                        // Fire amulet of sleep
   if (sNamePlus  !="") sAdds = sNamePlus + " " + sAdds;                                       // +3 ac fire amulet of sleep
   if (sNameHaste !="") sAdds = sNameHaste + " " + sAdds;                                       // Quick fire amulet of sleep
   if (sNameClass !="") sAdds = sNameClass + " " + sAdds;                                       // druid's Quick +3 ac fire amulet of sleep [sk:sv:sr]
   sAdds = Trim(sAdds);
   if (sAdds=="") {
      if (sNameBoss!="") sAdds = sNameBoss;
      else if (FindSubString(sBase,"sx")>=0) sAdds = "Lucky";
      else if (FindSubString(sBase,"sv")>=0) sAdds = "Saving";
      else if (FindSubString(sBase,"sk")>=0) sAdds = "Master's";
      else if (FindSubString(sBase,"mi")>=0) sAdds = "Strongarm";
      else sAdds = "Arcane";
   }
   sBase = sAdds + " " + sBase;

   SetName(oItem, sBase);
   return oItem;
}

int SRM_PickSkillByClass(int nClass) {
   int iCommon = PickOneInt(SKILL_HEAL, SKILL_LORE, SKILL_PARRY);
   switch (nClass) {
      case CLASS_TYPE_BARBARIAN:
         return PickOneInt(iCommon, SKILL_DISCIPLINE, SKILL_INTIMIDATE, SKILL_LISTEN, SKILL_TAUNT);
      case CLASS_TYPE_BARD:
         iCommon = PickOneInt(iCommon, SKILL_USE_MAGIC_DEVICE, SKILL_CONCENTRATION);
         return PickOneInt(iCommon, SKILL_DISCIPLINE, SKILL_HIDE, SKILL_LISTEN, SKILL_MOVE_SILENTLY, SKILL_PERFORM, SKILL_PICK_POCKET, SKILL_SPELLCRAFT, SKILL_TAUNT, SKILL_TUMBLE);
      case CLASS_TYPE_CLERIC   :
         return PickOneInt(iCommon, SKILL_CONCENTRATION, SKILL_SPELLCRAFT);
      case CLASS_TYPE_DRUID    :
         return PickOneInt(iCommon, SKILL_ANIMAL_EMPATHY, SKILL_CONCENTRATION, SKILL_SPELLCRAFT);
      case CLASS_TYPE_FIGHTER  :
         return PickOneInt(iCommon, SKILL_CONCENTRATION, SKILL_DISCIPLINE);
      case CLASS_TYPE_MONK     :
         return PickOneInt(iCommon, SKILL_CONCENTRATION, SKILL_DISCIPLINE, SKILL_HIDE, SKILL_LISTEN, SKILL_MOVE_SILENTLY, SKILL_TUMBLE);
      case CLASS_TYPE_PALADIN  :
         return PickOneInt(iCommon, SKILL_CONCENTRATION, SKILL_DISCIPLINE, SKILL_TAUNT);
      case CLASS_TYPE_RANGER   :
         return PickOneInt(iCommon, SKILL_ANIMAL_EMPATHY, SKILL_DISCIPLINE, SKILL_HIDE, SKILL_MOVE_SILENTLY, SKILL_SEARCH, SKILL_SET_TRAP, SKILL_SPOT);
      case CLASS_TYPE_ROGUE    :
         iCommon = PickOneInt(iCommon, SKILL_USE_MAGIC_DEVICE, SKILL_DISABLE_TRAP, SKILL_INTIMIDATE);
         return PickOneInt(iCommon, SKILL_HIDE, SKILL_LISTEN, SKILL_MOVE_SILENTLY, SKILL_OPEN_LOCK, SKILL_PICK_POCKET, SKILL_SEARCH, SKILL_SET_TRAP, SKILL_SPOT, SKILL_TUMBLE);
      case CLASS_TYPE_SORCERER :
      case CLASS_TYPE_WIZARD   :
         return PickOneInt(SKILL_HEAL, SKILL_LORE, SKILL_PARRY, SKILL_CONCENTRATION, SKILL_SPELLCRAFT);
   }
   return PickOneInt(SKILL_HEAL, SKILL_LORE, SKILL_PARRY, SKILL_CONCENTRATION, SKILL_SPELLCRAFT);
}

int SRM_BasicClasses(int Class1, int Class2) {
   switch (Class2) {
      case CLASS_TYPE_BARBARIAN:      case CLASS_TYPE_BARD     :      case CLASS_TYPE_CLERIC   :      case CLASS_TYPE_DRUID    :
      case CLASS_TYPE_FIGHTER  :      case CLASS_TYPE_MONK     :      case CLASS_TYPE_PALADIN  :      case CLASS_TYPE_RANGER   :
      case CLASS_TYPE_ROGUE    :      case CLASS_TYPE_SORCERER :      case CLASS_TYPE_WIZARD   :
         return Class2; // VALID BASE CLASS
         break;
   }
   return Class1; // INVALID BASE CLASS, RETURN PRIMARY
}

int SRM_DetermineClassToUse(object oCharacter) {
   int nClass1 = SRM_BasicClasses(CLASS_TYPE_FIGHTER, GetClassByPosition(1, oCharacter)); // <- Force Class1 to Fighter if not basic class
   int nLevel1 = GetLevelByClass(nClass1, oCharacter);
   int nClass2 = SRM_BasicClasses(nClass1, GetClassByPosition(2, oCharacter));
   int nLevel2 = GetLevelByClass(nClass2, oCharacter);
   int nClass3 = SRM_BasicClasses(nClass1, GetClassByPosition(3, oCharacter));
   int nLevel3 = GetLevelByClass(nClass3, oCharacter);
   int nPick = Random(nLevel1+nLevel2+nLevel3)+1;
   if (nPick <= nLevel1) return nClass1;
   if (nPick <= nLevel1+nLevel2) return nClass2;
   return nClass3;
}

void voidCreateItemOnObject(string sItemTemplate, object oTarget = OBJECT_SELF, int nStackSize = 1)
{
   CreateItemOnObject(sItemTemplate, oTarget, nStackSize);
   return;
}

// Returns true if nHD matches the correct level range for the indicated nCategory. (i.e., First to Fourth level characters are considered Range1)
int SRM_GetRange(int nCategory, int nHD) {
   int nMin = 0; int nMax = 0;
   switch (nCategory) {
      case 6: nMin = RANGE_6_MIN; nMax = RANGE_6_MAX; break;
      case 5: nMin = RANGE_5_MIN; nMax = RANGE_5_MAX; break;
      case 4: nMin = RANGE_4_MIN; nMax = RANGE_4_MAX; break;
      case 3: nMin = RANGE_3_MIN; nMax = RANGE_3_MAX; break;
      case 2: nMin = RANGE_2_MIN; nMax = RANGE_2_MAX; break;
      case 1: nMin = RANGE_1_MIN; nMax = RANGE_1_MAX; break;
   }
   if (nHD >= nMin && nHD <= nMax) return TRUE;
   return FALSE;
}

int SRM_PickSpell(int nLvl) {
   int nSpellType = IP_CONST_CASTSPELL_CONTINUAL_FLAME_7;
   int iMax = 172;
   int iMin = 0;
   if      (nLvl < 10) { iMax = 63;  iMin = 0;   } // 0-1
   else if (nLvl < 15) { iMax = 106; iMin = 0;   } // 0-3
   else if (nLvl < 20) { iMax = 123; iMin = 63;  } // 2-5
   else if (nLvl < 25) { iMax = 130; iMin = 106; } // 4-7
   else if (nLvl < 30) { iMax = 149; iMin = 123; } // 6-9
   else if (nLvl < 35) { iMax = 155; iMin = 130; } // 8-11
   else                { iMax = 172; iMin = 130; } // 9+

   int nRoll = Random(iMax - iMin) + 1 + iMin;
   switch (nRoll) {
      case 1  :  nSpellType = IP_CONST_CASTSPELL_BLESS_2                          ; break;  // 0  2
      case 2  :  nSpellType = IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2                ; break;  // 0  2
      case 3  :  nSpellType = IP_CONST_CASTSPELL_MAGE_ARMOR_2                     ; break;  // 0  2
      case 4  :  nSpellType = IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2            ; break;  // 0  2
      case 5  :  nSpellType = IP_CONST_CASTSPELL_REMOVE_FEAR_2                    ; break;  // 0  2
      case 6  :  nSpellType = IP_CONST_CASTSPELL_GREASE_2                         ; break;  // 0  2
      case 7  :  nSpellType = IP_CONST_CASTSPELL_GHOUL_TOUCH_3                    ; break;  // 0  3
      case 8  :  nSpellType = IP_CONST_CASTSPELL_WEB_3                            ; break;  // 0  3
      case 9  :  nSpellType = IP_CONST_CASTSPELL_SILENCE_3                        ; break;  // 0  3
      case 10 :  nSpellType = IP_CONST_CASTSPELL_IDENTIFY_3                       ; break;  // 0  3
      case 11 :  nSpellType = IP_CONST_CASTSPELL_FIND_TRAPS_3                     ; break;  // 0  3
      case 12 :  nSpellType = IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3             ; break;  // 0  3
      case 13 :  nSpellType = IP_CONST_CASTSPELL_SOUND_BURST_3                    ; break;  // 0  3
      case 14 :  nSpellType = IP_CONST_CASTSPELL_SEE_INVISIBILITY_3               ; break;  // 0  3
      case 15 :  nSpellType = IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3               ; break;  // 0  3
      case 16 :  nSpellType = IP_CONST_CASTSPELL_AID_3                            ; break;  // 0  3
      case 17 :  nSpellType = IP_CONST_CASTSPELL_INVISIBILITY_3                   ; break;  // 0  3
      case 18 :  nSpellType = IP_CONST_CASTSPELL_LESSER_RESTORATION_3             ; break;  // 0  3
      case 19 :  nSpellType = IP_CONST_CASTSPELL_HOLD_ANIMAL_3                    ; break;  // 0  3
      case 20 :  nSpellType = IP_CONST_CASTSPELL_CLARITY_3                        ; break;  // 0  3
      case 21 :  nSpellType = IP_CONST_CASTSPELL_KNOCK_3                          ; break;  // 0  3
      case 22 :  nSpellType = IP_CONST_CASTSPELL_DARKNESS_3                       ; break;  // 0  3
      case 23 :  nSpellType = IP_CONST_CASTSPELL_HOLD_PERSON_3                    ; break;  // 0  3
      case 24 :  nSpellType = IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3             ; break;  // 0  3
      case 25 :  nSpellType = IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5              ; break;  // 0  5
      case 26 :  nSpellType = IP_CONST_CASTSPELL_SLEEP_5                          ; break;  // 0  5
      case 27 :  nSpellType = IP_CONST_CASTSPELL_MAGIC_FANG_5                     ; break;  // 0  5
      case 28 :  nSpellType = IP_CONST_CASTSPELL_AMPLIFY_5                        ; break;  // 0  5
      case 29 :  nSpellType = IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5            ; break;  // 0  5
      case 30 :  nSpellType = IP_CONST_CASTSPELL_TRUE_STRIKE_5                    ; break;  // 0  5
      case 31 :  nSpellType = IP_CONST_CASTSPELL_CAMOFLAGE_5                      ; break;  // 0  5
      case 32 :  nSpellType = IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5                ; break;  // 0  5
      case 33 :  nSpellType = IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5      ; break;  // 0  5
      case 34 :  nSpellType = IP_CONST_CASTSPELL_DOOM_5                           ; break;  // 0  5
      case 35 :  nSpellType = IP_CONST_CASTSPELL_ENTANGLE_5                       ; break;  // 0  5
      case 36 :  nSpellType = IP_CONST_CASTSPELL_BANE_5                           ; break;  // 0  5
      case 37 :  nSpellType = IP_CONST_CASTSPELL_SHIELD_5                         ; break;  // 0  5
      case 38 :  nSpellType = IP_CONST_CASTSPELL_DARKVISION_6                     ; break;  // 0  6
      case 39 :  nSpellType = IP_CONST_CASTSPELL_BLOOD_FRENZY_7                   ; break;  // 0  7
      case 40 :  nSpellType = IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7        ; break;  // 0  7
      case 41 :  nSpellType = IP_CONST_CASTSPELL_AURAOFGLORY_7                    ; break;  // 0  7
      case 42 :  nSpellType = IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7              ; break;  // 0  7
      case 43 :  nSpellType = IP_CONST_CASTSPELL_ONE_WITH_THE_LAND_7              ; break;  // 0  7
      case 44 :  nSpellType = IP_CONST_CASTSPELL_MAGIC_MISSILE_9                  ; break;  // 0  9
      case 45 :  nSpellType = IP_CONST_CASTSPELL_ROGUES_CUNNING_3                 ; break;  // 1  3
      case 46 :  nSpellType = IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5      ; break;  // 1  5
      case 47 :  nSpellType = IP_CONST_CASTSPELL_PRAYER_5                         ; break;  // 1  5
      case 48 :  nSpellType = IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5             ; break;  // 1  5
      case 49 :  nSpellType = IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5            ; break;  // 1  5
      case 50 :  nSpellType = IP_CONST_CASTSPELL_SLOW_5                           ; break;  // 1  5
      case 51 :  nSpellType = IP_CONST_CASTSPELL_STINKING_CLOUD_5                 ; break;  // 1  5
      case 52 :  nSpellType = IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5 ; break;  // 1  5
      case 53 :  nSpellType = IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5                 ; break;  // 1  5
      case 54 :  nSpellType = IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5            ; break;  // 1  5
      case 55 :  nSpellType = IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5              ; break;  // 1  5
      case 56 :  nSpellType = IP_CONST_CASTSPELL_FEAR_5                           ; break;  // 1  5
      case 57 :  nSpellType = IP_CONST_CASTSPELL_LESSER_DISPEL_5                  ; break;  // 1  5
      case 58 :  nSpellType = IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9             ; break;  // 1  9
      case 59 :  nSpellType = IP_CONST_CASTSPELL_DISPLACEMENT_9                   ; break;  // 1  9
      case 60 :  nSpellType = IP_CONST_CASTSPELL_WOUNDING_WHISPERS_9              ; break;  // 1  9
      case 61 :  nSpellType = IP_CONST_CASTSPELL_SPIKE_GROWTH_9                   ; break;  // 1  9
      case 62 :  nSpellType = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_9            ; break;  // 1  9
      case 63 :  nSpellType = IP_CONST_CASTSPELL_BARKSKIN_12                      ; break;  // 1  12
      case 64 :  nSpellType = IP_CONST_CASTSPELL_SEARING_LIGHT_5                  ; break;  // 2  5
      case 65 :  nSpellType = IP_CONST_CASTSPELL_LEGEND_LORE_5                    ; break;  // 2  5
      case 66 :  nSpellType = IP_CONST_CASTSPELL_WAR_CRY_7                        ; break;  // 2  7
      case 67 :  nSpellType = IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9               ; break;  // 2  9
      case 68 :  nSpellType = IP_CONST_CASTSPELL_RESIST_ELEMENTS_10               ; break;  // 2  10
      case 69 :  nSpellType = IP_CONST_CASTSPELL_FLAME_LASH_10                    ; break;  // 2  10
      case 70 :  nSpellType = IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7            ; break;  // 3  7
      case 71 :  nSpellType = IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7             ; break;  // 3  7
      case 72 :  nSpellType = IP_CONST_CASTSPELL_DEATH_WARD_7                     ; break;  // 3  7
      case 73 :  nSpellType = IP_CONST_CASTSPELL_ENERVATION_7                     ; break;  // 3  7
      case 74 :  nSpellType = IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7              ; break;  // 3  7
      case 75 :  nSpellType = IP_CONST_CASTSPELL_STONESKIN_7                      ; break;  // 3  7
      case 76 :  nSpellType = IP_CONST_CASTSPELL_HOLD_MONSTER_7                   ; break;  // 3  7
      case 77 :  nSpellType = IP_CONST_CASTSPELL_POLYMORPH_SELF_7                 ; break;  // 3  7
      case 78 :  nSpellType = IP_CONST_CASTSPELL_RESTORATION_7                    ; break;  // 3  7
      case 79 :  nSpellType = IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7            ; break;  // 3  7
      case 80 :  nSpellType = IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7          ; break;  // 3  7
      case 81 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_FEAR_10            ; break;  // 3  10
      case 82 :  nSpellType = IP_CONST_CASTSPELL_DISPEL_MAGIC_10                  ; break;  // 3  10
      case 83 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_LIGHTNING_10       ; break;  // 3  10
      case 84 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_SLEEP_10           ; break;  // 3  10
      case 85 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_ACID_10            ; break;  // 3  10
      case 86 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_COLD_10            ; break;  // 3  10
      case 87 :  nSpellType = IP_CONST_CASTSPELL_LIGHTNING_BOLT_10                ; break;  // 3  10
      case 88 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_SLOW_10            ; break;  // 3  10
      case 89 :  nSpellType = IP_CONST_CASTSPELL_CONFUSION_10                     ; break;  // 3  10
      case 90 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_FIRE_10            ; break;  // 3  10
      case 91 :  nSpellType = IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10      ; break;  // 3  10
      case 92 :  nSpellType = IP_CONST_CASTSPELL_FIREBALL_10                      ; break;  // 3  10
      case 93 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_GAS_10             ; break;  // 3  10
      case 94 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_WEAKEN_10          ; break;  // 3  10
      case 95 :  nSpellType = IP_CONST_CASTSPELL_HASTE_10                         ; break;  // 3  10
      case 96 :  nSpellType = IP_CONST_CASTSPELL_CALL_LIGHTNING_10                ; break;  // 3  10
      case 97 :  nSpellType = IP_CONST_CASTSPELL_DRAGON_BREATH_PARALYZE_10        ; break;  // 3  10
      case 98 :  nSpellType = IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13                ; break;  // 3  13
      case 99 :  nSpellType = IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13   ; break;  // 3  13
      case 100:  nSpellType = IP_CONST_CASTSPELL_OWLS_WISDOM_15                   ; break;  // 3  15
      case 101:  nSpellType = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15                ; break;  // 3  15
      case 102:  nSpellType = IP_CONST_CASTSPELL_FOXS_CUNNING_15                  ; break;  // 3  15
      case 103:  nSpellType = IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15                 ; break;  // 3  15
      case 104:  nSpellType = IP_CONST_CASTSPELL_BULLS_STRENGTH_15                ; break;  // 3  15
      case 105:  nSpellType = IP_CONST_CASTSPELL_CATS_GRACE_15                    ; break;  // 3  15
      case 106:  nSpellType = IP_CONST_CASTSPELL_GUST_OF_WIND_10                  ; break;  // 4  10
      case 107:  nSpellType = IP_CONST_CASTSPELL_ENDURANCE_15                     ; break;  // 4  15
      case 108:  nSpellType = IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9              ; break;  // 5  9
      case 109:  nSpellType = IP_CONST_CASTSPELL_ICE_STORM_9                      ; break;  // 5  9
      case 110:  nSpellType = IP_CONST_CASTSPELL_RAISE_DEAD_9                     ; break;  // 5  9
      case 111:  nSpellType = IP_CONST_CASTSPELL_GREATER_SHADOW_CONJURATION_9     ; break;  // 5  9
      case 112:  nSpellType = IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9          ; break;  // 5  9
      case 113:  nSpellType = IP_CONST_CASTSPELL_MIND_FOG_9                       ; break;  // 5  9
      case 114:  nSpellType = IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9              ; break;  // 5  9
      case 115:  nSpellType = IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9            ; break;  // 5  9
      case 116:  nSpellType = IP_CONST_CASTSPELL_FEEBLEMIND_9                     ; break;  // 5  9
      case 117:  nSpellType = IP_CONST_CASTSPELL_CLOUDKILL_9                      ; break;  // 5  9
      case 118:  nSpellType = IP_CONST_CASTSPELL_AWAKEN_9                         ; break;  // 5  9
      case 119:  nSpellType = IP_CONST_CASTSPELL_OWLS_INSIGHT_15                  ; break;  // 5  15
      case 120:  nSpellType = IP_CONST_CASTSPELL_FIREBRAND_15                     ; break;  // 5  15
      case 121:  nSpellType = IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15    ; break;  // 5  15
      case 122:  nSpellType = IP_CONST_CASTSPELL_ANIMATE_DEAD_15                  ; break;  // 5  15
      case 123:  nSpellType = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_10         ; break;  // 6  10
      case 124:  nSpellType = IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12            ; break;  // 6  12
      case 125:  nSpellType = IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12              ; break;  // 6  12
      case 126:  nSpellType = IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15    ; break;  // 6  15
      case 127:  nSpellType = IP_CONST_CASTSPELL_FLAME_ARROW_18                   ; break;  // 6  18
      case 128:  nSpellType = IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_15; break;  // 7  15
      case 129:  nSpellType = IP_CONST_CASTSPELL_CONE_OF_COLD_15                  ; break;  // 7  15
      case 130:  nSpellType = IP_CONST_CASTSPELL_STONE_TO_FLESH_5                 ; break;  // 8  5
      case 131:  nSpellType = IP_CONST_CASTSPELL_FLESH_TO_STONE_5                 ; break;  // 8  5
      case 132:  nSpellType = IP_CONST_CASTSPELL_MASS_HASTE_11                    ; break;  // 8  11
      case 133:  nSpellType = IP_CONST_CASTSPELL_GREATER_ENDURANCE_11             ; break;  // 8  11
      case 134:  nSpellType = IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11      ; break;  // 8  11
      case 135:  nSpellType = IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11            ; break;  // 8  11
      case 136:  nSpellType = IP_CONST_CASTSPELL_GREATER_BULLS_STRENGTH_11        ; break;  // 8  11
      case 137:  nSpellType = IP_CONST_CASTSPELL_GREATER_STONESKIN_11             ; break;  // 8  11
      case 138:  nSpellType = IP_CONST_CASTSPELL_PLANAR_BINDING_11                ; break;  // 8  11
      case 139:  nSpellType = IP_CONST_CASTSPELL_GREATER_FOXS_CUNNING_11          ; break;  // 8  11
      case 140:  nSpellType = IP_CONST_CASTSPELL_GREATER_CATS_GRACE_11            ; break;  // 8  11
      case 141:  nSpellType = IP_CONST_CASTSPELL_GREATER_EAGLES_SPLENDOR_11       ; break;  // 8  11
      case 142:  nSpellType = IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11        ; break;  // 8  11
      case 143:  nSpellType = IP_CONST_CASTSPELL_GREATER_OWLS_WISDOM_11           ; break;  // 8  11
      case 144:  nSpellType = IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15  ; break;  // 8  15
      case 145:  nSpellType = IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15               ; break;  // 9  15
      case 146:  nSpellType = IP_CONST_CASTSPELL_GREATER_DISPELLING_15            ; break;  // 9  15
      case 147:  nSpellType = IP_CONST_CASTSPELL_DISMISSAL_18                     ; break;  // 9  18
      case 148:  nSpellType = IP_CONST_CASTSPELL_FLAME_STRIKE_18                  ; break;  // 9  18
      case 149:  nSpellType = IP_CONST_CASTSPELL_GREATER_RESTORATION_13           ; break;  // 11 13
      case 150:  nSpellType = IP_CONST_CASTSPELL_POWER_WORD_STUN_13               ; break;  // 11 13
      case 151:  nSpellType = IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13           ; break;  // 11 13
      case 152:  nSpellType = IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13               ; break;  // 11 13
      case 153:  nSpellType = IP_CONST_CASTSPELL_SHADOW_SHIELD_13                 ; break;  // 11 13
      case 154:  nSpellType = IP_CONST_CASTSPELL_CREATE_UNDEAD_16                 ; break;  // 12 16
      case 155:  nSpellType = IP_CONST_CASTSPELL_AURA_OF_VITALITY_13              ; break;  // 15 13
      case 156:  nSpellType = IP_CONST_CASTSPELL_PREMONITION_15                   ; break;  // 15 15
      case 157:  nSpellType = IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15          ; break;  // 15 15
      case 158:  nSpellType = IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15         ; break;  // 15 15
      case 159:  nSpellType = IP_CONST_CASTSPELL_MIND_BLANK_15                    ; break;  // 15 15
      case 160:  nSpellType = IP_CONST_CASTSPELL_MASS_BLINDNESS_DEAFNESS_15       ; break;  // 15 15
      case 161:  nSpellType = IP_CONST_CASTSPELL_GREATER_PLANAR_BINDING_15        ; break;  // 15 15
      case 162:  nSpellType = IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20               ; break;  // 15 20
      case 163:  nSpellType = IP_CONST_CASTSPELL_ENERGY_BUFFER_20                 ; break;  // 15 20
      case 164:  nSpellType = IP_CONST_CASTSPELL_CONTROL_UNDEAD_20                ; break;  // 17 20
      case 165:  nSpellType = IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20        ; break;  // 17 20
      case 166:  nSpellType = IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18         ; break;  // 18 18
      case 167:  nSpellType = IP_CONST_CASTSPELL_SHAPECHANGE_17                   ; break;  // 19 17
      case 168:  nSpellType = IP_CONST_CASTSPELL_GATE_17                          ; break;  // 19 17
      case 169:  nSpellType = IP_CONST_CASTSPELL_DOMINATE_MONSTER_17              ; break;  // 19 17
      case 170:  nSpellType = IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17            ; break;  // 19 17
      case 171:  nSpellType = IP_CONST_CASTSPELL_ENERGY_DRAIN_17                  ; break;  // 19 17
      case 172:  nSpellType = IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20          ; break;  // 19 20
   }
   return nSpellType;
}

int SRM_AddProperty(object oItem, int nLvl, int nProp, string sMagicType, int nBonus, int nSubBonus = 0) {
   itemproperty ipNew = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_WHITE);
   int nDamageType;
   int nSaveType;
   int nSlotType;
   int nOnHitType;
   string sThisProp = "";
   int bAddedMagicTypeThisRun = FALSE;
   int bAddedClassThisRun = FALSE;
   int bAddedPlusThisRun = FALSE;
   int bAddedKeenAvThisRun = FALSE;
   int bAddedOnHitThisRun = FALSE;
   int bAddedHasteThisRun = FALSE;
   if      (sMagicType=="acid")     { nDamageType = IP_CONST_DAMAGETYPE_ACID;       nSaveType = IP_CONST_SAVEVS_ACID;         }
   else if (sMagicType=="cold")     { nDamageType = IP_CONST_DAMAGETYPE_COLD;       nSaveType = IP_CONST_SAVEVS_COLD;         }
   else if (sMagicType=="fire")     { nDamageType = IP_CONST_DAMAGETYPE_FIRE;       nSaveType = IP_CONST_SAVEVS_FIRE;         }
   else if (sMagicType=="electric") { nDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL; nSaveType = IP_CONST_SAVEVS_ELECTRICAL;   }
   else if (sMagicType=="divine")   { nDamageType = IP_CONST_DAMAGETYPE_DIVINE;     nSaveType = IP_CONST_SAVEVS_DIVINE;       }
   else if (sMagicType=="magic")    { nDamageType = IP_CONST_DAMAGETYPE_MAGICAL;    nSaveType = IP_CONST_SAVEVS_MINDAFFECTING;}
   else if (sMagicType=="negative") { nDamageType = IP_CONST_DAMAGETYPE_NEGATIVE;   nSaveType = IP_CONST_SAVEVS_NEGATIVE;     }
   else if (sMagicType=="positive") { nDamageType = IP_CONST_DAMAGETYPE_POSITIVE;   nSaveType = IP_CONST_SAVEVS_POSITIVE;     }
   else if (sMagicType=="sonic")    { nDamageType = IP_CONST_DAMAGETYPE_SONIC;      nSaveType = IP_CONST_SAVEVS_SONIC;        }
   sMagicType = CapitalizeFirstLetter(sMagicType);
   switch (nProp) {
      case ITEM_PROPERTY_ATTACK_BONUS:
         ipNew = ItemPropertyAttackBonus(nBonus);
         sThisProp = "ab";
         break;
      case ITEM_PROPERTY_AC_BONUS:
         ipNew = ItemPropertyACBonus(nBonus);
         sThisProp = "ac";
         break;
      case ITEM_PROPERTY_ABILITY_BONUS:
         ipNew = ItemPropertyAbilityBonus(Random(6), nBonus);
         sThisProp = GetStringLowerCase(AbilityString(GetItemPropertySubType(ipNew)));
         break;
      case ITEM_PROPERTY_MIGHTY:
         ipNew = ItemPropertyMaxRangeStrengthMod(nBonus);
         sThisProp = "mi";
         break;
      case ITEM_PROPERTY_DAMAGE_BONUS:
         if (SMS_GetItemCurrentBonus(oItem, ITEM_PROPERTY_DAMAGE_BONUS, nDamageType) > 0) nDamageType = SMS_RotateDamage(nDamageType); // ALREADY GOT THIS DAMAGE, GRAB THE NEXT ONE
         ipNew = ItemPropertyDamageBonus(nDamageType, nBonus);
         bAddedMagicTypeThisRun = TRUE;
         sThisProp = "dm";
         break;
      case ITEM_PROPERTY_MASSIVE_CRITICALS:
         ipNew = ItemPropertyMassiveCritical(nBonus);
         sThisProp = "mc";
         break;
      case ITEM_PROPERTY_SKILL_BONUS:
         if (SMS_GetItemCurrentBonus(oItem, ITEM_PROPERTY_SKILL_BONUS, nSubBonus) > 0) return TRUE; // ALREADY GOT THIS SKILL
         ipNew = ItemPropertySkillBonus(nSubBonus, nBonus);
         sThisProp = "sk";
         break;
      case ITEM_PROPERTY_SAVING_THROW_BONUS:
         if (SMS_GetItemCurrentBonus(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, nSaveType) > 0 || sMagicType=="Magic") { // IF VsX Save, Add the odd ball types
            switch (Random(5)) {
               case 0: nSaveType = IP_CONST_SAVEVS_DEATH;         sNameBoss = "Deathless"; break;
               case 1: nSaveType = IP_CONST_SAVEVS_DISEASE;       sNameBoss = "Healthy"; break;
               case 2: nSaveType = IP_CONST_SAVEVS_FEAR;          sNameBoss = "Fearless"; break;
               case 3: nSaveType = IP_CONST_SAVEVS_MINDAFFECTING; sNameBoss = "Smart"; break;
               case 4: nSaveType = IP_CONST_SAVEVS_POISON;        sNameBoss = "Iron Belly"; break;
             }
         } else {
            bAddedMagicTypeThisRun = TRUE;
         }
         ipNew = ItemPropertyBonusSavingThrowVsX(nSaveType, nBonus);
         sThisProp = "sx";
         break;
      case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
         ipNew = ItemPropertyBonusSavingThrow(Random(3)+1, nBonus);
         sThisProp = "sv";
         break;
      case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
         ipNew = ItemPropertyDamageImmunity(nDamageType, nBonus);
         bAddedMagicTypeThisRun = TRUE;
         sThisProp = "di";
         break;
      case ITEM_PROPERTY_DAMAGE_RESISTANCE:
         sThisProp = "dr";
         if (d10()==1) { nDamageType = Random(3); sThisProp = "dR"; } // 10% for buldge, pierce, slash
         else bAddedMagicTypeThisRun = TRUE;
         ipNew = ItemPropertyDamageResistance(nDamageType, nBonus);
         break;
      case ITEM_PROPERTY_DAMAGE_REDUCTION:
         ipNew = ItemPropertyDamageReduction(nBonus, nSubBonus);
         bAddedMagicTypeThisRun = TRUE;
         sThisProp = "d%";
         break;
      case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
         ipNew = ItemPropertyVampiricRegeneration(nBonus);
         sThisProp = "vr";
         sNameBoss = "Nosferatu's";
         break;
      case ITEM_PROPERTY_REGENERATION:
         ipNew = ItemPropertyRegeneration(nBonus);
         sThisProp = "re";
         sNameBoss = "Lord Troll's";
         break;
      case ITEM_PROPERTY_ON_HIT_PROPERTIES:
         nOnHitType = Random(11);
         bAddedOnHitThisRun = TRUE;
         switch (nOnHitType) {
            case 0:  nOnHitType = IP_CONST_ONHIT_SLEEP     ; sThisProp = "Sleep"; break;
            case 1:  nOnHitType = IP_CONST_ONHIT_STUN      ; sThisProp = "Stun"; break;
            case 2:  nOnHitType = IP_CONST_ONHIT_HOLD      ; sThisProp = "Hold"; break;
            case 3:  nOnHitType = IP_CONST_ONHIT_CONFUSION ; sThisProp = "Confusion"; break;
            case 4:  nOnHitType = IP_CONST_ONHIT_DAZE      ; sThisProp = "Daze"; break;
            case 5:  nOnHitType = IP_CONST_ONHIT_DOOM      ; sThisProp = "Doom"; break;
            case 6:  nOnHitType = IP_CONST_ONHIT_FEAR      ; sThisProp = "Fear"; break;
            case 7:  nOnHitType = IP_CONST_ONHIT_SLOW      ; sThisProp = "Slow"; break;
            case 8:  nOnHitType = IP_CONST_ONHIT_SILENCE   ; sThisProp = "Silence"; break;
            case 9:  nOnHitType = IP_CONST_ONHIT_DEAFNESS  ; sThisProp = "Deafness"; break;
            case 10: nOnHitType = IP_CONST_ONHIT_BLINDNESS ; sThisProp = "Blindness"; break;
         }
         ipNew = ItemPropertyOnHitProps(nOnHitType, nBonus, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS);
         break;
      case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
         ipNew = ItemPropertyBonusLevelSpell(nSubBonus, nBonus);
         //sThisProp = ClassString(nClass);
         bAddedClassThisRun = TRUE;
         break;
      case ITEM_PROPERTY_SPELL_RESISTANCE:
         ipNew = ItemPropertyBonusSpellResistance(nBonus);
         sThisProp = "sr";
         break;
      case ITEM_PROPERTY_HASTE:
         ipNew = ItemPropertyHaste();
         bAddedHasteThisRun = TRUE;
         sThisProp = "Quick";
         break;
      case ITEM_PROPERTY_KEEN:
         ipNew = ItemPropertyKeen();
         sThisProp = "Keen";
         bAddedKeenAvThisRun = TRUE;
         break;
      case ITEM_PROPERTY_HOLY_AVENGER:
         ipNew = ItemPropertyHolyAvenger();
         sThisProp = "Avenger";
         bAddedKeenAvThisRun = TRUE;
         break;
      case ITEM_PROPERTY_BONUS_FEAT:
         ipNew = ItemPropertyBonusFeat(Random(31));
         sThisProp = "fe";
         break;
      case ITEM_PROPERTY_CAST_SPELL:
         ipNew = ItemPropertyCastSpell(nBonus, nSubBonus);
         sThisProp = "cs";
         break;
   }
   SRM_Debug("Adding " + IPString(nProp));
   IPSafeAddItemProperty(oItem, ipNew);
   if (GetItemLevel(GetGoldPieceValue(oItem)) > SMS_ITEM_LEVEL_MAX) {
      SRM_Debug("  ** Removed Property due to SMS_ITEM_LEVEL_MAX");
      RemoveItemProperty(oItem, ipNew);
      return FALSE;
   }
   if (bAddedMagicTypeThisRun) sNameDam = sMagicType;
   if (bAddedClassThisRun) bAddedClass = TRUE;
   else if (bAddedPlusThisRun) sNamePlus = sThisProp;
   else if (bAddedOnHitThisRun) sNameOnHit = sThisProp;
   else if (bAddedHasteThisRun) sNameHaste = sThisProp;
   else if (bAddedKeenAvThisRun) {
      if (sNameKeenAv == "Keen" || sNameKeenAv == "Avenger") sNameKeenAv = "Keen Avenger"; // GOT ONE, NOW GOT BOTH
      else sNameKeenAv = sThisProp;
   }
   else if (sThisProp!="") sNameBonus = sThisProp + ":" + sNameBonus; //SRM_AddName(sThisProp); // Not special add to generic list
   if (GetItemLevel(GetGoldPieceValue(oItem)) > nLvl) return FALSE; // DONE ADDING PROPS
   return TRUE;
}

object SRM_AddBonuses(object oItem, int nLvl, int nTreasureValue, int nClass, string sMagicType = "") {
   sNameBonus = "";
   sNamePlus = "";
   sNameDam = "";
   sNameClass = "";
   sNameKeenAv = "";
   sNameOnHit = "";
   sNameHaste = "";
   sNameBoss = "";
   bAddedClass = FALSE;
   int nBaseType = GetBaseItemType(oItem);
   int nBonus = GetMin(12, nTreasureValue + nLvl / 5); // 1-4 + 8 = 12 max, or 120% over legal
   int nAddAB = SMS_AB_MAX * nBonus / 10;
   int nAddAbility = SMS_ABILITY_MAIN_ITEM_MAX * nBonus / 10;        // 3
   int nAddAC = SMS_AC_MAX * nBonus / 10;             // 6
   int nAddDamBonus = 9 * nBonus / 12;       // 6-15 (Damage const run 6 (1d4) - 15 (2d12) - adds 6 below in random pick
   int nAddDamCount = nTreasureValue / 2;    // 1-2 damages on Med-High treasure
   int nAddMassCrit = 0;                     // assigned below based on damage count
   int nAddDamImm = 5 * nBonus / 12;         // 0-6 (DI Consts run 1-7 (5=75%)
   int nAddDamRes = 3 * nBonus / 12;         // 0-3 (DR Consts run 1-10 (3=15)
   int nAddDamSoakAB = 8 * nBonus / 10;      // 8
   int nAddDamSoakAmt = 5 * nBonus / 12;     // 1-5 (Soak Consts run 1-10 (5=25)
   int nAddMighty = SMS_MIGHTY_MAX * nBonus / 10;        // 10
   int nAddOnHitDC = 6 * nBonus / 12;        // 0-6 (OH Consts run 0-6
   int nAddRegen = 1 * nBonus / 10;          // 2
   int nAddSave = SMS_SAVE_VS_MAIN_ITEM_MAX * nBonus / 10;           // 5
   int nAddSaveVs = 1 * nBonus / 10;         // 5 Big 3
   int nAddSkill = SMS_SKILL_MAX * nBonus / 10;          // 3
   int nAddSkillCount = nTreasureValue / 2;    // 1-2 Skill on Med-High treasure
   int nAddSlot = 9 * nBonus / 12;      // 9
   int nAddSlotCount = nTreasureValue / 2;    // 1-2 Slots on Med-High treasure
   int nAddSR = 11 * nBonus / 12;            // 0-11 (SR Consts run 0-11
   int nAddVampRegen = SMS_VAMP_REGEN_MAX * nBonus / 10;      // 6
   int nAddCastSpell = (nTreasureValue==4);                   // Only On High Treasure Value Items
   int nAddCastUses = 8; // ONE PER DAY
   int nAddFeat = (nTreasureValue==4);                        // Only On High Treasure Value Items
   int nAddKeen = (nTreasureValue==4 && nLvl>10);             // Only On High & Over Level 10
   int nAddHaste = (nTreasureValue==4 && nLvl>15);            // Only On High & Over Level 15
   int nAddHolySword = (nTreasureValue==4 && nLvl>25);        // Only On High & Over Level 25
   sNameBonus = "";
   int nACPCTChance = 0;
   if (nBaseType==BASE_ITEM_ARMOR || nBaseType==BASE_ITEM_SMALLSHIELD || nBaseType==BASE_ITEM_LARGESHIELD || nBaseType==BASE_ITEM_TOWERSHIELD) {
      // ZERO THE INVALID PROPERTIES FOR THIS BASE TYPE
      //nAddAbility = 0;
      //nAddAC = 0;
      //nAddDamImm = 0;
      //nAddDamRes = 0;
      //nAddDamSoakAB = 0;
      //nAddDamSoakAmt = 0;
      //nAddRegen = 0;
      //nAddSave = 0;
      //nAddSkill = 0;
      nACPCTChance = 100;
      nAddAB = 0;
      nAddCastSpell = 0;
      nAddDamBonus = 0;
      nAddDamCount = 0;
      nAddFeat = 0;
      nAddHaste = 0;
      nAddHolySword = 0;
      nAddKeen = 0;
      nAddMighty = 0;
      nAddOnHitDC = 0;
      nAddSaveVs = 0;  // Big 3
      nAddSlotCount = 0;
      nAddSR = 0;
      nAddVampRegen = 0;
   } else if (nBaseType==BASE_ITEM_AMULET || nBaseType==BASE_ITEM_BELT || nBaseType==BASE_ITEM_BOOTS || nBaseType==BASE_ITEM_BRACER || nBaseType==BASE_ITEM_CLOAK || nBaseType==BASE_ITEM_HELMET) {
      //nAddAbility = 0;
      //nAddAC = 0;
      //nAddCastSpell = 0;
      //nAddDamImm = 0;
      //nAddDamRes = 0;
      //nAddFeat = 0;
      //nAddHaste = 0;
      //nAddRegen = 0;
      //nAddSave = 0;
      //nAddSaveVs = 0;  // Big 3
      //nAddSkill = 0;
      //nAddSlotCount = 0;
      //nAddSR = 0;
      nACPCTChance = 25;
      nAddAB = 0;
      nAddDamBonus = 0;
      nAddDamCount = 0;
      nAddDamSoakAB = 0;
      nAddDamSoakAmt = 0;
      nAddHolySword = 0;
      nAddKeen = 0;
      nAddMighty = 0;
      nAddOnHitDC = 0;
      nAddVampRegen = 0;
   } else if (nBaseType==BASE_ITEM_RING) {
      //nAddAbility = 0;
      //nAddCastSpell = 0;
      //nAddDamImm = 0;
      //nAddDamRes = 0;
      //nAddDamSoakAB = 0;
      //nAddDamSoakAmt = 0;
      //nAddFeat = 0;
      //nAddHaste = 0;
      //nAddRegen = 0;
      //nAddSave = 0;
      //nAddSaveVs = 0;  // Big 3
      //nAddSkill = 0;
      //nAddSlotCount = 0;
      //nAddSR = 0;
      nAddAB = 0;
      nAddAC = 0;
      nAddDamBonus = 0;
      nAddDamCount = 0;
      nAddHolySword = 0;
      nAddKeen = 0;
      nAddMighty = 0;
      nAddOnHitDC = 0;
      nAddVampRegen = 0;
   } else if (nBaseType==BASE_ITEM_MAGICSTAFF) {
      //nAddAB = 0;
      //nAddAbility = 0;
      //nAddCastSpell = 0;
      //nAddDamBonus = 0;
      //nAddDamCount = 0;
      //nAddOnHitDC = 0;
      //nAddSave = 0;
      //nAddSkill = 0;
      //nAddSlotCount = 0;
      //nAddVampRegen = 0;
      nAddAC = 0;
      nAddDamImm = 0;
      nAddDamRes = 0;
      nAddDamSoakAB = 0;
      nAddDamSoakAmt = 0;
      nAddFeat = 0;
      nAddHaste = 0;
      nAddHolySword = 0;
      nAddKeen = 0;
      nAddMighty = 0;
      nAddRegen = 0;
      nAddSaveVs = 0;  // Big 3
      nAddSR = 0;
   } else if (nBaseType==BASE_ITEM_GLOVES) {
      //nAddAB = 0;
      //nAddAbility = 0;
      //nAddDamBonus = 0;
      //nAddDamCount = 0;
      //nAddDamImm = 0;
      //nAddDamRes = 0;
      //nAddHaste = 0;
      //nAddOnHitDC = 0;
      //nAddRegen = 0;
      //nAddSave = 0;
      //nAddSaveVs = 0;  // Big 3
      //nAddSkill = 0;
      nAddAC = 0;
      nAddCastSpell = 0;
      nAddDamSoakAB = 0;
      nAddDamSoakAmt = 0;
      nAddFeat = 0;
      nAddHolySword = 0;
      nAddKeen = 0;
      nAddMighty = 0;
      nAddSlotCount = 0;
      nAddSR = 0;
      nAddVampRegen = 0;
   } else  { // WEAPONS
      //nAddAB = 0;
      //nAddDamBonus = 0;
      //nAddDamCount = 0;
      //nAddHolySword = 0;
      //nAddKeen = 0;
      //nAddMighty = 0;
      //nAddOnHitDC = 0;
      //nAddVampRegen = 0;
      nAddAbility = 0;
      nAddAC = 0;
      nAddCastSpell = 0;
      nAddDamImm = 0;
      nAddDamRes = 0;
      nAddDamSoakAB = 0;
      nAddDamSoakAmt = 0;
      nAddFeat = 0;
      nAddHaste = 0;
      nAddRegen = 0;
      nAddSave = 0;
      nAddSaveVs = 0;  // Big 3
      nAddSkill = 0;
      nAddSlotCount = 0;
      nAddSR = 0;
      SMS_GetWeaponData(oItem);
      if (nAddMighty)    nAddMighty    = (WeaponStats.Ranged || WeaponStats.Throw);   // mighty only on ranged, throwing
      if (nAddVampRegen) nAddVampRegen = (!WeaponStats.Ranged);                       // No Vamp Regen on Ranged
      if (nAddOnHitDC)   nAddOnHitDC   = (!WeaponStats.Ranged);                       // no onhit for ranged weapons
      if (nAddKeen)      nAddKeen      = (!WeaponStats.Ranged && !WeaponStats.Throw); // no keen if ranged, throwing
      if (WeaponStats.Ranged)  nAddDamCount  = 0;                                     // no damage of bows
   }
   nAddAB = RandomUpperHalf(nAddAB);
   nAddMassCrit = Random(nAddDamCount+1);
   nAddDamBonus = 6 + RandomUpperHalf(nAddDamBonus); // special +6 to skip fixed damage types
   nAddDamCount = Random(nAddDamCount+1);
   nAddMighty = RandomUpperHalf(nAddMighty);
   nAddOnHitDC = RandomUpperHalf(nAddOnHitDC);
   nAddSave = RandomUpperHalf(nAddSave);
   nAddSaveVs = RandomUpperHalf(nAddSaveVs);
   nAddSkill = RandomUpperHalf(nAddSkill);
   nAddSkillCount = Random(nAddSkillCount+1);
   nAddVampRegen = RandomUpperHalf(nAddVampRegen);
   nAddAbility = RandomUpperHalf(nAddAbility);
   nAddAC = RandomUpperHalf(nAddAC);
   nAddDamImm = RandomUpperHalf(nAddDamImm);
   nAddDamRes = RandomUpperHalf(nAddDamRes);
   nAddDamSoakAB = RandomUpperHalf(nAddDamSoakAB);
   nAddDamSoakAmt = RandomUpperHalf(nAddDamSoakAmt);
   nAddRegen = RandomUpperHalf(nAddRegen);
   nAddSlotCount = Random(nAddSlotCount+1);
   nAddSR = RandomUpperHalf(nAddSR);

   if (nAddSkill==0) nAddSkillCount = 0;

   if (sMagicType == "") {
      sMagicType = PickOne("divine", "magic", "negative", "positive", "sonic");
      sMagicType = PickOne("acid", "cold", "fire", "electric", sMagicType);
   } else if (d8()==1) { // 25% chance of override
      sMagicType = PickOne("divine", "magic", "negative", "positive", "sonic");
   }
   if (nClass==CLASS_TYPE_INVALID) {
      if (d2()==1) nClass = PickOneInt(CLASS_TYPE_BARBARIAN, CLASS_TYPE_BARD, CLASS_TYPE_CLERIC, CLASS_TYPE_DRUID, CLASS_TYPE_FIGHTER);
      else nClass = PickOneInt(CLASS_TYPE_MONK, CLASS_TYPE_PALADIN, CLASS_TYPE_RANGER, CLASS_TYPE_ROGUE, CLASS_TYPE_SORCERER, CLASS_TYPE_WIZARD);
   }

   int nSpellClass;
   if (nAddSlotCount) {
      nAddSlot = 9;
      switch (nClass) { // CHECK IF SPELL CLASS, ELSE FORCE IT TO ONE
         case CLASS_TYPE_BARD: case CLASS_TYPE_CLERIC: case CLASS_TYPE_DRUID: case CLASS_TYPE_PALADIN: case CLASS_TYPE_RANGER: case CLASS_TYPE_SORCERER: case CLASS_TYPE_WIZARD:
            break;
         default:
            nClass = PickOneInt(CLASS_TYPE_WIZARD, CLASS_TYPE_SORCERER, CLASS_TYPE_CLERIC, CLASS_TYPE_DRUID, CLASS_TYPE_BARD, CLASS_TYPE_RANGER, CLASS_TYPE_PALADIN);
      }
      switch (nClass) {
         case CLASS_TYPE_BARD:     nSpellClass = IP_CONST_CLASS_BARD    ; nAddSlot = 6; break;
         case CLASS_TYPE_CLERIC:   nSpellClass = IP_CONST_CLASS_CLERIC  ; break;
         case CLASS_TYPE_DRUID:    nSpellClass = IP_CONST_CLASS_DRUID   ; break;
         case CLASS_TYPE_PALADIN:  nSpellClass = IP_CONST_CLASS_PALADIN ; nAddSlot = 4; break;
         case CLASS_TYPE_RANGER:   nSpellClass = IP_CONST_CLASS_RANGER  ; nAddSlot = 4; break;
         case CLASS_TYPE_SORCERER: nSpellClass = IP_CONST_CLASS_SORCERER; break;
         case CLASS_TYPE_WIZARD:   nSpellClass = IP_CONST_CLASS_WIZARD  ; break;
         default:                  nSpellClass = PickOneInt(IP_CONST_CLASS_WIZARD, IP_CONST_CLASS_CLERIC, IP_CONST_CLASS_DRUID, IP_CONST_CLASS_SORCERER); break;
      }
      nAddSlot = RandomUpperHalf(nAddSlot);
   }
   int nSkill;
   int bDone = FALSE;

   if (!bDone && nAddAB         && Random(002)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_ATTACK_BONUS               , sMagicType, nAddAB       ); nAddAB = 0; }
   if (!bDone && nAddDamCount   && Random(003)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_DAMAGE_BONUS               , sMagicType, nAddDamBonus ); nAddDamCount--; }
   if (!bDone && nAddMassCrit   && Random(003)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_MASSIVE_CRITICALS          , sMagicType, nAddDamBonus ); nAddMassCrit = 0; }
   if (!bDone && nAddVampRegen  && Random(010)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_REGENERATION_VAMPIRIC      , sMagicType, nAddVampRegen); nAddVampRegen = 0; }
   if (!bDone && nAddMighty     && Random(003)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_MIGHTY                     , sMagicType, nAddMighty   ); nAddMighty = 0; }
   if (!bDone && nAddKeen       && Random(050)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_KEEN                       , sMagicType, nAddKeen     ); nAddKeen      = 0; }
   if (!bDone && nAddDamCount   && Random(003)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_DAMAGE_BONUS               , PickOne("divine", "magic", "negative", "positive", "sonic"), --nAddDamBonus ); nAddDamCount--; }
   //if (!bDone && nAddHolySword  && Random(999)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_HOLY_AVENGER               , sMagicType, nAddHolySword); nAddHolySword = 0; }

   if (!bDone && nAddAC         && Random(100)<=nACPCTChance)   { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_AC_BONUS                   , sMagicType, nAddAC       ); nAddAC = 0; }
   if (!bDone && nAddSkillCount && Random(005)<=nTreasureValue) { nSkill = SRM_PickSkillByClass(nClass); bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_SKILL_BONUS                , sMagicType, nAddSkill, nSkill); nAddSkillCount--; }
   //if (!bDone && nAddDamImm     && Random(050)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE       , sMagicType, nAddDamImm   ); nAddDamImm = 0; }
   //if (!bDone && nAddDamRes     && Random(100)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_DAMAGE_RESISTANCE          , sMagicType, nAddDamRes   ); nAddDamRes = 0; }
   if (!bDone && nAddCastSpell  && Random(100)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_CAST_SPELL                 , sMagicType, SRM_PickSpell(nLvl), nAddCastUses); nAddCastSpell = 0; }
   if (!bDone && nAddDamSoakAB  && Random(500)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_DAMAGE_REDUCTION           , sMagicType, nAddDamSoakAB, nAddDamSoakAmt); nAddDamSoakAB = 0; }
   if (!bDone && nAddHaste      && Random(100)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_HASTE                      , sMagicType, nAddHaste    ); nAddHaste     = 0; }
   if (!bDone && nAddSR         && Random(500)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_SPELL_RESISTANCE           , sMagicType, nAddSR       ); nAddSR = 0; }
   if (!bDone && nAddFeat       && Random(999)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_BONUS_FEAT                 , sMagicType, nAddFeat     ); nAddFeat      = 0; }
   if (!bDone && nAddOnHitDC    && Random(500)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_ON_HIT_PROPERTIES          , sMagicType, nAddOnHitDC  ); nAddOnHitDC = 0; bDone=TRUE; }
   if (!bDone && nAddAbility    && Random(050)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_ABILITY_BONUS              , sMagicType, nAddAbility  ); nAddAbility = 0; bDone=TRUE; }
   if (!bDone && nAddSkillCount && Random(005)<=nTreasureValue) { nSkill = SRM_PickSkillByClass(nClass); bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_SKILL_BONUS                , sMagicType, nAddSkill, nSkill); nAddSkillCount--; bDone=TRUE; }
   if (!bDone && nAddSave       && Random(010)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_SAVING_THROW_BONUS         , sMagicType, nAddSave     ); nAddSave = 0; bDone=TRUE; }
   if (!bDone && nAddSaveVs     && Random(020)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, sMagicType, nAddSaveVs   ); nAddSaveVs = 0; bDone=TRUE; }
   if (!bDone && nAddSlotCount  && Random(020)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, sMagicType, nAddSlot, nSpellClass); nAddSlotCount--; bDone=TRUE;}
   if (!bDone && nAddSlotCount  && Random(020)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, sMagicType, nAddSlot, nSpellClass); nAddSlotCount--; nAddSlot = RandomUpperHalf(nAddSlot); bDone=TRUE;}
   if (!bDone && nAddRegen      && Random(050)<=nTreasureValue) { bDone = !SRM_AddProperty(oItem, nLvl, ITEM_PROPERTY_REGENERATION               , sMagicType, nAddRegen    ); nAddRegen = 0; }


   if (GetGoldPieceValue(oItem)>1000) { // ONLY USE THINGS WITH SOME WORTH
      if (bAddedClass) sNameClass = ClassString(nClass)+"'s";
      oItem = SRM_SetName(oItem);
   } else {
      SRM_Debug("Worthless crap destroyed: " + GetName(oItem) + " " + sNameBonus);
      DestroyObject(oItem); //worthless item
      oItem = OBJECT_INVALID;
   }
   return oItem;
}

// Returns a Random level spell level
int SRM_PickScrollLevel(int nHD = 1) {
   int nLevel = 1;
   if (SRM_GetRange(1, nHD)) { // 1-3
      nLevel = Random(3) + 1;
   } else if (SRM_GetRange(2, nHD)) { // 2-5
      nLevel = Random(5) + 1;
      if (nLevel < 2) nLevel = 2;
   } else if (SRM_GetRange(3, nHD)) { // 3-7
      nLevel = Random(7) + 1;
      if (nLevel < 3) nLevel = 3;
   } else if (SRM_GetRange(4, nHD)) { // 4-9
      nLevel = Random(9) + 1;
      if (nLevel < 4) nLevel = 4;
   } else if (SRM_GetRange(5, nHD)) { // 5-9
      nLevel = Random(9) + 1;
      if (nLevel < 5) nLevel = 5;
   } else if (SRM_GetRange(6, nHD)) { // 6-9
      nLevel = Random(9) + 1;
      if (nLevel < 6) nLevel = 6;
   }
   return nLevel;
}

int SRM_GetNumberOfItems(int nTreasureType) {
   int nItems = 1;
   int nRandom = d100();
   int nProbThreeItems = 0;
   int nProbTwoItems = 0;
   int nProbOneItems = 0;
   if (nTreasureType == TREASURE_LOW) {
      nProbThreeItems = NUMBER_LOW_THREE;      nProbTwoItems = NUMBER_LOW_TWO;      nProbOneItems = NUMBER_LOW_ONE;
   } else if (nTreasureType == TREASURE_MEDIUM) {
      nProbThreeItems = NUMBER_MED_THREE;      nProbTwoItems = NUMBER_MED_TWO;      nProbOneItems = NUMBER_MED_ONE;
   } else if (nTreasureType == TREASURE_HIGH) {
      nProbThreeItems = NUMBER_HIGH_THREE;     nProbTwoItems = NUMBER_HIGH_TWO;     nProbOneItems = NUMBER_HIGH_ONE;
   } else if (nTreasureType == TREASURE_BOSS) {
      nProbThreeItems = NUMBER_BOSS_THREE;     nProbTwoItems = NUMBER_BOSS_TWO;     nProbOneItems = NUMBER_BOSS_ONE;
   }
   if (nRandom <= nProbThreeItems) nItems = 3;
   else if (nRandom <= nProbTwoItems + nProbThreeItems) nItems = 2;
   return nItems;
}

object SRM_CreateJunk(object oTarget) {
   string sRes = "NW_IT_TORCH001";
   int nResult = Random(5) + 1;
   switch (nResult) {
      case 1: sRes = "NW_IT_MPOTION021"; break; //ale
      case 2: sRes = "NW_IT_MPOTION021"; break;   // ale
      case 3: sRes = "NW_IT_MPOTION023"; break; // wine
      case 4: sRes = "NW_IT_MPOTION021"; break; // ale
      case 5: sRes = "NW_IT_MPOTION022"; break; // spirits
   }
   return CreateItemOnObject(sRes, oTarget, 6);
}

int SRM_GetGoldValue(int nHD = 1, int nTreasureType = 1) {
   int nAmount = (nHD * nHD) * (10+d100());
   float nMod = 0.0;
   if (nTreasureType == TREASURE_LOW) nMod = LOW_MOD_GOLD;
   else if (nTreasureType == TREASURE_MEDIUM) nMod = MEDIUM_MOD_GOLD;
   else if (nTreasureType == TREASURE_HIGH) nMod = HIGH_MOD_GOLD;
   nAmount = FloatToInt(nAmount * nMod);
   if (nAmount <= 100) nAmount = 100+d20(); // * always at least 100 gp is created
   return nAmount;
}

object SRM_CreateGold(object oTarget, int nTreasureType, int nHD = 1) {
   return CreateItemOnObject("NW_IT_GOLD001", oTarget, SRM_GetGoldValue(nHD, nTreasureType));
}

int SRM_GoldToGem(object oTarget, int iGold = 0, int iGemValue = 0, string sRef = "")
{
   int iGemCount = iGold / iGemValue;
   iGemCount = GetMin(10, RandomUpperHalf(iGemCount)); // 0 - 10
   if (iGemCount)
   {
      CreateItemOnObject(sRef, oTarget, iGemCount);
      iGold = iGold - (iGemCount * iGemValue);
   }
   return iGold;
}

void SRM_CreateGem(object oTarget, int nTreasureType, int nHD = 1)
{
    /*
    int iGold = SRM_GetGoldValue(nHD, nTreasureType);

    if (iGold>=30000) iGold = SRM_GoldToGem(oTarget, iGold, 30000, "gem_30000");
    if (iGold>=20000) iGold = SRM_GoldToGem(oTarget, iGold, 20000, "gem_20000");
    if (iGold>=10000) iGold = SRM_GoldToGem(oTarget, iGold, 10000, "gem_10000");
    if (iGold>= 5000) iGold = SRM_GoldToGem(oTarget, iGold,  5000, "gem_5000");
    if (iGold>= 4000) iGold = SRM_GoldToGem(oTarget, iGold,  4000, "nw_it_gem012");
    if (iGold>= 3000) iGold = SRM_GoldToGem(oTarget, iGold,  3000, "nw_it_gem006");
    if (iGold>= 2000) iGold = SRM_GoldToGem(oTarget, iGold,  2000, "nw_it_gem005");
    if (iGold>= 1500) iGold = SRM_GoldToGem(oTarget, iGold,  1500, "nw_it_gem009");
    if (iGold>= 1000) iGold = SRM_GoldToGem(oTarget, iGold,  1000, "nw_it_gem008");
    if (iGold>=  250) iGold = SRM_GoldToGem(oTarget, iGold,   250, "nw_it_gem010");
    if (iGold>=  145) iGold = SRM_GoldToGem(oTarget, iGold,   145, "nw_it_gem013");
    if (iGold>=  120) iGold = SRM_GoldToGem(oTarget, iGold,   120, "nw_it_gem011");
    */
}

object SRM_CreateJewel(object oTarget, int nTreasureType, int nHD = 1) {
   string sJewel = "nw_it_mring021";
   return CreateItemOnObject(sJewel, oTarget, 1);
}

string SRM_PickArcaneScroll(int nLvl = 1) {
   int nRandom = 0;
   string sScroll = "";
   if (nLvl==1) {
      nRandom = Random(23) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr101"; break;    case 13: sScroll = "nw_it_sparscr113"; break;
         case  2: sScroll = "nw_it_sparscr102"; break;    case 14: sScroll = "nw_it_sparscr210"; break;
         case  3: sScroll = "nw_it_sparscr103"; break;    case 15: sScroll = "x1_it_sparscr101"; break;
         case  4: sScroll = "nw_it_sparscr104"; break;    case 16: sScroll = "x1_it_sparscr102"; break;
         case  5: sScroll = "nw_it_sparscr105"; break;    case 17: sScroll = "x1_it_sparscr103"; break;
         case  6: sScroll = "nw_it_sparscr106"; break;    case 18: sScroll = "x1_it_sparscr104"; break;
         case  7: sScroll = "nw_it_sparscr107"; break;    case 19: sScroll = "x2_it_sparscr101"; break;
         case  8: sScroll = "nw_it_sparscr108"; break;    case 20: sScroll = "x2_it_sparscr102"; break;
         case  9: sScroll = "nw_it_sparscr109"; break;    case 21: sScroll = "x2_it_sparscr103"; break;
         case 10: sScroll = "nw_it_sparscr110"; break;    case 22: sScroll = "x2_it_sparscr104"; break;
         case 11: sScroll = "nw_it_sparscr111"; break;    case 23: sScroll = "x2_it_sparscr105"; break;
         case 12: sScroll = "nw_it_sparscr112"; break;
      }
   } else if (nLvl==2) {
      nRandom = Random(29) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr201"; break;    case 16: sScroll = "nw_it_sparscr218"; break;
         case  2: sScroll = "nw_it_sparscr202"; break;    case 17: sScroll = "nw_it_sparscr219"; break;
         case  3: sScroll = "nw_it_sparscr203"; break;    case 18: sScroll = "nw_it_sparscr220"; break;
         case  4: sScroll = "nw_it_sparscr204"; break;    case 19: sScroll = "nw_it_sparscr221"; break;
         case  5: sScroll = "nw_it_sparscr205"; break;    case 20: sScroll = "x1_it_sparscr201"; break;
         case  6: sScroll = "nw_it_sparscr206"; break;    case 21: sScroll = "x1_it_sparscr202"; break;
         case  7: sScroll = "nw_it_sparscr207"; break;    case 22: sScroll = "x1_it_sparscr301"; break;
         case  8: sScroll = "nw_it_sparscr208"; break;    case 23: sScroll = "x2_it_sparscr201"; break;
         case  9: sScroll = "nw_it_sparscr209"; break;    case 24: sScroll = "x2_it_sparscr201"; break;
         case 10: sScroll = "nw_it_sparscr211"; break;    case 25: sScroll = "x2_it_sparscr203"; break;
         case 11: sScroll = "nw_it_sparscr212"; break;    case 26: sScroll = "x2_it_sparscr204"; break;
         case 12: sScroll = "nw_it_sparscr213"; break;    case 27: sScroll = "x2_it_sparscr205"; break;
         case 13: sScroll = "nw_it_sparscr214"; break;    case 28: sScroll = "x2_it_sparscr206"; break;
         case 14: sScroll = "nw_it_sparscr215"; break;    case 29: sScroll = "x2_it_sparscr207"; break;
         case 15: sScroll = "nw_it_sparscr216"; break;
      }
   } else if (nLvl==3) {
      nRandom = Random(26) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr217"; break;    case 14: sScroll = "nw_it_sparscr313"; break;
         case  2: sScroll = "nw_it_sparscr301"; break;    case 15: sScroll = "nw_it_sparscr314"; break;
         case  3: sScroll = "nw_it_sparscr302"; break;    case 16: sScroll = "nw_it_sparscr315"; break;
         case  4: sScroll = "nw_it_sparscr303"; break;    case 17: sScroll = "nw_it_spdvscr301"; break;
         case  5: sScroll = "nw_it_sparscr304"; break;    case 18: sScroll = "x1_it_sparscr301"; break;
         case  6: sScroll = "nw_it_sparscr305"; break;    case 19: sScroll = "x1_it_sparscr302"; break;
         case  7: sScroll = "nw_it_sparscr306"; break;    case 20: sScroll = "x1_it_sparscr303"; break;
         case  8: sScroll = "nw_it_sparscr307"; break;    case 21: sScroll = "x2_it_sparscr301"; break;
         case  9: sScroll = "nw_it_sparscr308"; break;    case 22: sScroll = "x2_it_sparscr302"; break;
         case 10: sScroll = "nw_it_sparscr309"; break;    case 23: sScroll = "x2_it_sparscr303"; break;
         case 11: sScroll = "nw_it_sparscr310"; break;    case 24: sScroll = "x2_it_sparscr304"; break;
         case 12: sScroll = "nw_it_sparscr311"; break;    case 25: sScroll = "x2_it_sparscr305"; break;
         case 13: sScroll = "nw_it_sparscr312"; break;    case 26: sScroll =  "x2_it_sparscrmc"; break;
      }
   } else if (nLvl==4) {
      nRandom = Random(20) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr401"; break;    case 11: sScroll = "nw_it_sparscr411"; break;
         case  2: sScroll = "nw_it_sparscr402"; break;    case 12: sScroll = "nw_it_sparscr412"; break;
         case  3: sScroll = "nw_it_sparscr403"; break;    case 13: sScroll = "nw_it_sparscr413"; break;
         case  4: sScroll = "nw_it_sparscr404"; break;    case 14: sScroll = "nw_it_sparscr414"; break;
         case  5: sScroll = "nw_it_sparscr405"; break;    case 15: sScroll = "nw_it_sparscr415"; break;
         case  6: sScroll = "nw_it_sparscr406"; break;    case 16: sScroll = "nw_it_sparscr416"; break;
         case  7: sScroll = "nw_it_sparscr407"; break;    case 17: sScroll = "nw_it_sparscr417"; break;
         case  8: sScroll = "nw_it_sparscr408"; break;    case 18: sScroll = "nw_it_sparscr418"; break;
         case  9: sScroll = "nw_it_sparscr409"; break;    case 19: sScroll = "x1_it_sparscr401"; break;
         case 10: sScroll = "nw_it_sparscr410"; break;    case 20: sScroll = "x2_it_sparscr401"; break;
      }
   } else if (nLvl==5) {
      nRandom = Random(18) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr501"; break;    case 10: sScroll = "nw_it_sparscr510"; break;
         case  2: sScroll = "nw_it_sparscr502"; break;    case 11: sScroll = "nw_it_sparscr511"; break;
         case  3: sScroll = "nw_it_sparscr503"; break;    case 12: sScroll = "nw_it_sparscr512"; break;
         case  4: sScroll = "nw_it_sparscr504"; break;    case 13: sScroll = "nw_it_sparscr513"; break;
         case  5: sScroll = "nw_it_sparscr505"; break;    case 14: sScroll = "x1_it_sparscr501"; break;
         case  6: sScroll = "nw_it_sparscr506"; break;    case 15: sScroll = "x1_it_sparscr502"; break;
         case  7: sScroll = "nw_it_sparscr507"; break;    case 16: sScroll = "x2_it_sparscr501"; break;
         case  8: sScroll = "nw_it_sparscr508"; break;    case 17: sScroll = "x2_it_sparscr502"; break;
         case  9: sScroll = "nw_it_sparscr509"; break;    case 18: sScroll = "x2_it_sparscr503"; break;
      }
   } else if (nLvl==6) {
      nRandom = Random(24) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr601"; break;    case 13: sScroll = "nw_it_sparscr613"; break;
         case  2: sScroll = "nw_it_sparscr602"; break;    case 14: sScroll = "nw_it_sparscr614"; break;
         case  3: sScroll = "nw_it_sparscr603"; break;    case 15: sScroll = "x1_it_sparscr601"; break;
         case  4: sScroll = "nw_it_sparscr604"; break;    case 16: sScroll = "x1_it_sparscr602"; break;
         case  5: sScroll = "nw_it_sparscr605"; break;    case 17: sScroll = "x1_it_sparscr603"; break;
         case  6: sScroll = "nw_it_sparscr606"; break;    case 18: sScroll = "x1_it_sparscr604"; break;
         case  7: sScroll = "nw_it_sparscr607"; break;    case 19: sScroll = "x1_it_sparscr605"; break;
         case  8: sScroll = "nw_it_sparscr608"; break;    case 20: sScroll = "x1_it_spdvscr601"; break;
         case  9: sScroll = "nw_it_sparscr609"; break;    case 21: sScroll = "x1_it_spdvscr602"; break;
         case 10: sScroll = "nw_it_sparscr610"; break;    case 22: sScroll = "x1_it_spdvscr605"; break;
         case 11: sScroll = "nw_it_sparscr611"; break;    case 23: sScroll = "x2_it_sparscr601"; break;
         case 12: sScroll = "nw_it_sparscr612"; break;    case 24: sScroll = "x2_it_sparscr602"; break;
      }
   } else if (nLvl==7) {
      nRandom = Random(12) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr701"; break;    case  7: sScroll = "nw_it_sparscr707"; break;
         case  2: sScroll = "nw_it_sparscr702"; break;    case  8: sScroll = "nw_it_sparscr708"; break;
         case  3: sScroll = "nw_it_sparscr703"; break;    case  9: sScroll = "nw_it_sparscr802"; break;
         case  4: sScroll = "nw_it_sparscr704"; break;    case 10: sScroll = "x1_it_sparscr701"; break;
         case  5: sScroll = "nw_it_sparscr705"; break;    case 11: sScroll = "x2_it_sparscr701"; break;
         case  6: sScroll = "nw_it_sparscr706"; break;    case 12: sScroll = "x2_it_sparscr703"; break;
      }
   } else if (nLvl==8) {
      nRandom = Random(11) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr801"; break;    case  7: sScroll = "nw_it_sparscr808"; break;
         case  2: sScroll = "nw_it_sparscr803"; break;    case  8: sScroll = "nw_it_sparscr809"; break;
         case  3: sScroll = "nw_it_sparscr804"; break;    case  9: sScroll = "x1_it_sparscr801"; break;
         case  4: sScroll = "nw_it_sparscr805"; break;    case 10: sScroll = "x1_it_spdvscr802"; break;
         case  5: sScroll = "nw_it_sparscr806"; break;    case 11: sScroll = "x2_it_sparscr801"; break;
         case  6: sScroll = "nw_it_sparscr807"; break;
      }
   } else if (nLvl==9) {
      nRandom = Random(15) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr901"; break;    case  9: sScroll = "nw_it_sparscr909"; break;
         case  2: sScroll = "nw_it_sparscr902"; break;    case 10: sScroll = "nw_it_sparscr910"; break;
         case  3: sScroll = "nw_it_sparscr903"; break;    case 11: sScroll = "nw_it_sparscr911"; break;
         case  4: sScroll = "nw_it_sparscr904"; break;    case 12: sScroll = "nw_it_sparscr912"; break;
         case  5: sScroll = "nw_it_sparscr905"; break;    case 13: sScroll = "x1_it_sparscr901"; break;
         case  6: sScroll = "nw_it_sparscr906"; break;    case 14: sScroll = "x2_it_sparscr901"; break;
         case  7: sScroll = "nw_it_sparscr907"; break;    case 15: sScroll = "x2_it_sparscr902"; break;
         case  8: sScroll = "nw_it_sparscr908"; break;
      }
   }
   return sScroll;
}

string SRM_PickDivineScroll(int nLvl = 1) {
   int nRandom = 0;
   string sScroll = "";
   if (nLvl==1) {
      nRandom = Random(18) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr102"; break;     case 10: sScroll = "x2_it_sparscr105"; break;
         case  2: sScroll = "nw_it_sparscr105"; break;     case 11: sScroll = "x2_it_spdvscr101"; break;
         case  3: sScroll = "x1_it_spdvscr101"; break;     case 12: sScroll = "x2_it_spdvscr102"; break;
         case  4: sScroll = "x1_it_spdvscr102"; break;     case 13: sScroll = "x2_it_spdvscr103"; break;
         case  5: sScroll = "x1_it_spdvscr103"; break;     case 14: sScroll = "x2_it_spdvscr104"; break;
         case  6: sScroll = "x1_it_spdvscr104"; break;     case 15: sScroll = "x2_it_spdvscr105"; break;
         case  7: sScroll = "x1_it_spdvscr105"; break;     case 16: sScroll = "x2_it_spdvscr106"; break;
         case  8: sScroll = "x1_it_spdvscr106"; break;     case 17: sScroll = "x2_it_spdvscr107"; break;
         case  9: sScroll = "x1_it_spdvscr107"; break;     case 18: sScroll = "x2_it_spdvscr108"; break;
      }
   } else if (nLvl==2) {
      nRandom = Random(20) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr203"; break;     case 11: sScroll = "x1_it_spdvscr202"; break;
         case  2: sScroll = "nw_it_sparscr206"; break;     case 12: sScroll = "x1_it_spdvscr203"; break;
         case  3: sScroll = "nw_it_sparscr214"; break;     case 13: sScroll = "x1_it_spdvscr204"; break;
         case  4: sScroll = "nw_it_sparscr218"; break;     case 14: sScroll = "x1_it_spdvscr205"; break;
         case  5: sScroll = "nw_it_spdvscr201"; break;     case 15: sScroll = "x2_it_sparscr204"; break;
         case  6: sScroll = "nw_it_spdvscr202"; break;     case 16: sScroll = "x2_it_spdvscr201"; break;
         case  7: sScroll = "nw_it_spdvscr203"; break;     case 17: sScroll = "x2_it_spdvscr202"; break;
         case  8: sScroll = "nw_it_spdvscr204"; break;     case 18: sScroll = "x2_it_spdvscr203"; break;
         case  9: sScroll = "x1_it_sparscr301"; break;     case 19: sScroll = "x2_it_spdvscr204"; break;
         case 10: sScroll = "x1_it_spdvscr201"; break;     case 20: sScroll = "x2_it_spdvscr205"; break;
      }
   } else if (nLvl==3) {
      nRandom = Random(21) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr301"; break;     case 12: sScroll = "x2_it_spdvscr304"; break;
         case  2: sScroll = "nw_it_sparscr306"; break;     case 13: sScroll = "x2_it_spdvscr305"; break;
         case  3: sScroll = "nw_it_spdvscr301"; break;     case 14: sScroll = "x2_it_spdvscr306"; break;
         case  4: sScroll = "nw_it_spdvscr302"; break;     case 15: sScroll = "x2_it_spdvscr307"; break;
         case  5: sScroll = "x1_it_spdvscr302"; break;     case 16: sScroll = "x2_it_spdvscr308"; break;
         case  6: sScroll = "x1_it_spdvscr303"; break;     case 17: sScroll = "x2_it_spdvscr309"; break;
         case  7: sScroll = "x1_it_spdvscr304"; break;     case 18: sScroll = "x2_it_spdvscr310"; break;
         case  8: sScroll = "x1_it_spdvscr305"; break;     case 19: sScroll = "x2_it_spdvscr311"; break;
         case  9: sScroll = "x2_it_spdvscr301"; break;     case 20: sScroll = "x2_it_spdvscr312"; break;
         case 10: sScroll = "x2_it_spdvscr302"; break;     case 21: sScroll = "x2_it_spdvscr313"; break;
         case 11: sScroll = "x2_it_spdvscr303"; break;
      }
   } else if (nLvl==4) {
      nRandom = Random(15) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr404"; break;     case  9: sScroll = "x2_it_spdvscr401"; break;
         case  2: sScroll = "nw_it_sparscr411"; break;     case 10: sScroll = "x2_it_spdvscr402"; break;
         case  3: sScroll = "nw_it_sparscr414"; break;     case 11: sScroll = "x2_it_spdvscr403"; break;
         case  4: sScroll = "nw_it_spdvscr401"; break;     case 12: sScroll = "x2_it_spdvscr404"; break;
         case  5: sScroll = "nw_it_spdvscr402"; break;     case 13: sScroll = "x2_it_spdvscr405"; break;
         case  6: sScroll = "x1_it_spdvscr401"; break;     case 14: sScroll = "x2_it_spdvscr406"; break;
         case  7: sScroll = "x1_it_spdvscr402"; break;     case 15: sScroll = "x2_it_spdvscr407"; break;
         case  8: sScroll = "x2_it_sparscr401"; break;
      }
   } else if (nLvl==5) {
      nRandom = Random(17) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr501"; break;     case  9: sScroll = "x2_it_spdvscr503"; break;
         case  2: sScroll = "nw_it_sparscr510"; break;     case 10: sScroll = "x2_it_spdvscr504"; break;
         case  3: sScroll = "nw_it_spdvscr501"; break;     case 11: sScroll = "x2_it_spdvscr505"; break;
         case  4: sScroll = "x1_it_spdvscr403"; break;     case 12: sScroll = "x2_it_spdvscr506"; break;
         case  5: sScroll = "x1_it_spdvscr501"; break;     case 13: sScroll = "x2_it_spdvscr507"; break;
         case  6: sScroll = "x1_it_spdvscr502"; break;     case 14: sScroll = "x2_it_spdvscr508"; break;
         case  7: sScroll = "x2_it_spdvscr501"; break;     case 15: sScroll = "x2_it_spdvscr509"; break;
         case  8: sScroll = "x2_it_spdvscr502"; break;     case 16: sScroll = "deathcharm"; break;
                                                           case 17: sScroll = "freedomcharm"; break;
      }
   } else if (nLvl==6) {
      nRandom = Random(11) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr605"; break;     case  7: sScroll = "x2_it_spdvscr602"; break;
         case  2: sScroll = "x1_it_spdvscr601"; break;     case  8: sScroll = "x2_it_spdvscr603"; break;
         case  3: sScroll = "x1_it_spdvscr603"; break;     case  9: sScroll = "x2_it_spdvscr604"; break;
         case  4: sScroll = "x1_it_spdvscr604"; break;     case 10: sScroll = "x2_it_spdvscr605"; break;
         case  5: sScroll = "x1_it_spdvscr605"; break;     case 11: sScroll = "x2_it_spdvscr606"; break;
         case  6: sScroll = "x2_it_spdvscr601"; break;
      }
   } else if (nLvl==7) {
      nRandom = Random(7) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr703"; break;     case  5: sScroll = "x1_it_spdvscr702"; break;
         case  2: sScroll = "nw_it_spdvscr701"; break;     case  6: sScroll = "x1_it_spdvscr703"; break;
         case  3: sScroll = "nw_it_spdvscr702"; break;     case  7: sScroll = "x2_it_spdvscr702"; break;
         case  4: sScroll = "x1_it_spdvscr701"; break;
      }
   } else if (nLvl==8) {
      nRandom = Random(10) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr805"; break;     case  6: sScroll = "x1_it_spdvscr804"; break;
         case  2: sScroll = "x1_it_spdvscr704"; break;     case  7: sScroll = "x2_it_spdvscr801"; break;
         case  3: sScroll = "x1_it_spdvscr801"; break;     case  8: sScroll = "x2_it_spdvscr802"; break;
         case  4: sScroll = "x1_it_spdvscr802"; break;     case  9: sScroll = "x2_it_spdvscr803"; break;
         case  5: sScroll = "x1_it_spdvscr803"; break;     case 10: sScroll = "x2_it_spdvscr804"; break;
      }
   } else if (nLvl==9) {
      nRandom = Random(5) + 1;
      switch (nRandom) {
         case  1: sScroll = "nw_it_sparscr904"; break;     case  4: sScroll = "x2_it_spdvscr902"; break;
         case  2: sScroll = "x1_it_spdvscr901"; break;     case  5: sScroll = "x2_it_spdvscr903"; break;
         case  3: sScroll = "x2_it_spdvscr901"; break;
      }
   }
   return sScroll;
}

object SRM_CreateArcaneScroll(object oTarget, int nHD = 1) {
   string sScroll = SRM_PickArcaneScroll(SRM_PickScrollLevel(nHD));
   return CreateItemOnObject(sScroll, oTarget, d4());
}

object SRM_CreateDivineScroll(object oTarget, int nHD = 1) {
   string sScroll = SRM_PickDivineScroll(SRM_PickScrollLevel(nHD));
   return CreateItemOnObject(sScroll, oTarget, d4());
}

object SRM_CreateAmmo(object oTarget, int nHD = 1) {
   string sAmmo = "";
   if (SRM_GetRange(1, nHD)) {
      int nRandom = Random(42) + 1;
      switch (nRandom) {
          case  1: sAmmo = "nw_wammbo008"; break;    case 22: sAmmo = "nw_wammbu001"; break;
          case  2: sAmmo = "nw_wammar009"; break;    case 23: sAmmo = "nw_wammar011"; break;
          case  3: sAmmo = "nw_wammbu008"; break;    case 24: sAmmo = "nw_wammbo010"; break;
          case  4: sAmmo = "nw_wammbo002"; break;    case 25: sAmmo = "nw_wammbu010"; break;
          case  5: sAmmo = "nw_wammbo001"; break;    case 26: sAmmo = "nw_wammbu003"; break;
          case  6: sAmmo = "nw_wammbu009"; break;    case 27: sAmmo = "nw_wammbu002"; break;
          case  7: sAmmo = "nw_wammbo009"; break;    case 28: sAmmo = "nw_wthmax002"; break;
          case  8: sAmmo = "nw_wammar010"; break;    case 29: sAmmo = "nw_wthmdt002"; break;
          case  9: sAmmo = "nw_wammar001"; break;    case 30: sAmmo = "nw_wthmsh002"; break;
          case 10: sAmmo = "nw_wammbo003"; break;    case 31: sAmmo = "nw_wthmsh006"; break;
          case 11: sAmmo = "nw_wammar006"; break;    case 32: sAmmo = "nw_wthmax005"; break;
          case 12: sAmmo = "nw_wammbo004"; break;    case 33: sAmmo = "nw_wthmax008"; break;
          case 13: sAmmo = "nw_wammar005"; break;    case 34: sAmmo = "nw_wthmax007"; break;
          case 14: sAmmo = "nw_wammar002"; break;    case 35: sAmmo = "nw_wthmdt008"; break;
          case 15: sAmmo = "nw_wammar003"; break;    case 36: sAmmo = "nw_wthmdt003"; break;
          case 16: sAmmo = "nw_wammar004"; break;    case 37: sAmmo = "nw_wthmdt005"; break;
          case 17: sAmmo = "nw_wammbu004"; break;    case 38: sAmmo = "nw_wthmdt006"; break;
          case 18: sAmmo = "nw_wammbu006"; break;    case 39: sAmmo = "nw_wthmsh007"; break;
          case 19: sAmmo = "nw_wammbo005"; break;    case 40: sAmmo = "nw_wthmsh008"; break;
          case 20: sAmmo = "nw_wammbu007"; break;    case 41: sAmmo = "nw_wthmsh003"; break;
          case 21: sAmmo = "nw_wammbu005"; break;    case 42: sAmmo = "nw_wthmsh005"; break;
      }
   } else if (SRM_GetRange(2, nHD)) {
      int nRandom = Random(37) + 1;
      switch (nRandom) {
          case  1: sAmmo = "nw_wammar006"; break;    case 20: sAmmo = "x2_wammar012"; break;
          case  2: sAmmo = "nw_wammbo004"; break;    case 21: sAmmo = "x2_wammbo011"; break;
          case  3: sAmmo = "nw_wammar005"; break;    case 22: sAmmo = "x2_wammbu009"; break;
          case  4: sAmmo = "nw_wammar002"; break;    case 23: sAmmo = "nw_wthmax009"; break;
          case  5: sAmmo = "nw_wammar003"; break;    case 24: sAmmo = "nw_wthmdt009"; break;
          case  6: sAmmo = "nw_wammar004"; break;    case 25: sAmmo = "nw_wthmdt004"; break;
          case  7: sAmmo = "nw_wammbu004"; break;    case 26: sAmmo = "nw_wthmsh009"; break;
          case  8: sAmmo = "nw_wammbu006"; break;    case 27: sAmmo = "nw_wthmsh004"; break;
          case  9: sAmmo = "nw_wammbo005"; break;    case 28: sAmmo = "x0_wthmax001"; break;
          case 10: sAmmo = "nw_wammbu007"; break;    case 29: sAmmo = "nw_wthmax006"; break;
          case 11: sAmmo = "nw_wammbu005"; break;    case 30: sAmmo = "nw_wthmax004"; break;
          case 12: sAmmo = "nw_wammbu001"; break;    case 31: sAmmo = "nw_wthmax003"; break;
          case 13: sAmmo = "nw_wammar011"; break;    case 32: sAmmo = "x0_wthmdt001"; break;
          case 14: sAmmo = "nw_wammbo010"; break;    case 33: sAmmo = "x0_wthmsh001"; break;
          case 15: sAmmo = "nw_wammbu010"; break;    case 34: sAmmo = "x0_wthmax002"; break;
          case 16: sAmmo = "nw_wammbu003"; break;    case 35: sAmmo = "nw_wthmdt007"; break;
          case 17: sAmmo = "nw_wammbu002"; break;    case 36: sAmmo = "x0_wthmdt002"; break;
          case 18: sAmmo = "nw_wammbo006"; break;    case 37: sAmmo = "x0_wthmsh002"; break;
          case 19: sAmmo = "nw_wammar007"; break;
      }
   } else {
      int nRandom = Random(17) + 1;
      switch (nRandom) {
          case  1: sAmmo = "x2_wammar012"; break;    case 11: sAmmo = "x0_wthmax002"; break;
          case  2: sAmmo = "x2_wammbo011"; break;    case 12: sAmmo = "nw_wthmdt007"; break;
          case  3: sAmmo = "x2_wammbu009"; break;    case 13: sAmmo = "x0_wthmdt002"; break;
          case  4: sAmmo = "x2_wammbo001"; break;    case 14: sAmmo = "x0_wthmsh002"; break;
          case  5: sAmmo = "x2_wammar013"; break;    case 15: sAmmo = "x2_wthmax003"; break;
          case  6: sAmmo = "x2_wammbo012"; break;    case 16: sAmmo = "x2_wthmdt003"; break;
          case  7: sAmmo = "x2_wammbu010"; break;    case 17: sAmmo = "x2_wthmsh003"; break;
          case  8: sAmmo = "nw_wammbo007"; break;    case 18: sAmmo = "x2_wthmax004"; break;
          case  9: sAmmo = "nw_wammar008"; break;    case 19: sAmmo = "x2_wthmdt004"; break;
          case 10: sAmmo = "x2_wammar001"; break;    case 20: sAmmo = "x2_wthmsh004"; break;
      }
   }
   return CreateItemOnObject(sAmmo, oTarget, Random(49) + 50);
}

object SRM_CreateTrapKit(object oTarget, int nHD = 1) {
   string sKit = "";
   if (SRM_GetRange(1, nHD)) {
      int nRandom = Random(30) + 1;
      switch (nRandom) {
          case  1: sKit = "nw_it_trap001"; break;    case 16: sKit = "nw_it_trap031"; break;
          case  2: sKit = "nw_it_trap002"; break;    case 17: sKit = "nw_it_trap039"; break;
          case  3: sKit = "nw_it_trap033"; break;    case 18: sKit = "nw_it_trap013"; break;
          case  4: sKit = "nw_it_trap029"; break;    case 19: sKit = "nw_it_trap007"; break;
          case  5: sKit = "nw_it_trap037"; break;    case 20: sKit = "nw_it_trap043"; break;
          case  6: sKit = "nw_it_trap003"; break;    case 21: sKit = "nw_it_trap010"; break;
          case  7: sKit = "nw_it_trap005"; break;    case 22: sKit = "nw_it_trap040"; break;
          case  8: sKit = "nw_it_trap041"; break;    case 23: sKit = "nw_it_trap036"; break;
          case  9: sKit = "nw_it_trap009"; break;    case 24: sKit = "nw_it_trap017"; break;
          case 10: sKit = "nw_it_trap034"; break;    case 25: sKit = "nw_it_trap032"; break;
          case 11: sKit = "nw_it_trap030"; break;    case 26: sKit = "nw_it_trap011"; break;
          case 12: sKit = "nw_it_trap038"; break;    case 27: sKit = "nw_it_trap014"; break;
          case 13: sKit = "nw_it_trap006"; break;    case 28: sKit = "nw_it_trap008"; break;
          case 14: sKit = "nw_it_trap042"; break;    case 29: sKit = "nw_it_trap044"; break;
          case 15: sKit = "nw_it_trap035"; break;    case 30: sKit = "nw_it_trap021"; break;
       }
   } else if (SRM_GetRange(2, nHD)) {
      int nRandom = Random(21) + 1;
      switch (nRandom) {
          case  1: sKit = "nw_it_trap040"; break;    case 12: sKit = "nw_it_trap012"; break;
          case  2: sKit = "nw_it_trap036"; break;    case 13: sKit = "nw_it_trap025"; break;
          case  3: sKit = "nw_it_trap017"; break;    case 14: sKit = "x2_it_trap004"; break;
          case  4: sKit = "nw_it_trap032"; break;    case 15: sKit = "x2_it_trap003"; break;
          case  5: sKit = "nw_it_trap011"; break;    case 16: sKit = "nw_it_trap022"; break;
          case  6: sKit = "nw_it_trap014"; break;    case 17: sKit = "nw_it_trap019"; break;
          case  7: sKit = "nw_it_trap008"; break;    case 18: sKit = "nw_it_trap016"; break;
          case  8: sKit = "nw_it_trap044"; break;    case 19: sKit = "nw_it_trap023"; break;
          case  9: sKit = "nw_it_trap021"; break;    case 20: sKit = "nw_it_trap026"; break;
          case 10: sKit = "nw_it_trap015"; break;    case 21: sKit = "nw_it_trap020"; break;
          case 11: sKit = "nw_it_trap018"; break;
      }
  } else {
      int nRandom = Random(15) + 1;
      switch (nRandom) {
          case  1: sKit = "nw_it_trap025"; break;    case  9: sKit = "nw_it_trap020"; break;
          case  2: sKit = "x2_it_trap004"; break;    case 10: sKit = "nw_it_trap004"; break;
          case  3: sKit = "x2_it_trap003"; break;    case 11: sKit = "nw_it_trap027"; break;
          case  4: sKit = "nw_it_trap022"; break;    case 12: sKit = "nw_it_trap024"; break;
          case  5: sKit = "nw_it_trap019"; break;    case 13: sKit = "nw_it_trap028"; break;
          case  6: sKit = "nw_it_trap016"; break;    case 14: sKit = "x2_it_trap002"; break;
          case  7: sKit = "nw_it_trap023"; break;    case 15: sKit = "x2_it_trap001"; break;
          case  8: sKit = "nw_it_trap026"; break;
      }
   }
   return CreateItemOnObject(sKit, oTarget, 1);
}

object SRM_CreateHealingKit(object oTarget, int nHD = 1) {
  nHD = Random(100) + nHD;
  string sKit = "";
  if (nHD<25)      sKit = "nw_it_medkit001";
  else if (nHD<50) sKit = "nw_it_medkit002";
  else if (nHD<75) sKit = "nw_it_medkit003";
  else             sKit = "nw_it_medkit004";
  return CreateItemOnObject(sKit, oTarget, d4());
}

object SRM_CreateLockPick(object oTarget, int nHD = 1) {
  nHD = Random(100) + nHD;
  string sKit = "";
  if (nHD<16)      sKit = "nw_it_picks001";
  else if (nHD<32) sKit = "nw_it_picks002";
  else if (nHD<48) sKit = "nw_it_picks003";
  else if (nHD<64) sKit = "x2_it_picks001";
  else if (nHD<80) sKit = "nw_it_picks004";
  else             sKit = "x2_it_picks002";
  return CreateItemOnObject(sKit, oTarget, d4());
}

object SRM_CreatePoison(object oTarget) {
   string sPoison = "";
   int nRandom = Random(18) + 1;
   switch (nRandom) {
      case  1: sPoison = "x2_it_poison007"; break;    case 10: sPoison = "x2_it_poison025"; break;
      case  2: sPoison = "x2_it_poison008"; break;    case 11: sPoison = "x2_it_poison026"; break;
      case  3: sPoison = "x2_it_poison009"; break;    case 12: sPoison = "x2_it_poison027"; break;
      case  4: sPoison = "x2_it_poison013"; break;    case 13: sPoison = "x2_it_poison031"; break;
      case  5: sPoison = "x2_it_poison014"; break;    case 14: sPoison = "x2_it_poison032"; break;
      case  6: sPoison = "x2_it_poison015"; break;    case 15: sPoison = "x2_it_poison033"; break;
      case  7: sPoison = "x2_it_poison019"; break;    case 16: sPoison = "x2_it_poison037"; break;
      case  8: sPoison = "x2_it_poison020"; break;    case 17: sPoison = "x2_it_poison038"; break;
      case  9: sPoison = "x2_it_poison021"; break;    case 18: sPoison = "x2_it_poison039"; break;
   }
   return CreateItemOnObject(sPoison, oTarget, d4());
}

object SRM_CreateKit(object oTarget, int nHD = 1) {
   object oItem;
   switch (d4()) {
      case 1: oItem=SRM_CreateTrapKit(oTarget, nHD); break;
      case 2: oItem=SRM_CreatePoison(oTarget); break;
      case 3: oItem=SRM_CreateLockPick(oTarget, nHD); break;
      case 4: oItem=SRM_CreateHealingKit(oTarget, nHD); break;
   }
   return oItem;
}

object SRM_CreatePotion(object oTarget, int nHD = 1, int nStack = 1) {
   string sPotion = "";
   int nRandom = Random(50) + 1;
   nStack = 4+d6();
   switch (nRandom) {
      case  1: sPotion = "nw_it_mpotion001"; break;     case 26: sPotion = "ptn_displace";     break;
      case  2: sPotion = "nw_it_mpotion020"; break;     case 27: sPotion = "ptn_drowsight";    break;
      case  3: sPotion = "nw_it_mpotion009"; break;     case 28: sPotion = "ptn_earthprt";     break;
      case  4: sPotion = "x2_it_mpotion001"; break;     case 29: sPotion = "ptn_eavesdrop";    break;
      case  5: sPotion = "nw_it_mpotion002"; break;     case 30: sPotion = "ptn_firebreath";   break;
      case  6: sPotion = "nw_it_mpotion005"; break;     case 31: sPotion = "ptn_fury";         break;
      case  7: sPotion = "nw_it_mpotion007"; break;     case 32: sPotion = "ptn_herocha";      break;
      case  8: sPotion = "nw_it_mpotion008"; break;     case 33: sPotion = "ptn_herocon";      break;
      case  9: sPotion = "nw_it_mpotion010"; break;     case 34: sPotion = "ptn_herodex";      break;
      case 10: sPotion = "nw_it_mpotion011"; break;     case 35: sPotion = "ptn_heroint";      break;
      case 11: sPotion = "nw_it_mpotion013"; break;     case 36: sPotion = "ptn_heroism";      break;
      case 12: sPotion = "nw_it_mpotion014"; break;     case 37: sPotion = "ptn_herostr";      break;
      case 13: sPotion = "nw_it_mpotion015"; break;     case 38: sPotion = "ptn_herowis";      break;
      case 14: sPotion = "nw_it_mpotion016"; break;     case 39: sPotion = "ptn_majelres";     break;
      case 15: sPotion = "nw_it_mpotion017"; break;     case 40: sPotion = "ptn_minelres";     break;
      case 16: sPotion = "nw_it_mpotion018"; break;     case 41: sPotion = "ptn_mystabs";      break;
      case 17: sPotion = "nw_it_mpotion019"; break;     case 42: sPotion = "ptn_mystprot";     break;
      case 18: sPotion = "x2_it_mpotion002"; break;     case 43: sPotion = "ptn_negprot";      break;
      case 19: sPotion = "nw_it_mpotion003"; break;     case 44: sPotion = "ptn_rallycry";     break;
      case 20: sPotion = "nw_it_mpotion004"; break;     case 45: sPotion = "ptn_rogscunn";     break;
      case 21: sPotion = "nw_it_mpotion006"; break;     case 46: sPotion = "ptn_shielding";    break;
      case 22: sPotion = "nw_it_mpotion012"; break;     case 47: sPotion = "ptn_stingret";     break;
      case 23: sPotion = "ptn_burnretort";   break;     case 48: sPotion = "ptn_superhero";    break;
      case 24: sPotion = "ptn_clairvoy";     break;     case 49: sPotion = "ptn_traploc";      break;
      case 25: sPotion = "ptn_command";      break;     case 50: sPotion = "ptn_unfettered";   break;
   }
   return CreateItemOnObject(sPotion, oTarget, nStack);
}

object SRM_PickWeapon(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="") {
   string sItem = "";
   if (sType=="exotic") {
      switch (Random(2)) {
         case 0: sItem = PickOne("nw_wswbs001", "nw_wdbma001", "nw_wdbax001", "x2_wdwraxe001", "nw_wspka001", "nw_wswka001"); break;
         case 1: sItem = PickOne("nw_wspku001", "nw_wplsc001", "nw_wthsh001", "nw_wdbsw001", "x2_it_wpwhip"); break;
      }
   } else if (sType=="martial") {
      switch (Random(3)) {
         case 0: sItem = PickOne("nw_waxbt001", "nw_waxgr001", "nw_wswgs001", "nw_wplhb001", "nw_waxhn001", "nw_wblfh001"); break;
         case 1: sItem = PickOne("nw_wblfl001", "nw_wblhl001", "nw_wbwln001", "nw_wswls001", "nw_wswrp001", "nw_wswsc001"); break;
         case 2: sItem = PickOne("nw_wbwsh001", "nw_wswss001", "nw_wdbqs001", "nw_wthax001", "nw_wblhw001"); break;
      }
   } else if (sType=="simple") {
      switch (Random(2)) {
         case 0: sItem = PickOne("nw_wblcl001", "nw_wswdg001", "nw_wthdt001", "nw_wblml001", "nw_wspsc001", "nw_wplss001"); break;
         case 1: sItem = PickOne("nw_wblms001", "nw_wdbqs001", "nw_wbwxl001", "nw_wbwxh001", "nw_wbwsl001"); break;
      }
   } else { // assume we sent in a specific weapon to make
      sItem = sType;
   }
   object oItem = CreateItemOnObject(sItem, oTarget, 1, "SEED_VALIDATED");
   int nBaseType = GetBaseItemType(oItem);
   if (nBaseType==BASE_ITEM_DART || nBaseType==BASE_ITEM_SHURIKEN || nBaseType==BASE_ITEM_THROWINGAXE) SetItemStackSize(oItem, Random(25)+25);
   //SRM_AddBonuses(oItem, nLvl, nTreasureValue, nClass, sMagicType);

   if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE && !GetLocalInt(oTarget,"BOSS")) { // EQUIP MOB'S THAT ARE NOT BOSSES
      AssignCommand(oTarget, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
   }
   return oItem;
}

void SRM_vPickWeapon(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="") {
   SRM_PickWeapon(oTarget, nLvl, nTreasureValue, sType, nClass, sMagicType);
}

object SRM_PickArmor(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="") {
   string sItem = "";
   if (sType=="heavy") {
      sItem = PickOne("nw_aarcl005","nw_aarcl006","nw_aarcl007");
   } else if (sType=="medium") {
      sItem = PickOne("nw_aarcl008","nw_aarcl003","nw_aarcl004");
   } else if (sType=="light") {
      sItem = PickOne("flel_it_robe","nw_aarcl009","nw_aarcl001");
   } else if (sType=="shield") {
      sItem = PickOne("nw_ashsw001","nw_ashlw001","nw_ashto001");
   }
   object oItem = CreateItemOnObject(sItem, oTarget, 1, "SEED_VALIDATED");
   //SRM_AddBonuses(oItem, nLvl, nTreasureValue, nClass, sMagicType);
   if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE && !GetLocalInt(oTarget,"BOSS")) { // EQUIP MOB'S THAT ARE NOT BOSSES
      AssignCommand(oTarget, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
   }
   return oItem;
}

void SRM_vPickArmor(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="") {
   SRM_PickArmor(oTarget, nLvl, nTreasureValue, sType, nClass, sMagicType);
}

object SRM_PickClothes(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="") {
   string sItem = "";
   int iSlot = 0;
   if (sType=="belt")         { sItem = "flel_it_belt";     iSlot = INVENTORY_SLOT_BELT; }
   else if (sType=="boots")   { sItem = "flel_it_boots";    iSlot = INVENTORY_SLOT_BOOTS; }
   else if (sType=="bracers") { sItem = "flel_it_bracers";  iSlot = INVENTORY_SLOT_ARMS; }
   else if (sType=="cloak")   { sItem = "flel_it_cloak";    iSlot = INVENTORY_SLOT_CLOAK; }
   else if (sType=="helmet")  { sItem = "flel_it_helmet";   iSlot = INVENTORY_SLOT_HEAD; }
   object oItem = CreateItemOnObject(sItem, oTarget, 1, "SEED_VALIDATED");
   //SRM_AddBonuses(oItem, nLvl, nTreasureValue, nClass, sMagicType);
   if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE && !GetLocalInt(oTarget,"BOSS")) { // EQUIP MOB'S THAT ARE NOT BOSSES
      AssignCommand(oTarget, ActionEquipItem(oItem, iSlot));
   }

   return oItem;
}

void SRM_vPickClothes(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="") {
   SRM_PickClothes(oTarget, nLvl, nTreasureValue, sType, nClass, sMagicType);
}

object SRM_PickMagic(object oTarget, int nLvl, int nTreasureValue, string sType="", int nClass=CLASS_TYPE_INVALID, string sMagicType="") {
   string sItem = "";
   int iSlot = 0;
   if (sType=="amulet") {
      sItem = "flel_it_amulet";
      iSlot = INVENTORY_SLOT_NECK;
   } else if (sType=="ring") {
      sItem = "flel_it_ring";
      iSlot = INVENTORY_SLOT_RIGHTRING;
   }
   object oItem = CreateItemOnObject(sItem, oTarget, 1, "SEED_VALIDATED");
   //SRM_AddBonuses(oItem, nLvl, nTreasureValue, nClass, sMagicType);
   if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE && !GetLocalInt(oTarget,"BOSS")) { // EQUIP MOB'S THAT ARE NOT BOSSES
      AssignCommand(oTarget, ActionEquipItem(oItem, iSlot));
   }
   return oItem;
}

void SRM_vPickMagic(object oTarget, int nLvl, int nTreasureValue, string sType, int nClass=CLASS_TYPE_INVALID, string sMagicType="") {
   SRM_PickMagic(oTarget, nLvl, nTreasureValue, sType, nClass, sMagicType);
}

object SRM_CreateLevelingWeapon(object oMinion, object oKiller) {
   string sResRef = GetBaseWeaponResRef(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oKiller));
   if (sResRef=="") {
      if (GetHasFeat(FEAT_MONK_AC_BONUS, oKiller)) sResRef="flel_it_mgloves";
      else sResRef = PickOne("nw_wswrp001", "nw_wswsc001", "nw_wplsc001", "nw_wspka001", "nw_wswbs001");
   }
   object oItem = CreateItemOnObject(sResRef, oMinion, 1, "LEVELING_WEAPON");
   SetName(oItem, "Leveling " + GetName(oItem));
   SetLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM", 1);
   DelayCommand(180.f, DestroyObjectDropped(oItem));
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE), oItem);
   return oItem;
}

object SRM_CreateTable2Item(object oTarget, object oMinion, int nTreasureType, int nClass) {
   string sItem = "nw_it_msmlmisc20"; // fish
   string sPick = "";
   int nProbArmor = 25;
   int nProbWeapon = 25;
   int nProbMagic = 25;
   int nProbClothes = 25;
   int nHD = GetMax(SMS_ITEM_LEVEL_MAX, GetHitDice(oMinion) + nTreasureType);
   int nRandom = d100();
   //* SETUP probabilities based on Class
   if ( nClass == CLASS_TYPE_FIGHTER || nClass == CLASS_TYPE_PALADIN || nClass  == CLASS_TYPE_RANGER || nClass  == CLASS_TYPE_BARBARIAN) {
      nProbArmor = 30;
      nProbWeapon = 30;
      nProbMagic = 20;
      nProbClothes = 20;
   } else if (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER) {
      nProbArmor = 15;
      nProbWeapon = 15;
      nProbMagic = 35;
      nProbClothes = 35;
   } else if (nClass == CLASS_TYPE_CLERIC || nClass == CLASS_TYPE_DRUID) {
      nProbArmor = 35;
      nProbWeapon = 25;
      nProbMagic = 20;
      nProbClothes = 20;
   } else if (nClass == CLASS_TYPE_MONK) {
      nProbArmor = 5;
      nProbWeapon = 30;
      nProbMagic = 35;
      nProbClothes = 30;
   } else if (nClass == CLASS_TYPE_ROGUE || nClass == CLASS_TYPE_BARD) {
      nProbArmor = 20;
      nProbWeapon = 20;
      nProbMagic = 30;
      nProbClothes = 30;
   }
   //* Create Items based on Probabilities
   if (nRandom <= nProbArmor) {
      sPick = PickOne("shield", "light");
      if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY,oMinion)) sPick=PickOne("heavy","medium", "shield");
      else if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM,oMinion)) sPick=PickOne("medium","light", "shield");
      else if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT,oMinion)) sPick="light";
      return SRM_PickArmor(oTarget, nHD, nTreasureType, sPick);
   } else if (nRandom <= nProbArmor + nProbWeapon) {
      sPick = PickOne("exotic","martial","simple");
      if      (GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD   , oMinion)) sPick="nw_wswbs001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD      , oMinion)) sPick="nw_wswls001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE      , oMinion)) sPick="nw_waxbt001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW         , oMinion)) sPick="nw_wbwln001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_CLUB            , oMinion)) sPick="nw_wblcl001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR    , oMinion)) sPick="nw_wblms001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER          , oMinion)) sPick="nw_wswdg001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER          , oMinion)) sPick="nw_wswrp001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_DART            , oMinion)) sPick="nw_wthdt001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR        , oMinion)) sPick="nw_wswsc001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE       , oMinion)) sPick="nw_wdbma001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE          , oMinion)) sPick="nw_wplsc001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE      , oMinion)) sPick="nw_wdbax001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD     , oMinion)) sPick="nw_wswss001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE           , oMinion)) sPick="x2_wdwraxe001"; else if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW        , oMinion)) sPick="nw_wbwsh001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE       , oMinion)) sPick="nw_waxgr001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN        , oMinion)) sPick="nw_wthsh001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD     , oMinion)) sPick="nw_wswgs001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE          , oMinion)) sPick="nw_wspsc001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD         , oMinion)) sPick="nw_wplhb001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_SLING           , oMinion)) sPick="nw_wbwsl001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE        , oMinion)) sPick="nw_waxhn001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR           , oMinion)) sPick="nw_wplss001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW  , oMinion)) sPick="nw_wbwxh001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_STAFF           , oMinion)) sPick="nw_wdbqs001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL     , oMinion)) sPick="nw_wblfh001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE    , oMinion)) sPick="nw_wthax001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_KAMA            , oMinion)) sPick="nw_wspka001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oMinion)) sPick="nw_wdbsw001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_KATANA          , oMinion)) sPick="nw_wswka001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE  , oMinion)) sPick="flel_it_mgloves";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI           , oMinion)) sPick="nw_wspku001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER      , oMinion)) sPick="nw_wblhw001";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW  , oMinion)) sPick="nw_wbwxl001";   else if (GetHasFeat(FEAT_WEAPON_FOCUS_WHIP            , oMinion)) sPick="x2_it_wpwhip";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL     , oMinion)) sPick="nw_wblfl001";   else if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC    , oMinion)) sPick="exotic";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER    , oMinion)) sPick="nw_wblhl001";   else if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL   , oMinion)) sPick="martial";
      else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE      , oMinion)) sPick="nw_wblml001";   else if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE    , oMinion)) sPick="simple";
      return SRM_PickWeapon(oTarget, nHD, nTreasureType, sPick, nClass);
   } else if (nRandom <= nProbArmor + nProbWeapon + nProbMagic) {
      sPick = PickOne("amulet","ring","ring");
      return SRM_PickMagic(oTarget, nHD, nTreasureType, sPick, nClass);
   } else if (nRandom <= nProbArmor + nProbWeapon + nProbMagic + nProbClothes) {
      sPick = PickOne("belt","boots","bracers","cloak","helmet");
      return SRM_PickClothes(oTarget, nHD, nTreasureType, sPick, nClass);
   }
   return CreateItemOnObject(sItem, oTarget, 1);
}

void SRM_RandomTreasure(int nTreasureType, object oMinion, object oCreateOn) {

   return;

   if (GetIsObjectValid(oMinion)==FALSE) {
      return;
   }
   if (oCreateOn==OBJECT_INVALID) {
      return;
   }
    // * VARIABLES
   int nProbJunk =   0;
   int nProbGold = 0;
   int nProbGem = 0;
   int nProbStone = 0;
   int nProbScroll = 0;
   int nProbAmmo = 0;
   int nProbKit = 0;
   int nProbPotion = 0;
   int nProbTable2 = 0;
   int i = 0;
   int nNumberItems = SRM_GetNumberOfItems(nTreasureType);
   int nClass =  SRM_DetermineClassToUse(oMinion);
   int nHD = GetHitDice(oMinion);

   // * Set Treasure Type Values
   if (nTreasureType == TREASURE_LOW) {
      nProbJunk   = LOW_PROB_JUNK;
      nProbGold   = LOW_PROB_GOLD;
      nProbGem    = LOW_PROB_GEM;
      nProbStone  = LOW_PROB_STONE;
      nProbScroll = LOW_PROB_SCROLL;
      nProbAmmo = LOW_PROB_AMMO ;
      nProbKit = LOW_PROB_KIT;
      nProbPotion = LOW_PROB_POTION;
      nProbTable2 = LOW_PROB_TABLE2;
   } else if (nTreasureType == TREASURE_MEDIUM) {
      nProbJunk   = MEDIUM_PROB_JUNK;
      nProbGold   = MEDIUM_PROB_GOLD;
      nProbGem    = MEDIUM_PROB_GEM;
      nProbStone  = MEDIUM_PROB_STONE;
      nProbScroll = MEDIUM_PROB_SCROLL;
      nProbAmmo = MEDIUM_PROB_AMMO ;
      nProbKit = MEDIUM_PROB_KIT;
      nProbPotion = MEDIUM_PROB_POTION;
      nProbTable2 = MEDIUM_PROB_TABLE2;
   } else if (nTreasureType == TREASURE_HIGH) {
      nProbJunk   = HIGH_PROB_JUNK;
      nProbGold   = HIGH_PROB_GOLD;
      nProbGem    = HIGH_PROB_GEM;
      nProbStone  = HIGH_PROB_STONE;
      nProbScroll = HIGH_PROB_SCROLL;
      nProbAmmo = HIGH_PROB_AMMO ;
      nProbKit = HIGH_PROB_KIT;
      nProbPotion = HIGH_PROB_POTION;
      nProbTable2 = HIGH_PROB_TABLE2;
   } else if (nTreasureType == TREASURE_BOSS) {
      nProbTable2 = 100;
   }
   object oItem;
   for (i = 1; i <= nNumberItems; i++) {
      int nRandom = d100();
      //if (nRandom <= nProbTable2)
      //   oItem = SRM_CreateTable2Item(oCreateOn, oMinion, nTreasureType, nClass);   // * Weapons, Armor, Misc - Class based
      /*else */if (nRandom <= nProbTable2 + nProbGold)
         oItem = SRM_CreateGold(oCreateOn, nTreasureType, nHD);    // * Gold
      else if (nRandom <= nProbTable2 + nProbGold + nProbGem)
         SRM_CreateGem(oCreateOn, nTreasureType, nHD);     // * Gem
      /*else if (nRandom <= nProbTable2 + nProbGold + nProbGem + nProbStone)
         oItem = SMS_CreateStone(oCreateOn);*/
      else if (nRandom <= nProbTable2 + nProbGold + nProbGem + nProbStone + nProbScroll) // * Scroll
         if (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER) oItem = SRM_CreateArcaneScroll(oCreateOn, nHD);
         else if (nClass == CLASS_TYPE_CLERIC || nClass == CLASS_TYPE_DRUID) oItem = SRM_CreateDivineScroll(oCreateOn, nHD);
         else if (d2()==1) oItem = SRM_CreateArcaneScroll(oCreateOn, nHD);
         else oItem = SRM_CreateDivineScroll(oCreateOn, nHD);
      else if (nRandom <= nProbTable2 + nProbGold + nProbGem + nProbStone + nProbScroll + nProbAmmo)
         oItem = SRM_CreateAmmo(oCreateOn, nHD);   // * Ammo
      else if (nRandom <= nProbTable2 + nProbGold + nProbGem + nProbStone + nProbScroll + nProbAmmo + nProbKit)
         oItem = SRM_CreateKit(oCreateOn, nHD);   // * Healing, Trap, or Thief kit
      else if (nRandom <= nProbTable2 + nProbGold + nProbGem + nProbStone + nProbScroll + nProbAmmo + nProbKit + nProbPotion)
         oItem = SRM_CreatePotion(oCreateOn, nHD);   // * Potion
      else
         oItem = SRM_CreateJunk(oCreateOn);                                // * Junk
      SetDroppableFlag(oItem, TRUE);
      if (d2()==1 && GetGoldPieceValue(oItem)>7500) SetIdentified(oItem, FALSE);
   }

}

object SRM_GenerateTreasure(object oMinion, object oKiller) {
   int nRoll;
   /*if (GetResRef(oMinion)=="zombie") {
      if (Random(150)==1) return SRM_CreateLevelingWeapon(oMinion, oKiller);
   }
   if (GetResRef(oMinion)=="trog003") { // TROG CLERIC
      if (Random(50)==1) return SMS_CreateStone(oMinion, "SMS_DAM_ACID");
   }
   if (GetResRef(oMinion)=="driderw002") { // DRIDER WIZARD
      if (Random(50)==1) return SMS_CreateStone(oMinion, "SMS_DAM_ELECTRIC");
   }
   /*if (GetResRef(oMinion)=="troll002") { // TROLL SHAMAN
      if (Random(50)==1) return SMS_CreateStone(oMinion, "SMS_REGEN");
   }
   if (GetResRef(oMinion)=="tundradwarf001") { // TUNDRA DWARF
      if (Random(50)==1) return SMS_CreateStone(oMinion, "SMS_DAM_COLD");
   }
   /*if (GetResRef(oMinion)=="drakulwarlock001") { // Curst Witch
      if (Random(50)==1) return SMS_CreateStone(oMinion, "SMS_DAM_NEGATIVE");
   }
   if (GetResRef(oMinion)=="bugbearenforcer") { // Bugbear Enforcer
      if (Random(50)==1) return SMS_CreateStone(oMinion, "SMS_DAM_BLUNT");
   }
   if (GetResRef(oMinion)=="azer003") { // Azer
      if (Random(50)==1) return SMS_CreateStone(oMinion, "SMS_DAM_FIRE");
   }*/
   nRoll = Random(100);
   if (nRoll==1) return SMS_CreateStone(oMinion);
   return OBJECT_INVALID;
}


//void main () {}



#include "x2_inc_itemprop"
#include "_functions"
#include "seed_pick_stone"

object oWorkContainer = GetObjectByTag("WorkContainer");

int    SMS_AddDarkVision(object oPC, object oTarget, int nVisual);
int    SMS_AddHaste(object oPC, object oTarget, int nVisual);
int    SMS_AddHolySword(object oPC, object oTarget, int nVisual);
int    SMS_AddKeen(object oPC, object oTarget, int nVisual);
int    SMS_AddSpellSlot(object oPC, object oTarget, int nClass, string sClass, int nMaxLevel, int nVisual);
int    SMS_AddVisual(object oPC, object oTarget, int nType, int nVisual);
int    SMS_CanHaveAC(int nBaseType);
int    SMS_DamageBonusValue(int nDamageBonus);
int    SMS_DamageImmunityNext(int nDamageImmunity);
int    SMS_DamageResistanceNext(int nDamageResistance);
int    SMS_DamageSoakNext(int nDamageSoak);
int    SMS_DamageTypeEffect(int nDamageType);
void   SMS_DelayTransferPower(object oPC, object oTarget, object oNew, object oItem, itemproperty ipAdd, int nVisual, string sMsg);
int    SMS_GetItemBonusCount(object oTarget, int iBonusType, int bSum = FALSE);
int    SMS_GetItemCurrentBonus(object oTarget, int nBonusType, int nSubType = -1);
void   SMS_GetWeaponData(object oItem);
int    SMS_NextAbility(object oPC, object oTarget, int nBaseType, string sBaseType, int nAbility, string sAbility, int nVisual);
int    SMS_NextAC(object oPC, object oTarget, int nVisual);
int    SMS_NextDamageBonus(int nDamageBonus);
int    SMS_NextDamageImmunity(object oPC, object oTarget, int nDamageType);
int    SMS_NextDamageResistance(object oPC, object oTarget, int nDamageType);
int    SMS_NextMassiveCritical(object oPC, object oTarget, int nVisual);
int    SMS_NextOnHit(object oPC, object oTarget, int nOnHitType, int nVisual);
int    SMS_NextRegeneration(object oPC, object oTarget, int nVisual);
int    SMS_NextSaveSpecific(object oPC, object oTarget, int nSaveType, string sSaveType, int nVisual);
int    SMS_NextSaveVs(object oPC, object oTarget, int nSaveType, string sSaveType, int nVisual);
int    SMS_NextSkill(object oPC, object oTarget, int nSkillType, string sSkillType, int nVisual);
int    SMS_NextSpellResistance(object oPC, object oTarget, int nVisual);
int    SMS_NextWeaponAttack(object oPC, object oTarget, int nVisual);
int    SMS_NextWeaponDamage(object oPC, object oTarget, int nDamageType);
int    SMS_NextWeaponMighty(object oPC, object oTarget, int nVisual);
int    SMS_NextWeaponVampiric(object oPC, object oTarget, int nVisual);
int    SMS_OnHitNext(int nOnHit);
int    SMS_OnItemActivate(object oPC, object oTarget, object oItem);
int    SMS_PowerFailed(object oPC, string sMsg);
int    SMS_RemoveProperty(object oItem, itemproperty ipProperty, string sWhich = "ITEM_PROPERTY_ATTACK_BONUS");
int    SMS_RotateDamage(int nDamageType);
int    SMS_SpellResistanceNext(int nSR);
int    SMS_SumDamageBonuses(object oTarget, int nSkipSubType = -1, int nSkipNewAmt = IP_CONST_DAMAGEBONUS_1d4); // FEED IT A TYPE IF YOU ARE CALCULATING THE NEW VALUE THAT WILL INCLUDE THE TYPE SUPPLIED
int    SMS_TransferPower(object oPC, object oTarget, itemproperty ipAdd, int nVisual, string sMsg);
int    SMS_ValidDamageBonus(int nDamageBonus);

// Seeds Systems
// seed_magic_sys

// Maximum Item Level
const int SMS_ITEM_LEVEL_MAX = 40;
const int MAX_DAMAGE_PER_MOD = 12;

// AC Bonuses
const int SMS_AC_MAX = 5;

// Weapon Bonuses
const int SMS_AB_MAX                = 5;
const int SMS_WEAPON_MODS_LARGE     = 3;  // # OF DAMAGE MODS ON LARGE WEAPON
const int SMS_WEAPON_MODS_MEDIUM    = 2;
const int SMS_WEAPON_MODS_SMALL     = 2;
const int SMS_WEAPON_MODS_TINY      = 2;
const int SMS_WEAPON_MODS_THROWING  = 2;
const int SMS_WEAPON_MODS_AMMO      = 2;
const int SMS_WEAPON_MODS_GLOVES    = 3;
const int SMS_WEAPON_MASS_CRIT_MAX  = IP_CONST_DAMAGEBONUS_2d6;
const int SMS_WEAPON_MODS_MAX       = 12; //

// Ability Bonuses: Primary Item can have +6, other items +1
const int SMS_ABILITY_MAIN_ITEM_MAX   = 8;            // PRIMARY ITEM ABILITY MAX
const int SMS_ABILITY_OTHER_ITEM_MAX  = 8;            // OTHER ITEM ABILITY MAX
const int SMS_ABILITY_COUNT           = 8;            // NUMBER OF ABILITY BOOSTS PER ITEM

const int SMS_ABILITY_MAIN_ITEM_STR = BASE_ITEM_ARMOR;
const int SMS_ABILITY_MAIN_ITEM_CON = BASE_ITEM_BELT;
const int SMS_ABILITY_MAIN_ITEM_DEX = BASE_ITEM_BOOTS;
const int SMS_ABILITY_MAIN_ITEM_INT = BASE_ITEM_HELMET;
const int SMS_ABILITY_MAIN_ITEM_WIS = BASE_ITEM_AMULET;
const int SMS_ABILITY_MAIN_ITEM_CHA = BASE_ITEM_CLOAK;
const string SMS_ABILITY_MAIN_ITEM_STR_STRING = "Armor";
const string SMS_ABILITY_MAIN_ITEM_CON_STRING = "Belts";
const string SMS_ABILITY_MAIN_ITEM_DEX_STRING = "Boots";
const string SMS_ABILITY_MAIN_ITEM_INT_STRING = "Helms";
const string SMS_ABILITY_MAIN_ITEM_WIS_STRING = "Amulets";
const string SMS_ABILITY_MAIN_ITEM_CHA_STRING = "Cloaks";

// Skills
const int SMS_SKILL_MAX   = 4;    // MAX POINTS FOR EACH SKILL
const int SMS_SKILL_COUNT = 1;      // # OF SKILL TYPES PER ITEM (=MAX FOR AS MANY AS POINTS)

// Regeneration
const int SMS_REGEN_MAIN_ITEM           = BASE_ITEM_RING;
const int SMS_REGEN_MAIN_ITEM_MAX       = 2;           // PRIMARY ITEM ABILITY MAX
const int SMS_REGEN_OTHER_ITEM_MAX      = 0;             // OTHER ITEM ABILITY MAX
const string SMS_REGEN_MAIN_ITEM_STRING = "Rings";

// Damage Immunity (%)
const int SMS_DAMAGE_IMMUNITY_MAX = IP_CONST_DAMAGEIMMUNITY_50_PERCENT;
const int SMS_DAMAGE_IMMUNITY_COUNT = 0;

// Damage Soak: to Max AB, soak 25
const int SMS_DAMAGE_REDUCTION_AB_MAX = SMS_AB_MAX;
const int SMS_DAMAGE_REDUCTION_SOAK_MAX = IP_CONST_DAMAGESOAK_25_HP;

// Damage Resistance (x/-): Max 5/- :
const int    SMS_DAMAGE_RESISTANCE_MAX = IP_CONST_DAMAGERESIST_5;
const int    SMS_DAMAGE_RESISTANCE_COUNT = 1;

// Spell Resistance
const int    SMS_SPELL_RESISTANCE_MAIN_ITEM = BASE_ITEM_RING;
const int    SMS_SPELL_RESISTANCE_MAX = IP_CONST_SPELLRESISTANCEBONUS_32;
const string SMS_SPELL_RESISTANCE_MAIN_ITEM_STRING = "Rings";

// Saves -
//    No Universal
//    Specific (Fort, Reflex, Will) on Rings only, Fort comes with -Death to balance
//    Vs Saves can go anywhere
const int    SMS_SAVE_BIG3_COUNT = 2;                                // # OF SAVE ALLOW PER ITEM
const int    SMS_SAVE_BIG3_MAIN_ITEM = BASE_ITEM_RING;               // PRIMARY ITEM FOR SPECIFIC SAVE
const int    SMS_SAVE_BIG3_MAIN_ITEM_MAX = 5;           // MAX SAVE PER SAVE SPECIFIC
const string SMS_SAVE_BIG3_MAIN_ITEM_STRING = "Rings";

const int    SMS_SAVE_VS_COUNT = 1;                                      // # OF SAVE ALLOW PER ITEM
const int    SMS_SAVE_VS_MAIN_ITEM = BASE_ITEM_INVALID;                  // PRIMARY ITEM FOR VS SAVE (BASE_ITEM_INVALID = ANY)
const int    SMS_SAVE_VS_MAIN_ITEM_MAX = 3;          // MAX SAVE VS PER SAVE TYPE (0 TO DISABLE)
const int    SMS_SAVE_VS_OTHER_ITEM_MAX = 3;
const string SMS_SAVE_VS_MAIN_ITEM_STRING = "Any";

const int    SMS_SPELLSLOTS_MAX   = 9;                                 // TOTAL SUM OF SLOTS
const int    SMS_SPELLSLOTS_COUNT = 1;              // TOTAL # OF SLOTS

// Miscellaneous
const int    SMS_MIGHTY_MAX = 16;

const int    SMS_VAMP_REGEN_MAX = 6;
const int    SMS_ON_HIT_DC_MAX = IP_CONST_ONHIT_SAVEDC_26;

void DebugTSLE(string sMsg)
{
   //return;
   WriteTimestampedLogEntry(sMsg);
}

/*
void SDBLogMsg(string sType, string sMsg, object oPC=OBJECT_INVALID)
{
   string sLIID = "0";
   if (oPC!=OBJECT_INVALID)
   {
      sLIID = GetLocalString(oPC, "SDB_LIID");
      string sLIID = GetLocalString(oPC, "SDB_LIID");
      string sCKID = GetLocalString(oPC, "SDB_CKID");
      string sACID = GetLocalString(oPC, "SDB_ACID");
      string sPLID = GetLocalString(oPC, "SDB_PLID");
      sMsg = "CK(" + sCKID + ") " + "AC(" + sACID + ") "+ "PL(" + sPLID + ") " + GetPCPlayerName(oPC) + "/" + GetName(oPC) + " : " + sMsg;
   }
   string sSQL = "insert into logmsg (lm_type, lm_msg, lm_liid) values (" + DelimList(dbQuotes(sType), dbQuotes(sMsg), sLIID) + ")";
   SQLExecDirect(sSQL);
   WriteTimestampedLogEntry("SDB LOGMSG: " + sType + ": " + sMsg);
}
*/

void DestroySMS(object oPC)
{
   object oItem = GetFirstItemInInventory(oPC);
   while (oItem != OBJECT_INVALID)
   { // LOOP THRU ITEM IN INVENTORY
      string sTag = GetTag(oItem);
      if (sTag=="SEED_VALIDATED" || GetStringLeft(sTag, 4)=="SMS_" || GetBaseItemType(oItem)==BASE_ITEM_GEM)
      {
         WriteTimestampedLogEntry("DUPITEM PENALTY DESTROYING: " + GetName(oPC) + " / " + sTag + " / " + GetName(oItem));
         Insured_Destroy(oItem);
      }
      oItem = GetNextItemInInventory(oPC);
   }
   int nGold = GetGold(oPC);
   WriteTimestampedLogEntry("DUPITEM PENALTY DESTROYING GOLD: " + GetName(oPC) +  IntToString(nGold));
   TakeGoldFromCreature(nGold, oPC, TRUE);
}

int SMS_RotateDamage(int nDamageType)
{
   if      (nDamageType==IP_CONST_DAMAGETYPE_ACID)       return IP_CONST_DAMAGETYPE_COLD;
   else if (nDamageType==IP_CONST_DAMAGETYPE_COLD)       return IP_CONST_DAMAGETYPE_ELECTRICAL;
   else if (nDamageType==IP_CONST_DAMAGETYPE_ELECTRICAL) return IP_CONST_DAMAGETYPE_FIRE;
   else if (nDamageType==IP_CONST_DAMAGETYPE_FIRE)       return IP_CONST_DAMAGETYPE_NEGATIVE;
   else if (nDamageType==IP_CONST_DAMAGETYPE_NEGATIVE)   return IP_CONST_DAMAGETYPE_POSITIVE;
   else if (nDamageType==IP_CONST_DAMAGETYPE_POSITIVE)   return IP_CONST_DAMAGETYPE_SONIC;
   return IP_CONST_DAMAGETYPE_FIRE;
}

int SMS_RemoveProperty(object oItem, itemproperty ipProperty, string sWhich = "ITEM_PROPERTY_ATTACK_BONUS")
{
   RemoveItemProperty(oItem, ipProperty);
   DebugTSLE("     " + sWhich + " : removed");
   return TRUE;
}

struct SMS_WeaponStatsStruct
{
    int Type;
    int Size;
    int CritHitMult;
    int NumDice;
    int DieToRoll;
    int Ranged;
    int Ammo;
    int Throw;
    int Melee;
    int DamageMods;
};

struct SMS_WeaponStatsStruct WeaponStats;

void SMS_GetWeaponData(object oItem)
{
   int nBase = GetBaseItemType(oItem);
   WeaponStats.Ammo = FALSE;
   WeaponStats.Type = StringToInt(Get2DAString("baseitems", "WeaponType", nBase));
   if (WeaponStats.Type==0 || nBase==BASE_ITEM_BRACER) { // NOT A WEAPON (BUT COULD BE BOLT, ARROW, BULLET)
      WeaponStats.Type = 0;
      WeaponStats.Size = 0;                WeaponStats.CritHitMult = 0;
      WeaponStats.NumDice = 0;             WeaponStats.DieToRoll = 0;
      WeaponStats.Ranged = 0;              WeaponStats.Throw = 0;
      WeaponStats.Melee = 0;               WeaponStats.DamageMods = 0;
      if (nBase==BASE_ITEM_ARROW || nBase==BASE_ITEM_BOLT || nBase==BASE_ITEM_BULLET)
      {
         WeaponStats.Ammo = TRUE;
         WeaponStats.DamageMods = SMS_WEAPON_MODS_AMMO;
      }
      return;
   }
   WeaponStats.Size = StringToInt(Get2DAString("baseitems", "WeaponSize", nBase));
   WeaponStats.CritHitMult = StringToInt(Get2DAString("baseitems", "CritHitMult", nBase));
   WeaponStats.NumDice = StringToInt(Get2DAString("baseitems", "NumDice", nBase));
   WeaponStats.DieToRoll = StringToInt(Get2DAString("baseitems", "DieToRoll", nBase));
   int nAmmoType = StringToInt(Get2DAString("baseitems", "AmmunitionType", nBase));
   WeaponStats.Ranged = (nAmmoType == 1 || nAmmoType == 2 || nAmmoType == 3); //1=arrow,2=bolt,3=bullet
   WeaponStats.Throw = (nAmmoType == 4 || nAmmoType == 5 || nAmmoType == 6); //4=dart,5=shuriken,6=throwingaxe
   WeaponStats.Melee = !(WeaponStats.Ranged || WeaponStats.Throw);
   if (nBase == BASE_ITEM_GLOVES) WeaponStats.DamageMods = SMS_WEAPON_MODS_GLOVES;
   else if (WeaponStats.Size == 1) WeaponStats.DamageMods = SMS_WEAPON_MODS_TINY;
   else if (WeaponStats.Size == 2) WeaponStats.DamageMods = SMS_WEAPON_MODS_SMALL;
   else if (WeaponStats.Size == 3) WeaponStats.DamageMods = SMS_WEAPON_MODS_MEDIUM;
   else if (WeaponStats.Size == 4) WeaponStats.DamageMods = SMS_WEAPON_MODS_LARGE;
   if (WeaponStats.Ranged) WeaponStats.DamageMods = 0;
}

int SMS_DamageTypeEffect(int nDamageType) {
   if (nDamageType==IP_CONST_DAMAGETYPE_ACID)       return VFX_IMP_HEAD_ACID;
   if (nDamageType==IP_CONST_DAMAGETYPE_COLD)       return VFX_IMP_HEAD_COLD;
   if (nDamageType==IP_CONST_DAMAGETYPE_DIVINE)     return VFX_IMP_HEAD_MIND;
   if (nDamageType==IP_CONST_DAMAGETYPE_ELECTRICAL) return VFX_IMP_HEAD_ELECTRICITY;
   if (nDamageType==IP_CONST_DAMAGETYPE_FIRE)       return VFX_IMP_HEAD_FIRE;
   if (nDamageType==IP_CONST_DAMAGETYPE_MAGICAL)    return VFX_IMP_HEAD_NATURE;
   if (nDamageType==IP_CONST_DAMAGETYPE_NEGATIVE)   return VFX_IMP_HEAD_EVIL;
   if (nDamageType==IP_CONST_DAMAGETYPE_POSITIVE)   return VFX_IMP_HEAD_HOLY;
   if (nDamageType==IP_CONST_DAMAGETYPE_SONIC)      return VFX_IMP_HEAD_SONIC;
   if (nDamageType==IP_CONST_DAMAGETYPE_BLUDGEONING)return VFX_IMP_MAGBLUE;
   if (nDamageType==IP_CONST_DAMAGETYPE_PIERCING)   return VFX_IMP_MAGBLUE;
   if (nDamageType==IP_CONST_DAMAGETYPE_SLASHING)   return VFX_IMP_MAGBLUE;
   return VFX_IMP_HEAD_ODD;
}

int SMS_PowerFailed(object oPC, string sMsg) {
   FloatingTextStringOnCreature("pffftt!", oPC, TRUE);
   ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_IMP_DOOM), oPC);
   SendMessageToPC(oPC, sMsg);
   return FALSE; // CHANGE THIS TO TRUE TO DESTROY ITEM EVEN IF POWER FAILS
}

void SMS_DelayTransferPower(object oPC, object oTarget, object oNew, object oItem, itemproperty ipAdd, int nVisual, string sMsg) {
   int iNewLevel = GetItemLevel(GetGoldPieceValue(oNew));
   Insured_Destroy(oNew);
   if (iNewLevel > GetHitDice(oPC)) {
      SMS_PowerFailed(oPC, "The Item would be too powerful for you (level " + IntToString(iNewLevel) + ") with this enchantment.");
      return;
   }
   if (iNewLevel > SMS_ITEM_LEVEL_MAX) {
      SMS_PowerFailed(oPC, "The Item would be too powerful for this world (level " + IntToString(iNewLevel) + ") with this enchantment.");
      return;
   }
   AssignCommand(oPC, ActionUnequipItem(oTarget));
   IPSafeAddItemProperty(oTarget, ipAdd, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   FloatingTextStringOnCreature(sMsg, oPC, TRUE);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisual), oPC);
   SendMessageToPC(oPC,"Item is now level "+IntToString(iNewLevel));
   WriteTimestampedLogEntry("Stone Destroyed: " + GetName(oPC) + " / " + GetTag(oItem) + " / " + GetName(oItem) + " / " + GetTag(oTarget) + " / " + GetName(oTarget));
   Insured_Destroy(oItem); // UNCOMMENT AFTER TEST TO GET RID OF ITEM AFTER USE!!
   ExportSingleCharacter(oPC);
   string sTag = GetName(oItem);
   int bSuccess = FindSubString(sTag, "#");
   if (bSuccess!=-1) {
      string sACID = IntToString(dbGetACID(oPC));
      string sPLID = IntToString(dbGetPLID(oPC));
      string sTRUEID = IntToString(dbGetTRUEID(oPC));
      bSuccess++;
      sTag = GetStringRight(sTag, GetStringLength(sTag)-bSuccess);
      string sSQL = "select st_usedplid from stonetracker where st_stid="+sTag;
      NWNX_SQL_ExecuteQuery(sSQL);
      if (NWNX_SQL_ReadyToReadNextRow())
      {
         NWNX_SQL_ReadNextRow();
         bSuccess = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
         if (bSuccess > 0) {
            dbLogMsg("Dup stone used " + GetName(oItem), "DUPESTONE",dbGetTRUEID(oPC),dbGetDEXID(oPC),dbGetLIID(oPC),dbGetPLID(oPC));
            sSQL = "update trueid set duper=1 where trueid="+sTRUEID;
            NWNX_SQL_ExecuteQuery(sSQL);
            Insured_Destroy(oTarget);
            //DestroySMS(oPC);
            return;
         }
      }
      sSQL = "update stonetracker set st_used=now(), st_usedplid="+sPLID+" where st_stid="+sTag;
      NWNX_SQL_ExecuteQuery(sSQL);
   }
}

int SMS_TransferPower(object oPC, object oTarget, itemproperty ipAdd, int nVisual, string sMsg) {
   object oNew = CopyItem(oTarget, oWorkContainer);
   IPSafeAddItemProperty(oNew, ipAdd, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   DelayCommand(0.1f,SMS_DelayTransferPower(oPC, oTarget, oNew, GetItemActivated(), ipAdd, nVisual, sMsg));
   return TRUE;
}

int SMS_GetItemCurrentBonus(object oTarget, int nBonusType, int nSubType = -1) { // RETURN CURRENT ITEM BONUS LEVEL WITH OPTIONAL SUBTYPE
   itemproperty ipLoop=GetFirstItemProperty(oTarget);
   while (GetIsItemPropertyValid(ipLoop)) {
      if (GetItemPropertyType(ipLoop)==nBonusType) {
         if (nSubType == -1 || nSubType==GetItemPropertySubType(ipLoop)) return GetItemPropertyCostTableValue(ipLoop);
      }
      ipLoop=GetNextItemProperty(oTarget);
   }
   return 0;
}

// COUNTS # OF ITEMS BONUSES OF A SPECIFIC TYPE
// OPTIONALLY SUMS TOTAL ITEMS BONUSES OF A SPECIFIC TYPE (ie TOTAL # of SKILL POINTS RATHER THAN SKILL COUNT)
int SMS_GetItemBonusCount(object oTarget, int iBonusType, int bSum = FALSE) {
   int iCnt = 0;
   int iSum = 0;
   itemproperty ipLoop=GetFirstItemProperty(oTarget);
   while (GetIsItemPropertyValid(ipLoop)) {
      if (GetItemPropertyType(ipLoop)==iBonusType) {
         iCnt++;
         iSum = iSum + GetItemPropertyCostTableValue(ipLoop);
      }
      ipLoop=GetNextItemProperty(oTarget);
   }
   if (bSum) return iSum;
   return iCnt;
}

string SMS_FindUnique(object oTarget, int nIgnoreType) {
   itemproperty ipLoop=GetFirstItemProperty(oTarget);
   int nBonusType;
   while (GetIsItemPropertyValid(ipLoop)) {
      nBonusType = GetItemPropertyType(ipLoop);
      if (nBonusType!=nIgnoreType) {
         switch (nBonusType) {
            case ITEM_PROPERTY_ON_HIT_PROPERTIES:
               return "On Hit";
            case ITEM_PROPERTY_ABILITY_BONUS:
               return "Ability Bonus";
            case ITEM_PROPERTY_SKILL_BONUS:
               return "Skill Bonus";
            case ITEM_PROPERTY_SAVING_THROW_BONUS:
            case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
               return "Saving Throw";
            case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
               return "Spell Slot";
            case ITEM_PROPERTY_REGENERATION:
               return "Regeneration";
         }
      }
      ipLoop=GetNextItemProperty(oTarget);
   }
   return "";
}

int SMS_OnHitNext(int nOnHit) {
   if (nOnHit==SMS_ON_HIT_DC_MAX || nOnHit==IP_CONST_ONHIT_SAVEDC_26) return 999; // AT MAX!
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_14) return IP_CONST_ONHIT_SAVEDC_16;
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_16) return IP_CONST_ONHIT_SAVEDC_18;
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_18) return IP_CONST_ONHIT_SAVEDC_20;
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_20) return IP_CONST_ONHIT_SAVEDC_22;
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_22) return IP_CONST_ONHIT_SAVEDC_24;
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_24) return IP_CONST_ONHIT_SAVEDC_26;
   return IP_CONST_ONHIT_SAVEDC_14;
}

int SMS_NextOnHit(object oPC, object oTarget, int nOnHitType, int nVisual)
{
    string sUnique = SMS_FindUnique(oTarget, ITEM_PROPERTY_ON_HIT_PROPERTIES);
    if (sUnique!="") return SMS_PowerFailed(oPC, "This item has " + sUnique + " properties and cannot be enchanted with this magic.");
    int nBonusPower = -1;
    int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_ON_HIT_PROPERTIES);
    if (nBonusCnt) nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_ON_HIT_PROPERTIES, nOnHitType);
    string sType = OnHitTypeString(nOnHitType);
    if (nBonusCnt >= 1 && nBonusPower < 0) return SMS_PowerFailed(oPC, "This item has an On Hit bonus and cannot be enchanted any further.");
    if (nBonusPower==SMS_ON_HIT_DC_MAX) return SMS_PowerFailed(oPC, "This item has " + OnHitDCString(nBonusPower) + " " + sType + " On Hit bonus and cannot be enchanted any further.");
    nBonusPower = SMS_OnHitNext(nBonusPower);
    WriteTimestampedLogEntry("ONHIT: " + GetPCPlayerName(oPC) + "/" + GetName(oPC) + ": " + sType + " on hit increased to " + OnHitDCString(nBonusPower));
    return SMS_TransferPower(oPC, oTarget, ItemPropertyOnHitProps(nOnHitType, nBonusPower, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS), nVisual, sType+" on hit increased to "+OnHitDCString(nBonusPower));
}

int SMS_CanHaveAC(int nBaseType) {
   if (nBaseType==BASE_ITEM_AMULET)      return TRUE; //AC_NATURAL_BONUS;
   if (nBaseType==BASE_ITEM_ARMOR)       return TRUE; //AC_ARMOUR_ENCHANTMENT_BONUS;
   if (nBaseType==BASE_ITEM_BOOTS)       return TRUE; //AC_DODGE_BONUS;
   if (nBaseType==BASE_ITEM_BRACER)      return TRUE; //AC_ARMOUR_ENCHANTMENT_BONUS;
   if (nBaseType==BASE_ITEM_CLOAK)       return TRUE; //AC_DEFLECTION_BONUS;
   if (nBaseType==BASE_ITEM_GLOVES)      return TRUE; //AC_DEFLECTION_BONUS;
   if (nBaseType==BASE_ITEM_HELMET)      return TRUE; //AC_DEFLECTION_BONUS;
   if (nBaseType==BASE_ITEM_LARGESHIELD) return TRUE; //AC_SHIELD_ENCHANTMENT_BONUS;
   if (nBaseType==BASE_ITEM_SMALLSHIELD) return TRUE; //AC_SHIELD_ENCHANTMENT_BONUS;
   if (nBaseType==BASE_ITEM_TOWERSHIELD) return TRUE; //AC_SHIELD_ENCHANTMENT_BONUS;
   return FALSE;
}

int SMS_NextAC(object oPC, object oTarget, int nVisual) {
   if (!SMS_CanHaveAC(GetBaseItemType(oTarget))) return SMS_PowerFailed(oPC, "This magic may only be used on amulets, armor, boots, bracers, cloaks, helms, and shields.");
   int nAC = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_AC_BONUS) + 1;
   if (nAC > SMS_AC_MAX) return SMS_PowerFailed(oPC, "This item's AC bonus cannot be improved any further with this magic.");
   return SMS_TransferPower(oPC, oTarget, ItemPropertyACBonus(nAC), nVisual, "AC Enchanted to +"+IntToString(nAC));
}

int SMS_ValidDamageBonus(int nDamageBonus) {
   // INVALID TYPES CONVERTED TO VALID TYPES
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1   )      nDamageBonus = IP_CONST_DAMAGEBONUS_1d4;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_2   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d4;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_3   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d6;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_4   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d6;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d8 ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d6;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_5   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d10;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_6   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d10;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d12) nDamageBonus = IP_CONST_DAMAGEBONUS_1d10;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_7   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d10;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_8   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d6;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_9   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d6;
   else if (nDamageBonus==IP_CONST_DAMAGEBONUS_10  ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d8;
   // IF VALID, JUST RETURN ORGINAL
   return nDamageBonus;
}

int SMS_DamageBonusValue(int nDamageBonus) {
   // FIXED AMOUNTS RETURN DOUBLE DUE TO LACK OF RANDOMNESS
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1   ) return  2;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2   ) return  4;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_3   ) return  6;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_4   ) return  8;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_5   ) return 10;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_6   ) return 12;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_7   ) return 14;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_8   ) return 16;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_9   ) return 18;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_10  ) return 20;
   // NON-FIXED TYPES
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d4)  return  4;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d6)  return  6;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d8 ) return  8;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d4)  return  8;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d10) return 10;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d6)  return 12;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d12) return 12;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d8)  return 16;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d10) return 20;   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d12) return 24;
   return 1;
}

int SMS_NextDamageBonus(int nDamageBonus) {
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d12) return -1; // AT MAX!
   // REPLACE INVALID TYPES WITH SIMILIAR VALID TYPE
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d4;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d4;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_3   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d6;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_4   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d4;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d8 ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d4;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_5   ) nDamageBonus = IP_CONST_DAMAGEBONUS_1d10;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_6   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d6;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d12) nDamageBonus = IP_CONST_DAMAGEBONUS_2d6;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_7   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d6;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_8   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d8;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_9   ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d8;
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_10  ) nDamageBonus = IP_CONST_DAMAGEBONUS_2d10;
   // ROTATE UP TO THE NEXT AMOUNT
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d4)  return IP_CONST_DAMAGEBONUS_1d6;   // 6
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d6)  return IP_CONST_DAMAGEBONUS_2d4;   // 8
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d4)  return IP_CONST_DAMAGEBONUS_1d10;  // 10
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d10) return IP_CONST_DAMAGEBONUS_2d6;   // 12
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d6)  return IP_CONST_DAMAGEBONUS_2d8;   // 16
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d8)  return IP_CONST_DAMAGEBONUS_2d10;  // 20
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d10) return IP_CONST_DAMAGEBONUS_2d12;  // 24
   return IP_CONST_DAMAGEBONUS_1d4;
}

int SMS_SumDamageBonuses(object oTarget, int nSkipSubType = -1, int nSkipNewAmt = IP_CONST_DAMAGEBONUS_1d4) { // FEED IT A TYPE IF YOU ARE CALCULATING THE NEW VALUE THAT WILL INCLUDE THE TYPE SUPPLIED
   itemproperty ipLoop=GetFirstItemProperty(oTarget);
   int nSum = 0;
   while (GetIsItemPropertyValid(ipLoop)) {
      if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_DAMAGE_BONUS && GetItemPropertySubType(ipLoop)!=nSkipSubType) {
         nSum += SMS_DamageBonusValue(GetItemPropertyCostTableValue(ipLoop));
      }
      ipLoop=GetNextItemProperty(oTarget);
   }
   if (nSkipSubType!=-1) {
      nSum += SMS_DamageBonusValue(nSkipNewAmt); // ADD IN THE NEW DAMAGE AMOUNT WE WANT TO ADD
   }
   return nSum;
}

int SMS_NextWeaponDamage(object oPC, object oTarget, int nDamageType)
{
   SMS_GetWeaponData(oTarget);
   if (!WeaponStats.Melee) return SMS_PowerFailed(oPC, "This magic may only be used on melee weapons and monk gloves.");
   int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_DAMAGE_BONUS);
//SendMessageToPC(oPC, "nDamageType = " + IntToString(nDamageType));
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_DAMAGE_BONUS, nDamageType);
//SendMessageToPC(oPC, "nBonusPower = " + IntToString(nBonusPower));
   if (nBonusCnt>=WeaponStats.DamageMods && nBonusPower == 0) return SMS_PowerFailed(oPC, "This weapon has " + IntToString(WeaponStats.DamageMods) + " damage bonuses and cannot be enchanted any further.");
   int nBonusNext = SMS_NextDamageBonus(nBonusPower);
   string sType = DamageTypeString(nDamageType);
   if (nBonusNext==-1) return SMS_PowerFailed(oPC, "This weapon has " + DamageBonusString(nBonusPower) + " " + sType + " damage and cannot be enchanted any further.");
   int nMaxDamage = SMS_WEAPON_MODS_MAX * WeaponStats.DamageMods;
   int nDamageTotal = SMS_SumDamageBonuses(oTarget, nDamageType, nBonusNext);
   if (nDamageTotal > nMaxDamage) return SMS_PowerFailed(oPC, "Increasing the " + sType + " damage to " + DamageBonusString(nBonusNext) + " would exceed the max total damage for this weapon type and cannot be enchanted any further (" + IntToString(WeaponStats.DamageMods) + " mods * " + IntToString(SMS_WEAPON_MODS_MAX) + " per mod = " + IntToString(nMaxDamage) + ").");
   if (nBonusPower==0) nBonusCnt++;  // ADDING NEW
   SendMessageToPC(oPC, "This weapon now has " + IntToString(nBonusCnt) + " damage " + AddStoString("mod", nBonusCnt) + " and does a max of " + IntToString(nDamageTotal) + " damage. Max for this weapon is " + IntToString(WeaponStats.DamageMods) + " mods * " + IntToString(SMS_WEAPON_MODS_MAX) + " per mod = " + IntToString(nMaxDamage) + " damage.");
   return SMS_TransferPower(oPC, oTarget, ItemPropertyDamageBonus(nDamageType, nBonusNext), SMS_DamageTypeEffect(nDamageType), sType+" damage increased to "+DamageBonusString(nBonusNext));
}

int SMS_NextWeaponAttack(object oPC, object oTarget, int nVisual)
{
   SMS_GetWeaponData(oTarget);
   if (!WeaponStats.Melee && !WeaponStats.Ranged) return SMS_PowerFailed(oPC, "This magic may only be used on weapons and monk gloves.");
   itemproperty ipNew;
   int nBonusType = ITEM_PROPERTY_ATTACK_BONUS;
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_ATTACK_BONUS);
   if (!nBonusPower) // NO ATTACK BONUS, CHECK ENHANCED
   {
      nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_ENHANCEMENT_BONUS);
      if (nBonusPower) nBonusType = ITEM_PROPERTY_ENHANCEMENT_BONUS;
   }
   if (nBonusPower >= SMS_AB_MAX) return SMS_PowerFailed(oPC, "This weapon has +" + IntToString(nBonusPower) + " attack and cannot be enchanted any further.");
   nBonusPower++;
   if (nBonusType==ITEM_PROPERTY_ENHANCEMENT_BONUS) ipNew = ItemPropertyEnhancementBonus(nBonusPower);
   else ipNew = ItemPropertyAttackBonus(nBonusPower);
   return SMS_TransferPower(oPC, oTarget, ipNew, nVisual, "Weapon attack enchanted to +"+IntToString(nBonusPower));
}

int SMS_DamageImmunityNext(int nDamageImmunity)
{
   if (nDamageImmunity==SMS_DAMAGE_IMMUNITY_MAX || nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_100_PERCENT) return 999; // AT MAX!
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_5_PERCENT)  return IP_CONST_DAMAGEIMMUNITY_10_PERCENT;
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_10_PERCENT) return IP_CONST_DAMAGEIMMUNITY_25_PERCENT;
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_25_PERCENT) return IP_CONST_DAMAGEIMMUNITY_50_PERCENT;
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_50_PERCENT) return IP_CONST_DAMAGEIMMUNITY_75_PERCENT;
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_75_PERCENT) return IP_CONST_DAMAGEIMMUNITY_100_PERCENT;
   return IP_CONST_DAMAGEIMMUNITY_5_PERCENT;
}

int SMS_DamageSoakNext(int nDamageSoak)
{
   if (nDamageSoak==SMS_DAMAGE_REDUCTION_SOAK_MAX || nDamageSoak==IP_CONST_DAMAGESOAK_50_HP) return 999; // AT MAX!
   if (nDamageSoak==IP_CONST_DAMAGESOAK_5_HP)  return IP_CONST_DAMAGESOAK_10_HP;   if (nDamageSoak==IP_CONST_DAMAGESOAK_10_HP) return IP_CONST_DAMAGESOAK_15_HP;
   if (nDamageSoak==IP_CONST_DAMAGESOAK_15_HP) return IP_CONST_DAMAGESOAK_20_HP;   if (nDamageSoak==IP_CONST_DAMAGESOAK_20_HP) return IP_CONST_DAMAGESOAK_25_HP;
   if (nDamageSoak==IP_CONST_DAMAGESOAK_25_HP) return IP_CONST_DAMAGESOAK_30_HP;   if (nDamageSoak==IP_CONST_DAMAGESOAK_30_HP) return IP_CONST_DAMAGESOAK_35_HP;
   if (nDamageSoak==IP_CONST_DAMAGESOAK_35_HP) return IP_CONST_DAMAGESOAK_40_HP;   if (nDamageSoak==IP_CONST_DAMAGESOAK_40_HP) return IP_CONST_DAMAGESOAK_45_HP;
   if (nDamageSoak==IP_CONST_DAMAGESOAK_45_HP) return IP_CONST_DAMAGESOAK_50_HP;
   return IP_CONST_DAMAGESOAK_5_HP;
}

int SMS_DamageResistanceNext(int nDamageResistance)
{
   if (nDamageResistance==SMS_DAMAGE_RESISTANCE_MAX || nDamageResistance==IP_CONST_DAMAGERESIST_50) return 999; // AT MAX!
   if (nDamageResistance==IP_CONST_DAMAGERESIST_5 )  return IP_CONST_DAMAGERESIST_10;   if (nDamageResistance==IP_CONST_DAMAGERESIST_10)  return IP_CONST_DAMAGERESIST_15;
   if (nDamageResistance==IP_CONST_DAMAGERESIST_15)  return IP_CONST_DAMAGERESIST_20;   if (nDamageResistance==IP_CONST_DAMAGERESIST_20)  return IP_CONST_DAMAGERESIST_25;
   if (nDamageResistance==IP_CONST_DAMAGERESIST_25)  return IP_CONST_DAMAGERESIST_30;   if (nDamageResistance==IP_CONST_DAMAGERESIST_30)  return IP_CONST_DAMAGERESIST_35;
   if (nDamageResistance==IP_CONST_DAMAGERESIST_35)  return IP_CONST_DAMAGERESIST_40;   if (nDamageResistance==IP_CONST_DAMAGERESIST_40)  return IP_CONST_DAMAGERESIST_45;
   if (nDamageResistance==IP_CONST_DAMAGERESIST_45)  return IP_CONST_DAMAGERESIST_50;
   return IP_CONST_DAMAGERESIST_5;
}

int SMS_NextDamageResistance(object oPC, object oTarget, int nDamageType)
{
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_DAMAGE_RESISTANCE, nDamageType);
   int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_DAMAGE_RESISTANCE);
   string sType = DamageTypeString(nDamageType);
   if (nBonusCnt >= SMS_DAMAGE_RESISTANCE_COUNT && nBonusPower == 0) return SMS_PowerFailed(oPC, "This item has " + IntToString(nBonusCnt) + " damage resistance bonuses and cannot be enchanted any further.");
   if (nBonusPower==SMS_DAMAGE_RESISTANCE_MAX) return SMS_PowerFailed(oPC, "This item has " + DamageResistanceString(nBonusPower) + " " + sType + "  damage resistance and cannot be enchanted any further.");
   nBonusPower = SMS_DamageResistanceNext(nBonusPower);
   return SMS_TransferPower(oPC, oTarget, ItemPropertyDamageResistance(nDamageType, nBonusPower), SMS_DamageTypeEffect(nDamageType), sType+" damage resistance increased to "+DamageResistanceString(nBonusPower));
}

int SMS_NextAbility(object oPC, object oTarget, int nBaseType, string sBaseType, int nAbility, string sAbility, int nVisual)
{
   string sUnique = SMS_FindUnique(oTarget, ITEM_PROPERTY_ABILITY_BONUS);
   if (sUnique!="") return SMS_PowerFailed(oPC, "This item has " + sUnique + " properties and cannot be enchanted with this magic.");
   //SMS_GetWeaponData(oTarget);
   //if (WeaponStats.Type) return SMS_PowerFailed(oPC, "This magic cannot be used on weapons.");
   //if (GetBaseItemType(oTarget) != BASE_ITEM_RING) return SMS_PowerFailed(oPC, "This magic cannot be used on rings.");
   int iMax = SMS_ABILITY_MAIN_ITEM_MAX;
   //if (GetBaseItemType(oTarget)!=nBaseType) iMax = SMS_ABILITY_OTHER_ITEM_MAX;
   int nBonusSum = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_ABILITY_BONUS, TRUE); // SUM UP ALL ABILITY BONUSES
   if (nBonusSum >= iMax) return SMS_PowerFailed(oPC, "This item has +" + IntToString(nBonusSum) + " ability bonuses and cannot be enchanted any further.");
   //int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_ABILITY_BONUS);
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_ABILITY_BONUS, nAbility);
   //if (nBonusCnt >= SMS_ABILITY_COUNT && nBonusPower == 0) return SMS_PowerFailed(oPC, "This item has " + IntToString(nBonusCnt) + " ability bonuses and cannot be enchanted any further.");
   //if (nBonusPower >= iMax) return SMS_PowerFailed(oPC, "This item has +" + IntToString(nBonusPower) + sAbility + " and cannot be enchanted any further.");
   nBonusPower++;
   return SMS_TransferPower(oPC, oTarget, ItemPropertyAbilityBonus(nAbility, nBonusPower), nVisual, sBaseType + " " + sAbility + " enchanted to +"+IntToString(nBonusPower));
}

int SMS_NextSkill(object oPC, object oTarget, int nSkillType, string sSkillType, int nVisual)
{
   string sUnique = SMS_FindUnique(oTarget, ITEM_PROPERTY_SKILL_BONUS);
   if (sUnique!="") return SMS_PowerFailed(oPC, "This item has " + sUnique + " properties and cannot be enchanted with this magic.");
   int nBonusSum = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_SKILL_BONUS, TRUE); // SUM UP ALL SKILL BONUSES
   if (nBonusSum >= SMS_SKILL_MAX ) return SMS_PowerFailed(oPC, "This item has +" + IntToString(nBonusSum) + " skill bonuses and cannot be enchanted any further.");
   //int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_SKILL_BONUS);
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_SKILL_BONUS, nSkillType);
   //if (nBonusCnt >= SMS_SKILL_COUNT && nBonusPower == 0) return SMS_PowerFailed(oPC, "This item has " + IntToString(nBonusCnt) + " skill bonuses and cannot be enchanted any further.");
   //if (nBonusPower >= SMS_SKILL_MAX ) return SMS_PowerFailed(oPC, "This item has +" + IntToString(nBonusPower) + " " + sSkillType+" skill bonus and cannot be enchanted any further.");
   nBonusPower++;
   return SMS_TransferPower(oPC, oTarget, ItemPropertySkillBonus(nSkillType, nBonusPower), nVisual, sSkillType + " enchanted to +"+IntToString(nBonusPower));
}

int SMS_NextRegeneration(object oPC, object oTarget, int nVisual)
{
   string sUnique = SMS_FindUnique(oTarget, ITEM_PROPERTY_REGENERATION);
   if (sUnique!="") return SMS_PowerFailed(oPC, "This item has " + sUnique + " properties and cannot be enchanted with this magic.");
   if (GetBaseItemType(oTarget) != SMS_REGEN_MAIN_ITEM) return SMS_PowerFailed(oPC, "This magic may only be used on " + SMS_REGEN_MAIN_ITEM_STRING);
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_REGENERATION);
   if (nBonusPower >= SMS_REGEN_MAIN_ITEM_MAX) return SMS_PowerFailed(oPC, "This item has +" + IntToString(nBonusPower) + " regeneration and cannot be enchanted any further.");
   nBonusPower++;
   return SMS_TransferPower(oPC, oTarget, ItemPropertyRegeneration(nBonusPower), nVisual, "Regeneration Enchanted to +"+IntToString(nBonusPower));
}

int SMS_NextDamageImmunity(object oPC, object oTarget, int nDamageType)
{
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, nDamageType);
   int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE);
   string sType = DamageTypeString(nDamageType);
   if (nBonusCnt >= SMS_DAMAGE_IMMUNITY_COUNT && nBonusPower == 0) return SMS_PowerFailed(oPC, "This item has " + IntToString(nBonusCnt) + " damage immunity bonuses and cannot be enchanted any further.");
   if (nBonusPower==SMS_DAMAGE_IMMUNITY_MAX) return SMS_PowerFailed(oPC, "This item has " + DamageImmunityString(nBonusPower) + " " + sType + " damage immunity and cannot be enchanted any further.");
   nBonusPower = SMS_DamageImmunityNext(nBonusPower);
   return SMS_TransferPower(oPC, oTarget, ItemPropertyDamageImmunity(nDamageType, nBonusPower), SMS_DamageTypeEffect(nDamageType), sType+" damage immunity increased to "+DamageImmunityString(nBonusPower));
}

int SMS_SpellResistanceNext(int nSR)
{
   if (nSR==SMS_SPELL_RESISTANCE_MAX || nSR==IP_CONST_SPELLRESISTANCEBONUS_32) return 999; // AT MAX!
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_10) return IP_CONST_SPELLRESISTANCEBONUS_12;   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_12) return IP_CONST_SPELLRESISTANCEBONUS_14;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_14) return IP_CONST_SPELLRESISTANCEBONUS_16;   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_16) return IP_CONST_SPELLRESISTANCEBONUS_18;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_18) return IP_CONST_SPELLRESISTANCEBONUS_20;   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_20) return IP_CONST_SPELLRESISTANCEBONUS_22;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_22) return IP_CONST_SPELLRESISTANCEBONUS_24;   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_24) return IP_CONST_SPELLRESISTANCEBONUS_26;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_26) return IP_CONST_SPELLRESISTANCEBONUS_28;   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_28) return IP_CONST_SPELLRESISTANCEBONUS_30;
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_30) return IP_CONST_SPELLRESISTANCEBONUS_32;
   return IP_CONST_SPELLRESISTANCEBONUS_10;
}

int SMS_NextSpellResistance(object oPC, object oTarget, int nVisual)
{
   if (GetBaseItemType(oTarget)!=SMS_SPELL_RESISTANCE_MAIN_ITEM && SMS_SPELL_RESISTANCE_MAIN_ITEM!=BASE_ITEM_INVALID) return SMS_PowerFailed(oPC, "This magic can only be used on " + SMS_SPELL_RESISTANCE_MAIN_ITEM_STRING);
   int nBonusPower = -1;
   int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_SPELL_RESISTANCE);
   if (nBonusCnt) nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_SPELL_RESISTANCE);
   if (nBonusPower==SMS_SPELL_RESISTANCE_MAX) return SMS_PowerFailed(oPC, "This item has " + SpellResistanceString(nBonusPower) + " spell resistance and cannot be enchanted any further.");
   nBonusPower = SMS_SpellResistanceNext(nBonusPower);
   return SMS_TransferPower(oPC, oTarget, ItemPropertyBonusSpellResistance(nBonusPower), nVisual, "Spell Resistance increased to "+SpellResistanceString(nBonusPower));
}

int SMS_NextSaveVs(object oPC, object oTarget, int nSaveType, string sSaveType, int nVisual)
{
   string sUnique = SMS_FindUnique(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS);
   if (sUnique!="") return SMS_PowerFailed(oPC, "This item has " + sUnique + " properties and cannot be enchanted with this magic.");
   //if (GetBaseItemType(oTarget)!=SMS_SAVE_VS_MAIN_ITEM && SMS_SAVE_VS_MAIN_ITEM!=BASE_ITEM_INVALID) return SMS_PowerFailed(oPC, "This magic can only be used on " + SMS_SAVE_VS_MAIN_ITEM_STRING);
   int nBonusSum = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS, TRUE); // SUM UP ALL SAVES
   if (nBonusSum >= SMS_SAVE_VS_MAIN_ITEM_MAX) return SMS_PowerFailed(oPC, "This item has +" + IntToString(nBonusSum) + " Save vs. Effect bonuses and cannot be enchanted any further.");
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS, nSaveType);
   //int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS);
   //if (nBonusCnt>=SMS_SAVE_VS_COUNT && nBonusPower == 0) return SMS_PowerFailed(oPC, "This item has " + IntToString(nBonusCnt) + " Save vs. Effect bonuses and cannot be enchanted any further.");
   //if (nBonusPower >= SMS_SAVE_VS_MAIN_ITEM_MAX) return SMS_PowerFailed(oPC, "This item has +" + IntToString(nBonusCnt) + " Save vs. " + sSaveType + " bonus and cannot be enchanted any further.");
   nBonusPower++;
   return SMS_TransferPower(oPC, oTarget, ItemPropertyBonusSavingThrowVsX(nSaveType, nBonusPower), nVisual, "Save vs. " + sSaveType + " increased to +"+IntToString(nBonusPower));
}

int SMS_NextSaveSpecific(object oPC, object oTarget, int nSaveType, string sSaveType, int nVisual)
{
   string sUnique = SMS_FindUnique(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC);
   if (sUnique!="") return SMS_PowerFailed(oPC, "This item has " + sUnique + " properties and cannot be enchanted with this magic.");
   //if (GetBaseItemType(oTarget)!=SMS_SAVE_BIG3_MAIN_ITEM && SMS_SAVE_BIG3_MAIN_ITEM!=BASE_ITEM_INVALID) return SMS_PowerFailed(oPC, "This magic can only be used on " + SMS_SAVE_BIG3_MAIN_ITEM_STRING);
   int nBonusSum = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, TRUE); // SUM UP ALL SAVES
   if (nBonusSum >= SMS_SAVE_BIG3_MAIN_ITEM_MAX) return SMS_PowerFailed(oPC, "This item has +" + IntToString(nBonusSum) + " Save vs. Specific bonus and cannot be enchanted any further.");
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, nSaveType);
   //int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_SAVING_THROW_BONUS);
   //if (nBonusCnt>=SMS_SAVE_BIG3_COUNT && nBonusPower == 0) return SMS_PowerFailed(oPC, "This item has " + IntToString(nBonusCnt) + " Save bonuses and cannot be enchanted any further.");
   //if (nBonusPower >= SMS_SAVE_BIG3_MAIN_ITEM_MAX) return SMS_PowerFailed(oPC, "This item has +" + IntToString(nBonusPower) + " Save " + sSaveType + " bonus and cannot be enchanted any further.");
   nBonusPower++;
   return SMS_TransferPower(oPC, oTarget, ItemPropertyBonusSavingThrow(nSaveType, nBonusPower), nVisual, sSaveType + " save increased to +"+IntToString(nBonusPower));
}

int SMS_NextWeaponMighty(object oPC, object oTarget, int nVisual)
{
   if (!IPGetIsRangedWeapon(oTarget)) return SMS_PowerFailed(oPC, "This magic may only be used on ranged weapons.");
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_MIGHTY);
   if (nBonusPower >= SMS_MIGHTY_MAX) return SMS_PowerFailed(oPC, "This weapon has Mighty bonus +" + IntToString(nBonusPower) + " and cannot be enchanted any further.");
   nBonusPower++;
   return SMS_TransferPower(oPC, oTarget, ItemPropertyMaxRangeStrengthMod(nBonusPower), nVisual, "Mighty bonus increased to +"+IntToString(nBonusPower));
}

int SMS_NextMassiveCritical(object oPC, object oTarget, int nVisual)
{
   SMS_GetWeaponData(oTarget);
   if (!WeaponStats.Type) return SMS_PowerFailed(oPC, "This magic may only be used on weapons.");
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_MASSIVE_CRITICALS);
   if (nBonusPower==SMS_WEAPON_MASS_CRIT_MAX) return SMS_PowerFailed(oPC, "This weapon has " + DamageBonusString(nBonusPower) + " massive critical damage and cannot be enchanted any further.");
   nBonusPower = SMS_NextDamageBonus(nBonusPower);
   return SMS_TransferPower(oPC, oTarget, ItemPropertyMassiveCritical(nBonusPower), nVisual, "Massive Critical damage increased to "+DamageBonusString(nBonusPower));
}

int SMS_NextWeaponVampiric(object oPC, object oTarget, int nVisual)
{
   SMS_GetWeaponData(oTarget);
   if (!WeaponStats.Melee) return SMS_PowerFailed(oPC, "This magic may only be used on melee weapons.");
   int nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_REGENERATION_VAMPIRIC);
   if (nBonusPower >= SMS_VAMP_REGEN_MAX) return SMS_PowerFailed(oPC, "This weapon has +" + IntToString(nBonusPower) + " Vampiric Regeneration and cannot be enchanted any further.");
   nBonusPower++;
   return SMS_TransferPower(oPC, oTarget, ItemPropertyVampiricRegeneration(nBonusPower), nVisual, "Vampiric Regeneration Enchanted to +"+IntToString(nBonusPower));
}

int SMS_AddHaste(object oPC, object oTarget, int nVisual)
{
   //if (GetBaseItemType(oTarget)!=BASE_ITEM_BOOTS) return SMS_PowerFailed(oPC, "This magic can only be used on boots.");
   if (SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_HASTE)!=0) return SMS_PowerFailed(oPC, "This item cannot get any quicker with this magic.");
   return SMS_TransferPower(oPC, oTarget, ItemPropertyHaste(), nVisual, "Ándale!");
}

int SMS_AddDarkVision(object oPC, object oTarget, int nVisual)
{
   //if (GetBaseItemType(oTarget)!=BASE_ITEM_HELMET) return SMS_PowerFailed(oPC, "This magic can only be used on helmets.");
   if (SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_DARKVISION)!=0) return SMS_PowerFailed(oPC, "This item cannot look any sweeter with this magic.");
   return SMS_TransferPower(oPC, oTarget, ItemPropertyDarkvision(), nVisual, "This item now looks good!");
}

int SMS_AddVisual(object oPC, object oTarget, int nType, int nVisual)
{
   if (!IPGetIsMeleeWeapon(oTarget)) return SMS_PowerFailed(oPC, "This magic can only be used on melee weapons.");
   IPRemoveMatchingItemProperties(oTarget, ITEM_PROPERTY_VISUALEFFECT, -1); // strip existing visuals
   return SMS_TransferPower(oPC, oTarget, ItemPropertyVisualEffect(nType), nVisual, "Woosh!"); // ie nType=ITEM_VISUAL_ACID
}

int SMS_AddKeen(object oPC, object oTarget, int nVisual)
{
   SMS_GetWeaponData(oTarget);
   if (!WeaponStats.Melee) return SMS_PowerFailed(oPC, "This magic may only be used on melee weapons.");
   if (SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_KEEN)!=0) return SMS_PowerFailed(oPC, "This weapon cannot get any sharper with this magic.");
   return SMS_TransferPower(oPC, oTarget, ItemPropertyKeen(), nVisual, "Weapon sharped to a keen edge.");
}

int SMS_AddHolySword(object oPC, object oTarget, int nVisual)
{
   SMS_GetWeaponData(oTarget);
   if (!WeaponStats.Melee) return SMS_PowerFailed(oPC, "This magic may only be used on melee weapons.");
   if (SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_HOLY_AVENGER)!=0) return SMS_PowerFailed(oPC, "This weapon cannot get any holier with this magic.");
   return SMS_TransferPower(oPC, oTarget, ItemPropertyHolyAvenger(), nVisual, "Weapon blessed with a holy edge.");
}

int SMS_AddSpellSlot(object oPC, object oTarget, int nClass, string sClass, int nMaxLevel, int nVisual)
{
   string sUnique = SMS_FindUnique(oTarget, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N);
   if (sUnique!="") return SMS_PowerFailed(oPC, "This item has " + sUnique + " properties and cannot be enchanted with this magic.");
   int nBonusCnt = SMS_GetItemBonusCount(oTarget, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N);
   int nBonusPower = 0;
   if (nBonusCnt) nBonusPower = SMS_GetItemCurrentBonus(oTarget, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, nClass);
   if (nBonusCnt>=1 && nBonusPower == 0) return SMS_PowerFailed(oPC, "This item has " + IntToString(nBonusCnt) + " bonus spell slot and cannot be enchanted any further.");
   if (nBonusPower == nMaxLevel) return SMS_PowerFailed(oPC, "This item has a level " + IntToString(nMaxLevel) + " " + sClass + " bonus spell slot and cannot be enchanted any further.");
   nBonusPower++;
   return SMS_TransferPower(oPC, oTarget, ItemPropertyBonusLevelSpell(nClass, nBonusPower), nVisual, sClass + " bonus slot increased to " + IntToString(nBonusPower));
}

int SMS_OnItemActivate(object oPC, object oTarget, object oItem)
{
   string sWhich = GetTag(oItem);
   if (!IPGetIsItemEquipable(oTarget))
   {
      SMS_PowerFailed(oPC, "Only equipable items may be enchanted.");
      return FALSE;
   }
   else if (sWhich == "SMS_SK_INTIMIDATE"){
      return SMS_NextSkill(oPC, oTarget, SKILL_INTIMIDATE, "Intimidate", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_DISABLETRAP"){
      return SMS_NextSkill(oPC, oTarget, SKILL_DISABLE_TRAP, "Disable Trap", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_OPENLOCK"){
      return SMS_NextSkill(oPC, oTarget, SKILL_OPEN_LOCK, "Open Lock", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_PICKPOCKET"){
      return SMS_NextSkill(oPC, oTarget, SKILL_PICK_POCKET, "Pick Pocket", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_SETTRAP"){
      return SMS_NextSkill(oPC, oTarget, SKILL_SET_TRAP, "Set Rrap", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_UMD"){
      return SMS_NextSkill(oPC, oTarget, SKILL_USE_MAGIC_DEVICE, "Use Magic Device", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_ANIMALEMPATHY"){
      return SMS_NextSkill(oPC, oTarget, SKILL_ANIMAL_EMPATHY, "Animal Empathy", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_CONCENTRATION"){
      return SMS_NextSkill(oPC, oTarget, SKILL_CONCENTRATION, "Concentration", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_DISCIPLINE"){
      return SMS_NextSkill(oPC, oTarget, SKILL_DISCIPLINE, "Discipline", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_HEAL"){
      return SMS_NextSkill(oPC, oTarget, SKILL_HEAL, "Heal", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_HIDE"){
      return SMS_NextSkill(oPC, oTarget, SKILL_HIDE, "Hide", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_LISTEN"){
      return SMS_NextSkill(oPC, oTarget, SKILL_LISTEN, "Listen", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_LORE"){
      return SMS_NextSkill(oPC, oTarget, SKILL_LORE, "Lore", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_MOVESILENTLY"){
      return SMS_NextSkill(oPC, oTarget, SKILL_MOVE_SILENTLY, "Move Silently", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_PARRY"){
      return SMS_NextSkill(oPC, oTarget, SKILL_PARRY, "Parry", VFX_IMP_CHARM);
   }else if (sWhich == "SMS_SK_PERFORM"){
      return SMS_NextSkill(oPC, oTarget, SKILL_PERFORM, "Perform", VFX_IMP_CHARM);
   } else if (sWhich == "SMS_SK_SEARCH") {
      return SMS_NextSkill(oPC, oTarget, SKILL_SEARCH, "Search", VFX_IMP_CHARM);
   } else if (sWhich == "SMS_SK_SPELLCRAFT") {
      return SMS_NextSkill(oPC, oTarget, SKILL_SPELLCRAFT, "Spellcraft", VFX_IMP_CHARM);
   } else if (sWhich == "SMS_SK_SPOT") {
      return SMS_NextSkill(oPC, oTarget, SKILL_SPOT, "Spot", VFX_IMP_CHARM);
   } else if (sWhich == "SMS_SK_TAUNT") {
      return SMS_NextSkill(oPC, oTarget, SKILL_TAUNT, "Taunt", VFX_IMP_CHARM);
   } else if (sWhich == "SMS_SK_TUMBLE") {
      return SMS_NextSkill(oPC, oTarget, SKILL_TUMBLE, "Tumble", VFX_IMP_CHARM);
   } else if (sWhich == "SMS_ATTACK") {
      return SMS_NextWeaponAttack(oPC, oTarget, VFX_FNF_HOWL_MIND);
   } else if (sWhich == "SMS_MIGHTY") {
      return SMS_NextWeaponMighty(oPC, oTarget, VFX_FNF_GAS_EXPLOSION_MIND);
   } else if (sWhich == "SMS_HOLYSWORD") {
      return SMS_AddHolySword(oPC, oTarget, VFX_FNF_SUMMON_CELESTIAL);
   } else if (sWhich == "SMS_KEEN") {
      return SMS_AddKeen(oPC, oTarget, VFX_FNF_MYSTICAL_EXPLOSION);
   } else if (sWhich == "SMS_AC") {
      return SMS_NextAC(oPC, oTarget, VFX_IMP_GLOBE_USE);
   } else if (sWhich == "SMS_SPELLRESIST") {
      return SMS_NextSpellResistance(oPC, oTarget, VFX_IMP_SPELL_MANTLE_USE);
   } else if (sWhich == "SMS_DARKVISION") {
      return SMS_AddDarkVision(oPC, oTarget, VFX_IMP_SILENCE);
   } else if (sWhich == "SMS_HASTE") {
      return SMS_AddHaste(oPC, oTarget, VFX_IMP_HASTE);
   } else if (sWhich == "SMS_REGEN") {
      return SMS_NextRegeneration(oPC, oTarget, VFX_IMP_RAISE_DEAD);
   } else if (sWhich == "SMS_VAMPREGEN") {
      return SMS_NextWeaponVampiric(oPC, oTarget, VFX_FNF_LOS_EVIL_10);
   } else if (sWhich == "SMS_IM_ACID") {
      return SMS_NextDamageImmunity(oPC, oTarget, IP_CONST_DAMAGETYPE_ACID);
   } else if (sWhich == "SMS_IM_COLD") {
      return SMS_NextDamageImmunity(oPC, oTarget, IP_CONST_DAMAGETYPE_COLD);
   } else if (sWhich == "SMS_IM_DIVINE") {
      return SMS_NextDamageImmunity(oPC, oTarget, IP_CONST_DAMAGETYPE_DIVINE);
   } else if (sWhich == "SMS_IM_ELECTRIC") {
      return SMS_NextDamageImmunity(oPC, oTarget, IP_CONST_DAMAGETYPE_ELECTRICAL);
   } else if (sWhich == "SMS_IM_FIRE") {
      return SMS_NextDamageImmunity(oPC, oTarget, IP_CONST_DAMAGETYPE_FIRE);
   } else if (sWhich == "SMS_IM_MAGIC") {
      return SMS_NextDamageImmunity(oPC, oTarget, IP_CONST_DAMAGETYPE_MAGICAL);
   } else if (sWhich == "SMS_IM_NEGATIVE") {
      return SMS_NextDamageImmunity(oPC, oTarget, IP_CONST_DAMAGETYPE_NEGATIVE);
   } else if (sWhich == "SMS_IM_POSITIVE") {
      return SMS_NextDamageImmunity(oPC, oTarget, IP_CONST_DAMAGETYPE_POSITIVE);
   } else if (sWhich == "SMS_IM_SONIC") {
      return SMS_NextDamageImmunity(oPC, oTarget, IP_CONST_DAMAGETYPE_SONIC);
   } else if (sWhich == "SMS_ST_CHA") {
      return SMS_NextAbility(oPC, oTarget, SMS_ABILITY_MAIN_ITEM_CHA, SMS_ABILITY_MAIN_ITEM_CHA_STRING, IP_CONST_ABILITY_CHA, "Charisma", VFX_FNF_NATURES_BALANCE);
   } else if (sWhich == "SMS_ST_CON") {
      return SMS_NextAbility(oPC, oTarget, SMS_ABILITY_MAIN_ITEM_CON, SMS_ABILITY_MAIN_ITEM_CON_STRING, IP_CONST_ABILITY_CON, "Constitution", VFX_FNF_NATURES_BALANCE);
   } else if (sWhich == "SMS_ST_DEX") {
       return SMS_NextAbility(oPC, oTarget, SMS_ABILITY_MAIN_ITEM_DEX, SMS_ABILITY_MAIN_ITEM_DEX_STRING, IP_CONST_ABILITY_DEX, "Dexterity", VFX_FNF_NATURES_BALANCE);
   } else if (sWhich == "SMS_ST_INT") {
      return SMS_NextAbility(oPC, oTarget, SMS_ABILITY_MAIN_ITEM_INT, SMS_ABILITY_MAIN_ITEM_INT_STRING, IP_CONST_ABILITY_INT, "Intellegence", VFX_FNF_NATURES_BALANCE);
   } else if (sWhich == "SMS_ST_STR") {
      return SMS_NextAbility(oPC, oTarget, SMS_ABILITY_MAIN_ITEM_STR, SMS_ABILITY_MAIN_ITEM_STR_STRING, IP_CONST_ABILITY_STR, "Strength", VFX_FNF_NATURES_BALANCE);
   } else if (sWhich == "SMS_ST_WIS") {
      return SMS_NextAbility(oPC, oTarget, SMS_ABILITY_MAIN_ITEM_WIS, SMS_ABILITY_MAIN_ITEM_WIS_STRING, IP_CONST_ABILITY_WIS, "Wisdom", VFX_FNF_NATURES_BALANCE);
   } else if (sWhich == "SMS_SAVE_FORTITUDE") {
      return SMS_NextSaveSpecific(oPC, oTarget, IP_CONST_SAVEBASETYPE_FORTITUDE, "Fortitude Save", VFX_FNF_GAS_EXPLOSION_MIND);
   } else if (sWhich == "SMS_SAVE_REFLEX") {
      return SMS_NextSaveSpecific(oPC, oTarget, IP_CONST_SAVEBASETYPE_REFLEX, "Reflex Save", VFX_FNF_GAS_EXPLOSION_MIND);
   } else if (sWhich == "SMS_SAVE_WILL") {
      return SMS_NextSaveSpecific(oPC, oTarget, IP_CONST_SAVEBASETYPE_WILL, "Will Save", VFX_FNF_GAS_EXPLOSION_MIND);
   } else if (sWhich == "SMS_SAVE_ACID") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_ACID, "Save Vs. Acid", VFX_COM_HIT_ACID);
   } else if (sWhich == "SMS_SAVE_COLD") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_COLD, "Save Vs. Cold", VFX_COM_HIT_FROST);
   } else if (sWhich == "SMS_SAVE_DEATH") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_DEATH, "Save Vs. Death", VFX_IMP_DEATH_WARD);
   } else if (sWhich == "SMS_SAVE_DISEASE") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_DISEASE, "Save Vs. Disease", VFX_IMP_DISEASE_S);
   } else if (sWhich == "SMS_SAVE_DIVINE") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_DIVINE, "Save Vs. Divine", VFX_COM_HIT_DIVINE);
   } else if (sWhich == "SMS_SAVE_ELECTRIC") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_ELECTRICAL, "Save Vs. Electric", VFX_COM_HIT_ELECTRICAL);
   } else if (sWhich == "SMS_SAVE_FEAR") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_FEAR, "Save Vs. Fear", VFX_DUR_MIND_AFFECTING_FEAR);
   } else if (sWhich == "SMS_SAVE_FIRE") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_FIRE, "Save Vs. Fire", VFX_COM_HIT_FIRE);
   } else if (sWhich == "SMS_SAVE_MIND") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_MINDAFFECTING, "Save Vs. Mind Affecting", VFX_IMP_DESTRUCTION);
   } else if (sWhich == "SMS_SAVE_NEGATIVE") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_NEGATIVE, "Save Vs. Negative Energy", VFX_COM_HIT_NEGATIVE);
   } else if (sWhich == "SMS_SAVE_POISON") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_POISON, "Save Vs. Poison", VFX_IMP_POISON_L);
   } else if (sWhich == "SMS_SAVE_POSITIVE") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_POSITIVE, "Save Vs. Positive Energy", VFX_COM_HIT_DIVINE);
   } else if (sWhich == "SMS_SAVE_SONIC") {
      return SMS_NextSaveVs(oPC, oTarget, IP_CONST_SAVEVS_SONIC, "Save Vs. Sonic ", VFX_COM_HIT_SONIC);

   } else if (sWhich == "SMS_DAM_BLUNT") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_BLUDGEONING);
   } else if (sWhich == "SMS_DAM_POINTY") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_PIERCING);
   } else if (sWhich == "SMS_DAM_SHARP") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_SLASHING);

   } else if (sWhich == "SMS_DAM_ACID") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_ACID);
   } else if (sWhich == "SMS_DAM_COLD") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_COLD);
   } else if (sWhich == "SMS_DAM_DIVINE") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_DIVINE);
   } else if (sWhich == "SMS_DAM_ELECTRIC") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_ELECTRICAL);
   } else if (sWhich == "SMS_DAM_FIRE") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_FIRE);
   } else if (sWhich == "SMS_DAM_MAGIC") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_MAGICAL);
   } else if (sWhich == "SMS_DAM_NEGATIVE") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_NEGATIVE);
   } else if (sWhich == "SMS_DAM_POSITIVE") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_POSITIVE);
   } else if (sWhich == "SMS_DAM_SONIC") {
      return SMS_NextWeaponDamage(oPC, oTarget, IP_CONST_DAMAGETYPE_SONIC);
   } else if (sWhich == "SMS_DAM_MASSCRIT") {
      return SMS_NextMassiveCritical(oPC, oTarget, VFX_FNF_GAS_EXPLOSION_EVIL);
   } else if (sWhich == "SMS_DR_ACID") {
      return SMS_NextDamageResistance(oPC, oTarget, IP_CONST_DAMAGETYPE_ACID);
   } else if (sWhich == "SMS_DR_COLD") {
      return SMS_NextDamageResistance(oPC, oTarget, IP_CONST_DAMAGETYPE_COLD);
   } else if (sWhich == "SMS_DR_MASSCRIT") {
      return SMS_NextMassiveCritical(oPC, oTarget, VFX_FNF_GAS_EXPLOSION_EVIL);
   } else if (sWhich == "SMS_DR_DIVINE") {
      return SMS_NextDamageResistance(oPC, oTarget, IP_CONST_DAMAGETYPE_DIVINE);
   } else if (sWhich == "SMS_DR_ELECTRIC") {
      return SMS_NextDamageResistance(oPC, oTarget, IP_CONST_DAMAGETYPE_ELECTRICAL);
   } else if (sWhich == "SMS_DR_FIRE") {
      return SMS_NextDamageResistance(oPC, oTarget, IP_CONST_DAMAGETYPE_FIRE);
   } else if (sWhich == "SMS_DR_MAGIC") {
      return SMS_NextDamageResistance(oPC, oTarget, IP_CONST_DAMAGETYPE_MAGICAL);
   } else if (sWhich == "SMS_DR_NEGATIVE") {
      return SMS_NextDamageResistance(oPC, oTarget, IP_CONST_DAMAGETYPE_NEGATIVE);
   } else if (sWhich == "SMS_DR_POSITIVE") {
      return SMS_NextDamageResistance(oPC, oTarget, IP_CONST_DAMAGETYPE_POSITIVE);
   } else if (sWhich == "SMS_DR_SONIC") {
      return SMS_NextDamageResistance(oPC, oTarget, IP_CONST_DAMAGETYPE_SONIC);
   } else if (sWhich == "SMS_SLOT_BARD") {
      return SMS_AddSpellSlot(oPC, oTarget, IP_CONST_CLASS_BARD, "Bard", 6, VFX_FNF_GAS_EXPLOSION_ACID);
   } else if (sWhich == "SMS_SLOT_CLERIC") {
      return SMS_AddSpellSlot(oPC, oTarget, IP_CONST_CLASS_CLERIC, "Cleric", 9, VFX_FNF_GAS_EXPLOSION_ACID);
   } else if (sWhich == "SMS_SLOT_DRUID") {
      return SMS_AddSpellSlot(oPC, oTarget, IP_CONST_CLASS_DRUID, "Druid", 9, VFX_FNF_GAS_EXPLOSION_ACID);
   } else if (sWhich == "SMS_SLOT_PALADIN") {
      return SMS_AddSpellSlot(oPC, oTarget, IP_CONST_CLASS_PALADIN, "Paladin", 4, VFX_FNF_GAS_EXPLOSION_ACID);
   } else if (sWhich == "SMS_SLOT_RANGER") {
      return SMS_AddSpellSlot(oPC, oTarget, IP_CONST_CLASS_RANGER, "Ranger", 4, VFX_FNF_GAS_EXPLOSION_ACID);
   } else if (sWhich == "SMS_SLOT_SORCERER") {
      return SMS_AddSpellSlot(oPC, oTarget, IP_CONST_CLASS_SORCERER, "Sorcerer", 9, VFX_FNF_GAS_EXPLOSION_ACID);
   } else if (sWhich == "SMS_SLOT_WIZARD") {
      return SMS_AddSpellSlot(oPC, oTarget, IP_CONST_CLASS_WIZARD, "Wizard", 9, VFX_FNF_GAS_EXPLOSION_ACID);
   } else if (sWhich == "SMS_OH_DAZE") {
      return SMS_NextOnHit(oPC, oTarget, IP_CONST_ONHIT_DAZE, VFX_IMP_DAZED_S);
   } else if (sWhich == "SMS_OH_FEAR") {
      return SMS_NextOnHit(oPC, oTarget, IP_CONST_ONHIT_FEAR, VFX_DUR_MIND_AFFECTING_FEAR);
   } else if (sWhich == "SMS_OH_HOLD") {
      return SMS_NextOnHit(oPC, oTarget, IP_CONST_ONHIT_HOLD, VFX_DUR_PARALYZE_HOLD);
   } else if (sWhich == "SMS_OH_SLOW") {
      return SMS_NextOnHit(oPC, oTarget, IP_CONST_ONHIT_SLOW, VFX_IMP_SLOW);
   } else if (sWhich == "SMS_OH_STUN") {
      return SMS_NextOnHit(oPC, oTarget, IP_CONST_ONHIT_STUN, VFX_IMP_STUN);
   }
   return SMS_PowerFailed(oPC, "Unknown SMS item.");
}

//void main(){}



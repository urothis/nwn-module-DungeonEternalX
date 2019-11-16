///////////////////////////////////////////////
//:: Name Seed Property Stripper
//:: FileName seed_strip_ill
//:://////////////////////////////////////////////
/*
    Removes all illegal properties, downgrades overpowered ones, and compensates player for loss.
*/
#include "x2_inc_switches"
#include "x2_inc_itemprop"
//#include "flel_crafter_inc"
#include "gen_inc_color"
#include "seed_random_magi"

void DestroyAmmoCreator(object oPC)
{
   object oAmmoCreator = GetItemPossessedBy(oPC, "flel_it_ammo_crt");
   if (GetIsObjectValid(oAmmoCreator))
   {
      object oAmmoCreator2 = RetrieveCampaignObject("AMMO_CREATORS","ACRT_", GetLocation(oPC), oPC, oPC);
      GiveGoldToCreature(oPC, GetGoldPieceValue(oAmmoCreator2) * 3);
      DestroyObject(oAmmoCreator);
   }
}

void WTSLE(string sText)
{
   // WriteTimestampedLogEntry(sText);
}

const int MAX_DICE_DAMAGE = IP_CONST_DAMAGEBONUS_2d6;
const int MAX_FIXED_DAMAGE = IP_CONST_DAMAGEBONUS_6;

// COUNT SKILL TYPES
int iSkillCurrent;
int iSkillValue;
int iSK1 = 0;
int iSK2 = 0;
int iSK3 = 0;
int iSK4 = 0;
int iSK1_VAL = 0;
int iSK2_VAL = 0;
int iSK3_VAL = 0;
int iSK4_VAL = 0;

void SaveSkill(int nSkill, int nValue)
{
   iSkillValue = iSkillValue + nValue; // SUM UP THE SKILL POINTS
   if (!iSK1_VAL) {
      iSK1 = nSkill;
      iSK1_VAL = nValue;
   } else if (!iSK2_VAL) {
      iSK2 = nSkill;
      iSK2_VAL = nValue;
   } else if (!iSK3_VAL) {
      iSK3 = nSkill;
      iSK3_VAL = nValue;
   } else if (!iSK4_VAL) {
      iSK4 = nSkill;
      iSK4_VAL = nValue;
   }
   return;
}
void FindMaxSkill()
{
   if (iSK1_VAL>iSK2_VAL && iSK1_VAL>iSK3_VAL && iSK1_VAL>iSK4_VAL) {
      iSkillValue = iSK1_VAL;
      iSkillCurrent = iSK1;
      iSK1 = 0;
      iSK1_VAL = 0;
   } else if (iSK2_VAL>iSK3_VAL && iSK2_VAL>iSK4_VAL) {
      iSkillValue = iSK2_VAL;
      iSkillCurrent = iSK2;
      iSK2 = 0;
      iSK2_VAL = 0;
   } else if (iSK3_VAL>iSK4_VAL) {
      iSkillValue = iSK3_VAL;
      iSkillCurrent = iSK3;
      iSK3 = 0;
      iSK3_VAL = 0;
   } else if (iSK4_VAL>0){
      iSkillValue = iSK4_VAL;
      iSkillCurrent = iSK4;
      iSK4 = 0;
      iSK4_VAL = 0;
   } else {
      iSkillValue = 0;
      iSkillCurrent = 0;
   }
}

// COUNT SAVE TYPES
int iSaveVsCurrent;
int iSaveVsValue;
int iSV1 = 0;
int iSV2 = 0;
int iSV3 = 0;
int iSV1_VAL = 0;
int iSV2_VAL = 0;
int iSV3_VAL = 0;

void SaveSaveVs(int nSaveVs, int nValue) {
   iSaveVsValue = iSaveVsValue + nValue; // SUM UP THE POINTS
   if (!iSV1_VAL) {
      iSV1 = nSaveVs;
      iSV1_VAL = nValue;
   } else if (!iSV2_VAL) {
      iSV2 = nSaveVs;
      iSV2_VAL = nValue;
   } else if (!iSV3_VAL) {
      iSV3 = nSaveVs;
      iSV3_VAL = nValue;
   }
   return;
}
void FindMaxSaveVs() {
   if (iSV1_VAL>iSV2_VAL && iSV1_VAL>iSV3_VAL) {
      iSaveVsValue = iSV1_VAL;
      iSaveVsCurrent = iSV1;
      iSV1 = 0;
      iSV1_VAL = 0;
   } else if (iSV2_VAL>iSV3_VAL) {
      iSaveVsValue = iSV2_VAL;
      iSaveVsCurrent = iSV2;
      iSV2 = 0;
      iSV2_VAL = 0;
   } else if (iSV3_VAL>0) {
      iSaveVsValue = iSV3_VAL;
      iSaveVsCurrent = iSV3;
      iSV3 = 0;
      iSV3_VAL = 0;
   } else {
      iSaveVsValue = 0;
      iSaveVsCurrent = 0;
   }
}

// COUNT SAVE BIG3 TYPES
int iSaveBigValue;
int iSaveBigCurrent;
int iSB1 = 0;
int iSB2 = 0;
int iSB3 = 0;
int iSB1_VAL = 0;
int iSB2_VAL = 0;
int iSB3_VAL = 0;
void SaveSaveBig(int nSaveBig, int nValue) {
   iSaveBigValue = iSaveBigValue + nValue; // SUM UP THE POINTS
   if (!iSB1_VAL) {
      iSB1 = nSaveBig;
      iSB1_VAL = nValue;
   } else if (!iSB2_VAL) {
      iSB2 = nSaveBig;
      iSB2_VAL = nValue;
   } else if (!iSB3_VAL) {
      iSB3 = nSaveBig;
      iSB3_VAL = nValue;
   }
   return;
}
void FindMaxSaveBig() {
   if (iSB1_VAL>iSB2_VAL && iSB1_VAL>iSB3_VAL) {
      iSaveBigValue = iSB1_VAL;
      iSaveBigCurrent = iSB1;
      iSB1 = 0;
      iSB1_VAL = 0;
   } else if (iSB2_VAL>iSB3_VAL) {
      iSaveBigValue = iSB2_VAL;
      iSaveBigCurrent = iSB2;
      iSB2 = 0;
      iSB2_VAL = 0;
   } else if (iSB3_VAL>0) {
      iSaveBigValue = iSB3_VAL;
      iSaveBigCurrent = iSB3;
      iSB3 = 0;
      iSB3_VAL = 0;
   } else {
      iSaveBigValue = 0;
      iSaveBigCurrent = 0;
   }
}


void Compensate(object oPC)
{
   int iSlot=0;
   int iGP = 0;
   object oItem;
   for(iSlot = 0; iSlot < NUM_INVENTORY_SLOTS; iSlot++)
   {
      oItem = GetItemInSlot(iSlot, oPC);
      if (GetIsObjectValid(oItem)) iGP = iGP + GetGoldPieceValue(oItem);
   }
   oItem = GetFirstItemInInventory(oPC);
   while(GetIsObjectValid(oItem))
   {
      iGP = iGP + GetGoldPieceValue(oItem);
      oItem = GetNextItemInInventory(oPC);
   }
   int iOldGP = GetLocalInt(oPC, "ITEMS_VALID");
   if (iOldGP > 0) { // SECOND RUN, GIVE DIFFERENCE
      /*int iComp = iOldGP - iGP;
      SendMessageToPC(oPC, "New net worth is " + IntToString(iGP) + ". You were compensated " + IntToString(iComp));
      DeleteLocalInt(oPC, "ITEMS_VALID");
      if (iComp > 0) {
         GiveGoldToCreature(oPC, iComp);
         WTSLE(GetName(oPC) + ": PLAYER COMPENSATED: Start - End = Gold " + IntToString(iOldGP) + " - " + IntToString(iGP) + " = " + IntToString(iComp));
      }*/

      SendMessageToPC(oPC, GetRGB(11,9,11) + "Success! Your items were forced into compliance with the item rules. Read your journal for more information.");
   } else { // FIRST RUN, STORE THE VALUE
      SetLocalInt(oPC, "ITEMS_VALID", iGP);
      WTSLE(GetName(oPC) + ": PLAYER WORTH: " + IntToString(iGP));
      SendMessageToPC(oPC, "Your net worth is " + IntToString(iGP));
   }
}

// THESE FUNCTIONS SET UP AN ARRAY TO HANDLE THE ABILITY BONUS CHECKS
int iSTR = 0; int iDEX = 0; int iCON = 0; int iINT = 0; int iWIS = 0; int iCHA = 0;
itemproperty ipSTR; itemproperty ipDEX; itemproperty ipCON;
itemproperty ipINT; itemproperty ipWIS; itemproperty ipCHA;
int GetStat(int p) {
   if      (p == IP_CONST_ABILITY_STR) return iSTR; else if (p == IP_CONST_ABILITY_DEX) return iDEX;
   else if (p == IP_CONST_ABILITY_CON) return iCON; else if (p == IP_CONST_ABILITY_INT) return iINT;
   else if (p == IP_CONST_ABILITY_WIS) return iWIS; else if (p == IP_CONST_ABILITY_CHA) return iCHA;
   return 0;
}
void SetStat(int p, int v) {
   if      (p == IP_CONST_ABILITY_STR) iSTR = v; else if (p == IP_CONST_ABILITY_DEX) iDEX = v;
   else if (p == IP_CONST_ABILITY_CON) iCON = v; else if (p == IP_CONST_ABILITY_INT) iINT = v;
   else if (p == IP_CONST_ABILITY_WIS) iWIS = v; else if (p == IP_CONST_ABILITY_CHA) iCHA = v;
}
void SetStatIP(int p, itemproperty v) {
   if      (p == IP_CONST_ABILITY_STR) ipSTR = v; else if (p == IP_CONST_ABILITY_DEX) ipDEX = v;
   else if (p == IP_CONST_ABILITY_CON) ipCON = v; else if (p == IP_CONST_ABILITY_INT) ipINT = v;
   else if (p == IP_CONST_ABILITY_WIS) ipWIS = v; else if (p == IP_CONST_ABILITY_CHA) ipCHA = v;
}
itemproperty GetStatIP(int p) {
   if      (p == IP_CONST_ABILITY_STR) return ipSTR; else if (p == IP_CONST_ABILITY_DEX) return ipDEX;
   else if (p == IP_CONST_ABILITY_CON) return ipCON; else if (p == IP_CONST_ABILITY_INT) return ipINT;
   else if (p == IP_CONST_ABILITY_WIS) return ipWIS; else if (p == IP_CONST_ABILITY_CHA) return ipCHA;
   return ipCHA;
}
int MaxStat() {
   if (iSTR>0 && iSTR>=iDEX && iSTR>=iCON && iSTR>=iINT && iSTR>=iWIS && iSTR>=iCHA) return IP_CONST_ABILITY_STR;
   if (iDEX>0 && iDEX>=iSTR && iDEX>=iCON && iDEX>=iINT && iDEX>=iWIS && iDEX>=iCHA) return IP_CONST_ABILITY_DEX;
   if (iCON>0 && iCON>=iSTR && iCON>=iDEX && iCON>=iINT && iCON>=iWIS && iCON>=iCHA) return IP_CONST_ABILITY_CON;
   if (iINT>0 && iINT>=iSTR && iINT>=iCON && iINT>=iDEX && iINT>=iWIS && iINT>=iCHA) return IP_CONST_ABILITY_INT;
   if (iWIS>0 && iWIS>=iSTR && iWIS>=iCON && iWIS>=iINT && iWIS>=iDEX && iWIS>=iCHA) return IP_CONST_ABILITY_WIS;
   if (iCHA>0 && iCHA>=iSTR && iCHA>=iCON && iCHA>=iINT && iCHA>=iWIS && iCHA>=iDEX) return IP_CONST_ABILITY_CHA;
   return 0;
}
void FixStat(object oItem, int iPos) {
   itemproperty ipThis = GetStatIP(iPos);
   if (GetIsItemPropertyValid(ipThis)) { // HAD PROP BEFORE, LETS SEE WHAT HAS HAPPENED TO IT
      int iOld = GetItemPropertyCostTableValue(ipThis); // OLD VALUE
      int iNew = GetStat(GetItemPropertySubType(ipThis)); // NEW VALUE
      if (iOld != iNew) {
         RemoveItemProperty(oItem, ipThis);
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(iPos, iNew), oItem);
         WTSLE("     ITEM_PROPERTY_ABILITY_BONUS (" + AbilityString(iPos) + ") was " + IntToString(iOld) + " changed to " + IntToString(iNew));
      }
   }
}

int RemoveProperty(object oItem, itemproperty ipProperty, string sWhich = "ITEM_PROPERTY_ATTACK_BONUS") {
   RemoveItemProperty(oItem, ipProperty);
   WTSLE("     " + sWhich + " : removed");
   return TRUE;
}

// COUNTS # OF ITEMS BONUSES OF A SPECIFIC TYPE
// OPTIONALLY SUMS TOTAL ITEMS BONUSES OF A SPECIFIC TYPE (ie TOTAL # of SKILL POINTS RATHER THAN SKILL COUNT)
int GetItemBonusCount(object oTarget, int iBonusType, int bSum = FALSE) {
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



int DamageDiceValue(int iDamageAmount) {
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_1d4)  return 4 ;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_1d6)  return 6 ;
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_1d8)  return 8 ;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_2d4)  return 8 ;
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_1d10) return 10;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_1d12) return 12;
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_2d6)  return 12;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_2d8)  return 16;
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_2d10) return 20;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_2d12) return 24;
   return 0;
}

int DamageFixedValue(int iDamageAmount) {
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_1 )  return 1 ;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_2 )  return 2 ;
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_3 )  return 3 ;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_4 )  return 4 ;
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_5 )  return 5 ;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_6 )  return 6 ;
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_7 )  return 7 ;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_8 )  return 8 ;
   if (iDamageAmount==IP_CONST_DAMAGEBONUS_9 )  return 9 ;   if (iDamageAmount==IP_CONST_DAMAGEBONUS_10)  return 10;
   return 0;
}

int GetMaxDamageDice(object oItem) { // determine max damage dice per weapon - Flel
   int nType = GetBaseItemType(oItem);
   if (nType == BASE_ITEM_DAGGER              || nType == BASE_ITEM_HANDAXE      || nType == BASE_ITEM_KAMA ||
       nType == BASE_ITEM_KUKRI               || nType == BASE_ITEM_LIGHTHAMMER  || nType == BASE_ITEM_LIGHTMACE ||
       nType == BASE_ITEM_SHORTSWORD          || nType == BASE_ITEM_SICKLE       || nType == BASE_ITEM_WHIP)
      return SMS_WEAPON_MODS_SMALL;
   else if (nType == BASE_ITEM_BASTARDSWORD   || nType == BASE_ITEM_BATTLEAXE    || nType == BASE_ITEM_CLUB ||
            nType == BASE_ITEM_DWARVENWARAXE  || nType == BASE_ITEM_KATANA       || nType == BASE_ITEM_LIGHTFLAIL ||
            nType == BASE_ITEM_LONGSWORD      || nType == BASE_ITEM_MORNINGSTAR  || nType == BASE_ITEM_RAPIER ||
            nType == BASE_ITEM_SCIMITAR       || nType == BASE_ITEM_WARHAMMER)
      return SMS_WEAPON_MODS_MEDIUM;
   else if (nType == BASE_ITEM_DIREMACE       || nType == BASE_ITEM_DOUBLEAXE    || nType == BASE_ITEM_GREATAXE ||
            nType == BASE_ITEM_GREATSWORD     || nType == BASE_ITEM_HALBERD      || nType == BASE_ITEM_HEAVYFLAIL ||
            nType == BASE_ITEM_QUARTERSTAFF   || nType == BASE_ITEM_SCYTHE       || nType == BASE_ITEM_SHORTSPEAR ||
            nType == BASE_ITEM_TWOBLADEDSWORD || nType == BASE_ITEM_BASTARDSWORD)
      return SMS_WEAPON_MODS_LARGE;
   else if (nType == BASE_ITEM_ARROW          || nType == BASE_ITEM_BOLT         || nType == BASE_ITEM_BULLET)
      return SMS_WEAPON_MODS_AMMO;
   else if (nType == BASE_ITEM_DART           || nType == BASE_ITEM_SHURIKEN     || nType == BASE_ITEM_THROWINGAXE)
      return SMS_WEAPON_MODS_THROWING;
   else if (nType == BASE_ITEM_GLOVES         || nType == BASE_ITEM_BRACER)
      return SMS_WEAPON_MODS_GLOVES;
   return 0;
}

int FixMaxBonus(object oItem, itemproperty ipProperty, int iMaxBonus, int iWhich, string sWhich) {
   itemproperty ipAdd;
   int iSubType=GetItemPropertySubType(ipProperty);
   int iBonus = GetItemPropertyCostTableValue(ipProperty);
   if (iBonus > iMaxBonus) {
      RemoveItemProperty(oItem, ipProperty);
      switch (GetItemPropertyType(ipProperty)) {
         case ITEM_PROPERTY_AC_BONUS:
            ipAdd = ItemPropertyACBonus(iMaxBonus);
            break;
         case ITEM_PROPERTY_ATTACK_BONUS:
            ipAdd = ItemPropertyAttackBonus(iMaxBonus);
            break;
         case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            ipAdd = ItemPropertyEnhancementBonus(iMaxBonus);
            break;
         case ITEM_PROPERTY_MIGHTY:
            ipAdd = ItemPropertyMaxRangeStrengthMod(iMaxBonus);
            break;
         case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
            ipAdd = ItemPropertyVampiricRegeneration(iMaxBonus);
            break;
         case ITEM_PROPERTY_REGENERATION:
            ipAdd = ItemPropertyRegeneration(iMaxBonus);
            break;
         case ITEM_PROPERTY_SKILL_BONUS:
            ipAdd = ItemPropertySkillBonus(iSubType, iMaxBonus);
            break;
         case ITEM_PROPERTY_SAVING_THROW_BONUS:
            ipAdd = ItemPropertyBonusSavingThrowVsX(iSubType, iMaxBonus);
            break;
         case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            ipAdd = ItemPropertyBonusSavingThrow(iSubType, iMaxBonus);
            break;
      }
      AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oItem);  //IPSafeAddItemProperty(oItem, ipAdd);
      WTSLE("     " + sWhich + " : was " + IntToString(iBonus) + " changed to " + IntToString(iMaxBonus));
      return TRUE;
   }
   return FALSE;
}

int FixMaxDamage(object oItem, itemproperty ipProperty, int iWhich, string sWhich) {
   itemproperty ipAdd;
   int iSubType=GetItemPropertySubType(ipProperty);
   int iBonus = GetItemPropertyCostTableValue(ipProperty);
   int iNewDamage;
   int iMaxBonus;
   int bReplace = FALSE;
   int iDamage = DamageFixedValue(iBonus);
   if (iDamage > 0) { // FIXED DAMAGE AMOUNT
      iMaxBonus  = DamageFixedValue(MAX_FIXED_DAMAGE);
      if (iDamage > iMaxBonus) {
         bReplace = TRUE;
         iNewDamage = MAX_FIXED_DAMAGE;
         sWhich = sWhich + " (FIXED) ";
      }
   } else {
      iDamage = DamageDiceValue(iBonus);
      if (iDamage > 0) { // DICED DAMAGE AMOUNT
         iMaxBonus  = DamageDiceValue(MAX_DICE_DAMAGE);
         if (iDamage > iMaxBonus) {
            bReplace = TRUE;
            iNewDamage = MAX_DICE_DAMAGE;
            sWhich = sWhich + " (DICE) ";
         }
      } else {
         WTSLE("    oh that's not good - no damage value found..." );
      }

   }
   if (bReplace) {
      RemoveItemProperty(oItem, ipProperty);
      switch (GetItemPropertyType(ipProperty)) {
         case ITEM_PROPERTY_MASSIVE_CRITICALS:
            ipAdd = ItemPropertyMassiveCritical(iNewDamage);
            break;
         case ITEM_PROPERTY_DAMAGE_BONUS:
            ipAdd = ItemPropertyDamageBonus(iSubType, iNewDamage);
            break;
      }
      AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oItem);  //IPSafeAddItemProperty(oItem, ipAdd);
      WTSLE("     " + sWhich + " (" + DamageTypeString(iSubType) + ") was " + DamageBonusString(iBonus) + " changed to " + DamageBonusString(iNewDamage));
      return TRUE;
   }
   return FALSE;
}

void StripIllegalProps(object oItem) {
   object oPC = GetItemPossessor(oItem);
   if (GetLocalInt(oItem, "FORCE_VALID")) return;

   int nBaseItemType = GetBaseItemType(oItem);
   if (!GetIsEquipable(nBaseItemType)) return;

   WTSLE(GetName(oPC) + ": Checking Item: " + GetName(oItem) + " : " + GetTag(oItem));
   int iPropType;
   int iSubType;
   int iBonus;
   int bRestart = FALSE;
   int iFixCnt = 0;
   //TRACKS A UNIQUE ABILITY
   int iFoundUnique = -1; // WHEN WE FIND A UNIQUE PROPERTY TYPE, SAVE THE TYPE HERE - REMOVE ALL TYPES NOT EQUAL TO THIS TYPE AFTER THAT
   //SPELL SLOT VARS
   int iSpellMaxLvl = -1;
   int iSpellClass = 0;
   //ABILITY BONUS VARS
   int iAbilityTotal = GetItemBonusCount(oItem, ITEM_PROPERTY_ABILITY_BONUS, TRUE); // SUM OF TOTAL ABILITY POINTS
   if (iAbilityTotal > 0) iFoundUnique = ITEM_PROPERTY_ABILITY_BONUS; // IF WE HAVE ABILITY POINTS ON THE ITEM, FAVOR THEM OVER OTHER UNIQUE PROPERTIES
   int iStartingValue = GetGoldPieceValue(oItem);

   int iSkillPoints = GetItemBonusCount(oItem, ITEM_PROPERTY_SKILL_BONUS, TRUE); // GET TOTAL SKILL POINTS
   int iSaveBigPoints = GetItemBonusCount(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, TRUE); // GET TOTAL SAVE POINTS
   int iSaveVsPoints = GetItemBonusCount(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS, TRUE); // GET TOTAL SAVE POINTS
   int iFortPoints = 0;
   // COUNT DAMAGE TYPES
   int nDamageModCount = GetMaxDamageDice(oItem);
   int iD1 = -1;
   int iD2 = -1;
   int iD3 = -1;
   int iD4 = -1;

   int iMaxDamage = nDamageModCount * MAX_DAMAGE_PER_MOD;
   int iTotalDamage = SMS_SumDamageBonuses(oItem);
   WTSLE("     this item gets Damage count: " + IntToString(nDamageModCount) + " and total damage of " + IntToString(iMaxDamage) + " : This item has "  + IntToString(iTotalDamage));

   // Ezramun: no stackable properties on throwing weapons allowed. was possible to exploit it
   int nThrowing = FALSE;
   if (nBaseItemType == BASE_ITEM_SHURIKEN || nBaseItemType == BASE_ITEM_THROWINGAXE || nBaseItemType == BASE_ITEM_DART)
   {
      nThrowing = TRUE;
   }

   itemproperty ipAdd;
   itemproperty ipProperty =  GetFirstItemProperty(oItem);
   while (GetIsItemPropertyValid(ipProperty) && iFixCnt<50) { // iFixCnt<XXX is a short circuit to kill loop if executed more than XXX times
      iPropType = GetItemPropertyType(ipProperty);
      iSubType=GetItemPropertySubType(ipProperty);
      iBonus = GetItemPropertyCostTableValue(ipProperty);
      if (GetItemPropertyDurationType(ipProperty)==DURATION_TYPE_TEMPORARY) {
         RemoveItemProperty(oItem, ipProperty);
         ipProperty = GetNextItemProperty(oItem);
         continue;
      }
      //WTSLE("   CHECKING PROP " + IntToString(iPropType));
      switch (iPropType) {
         case ITEM_PROPERTY_ABILITY_BONUS:                              // Increases one of the six primary ability scores.
            if (nThrowing)
            {
               // Ezramun: No throwing weapon with stackable stats allowed
               DestroyAmmoCreator(oPC);
               Insured_Destroy(oItem);
               return;
            }
            else
            {
               if (iFoundUnique == -1) iFoundUnique = iPropType;
               if (iFoundUnique == iPropType) {
                  SetStat(iSubType, iBonus);
                  SetStatIP(iSubType, ipProperty);
               } else {
                  bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ABILITY_BONUS: UNIQUE PROP VIOLATION!");
                  iAbilityTotal = 0; // ZERO THIS, WE ARE STRIPPING THEM ALL
               }
            }
            break;
         case ITEM_PROPERTY_AC_BONUS:                                   // Grants a bonus to armor class (AC).
            bRestart = FixMaxBonus(oItem, ipProperty, SMS_AC_MAX, ITEM_PROPERTY_AC_BONUS, "ITEM_PROPERTY_AC_BONUS");
            break;
         case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:                // Grants a bonus to armor class (AC) when attacked by a particular alignment group (Lawful, Neutral, Chaotic).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP");
            break;
         case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:                    // Grants a bonus to armor class (AC) when attacked by a specific damage type (see DAMAGE_TYPE_* for available damage types).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE");
            break;
         case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:                   // Grants a bonus to armor class (AC) when attacked by a member of a particular racial group (see RACIAL_TYPE_* for racial groups).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP");
            break;
         case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:             // Grants a bonus to armor class (AC) when attacked by a specific alignment (Lawful, Neutral, Chaotic; and Good, Neutral, or Evil).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT");
            break;
         case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:                       //
            break;
         case ITEM_PROPERTY_ATTACK_BONUS:                               // Grants the wearer/wielder a bonus to attack rolls.
            bRestart = FixMaxBonus(oItem, ipProperty, SMS_AB_MAX, ITEM_PROPERTY_ATTACK_BONUS, "ITEM_PROPERTY_ATTACK_BONUS");
            break;
         case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:         //  Grants the wearer/wielder a bonus to attack rolls against a specific alignment group (Lawful, Neutral, Chaotic; and Good, Neutral, or Evil). Note that "alignment" in this constant literally reads "ALIGNEMENT".
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT");
            break;
         case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:               // Grants the wearer/wielder a bonus to attack rolls against a particular racial group (see RACIAL_TYPE_* for available racial groups).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP");
            break;
         case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:            // Grants the wearer/wielder a bonus to attack rolls against a particular alignment group (Lawful, Neutral, or Chaotic).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP");
            break;
         case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:                 // Reduces the weight of the item this property is applied to.
            break;
         case ITEM_PROPERTY_BONUS_FEAT:                                 // Grants the wearer/wielder a bonus feat specific to the item.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_BONUS_FEAT");
            break;
         case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:                // Grants the wearer/wielder a bonus spell slot of a specified level, if the wearer/wielder is capable of casting a particular type of magic (divine or arcane).
            // **** THIS IS HARD CODED TO A SINGLE SLOT PER ITEM, THIS WOULD NEED WORK IF MORE THAN ONE OR A SUM OF LEVELS APPROACH IS NEEDED
            if (iFoundUnique == -1) iFoundUnique = iPropType;
            if (iFoundUnique == iPropType) {
               if (iBonus > iSpellMaxLvl) { // SAVE THE MAX CLASS/SLOT ON THE ITEM
                  iSpellClass = iSubType;
                  iSpellMaxLvl = iBonus;
               }
               bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N");
            } else {
               bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N: UNIQUE PROP VIOLATION!");
            }
            break;
         case ITEM_PROPERTY_CAST_SPELL:                                 // Casts a spell.

            break;
         case ITEM_PROPERTY_DAMAGE_BONUS:                               // Grants a damage bonus (see DAMAGE_BONUS_* for damage bonuses).
            if (iTotalDamage > iMaxDamage) { // DAMAGE EXCEEDED, STRIP ALL AND ADD BACK MAX
               if      (iD1==-1) iD1 = iSubType;
               else if (iD2==-1) iD2 = iSubType;
               else if (iD3==-1) iD3 = iSubType;
               else if (iD4==-1) iD4 = iSubType;
               RemoveItemProperty(oItem, ipProperty);
            }
            break;
         case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:               // Grants a damage bonus (see DAMAGE_BONUS_* for damage bonuses) against a racial group (see RACIAL_TYPE_* for racial groups).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP");
            break;
         case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:            // Grants a damage bonus (see DAMAGE_BONUS_* for damage bonuses) against a particular alignment group (Lawful, Neutral, or Chaotic).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP");
            break;
         case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:         // Grants a damage bonus (see DAMAGE_BONUS_* for damage bonuses) against a specific alignment (Lawful, Neutral, Chaotic; and Good, Neutral, or Evil).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT");
            break;
         case ITEM_PROPERTY_DAMAGE_REDUCTION:                           // Grants the wearer/wielder damage reduction to a particular damage type (see DAMAGE_TYPE_* for damage types). Note damage reduction can normally be passed by weapons or attacks with certain magical enhancement bonuses.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DAMAGE_REDUCTION");
            break;
         case ITEM_PROPERTY_DAMAGE_RESISTANCE:                          // Grants the weilder/wearer complete immunity to a particular type of damage (see DAMAGE_TYPE_* for damage types).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DAMAGE_RESISTANCE");
            break;
         case ITEM_PROPERTY_DAMAGE_VULNERABILITY:                       // Gives the wearer/wielder an inherant weakness to a particular type of damage (see DAMAGE_TYPE_* for damage types).
            break;
         case ITEM_PROPERTY_DARKVISION:                                 // Grants the wearer/wielder darkvision (ability to see in complete darkness).
            break;
         case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:                    // Gives the wearer/wielder a decreased ability score in one of the six primary abilities. Normally this is the result of a curse.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DECREASED_ABILITY_SCORE");
            break;
         case ITEM_PROPERTY_DECREASED_AC:                               // Gives the wearer/wielder a decreased armor class (AC). Normally this is the result of a curse.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DECREASED_AC");
            break;
         case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:                  // Gives the wearer/wielder a decreased attack roll modifier. This is normally due to a curse.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER");
            break;
         case ITEM_PROPERTY_DECREASED_DAMAGE:                           // Causes the item, typically a weapon (missile or melee), to inflict decreased damage. Normally cursed items have decreased damage, but damaged, worn, or ruined items may also be affected by this property.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DECREASED_DAMAGE");
            break;
         case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:             // Usually denotes a cursed item by applying some sort of negative modifier to an item, typically a weapon (missile or melee).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER");
            break;
         case ITEM_PROPERTY_DECREASED_SAVING_THROWS:                    // Gives the wearer/wielder a general decrease to all three types of saving throws. This is normally the effect of a curse.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DECREASED_SAVING_THROWS");
            break;
         case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:           // Gives the wearer/wielder a general decrease to a specific type of saving throw (Fortitude, Reflex, Will). This is normally the effect of a curse.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC");
            break;
         case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:                   // Gives the wearer/wielder a decreased skill modifier to a particular skill. Normally this is the result of a curse.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_DECREASED_SKILL_MODIFIER");
            break;
         case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:          // Grants a magical container reduced overall weight for making heavy things easier to carry.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT");
            break;
         case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:    // Grants an enhancement bonus to an item, typically a weapon (missile or melee), against a specific alignment combination (Lawful, Neutral, Chaotic; and Good, Neutral, or Evil).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT");
            break;
         case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:       // Grants an enhancement bonus to an item, typically a weapon (missile or melee), against a particular alignment group (Lawful, Neutral, Chaotic).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP");
            break;
         case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:          // Grants an enhancement bonus to an item, typically a weapon (missile or melee), against a particular racial group (see RACIAL_TYPE_* for a racial groups).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP");
            break;
         case ITEM_PROPERTY_ENHANCEMENT_BONUS:                          // Grants an enhancement bonus to an item, typically a weapon (missile or melee).
            bRestart = FixMaxBonus(oItem, ipProperty, SMS_AB_MAX, ITEM_PROPERTY_ENHANCEMENT_BONUS, "ITEM_PROPERTY_ENHANCEMENT_BONUS");
            break;
         case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:                    // Extra damage type dealt with a melee weapon (see DAMAGE_TYPE_* for available damage types).
            WTSLE("***     ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE");
            break;
         case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:                   // Extra damage type dealt with a missile weapon (see DAMAGE_TYPE_* for available damage types).
            WTSLE("***     ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE");
            break;
         case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:                        // Grants the wearer/wielder the ability to move freely in environments that restrict movements (like that of an area effected by a Web or Entangle spell).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_FREEDOM_OF_MOVEMENT");
            break;
         case ITEM_PROPERTY_HASTE:                                      // Grants the wearer/wielder the benefits of a Haste spell (allows an extra partial action every round (six seconds)).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_HASTE");
            break;
         case ITEM_PROPERTY_HEALERS_KIT:                                //
            break;
         case ITEM_PROPERTY_HOLY_AVENGER:                               // Oh, the destruction that can be wrought when found in the hands of a paladin...
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_HOLY_AVENGER");
            break;
         case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:                       // Grants the wearer/wielder immunity to a particular damage type (see DAMAGE_TYPE_* for damage types).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE");
            break;
         case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:                     // Grants one of the following immunities: Critical hits, death magic, disease, fear, knockdown, level/ability drain, mind-affecting spells, paralysis, poison, or sneak attack.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS");
            break;
         case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:                    // Grants the wearer/wielder immunity to a specific spell.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL");
            break;
         case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:                      //
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL");
            break;
         case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:                   // Grants the wearer/wielder immunity to all spells of a particular level.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL");
            break;
         case ITEM_PROPERTY_IMPROVED_EVASION:                           // Grants the wearer/wielder the improved evasion special ability (allows them to completely avoid area of effect spells on a successful saving throw, half damage on a failed save, and avoid traps that require reflex saves).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_IMPROVED_EVASION");
            break;
         case ITEM_PROPERTY_KEEN:                                       // Doubles the threat range of a piercing or slashing weapon.
            break;
         case ITEM_PROPERTY_LIGHT:                                      // Generates light.
            break;
         case ITEM_PROPERTY_MASSIVE_CRITICALS:                          // Unknown. Speculation: A weapon with this property deals maximum damage on a successful critical hit.
            bRestart = FixMaxDamage(oItem, ipProperty, ITEM_PROPERTY_MASSIVE_CRITICALS, "ITEM_PROPERTY_MASSIVE_CRITICALS");
            break;
         case ITEM_PROPERTY_MIGHTY:                                     // Causes a ranged weapon, usually a short bow or long bow, to permit the weilder's Strength modifier to damage due to extra powerful stringing.
            bRestart = FixMaxBonus(oItem, ipProperty, SMS_MIGHTY_MAX, ITEM_PROPERTY_MIGHTY, "ITEM_PROPERTY_MIGHTY");
            break;
         case ITEM_PROPERTY_MIND_BLANK:                                 // Unknown. Speculation: causes a creature struck to lose a randomly selected spell or daily spell use.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_MIND_BLANK");
            break;
         case ITEM_PROPERTY_MONSTER_DAMAGE:                             // Unknown.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_MONSTER_DAMAGE");
            break;
         case ITEM_PROPERTY_NO_DAMAGE:                                  // When applied to a weapon (missile or melee) that weapon does not inflict damage.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_NO_DAMAGE");
            break;
         case ITEM_PROPERTY_ON_HIT_PROPERTIES:                          // Unknown.
            //if (iFoundUnique == -1) iFoundUnique = iPropType;
            //if (iFoundUnique == iPropType) {
            //   // NOTHING CURRENTLY
            //} else {
            //   bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ON_HIT_PROPERTIES: UNIQUE PROP VIOLATION!");
            //}
            //bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ON_HIT_PROPERTIES");
            break;
         case ITEM_PROPERTY_ON_MONSTER_HIT:                             // Unknown.
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ON_MONSTER_HIT");
            break;
         case ITEM_PROPERTY_ONHITCASTSPELL:                             //
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_ONHITCASTSPELL");
            break;
         case ITEM_PROPERTY_POISON:                                     // Weapons (missile or melee) with this property also inflict poison on a successful hit.
            break;
         case ITEM_PROPERTY_REGENERATION:                               // Grants the wearer/wielder hit point regeneration.
            if (nThrowing)
            {
               // Ezramun: No throwing weapon with stackable stats allowed
               DestroyAmmoCreator(oPC);
               Insured_Destroy(oItem);
               return;
            }
            else
            {
               if (iFoundUnique == -1) iFoundUnique = iPropType;
               if (iFoundUnique == iPropType) {
                  bRestart = FixMaxBonus(oItem, ipProperty, SMS_REGEN_MAIN_ITEM_MAX, ITEM_PROPERTY_REGENERATION, "ITEM_PROPERTY_REGENERATION");
               } else {
                  bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_REGENERATION: UNIQUE PROP VIOLATION!");
               }
            }
            break;
         case ITEM_PROPERTY_REGENERATION_VAMPIRIC:                      // Grants the wearer/wielder hit point regeneration equal to the damage inflicted by an attack with a weapon (melee or missile) with this property.
            bRestart = FixMaxBonus(oItem, ipProperty, SMS_VAMP_REGEN_MAX, ITEM_PROPERTY_REGENERATION_VAMPIRIC, "ITEM_PROPERTY_REGENERATION_VAMPIRIC");
            break;
         case ITEM_PROPERTY_SKILL_BONUS:                                // Grants the wearer/wielder a bonus to a particular skill.
            if (nThrowing)
            {
               // Ezramun: No throwing weapon with stackable stats allowed
               DestroyAmmoCreator(oPC);
               Insured_Destroy(oItem);
               return;
            }
            else
            {
               if (iFoundUnique == -1) iFoundUnique = iPropType;
               if (iFoundUnique == iPropType) {
                  if (iSkillPoints > SMS_SKILL_MAX) { // WE TOO HIGH, REMOVE ALL
                     SaveSkill(iSubType, iBonus);
                     RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_SKILL_BONUS: (" + IntToString(iSubType) + ") WILL RE-ADD");
                  }
               } else {
                  iSkillPoints = 0; // REMOVE ALL, DON'T ADD BACK
                  bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_SKILL_BONUS: UNIQUE PROP VIOLATION!");
               }
            }
            break;
         case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:                         // BIG FUCKING 3
            if (nThrowing)
            {
               // Ezramun: No throwing weapon with stackable stats allowed
               DestroyAmmoCreator(oPC);
               Insured_Destroy(oItem);
               return;
            }
            else
            {
               if (iFoundUnique == -1) iFoundUnique = iPropType;
               if (iFoundUnique == iPropType) {
                  if (iSaveBigPoints > SMS_SAVE_BIG3_MAIN_ITEM_MAX) {
                     SaveSaveBig(iSubType, iBonus);
                     RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC: (" + IntToString(iSubType) + ") WILL RE-ADD");
                  }
               } else {
                  iSaveBigPoints = 0; // REMOVE ALL, DON'T ADD BACK
                  RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC: UNIQUE PROP VIOLATION!");
               }
            }
            break;
         case ITEM_PROPERTY_SAVING_THROW_BONUS:               //  Save Vs Effects
            if (nThrowing)
            {
               // Ezramun: No throwing weapon with stackable stats allowed
               DestroyAmmoCreator(oPC);
               Insured_Destroy(oItem);
               return;
            }
            else
            {
               if (iFoundUnique == -1) iFoundUnique = iPropType;
               if (iFoundUnique == iPropType) {
                  if (iSaveVsPoints > SMS_SAVE_VS_MAIN_ITEM_MAX) {
                     SaveSaveVs(iSubType, iBonus);
                     RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC: (" + IntToString(iSubType) + ") WILL RE-ADD");
                  }
               } else {
                  iSaveVsPoints = 0; // REMOVE ALL, DON'T ADD BACK
                  RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC: UNIQUE PROP VIOLATION!");
               }
            }
            break;
         case ITEM_PROPERTY_SPECIAL_WALK:                               //
            break;
         case ITEM_PROPERTY_SPELL_RESISTANCE:                           // Grants the wearer/wielder spell resistance to a specified degree.
            if (GetBaseItemType(oItem)==BASE_ITEM_RING) {
               if (iBonus<=IP_CONST_SPELLRESISTANCEBONUS_18) {
                  break;
               } else {
                  IPSafeAddItemProperty(oItem, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
                  WTSLE("     ITEM_PROPERTY_SPELL_RESISTANCE: Nerfed 18");
                  break;
               }
            }
            RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_SPELL_RESISTANCE: TOO HIGH!");
         case ITEM_PROPERTY_THIEVES_TOOLS:                              // Marks an item as thieves tools used for opening locks and disarming traps.
            break;
         case ITEM_PROPERTY_TRAP:                                       // Denotes an item as a trap that can be placed.
            break;
         case ITEM_PROPERTY_TRUE_SEEING:                                // Grants the wearer/wielder the benefits of a True Seeing spell (see invisible or magically concealed creatures).
            bRestart = RemoveProperty(oItem, ipProperty, "ITEM_PROPERTY_TRUE_SEEING");
            break;
         case ITEM_PROPERTY_TURN_RESISTANCE:                            // Grants the wearer/wielder additional turn resistance.
            break;
         case ITEM_PROPERTY_UNLIMITED_AMMUNITION:                       // Grants the wearer/wielder unlimited ammunition with a missile weapon that requires ammunition.
            break;
         case ITEM_PROPERTY_VISUALEFFECT:                               //
            break;
         case ITEM_PROPERTY_WEIGHT_INCREASE:                            //
            break;
      }
      if (bRestart) {
         WTSLE("*** RESTART IP LOOP!");
         bRestart = FALSE;
         ipProperty = GetFirstItemProperty(oItem); // WHEN REMOVING/ADDING A PROPERTY IT IS NECESSARY TO RESTART AT THE BEGINNING OR NWN LOSES IT"S PLACE IN THE LIST
         iFixCnt++;
      } else {
         ipProperty = GetNextItemProperty(oItem);
      }
   }
   int i;
   if (iSkillPoints > SMS_SKILL_MAX) { // WE REMOVED ALL THE SKILL BONUSES, ADD BACK UNTIL MAX IS REACHED
      iSkillPoints = 0;
      for (i=1;i<=4;i++) {
         FindMaxSkill();
         iSkillValue = ((iSkillPoints+iSkillValue) > SMS_SKILL_MAX) ? SMS_SKILL_MAX-iSkillPoints : iSkillValue; //IF THIS PUSHES US OVER MAX, TAKE THE DIFFERENCE, ELSE USE THE VALUE
         iSkillPoints += iSkillValue;
         if (iSkillValue) {
            IPSafeAddItemProperty(oItem, ItemPropertySkillBonus(iSkillCurrent, iSkillValue), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            WTSLE("Added Back Skill (" + IntToString(iSkillCurrent) + ") " + IntToString(iSkillValue));
         } else {
            WTSLE("NOT ADDING Back Skill (" + IntToString(iSkillCurrent) + ") " + IntToString(iSkillValue));
         }
      }
   }
   if (iSaveVsPoints > SMS_SAVE_VS_MAIN_ITEM_MAX) { // WE REMOVED ALL THE SaveVs BONUSES, ADD BACK UNTIL MAX IS REACHED
      iSaveVsPoints = 0;
      for (i=1;i<=3;i++) {
         FindMaxSaveVs();
         iSaveVsValue = ((iSaveVsPoints+iSaveVsValue) > SMS_SAVE_VS_MAIN_ITEM_MAX) ? SMS_SAVE_VS_MAIN_ITEM_MAX-iSaveVsPoints : iSaveVsValue; //IF THIS PUSHES US OVER MAX, TAKE THE DIFFERENCE, ELSE USE THE VALUE
         iSaveVsPoints += iSaveVsValue;
         if (iSaveVsValue) {
            IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(iSaveVsCurrent, iSaveVsValue), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            WTSLE("Added Back SaveVs (" + IntToString(iSaveVsCurrent) + ") " + IntToString(iSaveVsValue));
         } else {
            WTSLE("NOT ADDING Back SaveVs (" + IntToString(iSaveVsCurrent) + ") " + IntToString(iSaveVsValue));
         }
      }
   }
   if (iSaveBigPoints > SMS_SAVE_BIG3_MAIN_ITEM_MAX) { // WE REMOVED ALL THE SaveBig BONUSES, ADD BACK UNTIL MAX IS REACHED
      iSaveBigPoints = 0;
      iFortPoints = 0;
      for (i=1;i<=3;i++) {
         FindMaxSaveBig();
         iSaveBigValue = ((iSaveBigPoints+iSaveBigValue) > SMS_SAVE_BIG3_MAIN_ITEM_MAX) ? SMS_SAVE_BIG3_MAIN_ITEM_MAX-iSaveBigPoints : iSaveBigValue; //IF THIS PUSHES US OVER MAX, TAKE THE DIFFERENCE, ELSE USE THE VALUE
         iSaveBigPoints += iSaveBigValue;
         if (iSaveBigValue) {
            IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrow(iSaveBigCurrent, iSaveBigValue), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            WTSLE("Added Back Big3 (" + IntToString(iSaveBigCurrent) + ") " + IntToString(iSaveBigValue));
            if (iSkillCurrent==IP_CONST_SAVEBASETYPE_FORTITUDE) {
               iFortPoints = iSkillValue-2;
               if (iFortPoints > 0) {
                  IPSafeAddItemProperty(oItem, ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_DEATH, iFortPoints), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
                  WTSLE("     DEATH PENALTY ADDED TO BALANCE FORT: " + IntToString(iFortPoints));
               }
            }
         }
      }
   }


   // CHECK FORT AND ADD -DEATH
   /*if (iFortPoints > 0) {
      iFortPoints = 0;
      ipProperty=GetFirstItemProperty(oItem);
      while (GetIsItemPropertyValid(ipProperty)) {
         if (GetItemPropertyType(ipProperty)==ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC && GetItemPropertySubType(ipProperty) == IP_CONST_SAVEBASETYPE_FORTITUDE) {
            iFortPoints = iFortPoints + GetItemPropertyCostTableValue(ipProperty);
         }
         ipProperty=GetNextItemProperty(oItem);
      }
      // CHANGE NEXT LINE AND SET iFortPoints TO THE AMOUNT OF DEATH PENALTY
      iFortPoints = iFortPoints - 2;
      if (iFortPoints > 0) {
         IPSafeAddItemProperty(oItem, ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_DEATH, iFortPoints), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
         WTSLE("     DEATH PENALTY ADDED TO BALANCE FORT: " + IntToString(iFortPoints));
      }
   }*/

    // WE HAD SOME SPELL SLOTS, ADD EM BACK NOW
   if (iSpellMaxLvl > 0) {
      ipAdd = ItemPropertyBonusLevelSpell(iSpellClass, iSpellMaxLvl);
      AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oItem);  //IPSafeAddItemProperty(oItem, ipAdd);
      WTSLE("     SPELL SLOT FOR " + IntToString(iSpellClass) + " added for level " + IntToString(iSpellMaxLvl));
   }
   if (iTotalDamage > iMaxDamage) {
      if (iD1!=-1 && nDamageModCount>=1) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(iD1, IP_CONST_DAMAGEBONUS_2d6), oItem);
      if (iD2!=-1 && nDamageModCount>=2) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(iD2, IP_CONST_DAMAGEBONUS_2d6), oItem);
      if (iD3!=-1 && nDamageModCount>=3) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(iD3, IP_CONST_DAMAGEBONUS_2d6), oItem);
      if (iD4!=-1 && nDamageModCount>=4) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(iD4, IP_CONST_DAMAGEBONUS_2d6), oItem);
   }
   // TOO MANY STAT BOOSTS!
   if (iAbilityTotal > SMS_ABILITY_MAIN_ITEM_MAX) {
      while (iAbilityTotal > SMS_ABILITY_MAIN_ITEM_MAX) {
         int iReduceTotal = iAbilityTotal - SMS_ABILITY_MAIN_ITEM_MAX; // NEED TO TRIM THIS MANY POINTS, TRY TO TAKE OFF IN 2's
         int iReduceBy = 1;
         int iMaxPos = MaxStat(); // RETURNS ARRAY POSITION OF BIGGEST BOOST
         int iMaxVal = GetStat(iMaxPos); // GET THE VALUE OF THE BIGGEST BOOST
         if (iReduceTotal > 1 && iMaxVal > 1) iReduceBy = 2;
         SetStat(iMaxPos, iMaxVal - iReduceBy); // LOWER THE BIGGEST ONE FIRST
         iAbilityTotal = iAbilityTotal - iReduceBy;
      }
      FixStat(oItem, IP_CONST_ABILITY_STR);
      FixStat(oItem, IP_CONST_ABILITY_CON);
      FixStat(oItem, IP_CONST_ABILITY_WIS);
      FixStat(oItem, IP_CONST_ABILITY_DEX);
      FixStat(oItem, IP_CONST_ABILITY_INT);
      FixStat(oItem, IP_CONST_ABILITY_CHA);
   }
   return /*iFixCnt*/;
}

//void main() {}

//+5 fort = -2 death
//+1 fort = nothing :O
//+1 fort +1 fort +1fort = -1 death
//+2 fort +2fort = -2 death

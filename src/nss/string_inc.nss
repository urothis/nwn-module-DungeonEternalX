string SaveVsBonusString(int nSaveType);
string IPClassString(int nClass = 0);
string ItemPropertyDesc(int iPropType, int iSubType, int iBonus, int iParam1=0);
string ListGetCurrent();
void ListSetCurrent(string sValue);
// TAKES THE FIRST VALUE OFF LIST AND RETURNS TRUNCATED LIST
// STORE THE POPPED ELEMENT IN ListGetCurrent();
string ListPopElement(string sList, string sDelim = ",");
int ListGetCount(string sList, string sDelim = ",");
string ListGetElement(string sList, int nElement, string sDelim = ",");
int StringStartsWith(string sIn, string sMatch);
//Returns a string (Daze, Fear, Hold, Slow, or Stun) of an IP_CONST_ONHIT_*
//DEFAULT: "Missed OnHitType"
string OnHitTypeString(int nOnHitType);
string OnHitDCString(int nOnHit);
string DamageBonusString(int nDamageBonus);
string DamageImmunityString(int nDamageImmunity);
string DamageSoakString(int nDamageSoak);
string DamageResistanceString(int nDamageResistance);
string SpellResistanceString(int nSR);
string RacialString(int nRace = 0);
string ClassStringAbbr(int nClass = 0);
string ClassString(int nClass = 0, int bAbbr=FALSE);
string GetCountString(int nCount, int nLowerCase = FALSE);
string GetBaseWeaponResRef(object oItem);
string DamageTypeString(int nDamageType);
//Formats a string so that if you have a value n, like 20 ducks, it would see a number > 1
//and add an s at the end of the string. Duck vs. Ducks. Allows the s to be applied dynamically.
//INPUT:
//sIn = original string
//iIn = the number of objects
string AddStoString(string sIn, int iIn);
//Picks a random string that isn't NULL
string PickOne(string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="");
//Trims the spaces around the string.
string Trim(string sIn);
string AbilityString(int nAbilityType);
string IPString(int nProp);
string CapitalizeFirstLetter(string sIn);
string LightString(int nLight);
string OnHitString(int nOnHit);
string SaveSpecificBonusString(int nSaveType);
string SkillBonusString(int nSkillType);
string VisualEffectString(int nVE);
// Convert seconds into string: X Days, X Hours, X Minutes, X Seconds
string ConvertSecondsToString(int nSeconds);
string InventorySlotString(int nSlot = 0);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

string SaveVsBonusString(int nSaveType)
{
   if (nSaveType==IP_CONST_SAVEVS_ACID         ) return "Acid";            if (nSaveType==IP_CONST_SAVEVS_COLD         ) return "Cold";
   if (nSaveType==IP_CONST_SAVEVS_DEATH        ) return "Death";           if (nSaveType==IP_CONST_SAVEVS_DISEASE      ) return "Disease";
   if (nSaveType==IP_CONST_SAVEVS_DIVINE       ) return "Divine";          if (nSaveType==IP_CONST_SAVEVS_ELECTRICAL   ) return "Electrical";
   if (nSaveType==IP_CONST_SAVEVS_FEAR         ) return "Fear";            if (nSaveType==IP_CONST_SAVEVS_FIRE         ) return "Fire";
   if (nSaveType==IP_CONST_SAVEVS_MINDAFFECTING) return "Mindaffecting";   if (nSaveType==IP_CONST_SAVEVS_NEGATIVE     ) return "Negative";
   if (nSaveType==IP_CONST_SAVEVS_POISON       ) return "Poison";          if (nSaveType==IP_CONST_SAVEVS_POSITIVE     ) return "Positive";
   if (nSaveType==IP_CONST_SAVEVS_SONIC        ) return "Sonic";           if (nSaveType==IP_CONST_SAVEVS_UNIVERSAL    ) return "Universal";
   return "Missed SaveVsBonusString";
}

string IPClassString(int nClass = 0)
{
   if (nClass == IP_CONST_CLASS_BARD    ) return "Bard"    ;
   if (nClass == IP_CONST_CLASS_CLERIC  ) return "Cleric"  ;
   if (nClass == IP_CONST_CLASS_DRUID   ) return "Druid"   ;
   if (nClass == IP_CONST_CLASS_PALADIN ) return "Paladin" ;
   if (nClass == IP_CONST_CLASS_RANGER  ) return "Ranger"  ;
   if (nClass == IP_CONST_CLASS_SORCERER) return "Sorcerer";
   if (nClass == IP_CONST_CLASS_WIZARD  ) return "Wizard"  ;
   return "IPClassString Mssing " + IntToString(nClass);
}

string ItemPropertyDesc(int iPropType, int iSubType, int iBonus, int iParam1=0)
{
   switch (iPropType)
   {
      case ITEM_PROPERTY_ABILITY_BONUS:               return AbilityString(iSubType) + "+" + IntToString(iBonus);
      case ITEM_PROPERTY_AC_BONUS:                    return "AC +" + IntToString(iBonus);
      case ITEM_PROPERTY_ATTACK_BONUS:                return "Attack +" + IntToString(iBonus);
      case ITEM_PROPERTY_BONUS_FEAT:
         if (iSubType==37) return "Disarm";
         return "Feat" + IntToString(iSubType);
      case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N: return IPClassString(iSubType) + " Level " + IntToString(iBonus);
      case ITEM_PROPERTY_CAST_SPELL:                  return "Cast Spell " + IntToString(iSubType);
      case ITEM_PROPERTY_DAMAGE_BONUS:                return DamageTypeString(iSubType) + " " + DamageBonusString(iBonus);
      case ITEM_PROPERTY_DAMAGE_REDUCTION:            return " Damage Reduction +" + IntToString(iSubType+1) + " soak " + DamageSoakString(iBonus);
      case ITEM_PROPERTY_DAMAGE_RESISTANCE:           return DamageTypeString(iSubType) + " " + DamageResistanceString(iBonus);
      case ITEM_PROPERTY_DARKVISION:                  return "Darkvision";
      case ITEM_PROPERTY_DECREASED_SAVING_THROWS:     return SaveVsBonusString(iSubType) + " save -" + IntToString(iBonus);
      case ITEM_PROPERTY_ENHANCEMENT_BONUS:           return "Enhancement +" + IntToString(iBonus);
      case ITEM_PROPERTY_HASTE:                       return "Haste";
      case ITEM_PROPERTY_HOLY_AVENGER:                return "Holy Avenger";
      case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:        return DamageTypeString(iSubType) + " immunity " + DamageImmunityString(iBonus);
      case ITEM_PROPERTY_KEEN:                        return "Keen";
      case ITEM_PROPERTY_LIGHT:                       return LightString(iParam1) + " Light";
      case ITEM_PROPERTY_MASSIVE_CRITICALS:           return "Massive Crits" + DamageBonusString(iBonus);
      case ITEM_PROPERTY_MIGHTY:                      return "Mighty +" + IntToString(iBonus);
      case ITEM_PROPERTY_ON_HIT_PROPERTIES:           return "On Hit " + OnHitTypeString(iSubType) + " " + OnHitString(iBonus);
      case ITEM_PROPERTY_REGENERATION:                return "Regeneration +" + IntToString(iBonus);
      case ITEM_PROPERTY_REGENERATION_VAMPIRIC:       return "Vampiric Regen +" + IntToString(iBonus);
      case ITEM_PROPERTY_SAVING_THROW_BONUS:          return "Save Vs " + SaveVsBonusString(iSubType) + " +" + IntToString(iBonus);
      case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC: return SaveSpecificBonusString(iSubType) + " +" + IntToString(iBonus);
      case ITEM_PROPERTY_SKILL_BONUS:                 return SkillBonusString(iSubType) + " +" + IntToString(iBonus);
      case ITEM_PROPERTY_SPELL_RESISTANCE:            return "Spell Resistance " + SpellResistanceString(iBonus);
      case ITEM_PROPERTY_VISUALEFFECT:                return "Visual Effect " + VisualEffectString(iSubType);
   }
   return "Missed ItemPropertyDesc " + IntToString(iPropType) + " : " + IntToString(iSubType) + " : " + IntToString(iBonus);
}

string ListGetCurrent()
{
   return GetLocalString(GetModule(), "LISTLAST");
}

void ListSetCurrent(string sValue)
{
   SetLocalString(GetModule(), "LISTLAST", sValue);
}

string ListPopElement(string sList, string sDelim = ",")
{
   int nLength = GetStringLength(sList);
   if (!nLength) { // NO LENGTH, NO ELEMENTS
      ListSetCurrent("");
      return ""; // LIST IS NOW EMPTY
   }
   int nPos = FindSubString(sList, sDelim); // GET FIRST DELIM IN LIST

   if (nPos==-1) { // LIST NOT EMPTY BUT CONTAINS NO DELIMITERS SO CONTAINS 1 ELEMENT
      ListSetCurrent(sList);
      return ""; // LIST IS NOW EMPTY
   }
   if (nPos==0) { // THERE IS A DELIM IN FIRST POSITION OF THE LIST
      ListSetCurrent(""); // EMPTY ELEMENT
      return GetStringRight(sList, nLength - 1); // SHORTEN THE LIST BY 1 AND EXIT
   }
   string sElement = GetStringLeft(sList, nPos);
   ListSetCurrent(sElement); // SAVE THE CURRENT ELEMENT
   sList = GetStringRight(sList, nLength - (nPos+1));
   return sList; // RETURN THE REMAINING LIST STARTING AFTER THE DELIM POSITION
}

int ListGetCount(string sList, string sDelim = ",")
{
   if (sList=="") return 0; // LIST IS EMPTY
   int nCount = 1;
   sList = ListPopElement(sList, sDelim);
   while (sList!="" && nCount<20) {
      nCount++;
      sList = ListPopElement(sList, sDelim);
   }
   return nCount;
}

string ListGetElement(string sList, int nElement, string sDelim = ",")
{
   int i;
   for (i=1; i <= nElement; i++) {
      sList = ListPopElement(sList, sDelim);
      if (i==nElement) return ListGetCurrent(); // AT THE DESIRED ELEMENT, RETURN IT
      if (sList=="") return ""; // THE LIST IS NOW EMPTY, SO RETURN EMPTY ELEMENT
   }
   return ""; // DEFAULT RETURN SHOULD NEVER BE REACHED
}

int StringStartsWith(string sIn, string sMatch)
{
   return (GetStringLeft(sIn, GetStringLength(sMatch))==sMatch);
}

string OnHitTypeString(int nOnHitType)
{
   if (nOnHitType==IP_CONST_ONHIT_DAZE) return "Daze";
   if (nOnHitType==IP_CONST_ONHIT_FEAR) return "Fear";
   if (nOnHitType==IP_CONST_ONHIT_HOLD) return "Hold";
   if (nOnHitType==IP_CONST_ONHIT_SLOW) return "Slow";
   if (nOnHitType==IP_CONST_ONHIT_STUN) return "Stun";
   return "Missed OnHitType";
}

string OnHitDCString(int nOnHit)
{
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_14)   return "DC 14";    if (nOnHit==IP_CONST_ONHIT_SAVEDC_16)  return "DC 16";
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_18)   return "DC 18";    if (nOnHit==IP_CONST_ONHIT_SAVEDC_20)  return "DC 20";
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_22)   return "DC 22";    if (nOnHit==IP_CONST_ONHIT_SAVEDC_24)  return "DC 24";
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_26)   return "DC 26";
   return "OnHitString MISSING";
}

string DamageBonusString(int nDamageBonus)
{
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_1   ) return "1";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d4 ) return "1d4";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_2   ) return "2";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d6 ) return "1d6";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_3   ) return "3";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d8 ) return "1d8";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_4   ) return "4";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d10) return "1d10";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_5   ) return "5";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d12) return "1d12";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_6   ) return "6";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d4 ) return "2d4";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_7   ) return "7";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d6 ) return "2d6";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_8   ) return "8";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d8 ) return "2d8";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_9   ) return "9";  if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d10) return "2d10";
   if (nDamageBonus==IP_CONST_DAMAGEBONUS_10  ) return "10"; if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d12) return "2d12";
   return "";
}

string DamageImmunityString(int nDamageImmunity)
{
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_5_PERCENT)   return "5%";    if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_10_PERCENT)  return "10%";
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_25_PERCENT)  return "25%";   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_50_PERCENT)  return "50%";
   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_75_PERCENT)  return "75%";   if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_100_PERCENT) return "100%";
   return "DamageImmunityString MISSING";
}

string DamageSoakString(int nDamageSoak)
{
   if (nDamageSoak==IP_CONST_DAMAGESOAK_5_HP)  return "5";    if (nDamageSoak==IP_CONST_DAMAGESOAK_10_HP) return "10";
   if (nDamageSoak==IP_CONST_DAMAGESOAK_15_HP) return "15";   if (nDamageSoak==IP_CONST_DAMAGESOAK_20_HP) return "20";
   if (nDamageSoak==IP_CONST_DAMAGESOAK_25_HP) return "25";   if (nDamageSoak==IP_CONST_DAMAGESOAK_30_HP) return "30";
   if (nDamageSoak==IP_CONST_DAMAGESOAK_35_HP) return "35";   if (nDamageSoak==IP_CONST_DAMAGESOAK_40_HP) return "40";
   if (nDamageSoak==IP_CONST_DAMAGESOAK_45_HP) return "45";   if (nDamageSoak==IP_CONST_DAMAGESOAK_50_HP) return "50";
   return "DamageSoakString MISSING";
}

string DamageResistanceString(int nDamageResistance)
{
   if (nDamageResistance==IP_CONST_DAMAGERESIST_5 )  return "5/-";    if (nDamageResistance==IP_CONST_DAMAGERESIST_10)  return "10/-";
   if (nDamageResistance==IP_CONST_DAMAGERESIST_15)  return "15/-";   if (nDamageResistance==IP_CONST_DAMAGERESIST_20)  return "20/-";
   if (nDamageResistance==IP_CONST_DAMAGERESIST_25)  return "25/-";   if (nDamageResistance==IP_CONST_DAMAGERESIST_30)  return "30/-";
   if (nDamageResistance==IP_CONST_DAMAGERESIST_35)  return "35/-";   if (nDamageResistance==IP_CONST_DAMAGERESIST_40)  return "40/-";
   if (nDamageResistance==IP_CONST_DAMAGERESIST_45)  return "45/-";   if (nDamageResistance==IP_CONST_DAMAGERESIST_50)  return "50/-";
   return "DamageResistanceString MISSING";
}

string SpellResistanceString(int nSR)
{
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_10) return "10";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_12) return "12";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_14) return "14";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_16) return "16";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_18) return "18";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_20) return "20";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_22) return "22";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_24) return "24";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_26) return "26";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_28) return "28";
   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_30) return "30";   if (nSR==IP_CONST_SPELLRESISTANCEBONUS_32) return "32";
   return "SpellResistanceString MISSING";
}

string RacialString(int nRace = 0)
{
   if(nRace == RACIAL_TYPE_ABERRATION        ) return "Aberration";
   if(nRace == RACIAL_TYPE_ANIMAL            ) return "Animal";
   if(nRace == RACIAL_TYPE_BEAST             ) return "Beast";
   if(nRace == RACIAL_TYPE_CONSTRUCT         ) return "Construct";
   if(nRace == RACIAL_TYPE_DRAGON            ) return "Dragon";
   if(nRace == RACIAL_TYPE_DWARF             ) return "Dwarf";
   if(nRace == RACIAL_TYPE_ELEMENTAL         ) return "Elemental";
   if(nRace == RACIAL_TYPE_ELF               ) return "Elf";
   if(nRace == RACIAL_TYPE_FEY               ) return "Fey";
   if(nRace == RACIAL_TYPE_GIANT             ) return "Giant";
   if(nRace == RACIAL_TYPE_GNOME             ) return "Gnome";
   if(nRace == RACIAL_TYPE_HALFELF           ) return "Half-Elf";
   if(nRace == RACIAL_TYPE_HALFLING          ) return "Halfling";
   if(nRace == RACIAL_TYPE_HALFORC           ) return "Half-Orc";
   if(nRace == RACIAL_TYPE_HUMAN             ) return "Human";
   if(nRace == RACIAL_TYPE_HUMANOID_GOBLINOID) return "Humanoid Goblinoid";
   if(nRace == RACIAL_TYPE_HUMANOID_MONSTROUS) return "Humanoid Monstrous";
   if(nRace == RACIAL_TYPE_HUMANOID_ORC      ) return "Humanoid Orc";
   if(nRace == RACIAL_TYPE_HUMANOID_REPTILIAN) return "Humanoid Reptilian";
   if(nRace == RACIAL_TYPE_INVALID           ) return "";
   if(nRace == RACIAL_TYPE_MAGICAL_BEAST     ) return "Magical Beast";
   if(nRace == RACIAL_TYPE_OOZE              ) return "Ooze";
   if(nRace == RACIAL_TYPE_OUTSIDER          ) return "Outsider";
   if(nRace == RACIAL_TYPE_SHAPECHANGER      ) return "Shapechanger";
   if(nRace == RACIAL_TYPE_UNDEAD            ) return "Undead";
   if(nRace == RACIAL_TYPE_VERMIN            ) return "Vermin";
   return "Miss: " + IntToString(nRace);
}

string ClassStringAbbr(int nClass = 0)
{
   if (nClass == CLASS_TYPE_ABERRATION     ) return "AB";    if (nClass == CLASS_TYPE_HARPER         ) return "HS";
   if (nClass == CLASS_TYPE_ANIMAL         ) return "AN";    if (nClass == CLASS_TYPE_HUMANOID       ) return "HU";
   if (nClass == CLASS_TYPE_ARCANE_ARCHER  ) return "AA";    if (nClass == CLASS_TYPE_INVALID        ) return "IN";
   if (nClass == CLASS_TYPE_ASSASSIN       ) return "AS";    if (nClass == CLASS_TYPE_MAGICAL_BEAST  ) return "MB";
   if (nClass == CLASS_TYPE_BARBARIAN      ) return "BB";    if (nClass == CLASS_TYPE_MONK           ) return "MK";
   if (nClass == CLASS_TYPE_BARD           ) return "BA";    if (nClass == CLASS_TYPE_MONSTROUS      ) return "MO";
   if (nClass == CLASS_TYPE_BEAST          ) return "BE";    if (nClass == CLASS_TYPE_OUTSIDER       ) return "OU";
   if (nClass == CLASS_TYPE_BLACKGUARD     ) return "BG";    if (nClass == CLASS_TYPE_PALADIN        ) return "PA";
   if (nClass == CLASS_TYPE_CLERIC         ) return "CL";    if (nClass == CLASS_TYPE_PALEMASTER     ) return "PM";
   if (nClass == CLASS_TYPE_COMMONER       ) return "CO";    if (nClass == CLASS_TYPE_RANGER         ) return "RA";
   if (nClass == CLASS_TYPE_CONSTRUCT      ) return "CN";    if (nClass == CLASS_TYPE_ROGUE          ) return "RO";
   if (nClass == CLASS_TYPE_DIVINECHAMPION ) return "DC";    if (nClass == CLASS_TYPE_SHADOWDANCER   ) return "SD";
   if (nClass == CLASS_TYPE_DRAGON         ) return "DR";    if (nClass == CLASS_TYPE_SHAPECHANGER   ) return "SC";
   if (nClass == CLASS_TYPE_DRAGONDISCIPLE ) return "RD";    if (nClass == CLASS_TYPE_SHIFTER        ) return "SH";
   if (nClass == CLASS_TYPE_DRUID          ) return "DR";    if (nClass == CLASS_TYPE_SORCERER       ) return "SO";
   if (nClass == CLASS_TYPE_DWARVENDEFENDER) return "DD";    if (nClass == CLASS_TYPE_UNDEAD         ) return "UD";
   if (nClass == CLASS_TYPE_ELEMENTAL      ) return "EL";    if (nClass == CLASS_TYPE_VERMIN         ) return "VE";
   if (nClass == CLASS_TYPE_FEY            ) return "FE";    if (nClass == CLASS_TYPE_WEAPON_MASTER  ) return "WM";
   if (nClass == CLASS_TYPE_FIGHTER        ) return "FI";    if (nClass == CLASS_TYPE_WIZARD         ) return "WI";
   if (nClass == CLASS_TYPE_GIANT          ) return "GI";
   return "Miss: " + IntToString(nClass);
}

string ClassString(int nClass = 0, int bAbbr=FALSE)
{
   if (bAbbr) return ClassStringAbbr(nClass);
   if (nClass == CLASS_TYPE_ABERRATION     ) return "Aberration";         if (nClass == CLASS_TYPE_HARPER         ) return "Harper";
   if (nClass == CLASS_TYPE_ANIMAL         ) return "Animal";             if (nClass == CLASS_TYPE_HUMANOID       ) return "Humanoid";
   if (nClass == CLASS_TYPE_ARCANE_ARCHER  ) return "Arcane_Archer";      if (nClass == CLASS_TYPE_INVALID        ) return "";
   if (nClass == CLASS_TYPE_ASSASSIN       ) return "Assassin";           if (nClass == CLASS_TYPE_MAGICAL_BEAST  ) return "Magical_Beast";
   if (nClass == CLASS_TYPE_BARBARIAN      ) return "Barbarian";          if (nClass == CLASS_TYPE_MONK           ) return "Monk";
   if (nClass == CLASS_TYPE_BARD           ) return "Bard";               if (nClass == CLASS_TYPE_MONSTROUS      ) return "Monstrous";
   if (nClass == CLASS_TYPE_BEAST          ) return "Beast";              if (nClass == CLASS_TYPE_OUTSIDER       ) return "Outsider";
   if (nClass == CLASS_TYPE_BLACKGUARD     ) return "Blackguard";         if (nClass == CLASS_TYPE_PALADIN        ) return "Paladin";
   if (nClass == CLASS_TYPE_CLERIC         ) return "Cleric";             if (nClass == CLASS_TYPE_PALEMASTER     ) return "Palemaster";
   if (nClass == CLASS_TYPE_COMMONER       ) return "Commoner";           if (nClass == CLASS_TYPE_RANGER         ) return "Ranger";
   if (nClass == CLASS_TYPE_CONSTRUCT      ) return "Construct";          if (nClass == CLASS_TYPE_ROGUE          ) return "Rogue";
   if (nClass == CLASS_TYPE_DIVINECHAMPION ) return "Divinechampion";     if (nClass == CLASS_TYPE_SHADOWDANCER   ) return "Shadowdancer";
   if (nClass == CLASS_TYPE_DRAGON         ) return "Dragon";             if (nClass == CLASS_TYPE_SHAPECHANGER   ) return "Shapechanger";
   if (nClass == CLASS_TYPE_DRAGONDISCIPLE ) return "Dragondisciple";     if (nClass == CLASS_TYPE_SHIFTER        ) return "Shifter";
   if (nClass == CLASS_TYPE_DRUID          ) return "Druid";              if (nClass == CLASS_TYPE_SORCERER       ) return "Sorcerer";
   if (nClass == CLASS_TYPE_DWARVENDEFENDER) return "Dwarvendefender";    if (nClass == CLASS_TYPE_UNDEAD         ) return "Undead";
   if (nClass == CLASS_TYPE_ELEMENTAL      ) return "Elemental";          if (nClass == CLASS_TYPE_VERMIN         ) return "Vermin";
   if (nClass == CLASS_TYPE_FEY            ) return "Fey";                if (nClass == CLASS_TYPE_WEAPON_MASTER  ) return "Weapon_Master";
   if (nClass == CLASS_TYPE_FIGHTER        ) return "Fighter";            if (nClass == CLASS_TYPE_WIZARD         ) return "Wizard";
   if (nClass == CLASS_TYPE_GIANT          ) return "Giant";
   return "Miss: " + IntToString(nClass);
}

string GetCountString(int nCount, int nLowerCase = FALSE)
{
    string sCount;
    switch (nCount)
    {
        case 1:     sCount = "First";   break;
        case 2:     sCount = "Second";  break;
        case 3:     sCount = "Third";   break;
        case 4:     sCount = "Fourth";  break;
        case 5:     sCount = "Fifth";   break;
        case 6:     sCount = "Sixth";   break;
        case 7:     sCount = "Seventh"; break;
        case 8:     sCount = "Eighth";  break;
        case 9:     sCount = "Ninth";   break;
        case 10:    sCount = "Tenth";   break;
    }
    if (nLowerCase) sCount = GetStringLowerCase(sCount);
    return sCount;
}

string GetBaseWeaponResRef(object oItem)
{
   int nItem = GetBaseItemType(oItem);
   if (nItem == BASE_ITEM_BASTARDSWORD)    return "nw_wswbs001";
   if (nItem == BASE_ITEM_BATTLEAXE)       return "nw_waxbt001";
   if (nItem == BASE_ITEM_CLUB)            return "nw_wblcl001";
   if (nItem == BASE_ITEM_DAGGER)          return "nw_wswdg001";
   if (nItem == BASE_ITEM_DIREMACE)        return "nw_wdbma001";
   if (nItem == BASE_ITEM_DOUBLEAXE)       return "nw_wdbax001";
   if (nItem == BASE_ITEM_DWARVENWARAXE)   return "x2_wdwraxe001";
   if (nItem == BASE_ITEM_GREATAXE)        return "nw_waxgr001";
   if (nItem == BASE_ITEM_GREATSWORD)      return "nw_wswgs001";
   if (nItem == BASE_ITEM_HALBERD)         return "nw_wplhb001";
   if (nItem == BASE_ITEM_HANDAXE)         return "nw_waxhn001";
   if (nItem == BASE_ITEM_HEAVYFLAIL)      return "nw_wblfh001";
   if (nItem == BASE_ITEM_KAMA)            return "nw_wspka001";
   if (nItem == BASE_ITEM_KATANA)          return "nw_wswka001";
   if (nItem == BASE_ITEM_KUKRI)           return "nw_wspku001";
   if (nItem == BASE_ITEM_LIGHTFLAIL)      return "nw_wblfl001";
   if (nItem == BASE_ITEM_LIGHTHAMMER)     return "nw_wblhl001";
   if (nItem == BASE_ITEM_LIGHTMACE)       return "nw_wblml001";
   if (nItem == BASE_ITEM_LONGSWORD)       return "nw_wswls001";
   if (nItem == BASE_ITEM_MORNINGSTAR)     return "nw_wblms001";
   if (nItem == BASE_ITEM_QUARTERSTAFF)    return "nw_wdbqs001";
   if (nItem == BASE_ITEM_RAPIER)          return "nw_wswrp001";
   if (nItem == BASE_ITEM_SCIMITAR)        return "nw_wswsc001";
   if (nItem == BASE_ITEM_SCYTHE)          return "nw_wplsc001";
   if (nItem == BASE_ITEM_SHORTSPEAR)      return "nw_wplss001";
   if (nItem == BASE_ITEM_SHORTSWORD)      return "nw_wswss001";
   if (nItem == BASE_ITEM_SICKLE)          return "nw_wspsc001";
   if (nItem == BASE_ITEM_TWOBLADEDSWORD)  return "nw_wdbsw001";
   if (nItem == BASE_ITEM_WARHAMMER)       return "nw_wblhw001";
   if (nItem == BASE_ITEM_WHIP)            return "x2_it_wpwhip";
   if (nItem == BASE_ITEM_GLOVES)          return "flel_it_mgloves";
   return "";
}

string DamageTypeString(int nDamageType)
{
   if (nDamageType==IP_CONST_DAMAGETYPE_ACID)       return "Acid";
   if (nDamageType==IP_CONST_DAMAGETYPE_COLD)       return "Cold";
   if (nDamageType==IP_CONST_DAMAGETYPE_DIVINE)     return "Divine";
   if (nDamageType==IP_CONST_DAMAGETYPE_ELECTRICAL) return "Electrical";
   if (nDamageType==IP_CONST_DAMAGETYPE_FIRE)       return "Fire";
   if (nDamageType==IP_CONST_DAMAGETYPE_MAGICAL)    return "Magical";
   if (nDamageType==IP_CONST_DAMAGETYPE_NEGATIVE)   return "Negative";
   if (nDamageType==IP_CONST_DAMAGETYPE_POSITIVE)   return "Positive";
   if (nDamageType==IP_CONST_DAMAGETYPE_SONIC)      return "Sonic";
   if (nDamageType==IP_CONST_DAMAGETYPE_BLUDGEONING)return "Bludgeoning";
   if (nDamageType==IP_CONST_DAMAGETYPE_PIERCING)   return "Piercing";
   if (nDamageType==IP_CONST_DAMAGETYPE_SLASHING)   return "Slashing";
   return "";
}

string AddStoString(string sIn, int iIn)
{
    if (iIn == 1) return sIn;
    return sIn + "s";
}

string PickOne(string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="")
{
   int i=(s1!="")+(s2!="")+(s3!="")+(s4!="")+(s5!="")+(s6!=""); // count strings not null
   i=Random(i)+1;
   if (i==1) return s1;   if (i==2) return s2;   if (i==3) return s3;
   if (i==4) return s4;   if (i==5) return s5;   if (i==6) return s6;
   if (i==7) return s7;   if (i==8) return s8;   if (i==9) return s9;
   return "badger";
}

string Trim(string sIn)
{
   int iLen = GetStringLength(sIn);
   while (iLen > 0) {
      if (GetStringRight(sIn,1)==" ") {
         sIn = GetStringLeft(sIn, iLen - 1);
      } else if(GetStringLeft(sIn,1)==" ") {
         sIn = GetStringRight(sIn, iLen - 1);
      } else {
         break;
      }
      iLen = iLen - 1;
   }
   return sIn;
}

string AbilityString(int nAbilityType)
{
   if (nAbilityType==IP_CONST_ABILITY_STR) return "STR"; if (nAbilityType==IP_CONST_ABILITY_DEX) return "DEX";
   if (nAbilityType==IP_CONST_ABILITY_CON) return "CON"; if (nAbilityType==IP_CONST_ABILITY_INT) return "INT";
   if (nAbilityType==IP_CONST_ABILITY_WIS) return "WIS"; if (nAbilityType==IP_CONST_ABILITY_CHA) return "CHA";
   return "Missing Ability Text";
}

string IPString(int nProp)
{
   switch (nProp)
   {
      case ITEM_PROPERTY_ABILITY_BONUS:                  return "Ability Bonus";
      case ITEM_PROPERTY_AC_BONUS:                       return "Ac Bonus";
      case ITEM_PROPERTY_ATTACK_BONUS:                   return "Attack Bonus";
      case ITEM_PROPERTY_BONUS_FEAT:                     return "Bonus Feat";
      case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:    return "Bonus Spell Slot";
      case ITEM_PROPERTY_CAST_SPELL:                     return "Cast Spell";
      case ITEM_PROPERTY_DAMAGE_BONUS:                   return "Damage Bonus";
      case ITEM_PROPERTY_DAMAGE_REDUCTION:               return "Damage Reduction";
      case ITEM_PROPERTY_DAMAGE_RESISTANCE:              return "Damage Resistance";
      case ITEM_PROPERTY_HASTE:                          return "Haste";
      case ITEM_PROPERTY_HOLY_AVENGER:                   return "Holy Avenger";
      case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:           return "Immunity Damage Type";
      case ITEM_PROPERTY_KEEN:                           return "Keen";
      case ITEM_PROPERTY_MASSIVE_CRITICALS:              return "Massive Criticals";
      case ITEM_PROPERTY_MIGHTY:                         return "Mighty";
      case ITEM_PROPERTY_ON_HIT_PROPERTIES:              return "On Hit Properties";
      case ITEM_PROPERTY_REGENERATION:                   return "Regeneration";
      case ITEM_PROPERTY_REGENERATION_VAMPIRIC:          return "Regeneration Vampiric";
      case ITEM_PROPERTY_SAVING_THROW_BONUS:             return "Saving Throw Bonus";
      case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:    return "Saving Throw Bonus Specific";
      case ITEM_PROPERTY_SKILL_BONUS:                    return "Skill Bonus";
      case ITEM_PROPERTY_SPELL_RESISTANCE:               return "Spell Resistance";
   }
   return "UNKNOWN PROP";
}

string CapitalizeFirstLetter(string sIn)
{
   return GetStringUpperCase(GetStringLeft(sIn,1)) + GetStringLowerCase(GetStringRight(sIn, GetStringLength(sIn)-1));
}

string LightString(int nLight)
{
   if (nLight==IP_CONST_LIGHTCOLOR_BLUE  ) return "Blue";   if (nLight==IP_CONST_LIGHTCOLOR_YELLOW) return "Yellow";
   if (nLight==IP_CONST_LIGHTCOLOR_PURPLE) return "Purple"; if (nLight==IP_CONST_LIGHTCOLOR_RED   ) return "Red";
   if (nLight==IP_CONST_LIGHTCOLOR_GREEN ) return "Green";  if (nLight==IP_CONST_LIGHTCOLOR_ORANGE) return "Orange";
   if (nLight==IP_CONST_LIGHTCOLOR_WHITE ) return "White";
   return "LightString MISSING";
}

string OnHitString(int nOnHit)
{
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_14)   return "DC 14";    if (nOnHit==IP_CONST_ONHIT_SAVEDC_16)  return "DC 16";
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_18)   return "DC 18";    if (nOnHit==IP_CONST_ONHIT_SAVEDC_20)  return "DC 20";
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_22)   return "DC 22";    if (nOnHit==IP_CONST_ONHIT_SAVEDC_24)  return "DC 24";
   if (nOnHit==IP_CONST_ONHIT_SAVEDC_26)   return "DC 26";
   return "OnHitString MISSING";
}

string SaveSpecificBonusString(int nSaveType)
{
   if (nSaveType==IP_CONST_SAVEBASETYPE_FORTITUDE) return"Fortitude";      if (nSaveType==IP_CONST_SAVEBASETYPE_WILL     ) return"Will";
   if (nSaveType==IP_CONST_SAVEBASETYPE_REFLEX   ) return"Reflex";
   return "Missed SaveSpecificBonusString";
}

string SkillBonusString(int nSkillType)
{
   if (nSkillType==SKILL_ANIMAL_EMPATHY  ) return "Animal Empathy"; if (nSkillType==SKILL_CONCENTRATION   ) return "Concentration";
   if (nSkillType==SKILL_DISABLE_TRAP    ) return "Disable Trap";   if (nSkillType==SKILL_DISCIPLINE      ) return "Discipline";
   if (nSkillType==SKILL_HEAL            ) return "Heal";           if (nSkillType==SKILL_HIDE            ) return "Hide";
   if (nSkillType==SKILL_INTIMIDATE      ) return "Intimidate";     if (nSkillType==SKILL_LISTEN          ) return "Listen";
   if (nSkillType==SKILL_MOVE_SILENTLY   ) return "Move Silently";  if (nSkillType==SKILL_OPEN_LOCK       ) return "Open Lock";
   if (nSkillType==SKILL_PARRY           ) return "Parry";          if (nSkillType==SKILL_PERFORM         ) return "Perform";
   if (nSkillType==SKILL_PICK_POCKET     ) return "Pick Pocket";    if (nSkillType==SKILL_SEARCH          ) return "Search";
   if (nSkillType==SKILL_SET_TRAP        ) return "Set Trap";       if (nSkillType==SKILL_SPELLCRAFT      ) return "Spellcraft";
   if (nSkillType==SKILL_SPOT            ) return "Spot";           if (nSkillType==SKILL_TAUNT           ) return "Taunt";
   if (nSkillType==SKILL_TUMBLE          ) return "Tumble";         if (nSkillType==SKILL_USE_MAGIC_DEVICE) return "Use Magic Device";
   return "Missed SkillBonusString";
}

string VisualEffectString(int nVE)
{
   if (nVE==ITEM_VISUAL_ACID   )    return "Acid";          if (nVE==ITEM_VISUAL_COLD) return "Cold";
   if (nVE==ITEM_VISUAL_ELECTRICAL) return "Electrical";    if (nVE==ITEM_VISUAL_EVIL) return "Evil";
   if (nVE==ITEM_VISUAL_FIRE   )    return "Fire";          if (nVE==ITEM_VISUAL_HOLY) return "Holy";
   if (nVE==ITEM_VISUAL_SONIC  )    return "Sonic";
   return "VisualEffectString MISSING";
}

string ConvertSecondsToString(int nSeconds)
{
   int nDays = nSeconds / 86400;
   nSeconds -= nDays * 86400;
   int nHours = nSeconds / 3600;
   nSeconds -= nHours * 3600;
   int nMinutes = nSeconds / 60;
   nSeconds -= nMinutes * 60;
   string sTime = "";
   if (nDays > 0) sTime = IntToString(nDays) + AddStoString(" day", nDays) + " ";
   if (nHours > 0) sTime += IntToString(nHours) + AddStoString(" hour", nHours) + " ";
   if (nMinutes > 0) sTime += IntToString(nMinutes) + AddStoString(" minute", nMinutes) + " ";
   if (nSeconds > 0) sTime += IntToString(nSeconds) + AddStoString(" second", nSeconds) + " ";
   return sTime;
}

string InventorySlotString(int nSlot = 0)
{
   if (nSlot == INVENTORY_SLOT_HEAD     ) return "Head";         if (nSlot == INVENTORY_SLOT_CHEST    ) return "Chest";
   if (nSlot == INVENTORY_SLOT_BOOTS    ) return "Boots";        if (nSlot == INVENTORY_SLOT_ARMS     ) return "Arms";
   if (nSlot == INVENTORY_SLOT_RIGHTHAND) return "Right Hand";   if (nSlot == INVENTORY_SLOT_LEFTHAND ) return "Left Hand";
   if (nSlot == INVENTORY_SLOT_CLOAK    ) return "Cloak";        if (nSlot == INVENTORY_SLOT_LEFTRING ) return "Left Ring";
   if (nSlot == INVENTORY_SLOT_RIGHTRING) return "Right Ring";   if (nSlot == INVENTORY_SLOT_NECK     ) return "Neck";
   if (nSlot == INVENTORY_SLOT_BELT     ) return "Belt";         if (nSlot == INVENTORY_SLOT_ARROWS   ) return "Arrows";
   if (nSlot == INVENTORY_SLOT_BULLETS  ) return "Bullets";      if (nSlot == INVENTORY_SLOT_BOLTS    ) return "Bolts";
   return "InventorySlotString Mssing " + IntToString(nSlot);
}
//void main(){}

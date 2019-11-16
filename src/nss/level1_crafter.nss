#include "x2_inc_itemprop"
#include "zdlg_include_i"
#include "gen_inc_color"
#include "db_inc"
#include "seed_magic_stone"
#include "_functions"
#include "string_inc"
#include "item_inc"

// PERSIST VARIABLE STRINGS
const string CRAFTER_LIST        = "CRAFTER_LIST";
const string CRAFTER_CONFIRM     = "CRAFTER_CONFIRM";

// PAGES
const int PAGE_MENU_MAIN          =   1;
const int PAGE_SHOW_MESSAGE       =   2;
const int PAGE_CONFIRM_ACTION     =   3;
const int PAGE_MENU_ABILITY       =   4;
const int PAGE_MENU_AC            =   5;
const int PAGE_MENU_ACESSORIES    =   6;
const int PAGE_MENU_AMMO          =   7;
const int PAGE_MENU_ARMOR         =   8;
const int PAGE_MENU_AXES          =   9;
const int PAGE_MENU_BLADED        =  10;
const int PAGE_MENU_BLUNTS        =  11;
const int PAGE_MENU_BONUSDC       =  12;
const int PAGE_MENU_BONUSDICE     =  13;
const int PAGE_MENU_BONUSPLUS     =  14;
const int PAGE_MENU_BONUSSLOT     =  15;
const int PAGE_MENU_DAMAGE        =  16;
const int PAGE_MENU_DOUBLESIDED   =  17;
const int PAGE_MENU_ENCHANTMENTS  =  18;
const int PAGE_MENU_EXOTIC        =  19;
const int PAGE_MENU_ONHIT         =  21;
const int PAGE_MENU_POLEARMS      =  22;
const int PAGE_MENU_PROPERTIES    =  23;
const int PAGE_MENU_RANGED        =  24;
const int PAGE_MENU_SAVEBIG3      =  25;
const int PAGE_MENU_SAVEVS        =  26;
const int PAGE_MENU_SHIELD        =  27;
const int PAGE_MENU_SKILLS        =  28;
const int PAGE_MENU_SPELLCLASS    =  29;
const int PAGE_MENU_WEAPONS       =  30;
const int PAGE_MENU_EQUIPPED      =  31;
const int PAGE_MENU_REMOVE        =  32;
const int PAGE_MENU_LIGHT         =  33;
const int PAGE_MENU_VISUALEFFECT  =  34;

const int ACTION_CONFIRM          = 101;
const int ACTION_CANCEL           = 102;
const int ACTION_END_CONVO        = 103;
const int ACTION_SELECT_BONUS     = 104;
const int ACTION_SELECT_PROPTYPE  = 105;
const int ACTION_SELECT_SUBTYPE   = 106;
const int ACTION_BUY_ITEM         = 107;
const int ACTION_START_ITEM       = 108;
const int ACTION_START_ITEM50     = 109;
const int ACTION_START_ITEM99     = 110;
const int ACTION_COPY_ITEM        = 111;
const int ACTION_REMOVE_PROP      = 112;
const int ACTION_EXAMINE_ITEM     = 113;

// SHOW constants for item properties
const int SHOW_ABILITY            = BIT1;
const int SHOW_SKILL              = BIT2;
const int SHOW_SAVEVS             = BIT3;
const int SHOW_SPELLSLOT          = BIT4;
const int SHOW_AB                 = BIT5;
const int SHOW_KEEN               = BIT6;
const int SHOW_DAMAGE             = BIT7;
const int SHOW_MASSCRITS          = BIT8;
const int SHOW_VAMP_REGEN         = BIT9;
const int SHOW_ONHIT              = BIT10;
const int SHOW_MIGHTY             = BIT11;
const int SHOW_REGEN              = BIT12;
const int SHOW_SAVESPECIFIC       = BIT13;
const int SHOW_HASTE              = BIT14;
const int SHOW_DARKVISION         = BIT15;
const int SHOW_AC                 = BIT16;
const int SHOW_LIGHT              = BIT17;
const int SHOW_VISUAL             = BIT18;
const int SHOW_EB                 = BIT19;

const int CRAFT_ARMOR             = BIT1;
const int CRAFT_MAGIC             = BIT2;
const int CRAFT_MELEE             = BIT3;
const int CRAFT_RANGED            = BIT4;

const int TEXT_COLOR = CLR_TANNER;


void   AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = CRAFTER_LIST);
void   AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = CRAFTER_LIST);
void   AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = CRAFTER_LIST);
void   DoConfirmAction();
void   DoShowMessage();
int    GetConfirmedAction();
int    GetNextPage();
int    GetPageOptionSelected(string sList = CRAFTER_LIST);
int    GetPageOptionSelectedInt(string sList = CRAFTER_LIST);
object GetPageOptionSelectedObject(string sList = CRAFTER_LIST);
string GetPageOptionSelectedString(string sList = CRAFTER_LIST);
string SendMsg(string sMsg);
void   SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No");
void   SetNextPage(int nPage);
void   SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO);

object oPC = GetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST
object oCrafter = OBJECT_SELF;
int MAX_LEVEL = 1;
int iActivePropCount = 0;

void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = CRAFTER_LIST) {
   ReplaceIntElement(AddStringElement(GetRGBColor(TEXT_COLOR)+sSelectionText, sList, oPC)-1, nSelectionValue, sList, oPC);
   AddIntElement(nSubValue, CRAFTER_LIST + "_SUB", oPC);
}
void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = CRAFTER_LIST) {
   ReplaceIntElement(AddStringElement(GetRGBColor(TEXT_COLOR)+sSelectionText, sList, oPC)-1, nSelectionValue, sList, oPC);
   AddStringElement(sSubValue, CRAFTER_LIST + "_SUB", oPC);
}
void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = CRAFTER_LIST) {
   ReplaceIntElement(AddStringElement(GetRGBColor(TEXT_COLOR)+sSelectionText, sList, oPC)-1, nSelectionValue, sList, oPC);
   AddObjectElement(oSubValue, CRAFTER_LIST + "_SUB", oPC);
}

void SetPrompt(string sText) {
   SetDlgPrompt(GetRGBColor(TEXT_COLOR)+sText);
}

string DisabledText(string sText) {
   return GetRGBColor(CLR_GRAY) + sText;
}

int GetPageOptionSelected(string sList = CRAFTER_LIST) {
   return GetIntElement(GetDlgSelection(), sList, oPC);
}

int GetPageOptionSelectedInt(string sList = CRAFTER_LIST) {
   return GetIntElement(GetDlgSelection(), sList + "_SUB", oPC);
}

string GetPageOptionSelectedString(string sList = CRAFTER_LIST) {
   return GetStringElement(GetDlgSelection(), sList + "_SUB", oPC);
}

object GetPageOptionSelectedObject(string sList = CRAFTER_LIST) {
   return GetObjectElement(GetDlgSelection(), sList + "_SUB", oPC);
}

int GetNextPage() {
   return GetLocalInt(oPC, CRAFTER_LIST + "_NEXTPAGE");
}
void SetNextPage(int nPage) {
   SetLocalInt(oPC, CRAFTER_LIST + "_NEXTPAGE", nPage);
}

int GetBackPage() {
   return GetLocalInt(oPC, CRAFTER_LIST + "_BACK");
}

void SetBackPage(int nPage) {
   SetLocalInt(oPC, CRAFTER_LIST + "_BACK", nPage);
}

void SetMaxBonus(int nMaxBonus) {
   SetLocalInt(oPC, CRAFTER_LIST+"_MAXBONUS", nMaxBonus);
}

int GetMaxBonus() {
   return GetLocalInt(oPC, CRAFTER_LIST+"_MAXBONUS");
}

void SetPropType(int nPropType) {
   SetLocalInt(oPC, CRAFTER_LIST+"_PROPTYPE", nPropType);
}

int GetPropType() {
   return GetLocalInt(oPC, CRAFTER_LIST+"_PROPTYPE");
}

void SetSubType(int nSubType) {
   SetLocalInt(oPC, CRAFTER_LIST+"_SUBTYPE", nSubType);
}

int GetSubType() {
   return GetLocalInt(oPC, CRAFTER_LIST+"_SUBTYPE");
}

void SetBonus(int iBonus) {
   SetLocalInt(oPC, CRAFTER_LIST+"_BONUS", iBonus);
}

int GetBonus() {
   return GetLocalInt(oPC, CRAFTER_LIST+"_BONUS");
}

object GetWorkingItem() {
    return GetLocalObject(oPC, CRAFTER_LIST+"_ITEM");
}

void SetWorkingItem(string sResRef, int iStack = 1) {
    object oItem = CreateItemOnObject(sResRef, oCrafter, iStack);
    SetDroppableFlag(oItem, FALSE);
    SetIdentified(oItem, TRUE);
    SetLocalObject(oPC, CRAFTER_LIST+"_ITEM", oItem);
}

void DeleteWorkingItem() {
    object oItem = GetWorkingItem();
    if (oItem!=OBJECT_INVALID) {
       DestroyObject(oItem);
       SetLocalObject(oPC, CRAFTER_LIST+"_ITEM", OBJECT_INVALID);
    }
}

object GetCopiedItem() {
    return GetLocalObject(oPC, CRAFTER_LIST+"_COPY");
}

void SetCopiedItem(object oItem) {
    SetLocalObject(oPC, CRAFTER_LIST+"_COPY", oItem);
}

void SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO) {
   SetLocalString(oPC, CRAFTER_CONFIRM, sPrompt);
   SetLocalInt(oPC, CRAFTER_CONFIRM, nOkAction);
   SetNextPage(PAGE_SHOW_MESSAGE);
}

void DoShowMessage() {
   SetPrompt(GetLocalString(oPC, CRAFTER_CONFIRM));
   int nOkAction = GetLocalInt(oPC, CRAFTER_CONFIRM);
   if (nOkAction!=ACTION_END_CONVO) AddMenuSelectionInt("Ok", nOkAction); // DON'T SHOW OK IF WE ARE ENDING CONVO, DEFAULT "END" WILL HANDLE IT
}

void SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No") {
   SetLocalString(oPC, CRAFTER_CONFIRM, sPrompt);
   SetLocalInt(oPC, CRAFTER_CONFIRM + "_Y", nActionConfirm);
   SetLocalInt(oPC, CRAFTER_CONFIRM + "_N", nActionCancel);
   SetLocalString(oPC, CRAFTER_CONFIRM + "_Y", sConfirm);
   SetLocalString(oPC, CRAFTER_CONFIRM + "_N", sCancel);
   SetNextPage(PAGE_CONFIRM_ACTION);
}

void DoConfirmAction() {
   SetPrompt(GetLocalString(oPC, CRAFTER_CONFIRM));
   AddMenuSelectionInt(GetLocalString(oPC, CRAFTER_CONFIRM + "_Y"), ACTION_CONFIRM, GetLocalInt(oPC, CRAFTER_CONFIRM+"_Y"));
   AddMenuSelectionInt(GetLocalString(oPC, CRAFTER_CONFIRM + "_N"), GetLocalInt(oPC, CRAFTER_CONFIRM+"_N"));
}

int GetConfirmedAction() {
   return GetLocalInt(oPC, CRAFTER_CONFIRM);
}

string SendMsg(string sMsg) {
   SendMessageToPC(oPC, sMsg);
   return sMsg+"\n";
}

struct ItemPropsStruct {
   int ItemBase;
   string ItemType;
   int ItemLevel;
   int ItemCost;
   int ItemCostMult;
   int ValidProps;
   int UsedProps;
   int HasUnique;
   int SaveSpecificSum;
   int SaveVsSum;
   int AbilitySum;
   int SkillSum;
   int Prop1Type;    int Prop1SubType;    int Prop1Bonus;   string Prop1Desc;
   int Prop2Type;    int Prop2SubType;    int Prop2Bonus;   string Prop2Desc;
   int Prop3Type;    int Prop3SubType;    int Prop3Bonus;   string Prop3Desc;
   int Prop4Type;    int Prop4SubType;    int Prop4Bonus;   string Prop4Desc;
   int Prop5Type;    int Prop5SubType;    int Prop5Bonus;   string Prop5Desc;
   int Prop6Type;    int Prop6SubType;    int Prop6Bonus;   string Prop6Desc;
   int Prop7Type;    int Prop7SubType;    int Prop7Bonus;   string Prop7Desc;
   int Prop8Type;    int Prop8SubType;    int Prop8Bonus;   string Prop8Desc;
   int PropCount;
   string PropList;
   int WeaponThrow;
   int WeaponAmmo;
   int WeaponRanged;
   int WeaponSize;
   int WeaponType;
   int WeaponMelee;
   int WeaponMods;
   int WeaponModsCount;
   int WeaponDamageMax;
   int WeaponDamageCurrent;

};

struct ItemPropsStruct ItemProps;

void SetProp(int iPropNum, int PropType, int PropSubType, int PropBonus, string PropDesc) {
   if (iPropNum==1) {
      ItemProps.Prop1Type = PropType;    ItemProps.Prop1SubType = PropSubType;
      ItemProps.Prop1Bonus = PropBonus;  ItemProps.Prop1Desc = PropDesc;
   } else if (iPropNum==2) {
      ItemProps.Prop2Type = PropType;    ItemProps.Prop2SubType = PropSubType;
      ItemProps.Prop2Bonus = PropBonus;  ItemProps.Prop2Desc = PropDesc;
   } else if (iPropNum==3) {
      ItemProps.Prop3Type = PropType;    ItemProps.Prop3SubType = PropSubType;
      ItemProps.Prop3Bonus = PropBonus;  ItemProps.Prop3Desc = PropDesc;
   } else if (iPropNum==4) {
      ItemProps.Prop4Type = PropType;    ItemProps.Prop4SubType = PropSubType;
      ItemProps.Prop4Bonus = PropBonus;  ItemProps.Prop4Desc = PropDesc;
   } else if (iPropNum==5) {
      ItemProps.Prop5Type = PropType;    ItemProps.Prop5SubType = PropSubType;
      ItemProps.Prop5Bonus = PropBonus;  ItemProps.Prop5Desc = PropDesc;
   } else if (iPropNum==6) {
      ItemProps.Prop6Type = PropType;    ItemProps.Prop6SubType = PropSubType;
      ItemProps.Prop6Bonus = PropBonus;  ItemProps.Prop6Desc = PropDesc;
   } else if (iPropNum==7) {
      ItemProps.Prop7Type = PropType;    ItemProps.Prop7SubType = PropSubType;
      ItemProps.Prop7Bonus = PropBonus;  ItemProps.Prop7Desc = PropDesc;
   } else if (iPropNum==8) {
      ItemProps.Prop8Type = PropType;    ItemProps.Prop8SubType = PropSubType;
      ItemProps.Prop8Bonus = PropBonus;  ItemProps.Prop8Desc = PropDesc;
   }
   if (ItemProps.PropList=="None") ItemProps.PropList = "";
   else ItemProps.PropList += ", ";
   ItemProps.PropList += PropDesc;
   ItemProps.PropCount = iPropNum;
}

void LoadItemProps(object oItem) {
   int iPropType;
   int iSubType;
   int iBonus;
   string sPropDesc;
   int iPropCnt = 0;
   ItemProps.HasUnique = -1;
   ItemProps.SaveSpecificSum = 0;
   ItemProps.SaveVsSum = 0;
   ItemProps.AbilitySum = 0;
   ItemProps.SkillSum = 0;
   ItemProps.ItemBase = GetBaseItemType(oItem);
   ItemProps.ItemType = CapitalizeFirstLetter(Get2DAString("baseitems", "label", ItemProps.ItemBase));
   ItemProps.ItemCostMult = 3;
   ItemProps.ItemLevel = GetItemLevel(GetGoldPieceValue(oItem));
   ItemProps.WeaponType = StringToInt(Get2DAString("baseitems", "WeaponType", ItemProps.ItemBase));
   ItemProps.WeaponModsCount = 0;
   ItemProps.WeaponMods = 0;
   ItemProps.WeaponDamageCurrent = 0;
   ItemProps.ValidProps = 0;

   ItemProps.ValidProps = (SHOW_ABILITY | SHOW_SKILL | SHOW_SAVEVS | SHOW_SPELLSLOT | SHOW_SAVESPECIFIC | SHOW_REGEN | SHOW_HASTE | SHOW_DARKVISION | SHOW_LIGHT);
   if (ItemProps.WeaponType==0 || ItemProps.ItemBase==BASE_ITEM_BRACER) { // NOT A WEAPON (BUT COULD BE BOLT, ARROW, BULLET)
      if (ItemProps.ItemBase==BASE_ITEM_ARROW || ItemProps.ItemBase==BASE_ITEM_BOLT || ItemProps.ItemBase==BASE_ITEM_BULLET) {
         ItemProps.WeaponAmmo = TRUE;
         ItemProps.WeaponMods = SMS_WEAPON_MODS_AMMO;
         ItemProps.ValidProps = (SHOW_DAMAGE | SHOW_VAMP_REGEN); // | SHOW_ONHIT);
      } else {
         ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AC);
      }
   } else {
      int nAmmoType = StringToInt(Get2DAString("baseitems", "AmmunitionType", ItemProps.ItemBase));
      ItemProps.WeaponRanged = (nAmmoType == 1 || nAmmoType == 2 || nAmmoType == 3); //1=arrow,2=bolt,3=bullet
      ItemProps.WeaponThrow = (nAmmoType == 4 || nAmmoType == 5 || nAmmoType == 6); //4=dart,5=shuriken,6=throwingaxe
      ItemProps.WeaponMelee = !(ItemProps.WeaponRanged || ItemProps.WeaponThrow);
      ItemProps.WeaponSize = StringToInt(Get2DAString("baseitems", "WeaponSize", ItemProps.ItemBase));
      if (ItemProps.WeaponSize == 1) ItemProps.WeaponMods = SMS_WEAPON_MODS_TINY;
      else if (ItemProps.WeaponSize == 2) ItemProps.WeaponMods = SMS_WEAPON_MODS_SMALL;
      else if (ItemProps.WeaponSize == 3) ItemProps.WeaponMods = SMS_WEAPON_MODS_MEDIUM;
      else if (ItemProps.WeaponSize == 4) ItemProps.WeaponMods = SMS_WEAPON_MODS_LARGE;
      if (ItemProps.ItemBase == BASE_ITEM_GLOVES) {
         ItemProps.WeaponMods = SMS_WEAPON_MODS_GLOVES;
         ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AB | SHOW_DAMAGE | SHOW_VAMP_REGEN);
      } else if (ItemProps.WeaponRanged) {
         ItemProps.WeaponMods = 0;
         ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AB | SHOW_MASSCRITS | SHOW_MIGHTY);
      } else if (ItemProps.WeaponThrow) {
         ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AB | SHOW_EB | SHOW_DAMAGE | SHOW_VAMP_REGEN | SHOW_ONHIT | SHOW_MIGHTY | SHOW_VISUAL);
         ItemProps.WeaponMods = SMS_WEAPON_MODS_THROWING;
      } else if (ItemProps.WeaponMods > 0) { // EVERYTHING ELSE SHOULD END UP IN HERE
         ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AB | SHOW_EB | SHOW_DAMAGE | SHOW_VAMP_REGEN | SHOW_KEEN | SHOW_MASSCRITS | SHOW_VISUAL);
      }
   }
   ItemProps.WeaponDamageMax = ItemProps.WeaponMods * MAX_DAMAGE_PER_MOD;
   itemproperty ipProperty =  GetFirstItemProperty(oItem);
   ItemProps.PropList = "None";
   while (GetIsItemPropertyValid(ipProperty)) {
      iPropCnt++;
      iPropType = GetItemPropertyType(ipProperty);
      iSubType=GetItemPropertySubType(ipProperty);
      iBonus = GetItemPropertyCostTableValue(ipProperty);
      int iParam1 = GetItemPropertyParam1Value(ipProperty);
      sPropDesc = ItemPropertyDesc(iPropType, iSubType, iBonus, iParam1);
      switch (iPropType) {
         case ITEM_PROPERTY_ABILITY_BONUS:
            if (ItemProps.HasUnique==-1) ItemProps.HasUnique = iPropType;
            ItemProps.AbilitySum+=iBonus;
            if (ItemProps.AbilitySum>=SMS_ABILITY_MAIN_ITEM_MAX) {
               ItemProps.UsedProps = ItemProps.UsedProps | SHOW_ABILITY;
            }
            break;
         case ITEM_PROPERTY_AC_BONUS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_AC;
            break;
         case ITEM_PROPERTY_ATTACK_BONUS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_AB | SHOW_EB;
            break;
         case ITEM_PROPERTY_BONUS_FEAT:
            break;
         case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_SPELLSLOT;
            if (ItemProps.HasUnique==-1) ItemProps.HasUnique = iPropType;
            break;
         case ITEM_PROPERTY_CAST_SPELL:
            break;
         case ITEM_PROPERTY_DAMAGE_BONUS:
            ItemProps.WeaponModsCount++;
            ItemProps.WeaponDamageCurrent += SMS_DamageBonusValue(iBonus);
            if (ItemProps.WeaponModsCount>=ItemProps.WeaponMods) {
               ItemProps.UsedProps = ItemProps.UsedProps | SHOW_DAMAGE;
            }
            break;
         case ITEM_PROPERTY_DAMAGE_REDUCTION:
            break;
         case ITEM_PROPERTY_DAMAGE_RESISTANCE:
            break;
         case ITEM_PROPERTY_DARKVISION:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_DARKVISION;
            break;
         case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
             sPropDesc = YellowText(sPropDesc);
            break;
         case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_EB | SHOW_AB;
            break;
         case ITEM_PROPERTY_HASTE:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_HASTE;
            break;
         case ITEM_PROPERTY_HOLY_AVENGER:
            break;
         case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
            break;
         case ITEM_PROPERTY_KEEN:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_KEEN;
            ItemProps.ItemCostMult++;
            break;
         case ITEM_PROPERTY_LIGHT:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_LIGHT;
            break;
         case ITEM_PROPERTY_MASSIVE_CRITICALS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_MASSCRITS;
            break;
         case ITEM_PROPERTY_MIGHTY:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_MIGHTY;
            break;
         case ITEM_PROPERTY_ON_HIT_PROPERTIES:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_ONHIT;
            if (ItemProps.HasUnique==-1) ItemProps.HasUnique = iPropType;
            ItemProps.ItemCostMult += 2;
            break;
         case ITEM_PROPERTY_REGENERATION:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_REGEN;
            if (ItemProps.HasUnique==-1) ItemProps.HasUnique = iPropType;
            break;
         case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_VAMP_REGEN;
            break;
         case ITEM_PROPERTY_SAVING_THROW_BONUS:
            ItemProps.SaveVsSum+=iBonus;
            if (ItemProps.HasUnique==-1) ItemProps.HasUnique = iPropType;
            if (ItemProps.SaveVsSum>=SMS_SAVE_VS_MAIN_ITEM_MAX) {
               ItemProps.UsedProps = ItemProps.UsedProps | SHOW_SAVEVS;
            }
            break;
         case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            ItemProps.SaveSpecificSum+=iBonus;
            if (ItemProps.HasUnique==-1) ItemProps.HasUnique = iPropType;
            if (ItemProps.SaveSpecificSum>=SMS_SAVE_BIG3_MAIN_ITEM_MAX) {
               ItemProps.UsedProps = ItemProps.UsedProps | SHOW_SAVESPECIFIC;
            }
            break;
         case ITEM_PROPERTY_SKILL_BONUS:
            ItemProps.SkillSum+=iBonus;
            if (ItemProps.HasUnique==-1) ItemProps.HasUnique = iPropType;
            if (ItemProps.SkillSum>=SMS_SKILL_MAX) {
               ItemProps.UsedProps = ItemProps.UsedProps | SHOW_SKILL;
            }
            break;
         case ITEM_PROPERTY_SPELL_RESISTANCE:
            break;
         case ITEM_PROPERTY_VISUALEFFECT:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_VISUAL;
            break;
      }
      SetProp(iPropCnt, iPropType, iSubType, iBonus, sPropDesc);
      ipProperty =  GetNextItemProperty(oItem);
   }
   ItemProps.ItemCost = GetGoldPieceValue(oItem) * ItemProps.ItemCostMult;
}

void ShowPropSelection(int iShow, int iUnique, string sText, int iAction, int iProp, int iAtMax = TRUE) {
   if (ItemProps.ValidProps & iShow) {
      int iCanUse = !(ItemProps.UsedProps & iShow) && !(iUnique && ItemProps.HasUnique!=-1);
      if (iProp==ItemProps.HasUnique && !iAtMax) iCanUse = TRUE;
      if (iCanUse) {
         iActivePropCount++;
      } else {
         sText = DisabledText(sText);
         iAction = PAGE_MENU_ENCHANTMENTS;
      }
      if (iUnique) sText += GetRGBColor(CLR_GRAY) + " (unique)";
      AddMenuSelectionInt(sText, iAction, iProp);
   }
}

int ShowOption(int iType) {
   return GetLocalInt(oCrafter, "CRAFTER_TYPE") & iType;
}

int CanRemove(int iProp) {
   return (iProp==ITEM_PROPERTY_DECREASED_SAVING_THROWS) ? PAGE_MENU_REMOVE : ACTION_REMOVE_PROP;
}

int MaxSpellSlot(int nClass) {
   switch (nClass) {
      case IP_CONST_CLASS_BARD   : return 6;
      case IP_CONST_CLASS_PALADIN: return 4;
      case IP_CONST_CLASS_RANGER : return 4;
   }
   return 9;
}

string FlagTooHigh(string sText, int iFlag) {
   return (iFlag) ? YellowText(sText) + RedText(" > Max!") + GetRGBColor(TEXT_COLOR): sText;
}

string HeaderMsg() {
   object oCopy = GetCopiedItem();
   int iCost = 0;
   int iTrade = 0;
   int iLevelTooHigh = (ItemProps.ItemLevel > MAX_LEVEL || ItemProps.ItemLevel > GetHitDice(oPC));
   string sMsg;
   sMsg =  "     Crafting:   " + ItemProps.ItemType + "\n";
   sMsg += "Level/Cost:   " + FlagTooHigh(IntToString(ItemProps.ItemLevel),iLevelTooHigh) + " / Free\n";
   sMsg += " Properties:   " + ItemProps.PropList + "\n\n";
   return sMsg;
}

void AddNewProperty() {
   object oItem = GetWorkingItem();
   itemproperty ipNew = CreateItemProperty(GetPropType(), GetSubType(), GetBonus());
   IPSafeAddItemProperty(oItem, ipNew);
   if (GetPropType()==ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC && GetSubType()==IP_CONST_SAVEBASETYPE_FORTITUDE) {
      if (GetBonus() > 2) IPSafeAddItemProperty(oItem, ItemPropertyReducedSavingThrowVsX(IP_CONST_SAVEVS_DEATH, GetBonus()-2));
      else IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS, DURATION_TYPE_PERMANENT, IP_CONST_SAVEVS_DEATH);
   }
}

void Init() {
   DeleteWorkingItem();
   SetCopiedItem(OBJECT_INVALID);
   SetNextPage(PAGE_MENU_MAIN);
}

void HandleSelection() {
   object oItem = GetWorkingItem();
   int iSelection = GetDlgSelection(); // THE NUMBER OF THE OPTION SELECTED
   int iOptionSelected = GetPageOptionSelected(); // THE ACTION/PAGE ASSOCIATED WITH THE OPTION
   int    iOptionSubSelected = GetPageOptionSelectedInt(); // THE SUB VALUE ASSOCIATED WITH THE OPTION
   string sOptionSubSelected = GetPageOptionSelectedString(); // THE SUB STRING ASSOCIATED WITH THE OPTION
   string sText;
   int iPropCnt;
   int iPropSeq;
   int iConfirmed;
   int iPropType;
   int iSubType;
   int iBonus;
   int iRemains;
   int iCopyCost = 0;
   object oCopy;
   int iGotMsg = 0;
   itemproperty ipProperty;
   SetBackPage(PAGE_MENU_MAIN);
   int iStack = 1;
   if (oItem!=OBJECT_INVALID) {

   }

   switch (iOptionSelected) {
      // ********************************
      // HANDLE SIMPLE PAGE TURNING FIRST
      // ********************************
      case PAGE_MENU_MAIN        :
      case PAGE_SHOW_MESSAGE     :
      case PAGE_CONFIRM_ACTION   :
      case PAGE_MENU_ABILITY     :
      case PAGE_MENU_AC          :
      case PAGE_MENU_ACESSORIES  :
      case PAGE_MENU_AMMO        :
      case PAGE_MENU_ARMOR       :
      case PAGE_MENU_AXES        :
      case PAGE_MENU_BLADED      :
      case PAGE_MENU_BLUNTS      :
      case PAGE_MENU_BONUSDC     :
      case PAGE_MENU_BONUSDICE   :
      case PAGE_MENU_BONUSPLUS   :
      case PAGE_MENU_BONUSSLOT   :
      case PAGE_MENU_DAMAGE      :
      case PAGE_MENU_DOUBLESIDED :
      case PAGE_MENU_ENCHANTMENTS:
      case PAGE_MENU_EQUIPPED    :
      case PAGE_MENU_EXOTIC      :
      case PAGE_MENU_LIGHT       :
      case PAGE_MENU_ONHIT       :
      case PAGE_MENU_POLEARMS    :
      case PAGE_MENU_PROPERTIES  :
      case PAGE_MENU_RANGED      :
      case PAGE_MENU_REMOVE      :
      case PAGE_MENU_SAVEBIG3    :
      case PAGE_MENU_SAVEVS      :
      case PAGE_MENU_SHIELD      :
      case PAGE_MENU_SKILLS      :
      case PAGE_MENU_SPELLCLASS  :
      case PAGE_MENU_VISUALEFFECT:
      case PAGE_MENU_WEAPONS     :
         if (GetNextPage()==iOptionSelected) PlaySound("vs_favhen4m_no");
         SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         return;

      // ************************
      // HANDLE PAGE ACTIONS NEXT
      // ************************
      case ACTION_END_CONVO:
         EndDlg();
         return;

      case ACTION_EXAMINE_ITEM:
         AssignCommand(oPC, ActionExamine(GetWorkingItem()));
         return;

      case ACTION_START_ITEM:
      case ACTION_START_ITEM50:
      case ACTION_START_ITEM99:
         if (iOptionSelected==ACTION_START_ITEM50) iStack = 50;
         else if (iOptionSelected==ACTION_START_ITEM99) iStack = 99;
         else iStack = 1;
         SetWorkingItem(sOptionSubSelected, iStack);
         if (iStack > 1) oCopy = GetItemPossessedBy(oPC,"flel_it_ammo_crt");
         else oCopy = OBJECT_INVALID;
         if (GetIsObjectValid(oCopy)) {
            oCopy = RetrieveCampaignObject("AMMO_CREATORS", "ACRT_", GetLocation(OBJECT_SELF), OBJECT_SELF, oPC);
            iCopyCost = GetMin(ItemProps.ItemCost, GetGoldPieceValue(oCopy) * 3);
            SetCopiedItem(oCopy); //oCopy = OBJECT_INVALID;
         }
         SetNextPage(PAGE_MENU_PROPERTIES);
         return;

      case ACTION_SELECT_PROPTYPE:
         SetPropType(iOptionSubSelected);
         switch (iOptionSubSelected) {
            // PROPS WITH NEITHER SUBTYPE OR BONUS POWER - DONE AFTER SELECTING
            case ITEM_PROPERTY_HASTE:
            case ITEM_PROPERTY_KEEN:
            case ITEM_PROPERTY_DARKVISION:
               AddNewProperty();
               return;

            // PROPS WITH NO SUBTYPES, JUST A BONUS POWER - SEND TO BONUS SELECTION
            case ITEM_PROPERTY_AC_BONUS:
               SetMaxBonus(SMS_AC_MAX);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_ATTACK_BONUS:
            case ITEM_PROPERTY_ENHANCEMENT_BONUS:
               SetMaxBonus(SMS_AB_MAX);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_MIGHTY:
               SetMaxBonus(SMS_MIGHTY_MAX);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_REGENERATION:
               SetMaxBonus(SMS_REGEN_MAIN_ITEM_MAX);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
               SetMaxBonus(SMS_VAMP_REGEN_MAX);
               SetNextPage(PAGE_MENU_BONUSPLUS);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;
            case ITEM_PROPERTY_MASSIVE_CRITICALS:
               SetNextPage(PAGE_MENU_BONUSDICE);
               SetBackPage(PAGE_MENU_ENCHANTMENTS);
               return;

            // PROPS WITH SUBTYPES - SEND TO SUBTYPE SCREEN
            case ITEM_PROPERTY_ABILITY_BONUS:
               SetMaxBonus(SMS_ABILITY_MAIN_ITEM_MAX);
               SetNextPage(PAGE_MENU_ABILITY);
               SetBackPage(PAGE_MENU_ABILITY);
               return;
            case ITEM_PROPERTY_DAMAGE_BONUS:
               SetNextPage(PAGE_MENU_DAMAGE);
               SetBackPage(PAGE_MENU_DAMAGE);
               return;
            case ITEM_PROPERTY_ON_HIT_PROPERTIES:
               SetNextPage(PAGE_MENU_ONHIT);
               SetBackPage(PAGE_MENU_ONHIT);
               return;
            case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
               SetMaxBonus(SMS_SAVE_BIG3_MAIN_ITEM_MAX);
               SetNextPage(PAGE_MENU_SAVEBIG3);
               SetBackPage(PAGE_MENU_SAVEBIG3);
               return;
            case ITEM_PROPERTY_SAVING_THROW_BONUS:
               SetMaxBonus(SMS_SAVE_VS_MAIN_ITEM_MAX);
               SetNextPage(PAGE_MENU_SAVEVS);
               SetBackPage(PAGE_MENU_SAVEVS);
               return;
            case ITEM_PROPERTY_SKILL_BONUS:
               SetMaxBonus(SMS_SKILL_MAX);
               SetNextPage(PAGE_MENU_SKILLS);
               SetBackPage(PAGE_MENU_SKILLS);
               return;
            case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
               SetNextPage(PAGE_MENU_SPELLCLASS);
               SetBackPage(PAGE_MENU_SPELLCLASS);
               return;
            case ITEM_PROPERTY_LIGHT:
               SetNextPage(PAGE_MENU_LIGHT);
               SetBackPage(PAGE_MENU_LIGHT);
               return;
            case ITEM_PROPERTY_VISUALEFFECT:
               SetNextPage(PAGE_MENU_VISUALEFFECT);
               SetBackPage(PAGE_MENU_VISUALEFFECT);
               return;
         }

      case ACTION_SELECT_SUBTYPE:
         SetSubType(iOptionSubSelected);
         switch (GetPropType()) {
            // PROPS WITH BONUS TYPES AS PLUS
            case ITEM_PROPERTY_ABILITY_BONUS:
            case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            case ITEM_PROPERTY_SAVING_THROW_BONUS:
            case ITEM_PROPERTY_SKILL_BONUS:
               SetNextPage(PAGE_MENU_BONUSPLUS);
               return;
            // PROPS WITH BONUS TYPES AS SPECIAL (ie DICE, DC)
            case ITEM_PROPERTY_DAMAGE_BONUS:
               SetNextPage(PAGE_MENU_BONUSDICE);
               return;
            case ITEM_PROPERTY_ON_HIT_PROPERTIES:
               SetNextPage(PAGE_MENU_BONUSDC);
               return;
            case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
               SetNextPage(PAGE_MENU_BONUSSLOT);
               return;
//            case ITEM_PROPERTY_LIGHT:
//            case ITEM_PROPERTY_VISUALEFFECT:
//               AddNewProperty();
               return;
         }
         return;

      case ACTION_SELECT_BONUS:
         SetBonus(iOptionSubSelected);
         AddNewProperty();
         SetNextPage(PAGE_MENU_ENCHANTMENTS);
         return;

      case ACTION_COPY_ITEM:
         oItem = CopyItem(GetPageOptionSelectedObject(), oCrafter);
         if (GetBaseItemType(oItem)==BASE_ITEM_ARROW || GetBaseItemType(oItem)==BASE_ITEM_BULLET || GetBaseItemType(oItem)==BASE_ITEM_BOLT) iStack = 99;
         else if (GetBaseItemType(oItem)==BASE_ITEM_DART || GetBaseItemType(oItem)==BASE_ITEM_SHURIKEN || GetBaseItemType(oItem)==BASE_ITEM_THROWINGAXE) iStack = 50;
         else iStack = 1;
         SetLocalObject(oPC, CRAFTER_LIST+"_ITEM", oItem); // SET WORKING OBJECT
         SetCopiedItem(GetPageOptionSelectedObject());
         SetNextPage(PAGE_MENU_PROPERTIES);
         SetBackPage(PAGE_MENU_EQUIPPED);
         return;

      case ACTION_REMOVE_PROP:
         ipProperty =  GetFirstItemProperty(oItem);
         sText = "All Properties ";
         ItemProps.PropList = "None";
         while (GetIsItemPropertyValid(ipProperty)) {
            iPropCnt++;
            iPropSeq++;
            iPropType = GetItemPropertyType(ipProperty);
            iSubType = GetItemPropertySubType(ipProperty);
            iBonus = GetItemPropertyCostTableValue(ipProperty);
            int iParam1 = GetItemPropertyParam1Value(ipProperty);
            if (iPropSeq==iOptionSubSelected || iOptionSubSelected==0) {
               RemoveItemProperty(oItem, ipProperty);
               iPropCnt--;
               if (iOptionSubSelected!=0) {
                  sText = ItemPropertyDesc(iPropType, iSubType, iBonus, iParam1);
                  if (iPropType==ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC && GetSubType()==IP_CONST_SAVEBASETYPE_FORTITUDE) {
                     IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS, DURATION_TYPE_PERMANENT, IP_CONST_SAVEVS_DEATH);
                     iPropCnt--;
                  }
                  //break;i
               }
            } else {
               SetProp(iPropSeq, iPropType, iSubType, iBonus, ItemPropertyDesc(iPropType, iSubType, iBonus, iParam1));
            }
            ipProperty = GetNextItemProperty(oItem);
         }
         sText = "Removed " + sText+ "\n\n" + "Properties:   " + ItemProps.PropList + "\n\n";
         if (iPropCnt<=0 || iOptionSubSelected==0) SetCopiedItem(OBJECT_INVALID); // REMOVED ALL PROPERTIES, DON'T NEED TO SELL ITEM
         SetShowMessage(sText, PAGE_MENU_PROPERTIES);
         return;

      case ACTION_BUY_ITEM:
         LoadItemProps(oItem);
         if (ItemProps.ItemLevel > MAX_LEVEL || ItemProps.ItemLevel > GetHitDice(oPC)) {
            SetShowMessage("This item is beyond my capabilities. Try removing some properties...", PAGE_MENU_REMOVE);
            return;
         }
         iCopyCost = 0;
         oCopy = GetCopiedItem();
         ItemProps.ItemCost = 0;
         if (GetItemStackSize(oItem)>1) { // AMMO CREATOR
            if (GetItemPossessedBy(oPC,"flel_it_ammo_crt")==OBJECT_INVALID) CreateItemOnObject("flel_it_ammo_crt",oPC);
            StoreCampaignObject("AMMO_CREATORS","ACRT_", oItem, oPC);
            SetShowMessage("Your ammo creator has been updated. You sold your one for " + IntToString(iCopyCost) + " to help pay for the new one.");
            iGotMsg = TRUE;
         }
         TakeGoldFromCreature(0, oPC, TRUE);
         PlaySound("it_coins");
         oItem = CopyObject(oItem, GetLocation(oPC), oPC, "CRAFTED");
         SetName(oItem, GetName(oItem, TRUE) + " of " + GetName(oPC));
         DeleteWorkingItem();
         if (oCopy!=OBJECT_INVALID && !iGotMsg) {
            DestroyObject(oCopy);
         }
         if (!iGotMsg) SetNextPage(PAGE_MENU_MAIN);
         return;

      // *****************************************
      // HANDLE CONFIRMED PAGE ACTIONS AND WE DONE
      // *****************************************
      case ACTION_CONFIRM: // THEY SAID YES TO SOMETHING (OR IT WAS AUTO-CONFIRMED ACTION)
         iConfirmed = GetPageOptionSelectedInt(); // THIS IS THE ACTION THEY CONFIRMED
         switch (iConfirmed) {
            case ACTION_SELECT_BONUS:
               return;
       }
    }
    SetNextPage(PAGE_MENU_MAIN); // If broken, send to main menu
}

void BuildPage(int nPage) {
   DeleteList(CRAFTER_LIST, oPC);
   DeleteList(CRAFTER_LIST+"_SUB", oPC);
   string sMsg;
   int i = 0;
   object oItem = GetWorkingItem();
   if (oItem!=OBJECT_INVALID) {
      LoadItemProps(oItem);
   }
   switch (nPage) {
      case PAGE_MENU_MAIN:
         SetPrompt("I can craft items up to level " + IntToString(MAX_LEVEL) + ". Select the item to craft:");
         AddMenuSelectionInt("Ammo, Throwing Weapons"  , PAGE_MENU_AMMO);
         AddMenuSelectionInt("Armor, Helms, Shields"   , PAGE_MENU_AC);
         AddMenuSelectionInt("Clothing and Accessories", PAGE_MENU_ACESSORIES);
         AddMenuSelectionInt("Ranged Weapons"          , PAGE_MENU_RANGED);
         AddMenuSelectionInt("Melee Weapons"           , PAGE_MENU_WEAPONS);
         DeleteWorkingItem();
         SetCopiedItem(OBJECT_INVALID);
         return;

      case PAGE_MENU_REMOVE:
         SetPrompt("Remove Item Property.\n\nSelect the Property to Remove:");
         if (ItemProps.PropCount>1) AddMenuSelectionInt("All Properties", ACTION_REMOVE_PROP, 0);
         if (ItemProps.Prop1Desc!="") AddMenuSelectionInt(ItemProps.Prop1Desc, CanRemove(ItemProps.Prop1Type), 1);
         if (ItemProps.Prop2Desc!="") AddMenuSelectionInt(ItemProps.Prop2Desc, CanRemove(ItemProps.Prop2Type), 2);
         if (ItemProps.Prop3Desc!="") AddMenuSelectionInt(ItemProps.Prop3Desc, CanRemove(ItemProps.Prop3Type), 3);
         if (ItemProps.Prop4Desc!="") AddMenuSelectionInt(ItemProps.Prop4Desc, CanRemove(ItemProps.Prop4Type), 4);
         if (ItemProps.Prop5Desc!="") AddMenuSelectionInt(ItemProps.Prop5Desc, CanRemove(ItemProps.Prop5Type), 5);
         if (ItemProps.Prop6Desc!="") AddMenuSelectionInt(ItemProps.Prop6Desc, CanRemove(ItemProps.Prop6Type), 6);
         if (ItemProps.Prop7Desc!="") AddMenuSelectionInt(ItemProps.Prop7Desc, CanRemove(ItemProps.Prop7Type), 7);
         if (ItemProps.Prop8Desc!="") AddMenuSelectionInt(ItemProps.Prop8Desc, CanRemove(ItemProps.Prop8Type), 8);
         AddMenuSelectionInt("[Back]", PAGE_MENU_PROPERTIES);
         break;

      case PAGE_MENU_AMMO:
         SetPrompt("Ammo and Throwing Weapons.\n\nSelect the Type:");
         AddMenuSelectionString("Arrows"       , ACTION_START_ITEM99, "nw_wamar001");
         AddMenuSelectionString("Bolts"        , ACTION_START_ITEM99, "nw_wambo001");
         AddMenuSelectionString("Bullets"      , ACTION_START_ITEM99, "nw_wambu001");
         AddMenuSelectionString("Darts"        , ACTION_START_ITEM50, "nw_wthdt001");
         AddMenuSelectionString("Shurikens"    , ACTION_START_ITEM50, "nw_wthsh001");
         AddMenuSelectionString("Throwing Axes", ACTION_START_ITEM50, "nw_wthax001");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;
      case PAGE_MENU_AC:
         SetPrompt("Armor, Helms, Shields.\n\nSelect the Type:");
         AddMenuSelectionInt("Armor",   PAGE_MENU_ARMOR);
         AddMenuSelectionString("Helm", ACTION_START_ITEM, "flel_it_helmet");
         AddMenuSelectionInt("Shields", PAGE_MENU_SHIELD);
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;
      case PAGE_MENU_ARMOR:
         SetPrompt("Armor.\n\nSelect the Type:");
         AddMenuSelectionString("AC 0: Robe"           , ACTION_START_ITEM, "arcanarobe");
         AddMenuSelectionString("AC 1: Padded"         , ACTION_START_ITEM, "nw_aarcl009");
         AddMenuSelectionString("AC 2: Leather"        , ACTION_START_ITEM, "nw_aarcl001");
         AddMenuSelectionString("AC 3: Studded Leather", ACTION_START_ITEM, "nw_aarcl002");
         AddMenuSelectionString("AC 4: Scale Mail"     , ACTION_START_ITEM, "nw_aarcl003");
         AddMenuSelectionString("AC 5: Chain Mail"     , ACTION_START_ITEM, "nw_aarcl004");
         AddMenuSelectionString("AC 6: Splint Mail"    , ACTION_START_ITEM, "nw_aarcl005");
         AddMenuSelectionString("AC 7: Half Plate"     , ACTION_START_ITEM, "nw_aarcl006");
         AddMenuSelectionString("AC 8: Full Plate"     , ACTION_START_ITEM, "nw_aarcl007");
         AddMenuSelectionInt("[Back]", PAGE_MENU_AC);
         break;
      case PAGE_MENU_SHIELD:
         SetPrompt("Shields.\n\nSelect the Type:");
         AddMenuSelectionString("AC 1: Small Shield", ACTION_START_ITEM, "nw_ashsw001");
         AddMenuSelectionString("AC 2: Large Shield", ACTION_START_ITEM, "nw_ashlw001");
         AddMenuSelectionString("AC 3: Tower Shield", ACTION_START_ITEM, "nw_ashto001");
         AddMenuSelectionInt("[Back]", PAGE_MENU_AC);
         break;

      case PAGE_MENU_ACESSORIES:
         SetPrompt("Clothing and Accessories.\n\nSelect the Type:");
         AddMenuSelectionString("Amulet"     , ACTION_START_ITEM, "arcanaamulet");
         AddMenuSelectionString("Belt"       , ACTION_START_ITEM, "arcanabelt");
         AddMenuSelectionString("Boots"      , ACTION_START_ITEM, "arcanaboots");
         AddMenuSelectionString("Bracers"    , ACTION_START_ITEM, "arcanabracer");
         AddMenuSelectionString("Cloak"      , ACTION_START_ITEM, "arcanacloak");
         AddMenuSelectionString("Ring"       , ACTION_START_ITEM, "nw_it_mring021");
         AddMenuSelectionString("Mage Staff" , ACTION_START_ITEM, "arcanastaff");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_RANGED:
         SetPrompt("Ranged Weapons.\n\nSelect the Type:");
         AddMenuSelectionString("Heavy Crossbow", ACTION_START_ITEM, "nw_wbwxh001");
         AddMenuSelectionString("Light Crossbow", ACTION_START_ITEM, "nw_wbwxl001");
         AddMenuSelectionString("Longbow"       , ACTION_START_ITEM, "nw_wbwln001");
         AddMenuSelectionString("Shortbow"      , ACTION_START_ITEM, "nw_wbwsh001");
         AddMenuSelectionString("Sling"         , ACTION_START_ITEM, "nw_wbwsl001");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_WEAPONS:
         SetPrompt("Melee Weapons.\n\nSelect the Type:");
         AddMenuSelectionInt("Axes"          , PAGE_MENU_AXES);
         AddMenuSelectionInt("Bladed"        , PAGE_MENU_BLADED);
         AddMenuSelectionInt("Blunts"        , PAGE_MENU_BLUNTS);
         AddMenuSelectionInt("Double-Sided"  , PAGE_MENU_DOUBLESIDED);
         AddMenuSelectionInt("Exotic"        , PAGE_MENU_EXOTIC);
         AddMenuSelectionInt("Polearms"      , PAGE_MENU_POLEARMS);
         AddMenuSelectionString("Monk Gloves", ACTION_START_ITEM, "arcanagauntlet");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_AXES:
         SetPrompt("Axes.\n\nSelect the Type:");
         AddMenuSelectionString("Handaxe"        , ACTION_START_ITEM, "nw_waxhn001");
         AddMenuSelectionString("Dwarven War Axe", ACTION_START_ITEM, "x2_wdwraxe001");
         AddMenuSelectionString("Battle Axe"     , ACTION_START_ITEM, "nw_waxbt001");
         AddMenuSelectionString("Great Axe"      , ACTION_START_ITEM, "nw_waxgr001");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_BLADED:
         SetPrompt("Bladed Weapons.\n\nSelect the Type:");
         AddMenuSelectionString("Dagger"       , ACTION_START_ITEM, "nw_wswdg001");
         AddMenuSelectionString("Bastard Sword", ACTION_START_ITEM, "nw_wswbs001");
         AddMenuSelectionString("Shortsword"   , ACTION_START_ITEM, "nw_wswss001");
         AddMenuSelectionString("Longsword"    , ACTION_START_ITEM, "nw_wswls001");
         AddMenuSelectionString("Greatsword"   , ACTION_START_ITEM, "nw_wswgs001");
         AddMenuSelectionString("Katana"       , ACTION_START_ITEM, "nw_wswka001");
         AddMenuSelectionString("Rapier"       , ACTION_START_ITEM, "nw_wswrp001");
         AddMenuSelectionString("Scimitar"     , ACTION_START_ITEM, "nw_wswsc001");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_BLUNTS:
         SetPrompt("Blunt Weapons.\n\nSelect the Type:");
         AddMenuSelectionString("Club"        , ACTION_START_ITEM, "nw_wblcl001");
         AddMenuSelectionString("Heavy Flail" , ACTION_START_ITEM, "nw_wblfh001");
         AddMenuSelectionString("Light Flail" , ACTION_START_ITEM, "nw_wblfl001");
         AddMenuSelectionString("Light Hammer", ACTION_START_ITEM, "nw_wblhl001");
         AddMenuSelectionString("Mace"        , ACTION_START_ITEM, "nw_wblml001");
         AddMenuSelectionString("Morningstar" , ACTION_START_ITEM, "nw_wblms001");
         AddMenuSelectionString("War Hammer"  , ACTION_START_ITEM, "nw_wblhw001");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_DOUBLESIDED:
         SetPrompt("Double Sided Weapons.\n\nSelect the Type:");
         AddMenuSelectionString("Dire Mace"      , ACTION_START_ITEM, "nw_wdbma001");
         AddMenuSelectionString("Double Axe"     , ACTION_START_ITEM, "nw_wdbax001");
         AddMenuSelectionString("Quarterstaff"   , ACTION_START_ITEM, "nw_wdbqs001");
         AddMenuSelectionString("Two-Sided Sword", ACTION_START_ITEM, "nw_wdbsw001");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_EXOTIC:
         SetPrompt("Exotic Weapons.\n\nSelect the Type:");
         AddMenuSelectionString("Kukri" , ACTION_START_ITEM, "nw_wspku001");
         AddMenuSelectionString("Kama"  , ACTION_START_ITEM, "nw_wspka001");
         AddMenuSelectionString("Sickle", ACTION_START_ITEM, "nw_wspsc001");
         AddMenuSelectionString("Whip"  , ACTION_START_ITEM, "x2_it_wpwhip");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_POLEARMS:
         SetPrompt("Polearms.\n\nSelect the Type:");
         AddMenuSelectionString("Halberd", ACTION_START_ITEM, "nw_wplhb001");
         AddMenuSelectionString("Scythe" , ACTION_START_ITEM, "nw_wplsc001");
         AddMenuSelectionString("Spear"  , ACTION_START_ITEM, "nw_wplss001");
         AddMenuSelectionString("Trident", ACTION_START_ITEM, "nw_wpltr001");
         AddMenuSelectionInt("[Back]", PAGE_MENU_MAIN);
         break;

      case PAGE_MENU_PROPERTIES:
         sMsg = HeaderMsg();
         sMsg += "What would you like to do now?";
         SetPrompt(sMsg);
         AddMenuSelectionInt("Add Enchantments", PAGE_MENU_ENCHANTMENTS);
         if (ItemProps.PropCount) {
            AddMenuSelectionInt("Remove Enchantments", PAGE_MENU_REMOVE);
         } else {
            AddMenuSelectionInt(DisabledText("Remove Enchantments"), PAGE_MENU_PROPERTIES);
         }
         AddMenuSelectionInt("Examine Item (refresh)", ACTION_EXAMINE_ITEM);
         AddMenuSelectionInt("Buy Item", ACTION_BUY_ITEM);
         AddMenuSelectionInt("Start Over", PAGE_MENU_MAIN);
         AddMenuSelectionInt("[Back]", GetBackPage());
         break;

      case PAGE_MENU_ENCHANTMENTS:
         sMsg = HeaderMsg();
         sMsg += "What property do you want to add?";
         SetPrompt(sMsg);
         ShowPropSelection(SHOW_AC          ,FALSE, "AC Bonus"             , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_AC_BONUS);
         ShowPropSelection(SHOW_AB          ,FALSE, "Attack Bonus"         , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_ATTACK_BONUS);
         ShowPropSelection(SHOW_LIGHT       ,FALSE, "Light"                , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_LIGHT);
         ShowPropSelection(SHOW_VISUAL      ,FALSE, "Visual Effects"       , ACTION_SELECT_PROPTYPE, ITEM_PROPERTY_VISUALEFFECT);
         AddMenuSelectionInt(iActivePropCount ? "[Back]" : "No Properties left to add [Back]", PAGE_MENU_PROPERTIES);
         break;

      case PAGE_MENU_LIGHT:
         sMsg = HeaderMsg();
         sMsg += "Select the Light color to add:";
         AddMenuSelectionInt("Blue"   , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_BLUE  );
         AddMenuSelectionInt("Green"  , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_GREEN );
         AddMenuSelectionInt("Orange" , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_ORANGE);
         AddMenuSelectionInt("Purple" , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_PURPLE);
         AddMenuSelectionInt("Red"    , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_RED   );
         AddMenuSelectionInt("White"  , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_WHITE );
         AddMenuSelectionInt("Yellow" , ACTION_SELECT_BONUS, IP_CONST_LIGHTCOLOR_YELLOW);
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         break;

      case PAGE_MENU_VISUALEFFECT:
         sMsg = HeaderMsg();
         sMsg += "Select the Visual Effect to add:";
         AddMenuSelectionInt("Acid"    , ACTION_SELECT_BONUS, ITEM_VISUAL_ACID    );
         AddMenuSelectionInt("Cold"    , ACTION_SELECT_BONUS, ITEM_VISUAL_COLD    );
         AddMenuSelectionInt("Electric", ACTION_SELECT_BONUS, ITEM_VISUAL_ELECTRICAL);
         AddMenuSelectionInt("Evil"    , ACTION_SELECT_BONUS, ITEM_VISUAL_EVIL    );
         AddMenuSelectionInt("Fire"    , ACTION_SELECT_BONUS, ITEM_VISUAL_FIRE    );
         AddMenuSelectionInt("Holy"    , ACTION_SELECT_BONUS, ITEM_VISUAL_HOLY    );
         AddMenuSelectionInt("Sonic"   , ACTION_SELECT_BONUS, ITEM_VISUAL_SONIC   );
         AddMenuSelectionInt("[Back]", PAGE_MENU_ENCHANTMENTS);
         break;

      case PAGE_MENU_BONUSPLUS:
         sMsg = HeaderMsg();
         sMsg += "Select type of " + IPString(GetPropType()) + " to add:";
         SetPrompt(sMsg);
         AddMenuSelectionInt("+1", ACTION_SELECT_BONUS, 1);
         AddMenuSelectionInt("[Back]", GetBackPage());
         break;

      case PAGE_SHOW_MESSAGE:
         DoShowMessage();
         break;
      case PAGE_CONFIRM_ACTION:
         DoConfirmAction();
         break;
    }
}

void CleanUp() {
    DeleteList(CRAFTER_LIST, oPC);
    DeleteList(CRAFTER_LIST+"_SUB", oPC);
}

void main() {
   int iEvent = GetDlgEventType();
   switch(iEvent) {
      case DLG_INIT:
         Init();
         break;
      case DLG_PAGE_INIT:
         BuildPage(GetNextPage());
         SetShowEndSelection(TRUE);
         SetDlgResponseList(CRAFTER_LIST, oPC);
         break;
      case DLG_SELECTION:
         HandleSelection();
         break;
      case DLG_ABORT:
      case DLG_END:
         CleanUp();
         break;
   }
}

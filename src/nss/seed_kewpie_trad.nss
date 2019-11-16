#include "x2_inc_itemprop"
#include "zdlg_include_i"
#include "gen_inc_color"
#include "db_inc"
#include "seed_pick_stone"


// PERSIST VARIABLE STRINGS
const string KEWPIE_LIST        = "KEWPIE_LIST";
const string KEWPIE_CONFIRM     = "KEWPIE_CONFIRM";

// PAGES
const int PAGE_MENU_MAIN          =   1;
const int PAGE_SHOW_MESSAGE       =   2;
const int PAGE_CONFIRM_ACTION     =   3;
const int PAGE_SELECT_GP          =   4;
const int PAGE_SELECT_XP          =   5;
const int PAGE_SELECT_DAMAGE      =   6;
const int PAGE_SELECT_CAST        =   7;
const int PAGE_SPELL_DEFENSE      =   8;
const int PAGE_SPELL_OFFENSE      =   9;
const int PAGE_SHOW_IOU           =  10;
const int PAGE_SELECT_WINGS       =  11;
const int PAGE_SELECT_TAIL        =  12;
const int PAGE_SELECT_SKIN        =  13;

const int ACTION_CONFIRM          = 101;
const int ACTION_CANCEL           = 102;
const int ACTION_END_CONVO        = 103;
const int ACTION_BUY_ITEM         = 104;
const int ACTION_CLAIM_IOU        = 105;
const int ACTION_BUY_WINGS        = 106;
const int ACTION_BUY_TAIL         = 107;
const int ACTION_BUY_SKIN         = 108;

const int TEXT_COLOR = CLR_TANNER;
object oPC = GetPcDlgSpeaker(); // THE SPEAKER OWNS THE LIST

string DisabledText(string sText) {
   return GetRGBColor(CLR_GRAY) + sText;
}

void AddMenuSelectionInt(string sSelectionText, int nSelectionValue, int nSubValue = 0, string sList = KEWPIE_LIST) {
   ReplaceIntElement(AddStringElement(GetRGBColor(TEXT_COLOR)+sSelectionText, sList, oPC)-1, nSelectionValue, sList, oPC);
   AddIntElement(nSubValue, KEWPIE_LIST + "_SUB", oPC);
}
void AddMenuSelectionString(string sSelectionText, int nSelectionValue, string sSubValue, string sList = KEWPIE_LIST) {
   ReplaceIntElement(AddStringElement(GetRGBColor(TEXT_COLOR)+sSelectionText, sList, oPC)-1, nSelectionValue, sList, oPC);
   AddStringElement(sSubValue, KEWPIE_LIST + "_SUB", oPC);
}
void AddMenuSelectionObject(string sSelectionText, int nSelectionValue, object oSubValue, string sList = KEWPIE_LIST) {
   ReplaceIntElement(AddStringElement(GetRGBColor(TEXT_COLOR)+sSelectionText, sList, oPC)-1, nSelectionValue, sList, oPC);
   AddObjectElement(oSubValue, KEWPIE_LIST + "_SUB", oPC);
}

void SetPrompt(string sText) {
   SetDlgPrompt(GetRGBColor(TEXT_COLOR)+sText);
}

int GetPageOptionSelected(string sList = KEWPIE_LIST) {
   return GetIntElement(GetDlgSelection(), sList, oPC);
}

string GetPageOptionSelectedCaption(string sList = KEWPIE_LIST) {
   return GetStringElement(GetDlgSelection(), sList, oPC);
}

int GetPageOptionSelectedInt(string sList = KEWPIE_LIST) {
   return GetIntElement(GetDlgSelection(), sList + "_SUB", oPC);
}

string GetPageOptionSelectedString(string sList = KEWPIE_LIST) {
   return GetStringElement(GetDlgSelection(), sList + "_SUB", oPC);
}

object GetPageOptionSelectedObject(string sList = KEWPIE_LIST) {
   return GetObjectElement(GetDlgSelection(), sList + "_SUB", oPC);
}

int GetNextPage() {
   return GetLocalInt(oPC, KEWPIE_LIST + "_NEXTPAGE");
}
void SetNextPage(int nPage) {
   SetLocalInt(oPC, KEWPIE_LIST + "_NEXTPAGE", nPage);
}

string GetBuyTag() {
   return GetLocalString(oPC, KEWPIE_LIST + "_BUYTAG");
}
void SetBuyTag(string sTag) {
   SetLocalString(oPC, KEWPIE_LIST + "_BUYTAG", sTag);
}
int GetBuyCost() {
   return GetLocalInt(oPC, KEWPIE_LIST + "_BUYCOST");
}
void SetBuyCost(int nCost) {
   SetLocalInt(oPC, KEWPIE_LIST + "_BUYCOST", nCost);
}
string GetIOUGIID() {
   return GetLocalString(oPC, KEWPIE_LIST + "_IOUGIID");
}
void SetIOUGIID(string sGIID) {
   SetLocalString(oPC, KEWPIE_LIST + "_IOUGIID", sGIID);
}

void SetShowMessage(string sPrompt, int nOkAction = ACTION_END_CONVO) {
   SetLocalString(oPC, KEWPIE_CONFIRM, sPrompt);
   SetLocalInt(oPC, KEWPIE_CONFIRM, nOkAction);
   SetNextPage(PAGE_SHOW_MESSAGE);
}

void DoShowMessage() {
   SetPrompt(GetLocalString(oPC, KEWPIE_CONFIRM));
   int nOkAction = GetLocalInt(oPC, KEWPIE_CONFIRM);
   if (nOkAction!=ACTION_END_CONVO) AddMenuSelectionInt("Ok", nOkAction); // DON'T SHOW OK IF WE ARE ENDING CONVO, DEFAULT "END" WILL HANDLE IT
}

void SetConfirmAction(string sPrompt, int nActionConfirm, int nActionCancel=PAGE_MENU_MAIN, string sConfirm="Yes", string sCancel="No") {
   SetLocalString(oPC, KEWPIE_CONFIRM, sPrompt);
   SetLocalInt(oPC, KEWPIE_CONFIRM + "_Y", nActionConfirm);
   SetLocalInt(oPC, KEWPIE_CONFIRM + "_N", nActionCancel);
   SetLocalString(oPC, KEWPIE_CONFIRM + "_Y", sConfirm);
   SetLocalString(oPC, KEWPIE_CONFIRM + "_N", sCancel);
   SetNextPage(PAGE_CONFIRM_ACTION);
}

void DoConfirmAction() {
   SetPrompt(GetLocalString(oPC, KEWPIE_CONFIRM));
   AddMenuSelectionInt(GetLocalString(oPC, KEWPIE_CONFIRM + "_Y"), ACTION_CONFIRM, GetLocalInt(oPC, KEWPIE_CONFIRM+"_Y"));
   AddMenuSelectionInt(GetLocalString(oPC, KEWPIE_CONFIRM + "_N"), GetLocalInt(oPC, KEWPIE_CONFIRM+"_N"));
}

int GetConfirmedAction() {
   return GetLocalInt(oPC, KEWPIE_CONFIRM);
}

string SendMsg(string sMsg) {
   SendMessageToPC(oPC, sMsg);
   return sMsg+"\n";
}

int CountKewpies() {
   if (GetLocalInt(oPC, "IAMARRES")) return 666;
   int nKewpies = 0;
   object oItem = GetFirstItemInInventory(oPC);
   while (GetIsObjectValid(oItem)) {
      SetIdentified(oItem, TRUE);
      if (GetStringLeft(GetTag(oItem), 12)=="PRIZE_TOKEN_") nKewpies++;
      oItem = GetNextItemInInventory(oPC);

   }
   return nKewpies;
}

int TakeKewpies(int nKewpies, string sMsg) {
   string sTag;
   sMsg += " by " + GetName(oPC);
   object oItem = GetFirstItemInInventory(oPC);
   while (GetIsObjectValid(oItem) && nKewpies) {
      sTag = GetTag(oItem);
      if (GetStringLeft(sTag, 12)=="PRIZE_TOKEN_") {
         sTag = GetStringRight(sTag, GetStringLength(sTag)-12);
         nKewpies--;
         string sSQL = "update tokentracker set tt_redemed=now(), tt_rplid="+IntToString(dbGetPLID(oPC))+", tt_rmsg="+dbQuotes(sMsg)+" where tt_ttid="+sTag;
         NWNX_SQL_ExecuteQuery(sSQL);
         DestroyObject(oItem);
      }
      oItem = GetNextItemInInventory(oPC);
   }
   return nKewpies;
}

void ShowPrize(string sTag, int nCost, int nCount, int nAction) {
   string sPrize = IntToString(nCost) + AddStoString(" Kewpie", nCost) + ": ";
   int bIsCast = (GetStringLeft(sTag,9)=="SMS_CAST_");
   if (bIsCast) {
      sPrize = "";
      nCount = nCost;
   }
   if (sTag=="GP") {
      int nGP = 1000000 * nCost * nCost;
      sTag = "GP"+IntToString(nGP);
      sPrize += IntToString(nGP) + " GP";
   } else if (sTag=="XP") {
      int nXP = 31200 * nCost * nCost;
      sTag = "XP"+IntToString(nXP);
      sPrize += IntToString(nXP) + " XP";
   } else if (GetStringLeft(sTag,4)=="SMS_") {
      sPrize += SMS_GetStoneName(sTag);
   } else if (nAction==PAGE_SELECT_WINGS || nAction==PAGE_SELECT_TAIL) {
      sPrize += sTag;
   }
   if (bIsCast) {
      sPrize = GetStringRight(sPrize, GetStringLength(sPrize)-11);
      sPrize += " (" + IntToString(nCost) + " charges)";
   }
   if (nCount<nCost) {
      sPrize = DisabledText(sPrize);
   } else {
      if (nAction==PAGE_SELECT_WINGS) nAction = ACTION_BUY_WINGS;
      else if (nAction==PAGE_SELECT_TAIL) nAction = ACTION_BUY_TAIL;
      else nAction = ACTION_BUY_ITEM;
   }
   AddMenuSelectionString(sPrize, nAction, sTag);
   nCount = GetElementCount(KEWPIE_LIST + "_SUB", oPC);
   ReplaceIntElement(nCount-1, nCost, KEWPIE_LIST + "_SUB", oPC);
}

void ShowSkins(int nKewpies) {
   string sSQL;
   string sSkin;
   string sDesc;
   string sPrize;
   sSQL = "select sk_skid, sk_desc from skins where sk_plid is null and sk_size = " + IntToString(GetCreatureSize(oPC));
   NWNX_SQL_ExecuteQuery(sSQL);
   while (NWNX_SQL_ReadyToReadNextRow())
   {
      NWNX_SQL_ReadNextRow();
      sSkin = NWNX_SQL_ReadDataInActiveRow(0);
      sDesc = NWNX_SQL_ReadDataInActiveRow(1);
      AddMenuSelectionString(sDesc, ACTION_BUY_SKIN, sSkin);
      int nCount = GetElementCount(KEWPIE_LIST + "_SUB", oPC);
      ReplaceIntElement(nCount-1, StringToInt(sSkin), KEWPIE_LIST + "_SUB", oPC);
      ShowPrize(sDesc, StringToInt(sSkin), nKewpies, PAGE_SELECT_SKIN);
   }
}

void ShowIOU(int bShowList=FALSE) {
   string sSQL;
   string sCount;
   string sName;
   string sGIID;
   if (!bShowList) sSQL = "count(*)";
   else sSQL = "gi_count, gi_giid, gi_name";
   sSQL = "select " + sSQL + " from giveitem where gi_redemed is null and gi_ckid=" + IntToString(dbGetCKID(oPC));
   if (bShowList) sSQL += " limit 10";
   NWNX_SQL_ExecuteQuery(sSQL);
   while (NWNX_SQL_ReadyToReadNextRow())
   {
      NWNX_SQL_ReadNextRow();
      sCount = NWNX_SQL_ReadDataInActiveRow(0);
      if (!bShowList) { // DON'T SHOW ALL THE ITEMS, JUST DISPLAY SELECT OPTION IF THERE ARE SOME THERE
         if (sCount!="0") {
            AddMenuSelectionInt("View DM IOU's (" + sCount + ")", PAGE_SHOW_IOU);
         }
      } else { // DISPLAY THE FULL LIST OF ITEMS I CAN COLLECT
         sGIID = NWNX_SQL_ReadDataInActiveRow(1);
         sName = NWNX_SQL_ReadDataInActiveRow(2);
         AddMenuSelectionString(sName, ACTION_CLAIM_IOU, sGIID);
      }
   }
}

object CreateIOUItem(object oPC, string sTag) {
   object oItem;
   if (sTag=="slaadgloves") {
      oItem = CreateItemOnObject("slaad_gloves", oPC, 1, "SEED_VALIDATED"); //
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2d6) , oItem);
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_2d6) , oItem);
      SetName(oItem, "Boxing Gloves of Thunder");

   } else if (sTag=="levelingweapon") {
       string sResRef = GetBaseWeaponResRef(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
       if (sResRef=="") {
          if (GetHasFeat(FEAT_MONK_AC_BONUS, oPC)) sResRef="flel_it_mgloves";
          else sResRef = PickOne("nw_wswrp001", "nw_wswsc001", "nw_wplsc001", "nw_wspka001", "nw_wswbs001");
       }
       oItem = CreateItemOnObject(sResRef, oPC, 1, "LEVELING_WEAPON");
       SetName(oItem, "Leveling " + GetName(oItem));
       AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE), oItem);
       return oItem;
   }
   return oItem;
}

void Init() {
   SetNextPage(PAGE_MENU_MAIN);
}

void HandleSelection() {
   int iConfirmed;
   int iSelection = GetDlgSelection(); // THE NUMBER OF THE OPTION SELECTED
   int    iOptionSelected = GetPageOptionSelected(); // THE ACTION/PAGE ASSOCIATED WITH THE OPTION
   string sOptionSelected = GetPageOptionSelectedCaption(); // THE CAPTION ASSOCIATED WITH THE OPTION
   int    iOptionSubSelected = GetPageOptionSelectedInt(); // THE SUB VALUE ASSOCIATED WITH THE OPTION
   string sOptionSubSelected = GetPageOptionSelectedString(); // THE SUB STRING ASSOCIATED WITH THE OPTION
   string sText;
   string sTag = GetBuyTag();
   int nCost = GetBuyCost();
   int bIsCast = (GetStringLeft(sTag,9)=="SMS_CAST_");
   int bIsXP = (GetStringLeft(sTag,2)=="XP");
   int bIsGP = (GetStringLeft(sTag,2)=="GP");
   int nCharges;
   object oItem;
   int nKewpies;

   switch (iOptionSelected) {
      // ********************************
      // HANDLE SIMPLE PAGE TURNING FIRST
      // ********************************
      case PAGE_MENU_MAIN        :
      case PAGE_SELECT_GP        :
      case PAGE_SELECT_XP        :
      case PAGE_SELECT_DAMAGE    :
      case PAGE_SELECT_CAST      :
      case PAGE_SPELL_DEFENSE    :
      case PAGE_SPELL_OFFENSE    :
      case PAGE_SHOW_IOU         :
      case PAGE_SHOW_MESSAGE     :
      case PAGE_CONFIRM_ACTION   :
      case PAGE_SELECT_WINGS     :
      case PAGE_SELECT_TAIL      :
      case PAGE_SELECT_SKIN      :
         if (GetNextPage()==iOptionSelected) PlaySound("vs_favhen4m_no");
         SetNextPage(iOptionSelected); // TURN TO NEW PAGE
         return;

      case ACTION_BUY_ITEM:
         SetBuyTag(sOptionSubSelected);
         SetBuyCost(iOptionSubSelected);
         bIsCast = (GetStringLeft(sOptionSubSelected,9)=="SMS_CAST_");
         if (bIsCast) {
            nCharges = iOptionSubSelected;
            iOptionSubSelected = 1;
         }
         bIsXP = (GetStringLeft(sOptionSubSelected,2)=="XP");
         bIsGP = (GetStringLeft(sOptionSubSelected,2)=="GP");
         sText = "Trade " + IntToString(iOptionSubSelected) + AddStoString(" Kewpie", iOptionSubSelected) + " for ";
         if (bIsXP) {
            sTag = GetStringRight(sOptionSubSelected, GetStringLength(sOptionSubSelected)-2);
            sText += sTag + " XP?";
         } else if (bIsGP) {
            sTag = GetStringRight(sOptionSubSelected, GetStringLength(sOptionSubSelected)-2);
            sText += sTag + " GP?";
         } else {
            sText += "a " + SMS_GetStoneName(sOptionSubSelected) + "?";
            if (bIsCast) sText += "?\n\n"+IntToString(nCharges)+" charges";
         }

         SetConfirmAction(sText, ACTION_BUY_ITEM, PAGE_MENU_MAIN);
         return;

      case ACTION_BUY_WINGS:
         SetBuyTag(sOptionSubSelected);
         sText = "Trade " + IntToString(iOptionSubSelected) + AddStoString(" Kewpie", iOptionSubSelected) + " for " + sOptionSubSelected + " Wings?";
         SetConfirmAction(sText, ACTION_BUY_WINGS, PAGE_MENU_MAIN);
         return;
      case ACTION_BUY_TAIL:
         SetBuyTag(sOptionSubSelected);
         sText = "Trade " + IntToString(iOptionSubSelected) + AddStoString(" Kewpie", iOptionSubSelected) + " for " + sOptionSubSelected + " Tail?";
         SetConfirmAction(sText, ACTION_BUY_TAIL, PAGE_MENU_MAIN);
         return;
      case ACTION_BUY_SKIN:
         SetBuyTag(sOptionSelected);
         SetBuyCost(StringToInt(sOptionSubSelected));
         SetCreatureAppearanceType(OBJECT_SELF, StringToInt(sOptionSubSelected));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GLOBE_USE), OBJECT_SELF);
         sText = "Trade 10 Kewpies for the selected skin?\n\n   " + sOptionSelected;
         SetConfirmAction(sText, ACTION_BUY_SKIN, PAGE_MENU_MAIN);
         SetLocalInt(oPC, "ACTION_SELECT_HACK", 1);
         return;

      case ACTION_CLAIM_IOU:
         SetBuyTag(sOptionSelected);     // NAME
         SetIOUGIID(sOptionSubSelected); // GIID
         SetConfirmAction("Claim owed " + sOptionSelected + "?", ACTION_CLAIM_IOU, PAGE_MENU_MAIN);
         return;

      // ************************
      // HANDLE PAGE ACTIONS NEXT
      // ************************
      case ACTION_END_CONVO:
         EndDlg();
         return;

      // *****************************************
      // HANDLE CONFIRMED PAGE ACTIONS AND WE DONE
      // *****************************************
      case ACTION_CONFIRM: // THEY SAID YES TO SOMETHING (OR IT WAS AUTO-CONFIRMED ACTION)
         iConfirmed = GetPageOptionSelectedInt(); // THIS IS THE ACTION THEY CONFIRMED
         switch (iConfirmed) {
            case ACTION_BUY_SKIN:
               nKewpies = CountKewpies();
               if (nKewpies < 10) {
                  SendMessageToPC(oPC, "You seem to have lost your kewpie.");
                  EndDlg();
                  return;
               }
               TakeKewpies(10, sTag);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
               SetCreatureAppearanceType(oPC, nCost);
               if (!GetLocalInt(oPC, "IAMSEED"))
                  NWNX_SQL_ExecuteQuery("update skins set sk_plid=" + IntToString(dbGetPLID(oPC)) + " where sk_skid=" + IntToString(nCost));
               EndDlg();
               return;

            case ACTION_BUY_WINGS:
               nKewpies = CountKewpies();
               if (nKewpies < 5) {
                  SendMessageToPC(oPC, "You seem to have lost your kewpie.");
                  EndDlg();
                  return;
               }
               if (sTag=="Angel") nCost = CREATURE_WING_TYPE_ANGEL;
               else if (sTag=="Bat") nCost = CREATURE_WING_TYPE_BAT;
               else if (sTag=="Bird") nCost = CREATURE_WING_TYPE_BIRD;
               else if (sTag=="Butterfly") nCost = CREATURE_WING_TYPE_BUTTERFLY;
               else if (sTag=="Demon") nCost = CREATURE_WING_TYPE_DEMON;
               else if (sTag=="Dragon") nCost = CREATURE_WING_TYPE_DRAGON;
               else if (sTag=="None") nCost = CREATURE_WING_TYPE_NONE;
               else nCost = CREATURE_WING_TYPE_BUTTERFLY;
               if (sTag != "None") TakeKewpies(5, sTag);
               else                TakeKewpies(1, sTag);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
               SetCreatureWingType(nCost, oPC);
               EndDlg();
               return;
            case ACTION_BUY_TAIL:
               nKewpies = CountKewpies();
               if (nKewpies < 3) {
                  SendMessageToPC(oPC, "You seem to have lost your kewpie.");
                  EndDlg();
                  return;
               }
               if (sTag=="Bone") nCost = CREATURE_TAIL_TYPE_BONE;
               else if (sTag=="Devil") nCost = CREATURE_TAIL_TYPE_DEVIL;
               else if (sTag=="Lizard") nCost = CREATURE_TAIL_TYPE_LIZARD;
               else if (sTag=="None") nCost = CREATURE_TAIL_TYPE_NONE;
               else nCost = CREATURE_TAIL_TYPE_DEVIL;
               if (sTag != "None") TakeKewpies(3, sTag);
               else                TakeKewpies(1, sTag);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
               SetCreatureTailType(nCost, oPC);
               EndDlg();
               return;

            case ACTION_BUY_ITEM:
               nKewpies = CountKewpies();
               if (bIsCast) {
                  nCharges = nCost;
                  nCost = 1;
               }
               if (nKewpies < nCost) {
                  SendMessageToPC(oPC, "You seem to have lost your kewpie.");
                  EndDlg();
                  return;
               } else if (bIsGP) {
                  int nGP = StringToInt(GetStringRight(sTag, GetStringLength(sTag)-2));
                  GiveGoldToCreature(oPC, nGP);
               } else if (bIsXP) {
                  int nXPOnPC = GetXP(oPC);
                  int nXP = StringToInt(GetStringRight(sTag, GetStringLength(sTag)-2));
                  dbSetXP(oPC, nXPOnPC+nXP, "KEWPIEXP");
               } else if (sTag=="SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11)) {
                  oItem = CreateItemOnObject("ptn_superhero", oPC, 10, sTag);
                  oItem = CreateItemOnObject("ptn_superhero", oPC, 10, sTag);
                  oItem = CreateItemOnObject("ptn_superhero", oPC, 10, sTag);
                  oItem = CreateItemOnObject("ptn_superhero", oPC, 10, sTag);
                  sTag = GetName(oItem);
               } else {
                  oItem = SMS_CreateStone(oPC, sTag);
                  if (bIsCast) SetItemCharges(oItem, nCharges);
                  sTag = GetName(oItem);
               }
               SetIdentified(oItem, TRUE);
               TakeKewpies(nCost, sTag);
               EndDlg();
               return;
            case ACTION_CLAIM_IOU:
               {
                  string sGIID = GetIOUGIID();
                  string sSQL = "select gi_tag, gi_type, gi_count from giveitem where gi_giid=" + sGIID;
                  string sTag;
                  string sType;
                  int nCount;
                  NWNX_SQL_ExecuteQuery(sSQL);
                  if (NWNX_SQL_ReadyToReadNextRow())
                  {
                     NWNX_SQL_ReadNextRow();
                     sTag   = NWNX_SQL_ReadDataInActiveRow(0);
                     sType  = NWNX_SQL_ReadDataInActiveRow(1);
                     if (sType=="gold") {
                        nCount = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
                        GiveGoldToCreature(oPC, nCount);
                     } else if (sType=="stone") {
                        oItem = SMS_CreateStone(oPC, sTag);
                     } else if (sType=="item") {
                        oItem = CreateIOUItem(oPC, sTag);
                     }
                  }
                  sSQL = "update giveitem set gi_redemed=now(), gi_plid="+IntToString(dbGetPLID(oPC))+" where gi_giid=" + sGIID;
                  NWNX_SQL_ExecuteQuery(sSQL);
                  SetNextPage(PAGE_SHOW_IOU); // If broken, send to main menu
               }
               return;
       }
    }
    SetNextPage(PAGE_MENU_MAIN); // If broken, send to main menu
}

void BuildPage(int nPage) {
   DeleteList(KEWPIE_LIST, oPC);
   DeleteList(KEWPIE_LIST+"_SUB", oPC);
   string sText;
   int i;
   int nKewpies = CountKewpies();
   string sKewpies = IntToString(nKewpies);
   switch (nPage) {
      case PAGE_MENU_MAIN:
         if (!nKewpies) {
            sText = "Welcome! You have no Kewpie dolls to exchange, but feel free to browse the prize list:";
         } else {
            sText = "Welcome! You have " + sKewpies + " Kewpie dolls to exchange. Select the type of prize you'd like:";
         }
         SetPrompt(sText);
         AddMenuSelectionInt("GP [1-5]", PAGE_SELECT_GP);
         AddMenuSelectionInt("XP [1-5]" , PAGE_SELECT_XP);
         AddMenuSelectionInt("Damage Stones [1-2]" , PAGE_SELECT_DAMAGE);
         AddMenuSelectionInt("Defensive Spell Stones [1]" , PAGE_SPELL_DEFENSE);
         AddMenuSelectionInt("Offensive Spell Stones [1]" , PAGE_SPELL_OFFENSE);
         if (nKewpies<3) AddMenuSelectionInt(DisabledText("Tails [3]"), PAGE_MENU_MAIN);
         else            AddMenuSelectionInt("Tails [3]" , PAGE_SELECT_TAIL);
         if (nKewpies<5) AddMenuSelectionInt(DisabledText("Wings [5]"), PAGE_MENU_MAIN);
         else            AddMenuSelectionInt("Wings [5]" , PAGE_SELECT_WINGS);
         if (nKewpies<10) AddMenuSelectionInt(DisabledText("Skins [10]"), PAGE_MENU_MAIN);
         else            AddMenuSelectionInt("Skins [10]" , PAGE_SELECT_SKIN);
         ShowIOU(FALSE);
         return;
      case PAGE_SELECT_GP:
         SetPrompt("Select the number of Kewpies you'd like to trade for XP:");
         for (i=1; i<=5; i++) {
            ShowPrize("GP", i, nKewpies, PAGE_SELECT_GP);
         }
         AddMenuSelectionInt("Back" , PAGE_MENU_MAIN);
         return;
      case PAGE_SELECT_XP:
         SetPrompt("Select the number of Kewpies you'd like to trade for XP:");
         for (i=1; i<=5; i++) {
            ShowPrize("XP", i, nKewpies, PAGE_SELECT_XP);
         }
         AddMenuSelectionInt("Back" , PAGE_MENU_MAIN);
         return;
      case PAGE_SELECT_DAMAGE:
         SetPrompt("Select the type of damage stone you'd like:");
         ShowPrize("SMS_DAM_BLUNT",    1, nKewpies, PAGE_SELECT_DAMAGE);
         ShowPrize("SMS_DAM_POINTY",   1, nKewpies, PAGE_SELECT_DAMAGE);
         ShowPrize("SMS_DAM_SHARP",    1, nKewpies, PAGE_SELECT_DAMAGE);
         ShowPrize("SMS_DAM_SONIC",    1, nKewpies, PAGE_SELECT_DAMAGE);
         ShowPrize("SMS_DAM_NEGATIVE", 2, nKewpies, PAGE_SELECT_DAMAGE);
         ShowPrize("SMS_DAM_POSITIVE", 2, nKewpies, PAGE_SELECT_DAMAGE);
         ShowPrize("SMS_DAM_DIVINE",   2, nKewpies, PAGE_SELECT_DAMAGE);
         ShowPrize("SMS_DAM_MAGIC",    2, nKewpies, PAGE_SELECT_DAMAGE);
         AddMenuSelectionInt("Back" , PAGE_MENU_MAIN);
         return;
      case PAGE_SPELL_DEFENSE:
         SetPrompt("Select the type of Defensive Spell Casting stone you'd like:");
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_DEATH_WARD_7)                 ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_ENERGY_BUFFER_20)             ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15)           ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7)        ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11)  ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_GREATER_SPELL_MANTLE_17)      ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7)      ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_MIND_BLANK_15)                ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15),50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_PREMONITION_15)               ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20)    ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_SHADOW_SHIELD_13)             ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_SPELL_RESISTANCE_15)          ,50, nKewpies, PAGE_SPELL_DEFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_TRUE_SEEING_9)                ,50, nKewpies, PAGE_SPELL_DEFENSE);
         AddMenuSelectionInt("Back" , PAGE_MENU_MAIN);
         return;
      case PAGE_SPELL_OFFENSE:
         SetPrompt("Select the type of Offensive Spell Casting stone you'd like:");
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7)          ,50, nKewpies, PAGE_SPELL_OFFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_GREATER_DISPELLING_15)        ,50, nKewpies, PAGE_SPELL_OFFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_GREATER_SPELL_BREACH_11)      ,50, nKewpies, PAGE_SPELL_OFFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_PRAYER_5)                     ,50, nKewpies, PAGE_SPELL_OFFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_SHAPECHANGE_17)               ,50, nKewpies, PAGE_SPELL_OFFENSE);
         ShowPrize("SMS_CAST_" + IntToString(IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11)    ,50, nKewpies, PAGE_SPELL_OFFENSE);
         AddMenuSelectionInt("Back" , PAGE_MENU_MAIN);
         return;
      case PAGE_SELECT_WINGS:
         SetPrompt("Select the type of Wings you'd like:");
         ShowPrize("Angel",     5, nKewpies, PAGE_SELECT_WINGS);
         ShowPrize("Bat",       5, nKewpies, PAGE_SELECT_WINGS);
         ShowPrize("Bird",      5, nKewpies, PAGE_SELECT_WINGS);
         ShowPrize("Butterfly", 5, nKewpies, PAGE_SELECT_WINGS);
         ShowPrize("Demon",     5, nKewpies, PAGE_SELECT_WINGS);
         ShowPrize("Dragon",    5, nKewpies, PAGE_SELECT_WINGS);
         ShowPrize("None",      1, nKewpies, PAGE_SELECT_WINGS);
         AddMenuSelectionInt("Back" , PAGE_MENU_MAIN);
         return;
      case PAGE_SELECT_TAIL:
         SetPrompt("Select the type of Tail you'd like:");
         ShowPrize("Bone",       3, nKewpies, PAGE_SELECT_TAIL);
         ShowPrize("Devil",      3, nKewpies, PAGE_SELECT_TAIL);
         ShowPrize("Lizard",     3, nKewpies, PAGE_SELECT_TAIL);
         ShowPrize("None",       1, nKewpies, PAGE_SELECT_TAIL);
         AddMenuSelectionInt("Back" , PAGE_MENU_MAIN);
         return;
      case PAGE_SELECT_SKIN:
         SetPrompt("Select the type of Skin you'd like:");
         ShowSkins(nKewpies);
         AddMenuSelectionInt("Back" , PAGE_MENU_MAIN);
         return;
      case PAGE_SHOW_IOU:
         SetPrompt("You have the following IOU's awaiting collection:");
         ShowIOU(TRUE);
         return;
      case PAGE_SHOW_MESSAGE:
         DoShowMessage();
         break;
      case PAGE_CONFIRM_ACTION:
         DoConfirmAction();
         break;
    }
}

void CleanUp() {
    DeleteList(KEWPIE_LIST, oPC);
    DeleteList(KEWPIE_LIST+"_SUB", oPC);
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
         SetDlgResponseList(KEWPIE_LIST, oPC);
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


#include "zdlg_include_i"
#include "db_inc"
#include "time_inc"

const string BAN_LIST = "BAN_LIST";
const string TARGET = "BAN_TARGET";
const string CURRENT_PAGE = "BAN_PAGE";

const string BAN_TYPE = "BAN_TYPE";
const string BAN_LENGTH = "BAN_LENGTH";

// DEFINE MAIN DIALOG PAGES
const int PAGE_MAIN_MENU       =   0;
const int PAGE_BAN_TEMP        =   1; // TEMP BANS
const int PAGE_BAN_PERM        =   2; // PERM BANS
const int PAGE_DO_BAN          =   3; // PROCESS THE BAN

// TEMP MENU OPTIONS
const int OPTION_BAN_TEMP_1    = 101; // TEMP BAN ADD 1 HOURS (VALUE - 100 = LENGTH)
const int OPTION_BAN_TEMP_2    = 102; // TEMP BAN ADD 2 HOURS
const int OPTION_BAN_TEMP_4    = 104; // TEMP BAN ADD 4 HOURS
const int OPTION_BAN_TEMP_8    = 108; // TEMP BAN ADD 8 HOURS
const int OPTION_BAN_TEMP_24   = 124; // TEMP BAN ADD 1 DAY
const int OPTION_BAN_TEMP_72   = 172; // TEMP BAN ADD 3 DAYS
const int OPTION_BAN_TEMP_168  = 268; // TEMP BAN ADD 1 WEEK

// PERM MENU OPTIONS
const int OPTION_BAN_PERM_TRUEID =  24; // PERM BAN CDKEY
const int OPTION_BAN_PERM_CKID   =  20; // PERM BAN CDKEY
const int OPTION_BAN_PERM_ACID   =  21; // PERM BAN ACCOUNT
const int OPTION_BAN_PERM_PLID   =  22; // PERM BAN PLAYER
const int OPTION_BAN_PERM_CAID   =  23; // PERM BAN CDKEY/ACCOUNT COMBO

// DO BAN OPTIONS
const int OPTION_BAN_THEM      =  30; // FINALIZE THE BANNING

// HandleSelection() will do this following based on iOptionValue:
//   set to a PAGE_ const to change pages
//   set to an OPTION_ const to process a selection on a page
void SetMenuOptionInt(string sOptionText, int iOptionValue, object oPC = OBJECT_SELF, string sList = BAN_LIST) {
   ReplaceIntElement(AddStringElement(sOptionText, BAN_LIST, oPC)-1, iOptionValue  , sList, oPC);
}
void SetMenuOptionString(string sOptionText, string sOptionValue, object oPC = OBJECT_SELF, string sList = BAN_LIST) {
   ReplaceStringElement(AddStringElement(sOptionText, BAN_LIST, oPC)-1, sOptionValue  , sList, oPC);
}
void SetMenuOptionObject(string sOptionText, object oOptionValue, object oPC = OBJECT_SELF, string sList = BAN_LIST) {
   ReplaceObjectElement(AddStringElement(sOptionText, BAN_LIST, oPC)-1, oOptionValue  , sList, oPC);
}

int GetNextPage() {
   return GetLocalInt(GetPcDlgSpeaker(), CURRENT_PAGE);
}

void SetNextPage(int nPage) {
   SetLocalInt(GetPcDlgSpeaker(), CURRENT_PAGE, nPage);
}

int GetPageOptionSelected(string sLIST = BAN_LIST) {
   return GetIntElement(GetDlgSelection(), sLIST, GetPcDlgSpeaker());
}

void HandleSelection() {
   object oPC = GetPcDlgSpeaker();
   object oTarget = GetLocalObject(oPC, TARGET);
   int nHours = GetLocalInt(oPC, BAN_LENGTH);
   int iOptionSelected = GetPageOptionSelected(); // RETURN THE KEY VALUE ASSOCIATED WITH THE SELECTION
   switch (iOptionSelected) {
      // HANDLE PAGE JUMPS FIRST
      case PAGE_MAIN_MENU:
      case PAGE_BAN_TEMP:
      case PAGE_BAN_PERM:
      case PAGE_DO_BAN:
         SetNextPage(iOptionSelected);
         break;
      // HANDLE EACH PAGES OPTIONS NEXT
      // TEMP BAN
      case OPTION_BAN_TEMP_1  :
      case OPTION_BAN_TEMP_2  :
      case OPTION_BAN_TEMP_4  :
      case OPTION_BAN_TEMP_8  :
      case OPTION_BAN_TEMP_24 :
      case OPTION_BAN_TEMP_72 :
      case OPTION_BAN_TEMP_168:
         nHours = nHours + iOptionSelected - 100; //(VALUE - 100 = LENGTH)
         SetLocalInt(oPC, BAN_LENGTH, nHours);
         break;
      // PERM BANS
      case OPTION_BAN_PERM_TRUEID:
      //case OPTION_BAN_PERM_ACID:
      //case OPTION_BAN_PERM_PLID:
      //case OPTION_BAN_PERM_CAID:
         SetNextPage(PAGE_DO_BAN);
         SetLocalInt(oPC, BAN_TYPE, iOptionSelected);
         break;
      case OPTION_BAN_THEM:
         dbApplyBan(oTarget, GetLocalInt(oPC, BAN_TYPE), GetLocalInt(oPC, BAN_LENGTH));
         EndDlg();
         break;

   }
}

void BuildPage(int nPage) {
   object oPC = GetPcDlgSpeaker();
   object oTarget = GetLocalObject(oPC, TARGET);
   int nHours = GetLocalInt(oPC, BAN_LENGTH);
   int nBanType = GetLocalInt(oPC, BAN_TYPE);
   DeleteList(BAN_LIST, oPC); // START FRESH PAGE
   switch (nPage) {
      case PAGE_MAIN_MENU:
         SetLocalInt(oPC, BAN_LENGTH, 0);
         SetLocalInt(oPC, BAN_TYPE  , 0);
         SetDlgPrompt("You have decided to ban " + GetName(oTarget) + ". Select the type of ban you would like to apply.");
         SetMenuOptionInt("Temporary Ban", PAGE_BAN_TEMP, oPC);
         SetMenuOptionInt("Permanent Ban", PAGE_BAN_PERM, oPC);
         break;
      case PAGE_BAN_TEMP:
         SetLocalInt(oPC, BAN_TYPE, BAN_TYPE_TEMP);
         SetDlgPrompt("The current ban length for " + GetName(oTarget) + " is " + HoursInDays(nHours) + ".\n\n How much time would you like to add?");
         SetMenuOptionInt("Add 1 Hour"   , OPTION_BAN_TEMP_1  , oPC);
         SetMenuOptionInt("Add 2 Hour"   , OPTION_BAN_TEMP_2  , oPC);
         SetMenuOptionInt("Add 4 Hour"   , OPTION_BAN_TEMP_4  , oPC);
         SetMenuOptionInt("Add 8 Hour"   , OPTION_BAN_TEMP_8  , oPC);
         SetMenuOptionInt("Add 1 Day"    , OPTION_BAN_TEMP_24 , oPC);
         SetMenuOptionInt("Add 3 Days"   , OPTION_BAN_TEMP_72 , oPC);
         SetMenuOptionInt("Add 7 Days"   , OPTION_BAN_TEMP_168, oPC);
         if (nHours) SetMenuOptionInt("Current Amount is good", PAGE_DO_BAN , oPC);
         SetMenuOptionInt("Back"         , PAGE_MAIN_MENU     , oPC);
         break;
      case PAGE_BAN_PERM:
         SetDlgPrompt("How harsh should this ban be?");
         SetMenuOptionInt("This TRUEID: " + dbPCtoString(oTarget) , OPTION_BAN_PERM_TRUEID, oPC);
         //SetMenuOptionInt("This CDKey: " + GetPCPublicCDKey(oTarget) , OPTION_BAN_PERM_CKID, oPC);
         //SetMenuOptionInt("This Account: " + GetPCPlayerName(oTarget), OPTION_BAN_PERM_ACID, oPC);
         //SetMenuOptionInt("This Character: " + GetName(oTarget)      , OPTION_BAN_PERM_PLID, oPC);
         //SetMenuOptionInt("This CDkey/Acct combination only"         , OPTION_BAN_PERM_CAID, oPC);
         SetMenuOptionInt("Back"                                     , PAGE_MAIN_MENU      , oPC);
         break;
      case PAGE_DO_BAN:
         string sMsg = "";
         switch (nBanType) {
            case BAN_TYPE_TEMP:
               SetLocalInt(oPC, BAN_TYPE, BAN_TYPE_TEMP);
               sMsg = "Temporarily Ban this TRUEID for " + HoursInDays(nHours) + "?\n\n---> " + dbGetTRUEIDName(oPC);
               break;
            case OPTION_BAN_PERM_TRUEID:
               SetLocalInt(oPC, BAN_TYPE, BAN_TYPE_PERM);
               sMsg = "Permanently Ban this TRUEID for " + HoursInDays(nHours) + "?\n\n---> " + dbGetTRUEIDName(oPC);
               break;
            case OPTION_BAN_PERM_CKID:
               SetLocalInt(oPC, BAN_TYPE, BAN_TYPE_PERM);
               sMsg = "Permanently Ban this CDKey?\n\n--->" + GetPCPublicCDKey(oPC);
               break;
            case OPTION_BAN_PERM_ACID:
               SetLocalInt(oPC, BAN_TYPE, BAN_TYPE_PERM);
               sMsg = "Permanently Ban this Account?\n\n--->" + GetPCPlayerName(oPC);
               break;
            case OPTION_BAN_PERM_CAID:
               SetLocalInt(oPC, BAN_TYPE, BAN_TYPE_PERM);
               sMsg = "Permanently Ban this CDKey/Account combination?\n\n--->" + GetPCPublicCDKey(oPC) + " / " + GetPCPlayerName(oPC) + "\n\n*Note: This only blocks this account from being access from this CDKey. This is useful for locking down faction access on shared computers.";
               break;
            case OPTION_BAN_PERM_PLID:
               SetLocalInt(oPC, BAN_TYPE, BAN_TYPE_PERM);
               sMsg = "Permanently Ban this Character?\n\n--->" + GetName(oPC);
               break;
         }
         SetDlgPrompt(sMsg);
         SetMenuOptionInt("Pull the trigger, they are so banned!"   , OPTION_BAN_THEM, oPC);
   }
}

void Init() {
   SetNextPage(PAGE_MAIN_MENU);
}

void CleanUp() {
    object oPC = GetPcDlgSpeaker();
    DeleteList(BAN_LIST, oPC);
    DeleteLocalInt(oPC, CURRENT_PAGE);
}

void main () {
   object oPC = GetPcDlgSpeaker();
   int iEvent = GetDlgEventType();
   switch(iEvent) {
      case DLG_INIT:
         Init();
         break;
      case DLG_PAGE_INIT:
         BuildPage(GetNextPage());
         SetShowEndSelection(TRUE);
         SetDlgResponseList(BAN_LIST, oPC);
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



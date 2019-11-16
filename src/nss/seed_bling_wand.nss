#include "zdlg_include_i"
#include "db_inc"

const string PRIZE_LIST         = "PRIZE_LIST";
const string TARGET             = "PRIZE_TARGET";
const string CURRENT_PAGE       = "PRIZE_PAGE";
const string PRIZE_COUNT        = "PRIZE_COUNT";
const string PRIZE_TYPE         = "PRIZE_TYPE";

// DEFINE MAIN DIALOG PAGES
const int PAGE_MAIN_MENU        = 0;
const int PAGE_DO_PRIZE         = 13; // PROCESS

// DO BAN OPTIONS
const int OPTION_PRIZE_THEM     = 30;  // FINALIZE

// HandleSelection() will do this following based on iOptionValue:
//   set to a PAGE_ const to change pages
//   set to an OPTION_ const to process a selection on a page
void SetMenuOptionInt(string sOptionText, int iOptionValue, object oPC = OBJECT_SELF, string sList = PRIZE_LIST) {
   ReplaceIntElement(AddStringElement(sOptionText, PRIZE_LIST, oPC)-1, iOptionValue  , sList, oPC);
}
void SetMenuOptionString(string sOptionText, string sOptionValue, object oPC = OBJECT_SELF, string sList = PRIZE_LIST) {
   ReplaceStringElement(AddStringElement(sOptionText, PRIZE_LIST, oPC)-1, sOptionValue  , sList, oPC);
}
void SetMenuOptionObject(string sOptionText, object oOptionValue, object oPC = OBJECT_SELF, string sList = PRIZE_LIST) {
   ReplaceObjectElement(AddStringElement(sOptionText, PRIZE_LIST, oPC)-1, oOptionValue  , sList, oPC);
}

int GetNextPage() {
   return GetLocalInt(GetPcDlgSpeaker(), CURRENT_PAGE);
}

void SetNextPage(int nPage) {
   SetLocalInt(GetPcDlgSpeaker(), CURRENT_PAGE, nPage);
}

int GetPageOptionSelected(string sLIST = PRIZE_LIST) {
   return GetIntElement(GetDlgSelection(), sLIST, GetPcDlgSpeaker());
}

void HandleSelection() {
   object oPC = GetPcDlgSpeaker();
   object oTarget = GetLocalObject(oPC, TARGET);
   int nAwardCount = GetLocalInt(oPC, PRIZE_COUNT);
   int i;
   string sToken;
   int iOptionSelected = GetPageOptionSelected(); // RETURN THE KEY VALUE ASSOCIATED WITH THE SELECTION
   switch (iOptionSelected) {
      // HANDLE PAGE JUMPS FIRST
      case PAGE_MAIN_MENU:
      case PAGE_DO_PRIZE:
         SetNextPage(iOptionSelected);
         break;
      // HANDLE EACH PAGES OPTIONS NEXT
      case 1  :
      case 420:
         if (iOptionSelected==420) nAwardCount = 1;
         else nAwardCount += iOptionSelected;
         if (nAwardCount>2) nAwardCount = 2;
         SetLocalInt(oPC, PRIZE_COUNT, nAwardCount);
         break;
      case OPTION_PRIZE_THEM:
         for (i=1;i<=nAwardCount; i++) {
            sToken = dbGetNextToken(oPC, oTarget, "Awarded by " + GetName(oPC) + " to " + GetName(oTarget));
            object oBling = CreateItemOnObject("bling", oTarget, 1, "BLING_"+sToken);
            SetName(oBling, "Bling Medallion #"+sToken);
            SetIdentified(oBling, TRUE);
            SetDroppableFlag(oBling, TRUE);
         }
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ICESKIN), oTarget, TurnsToSeconds(10));
         DeleteLocalInt(oTarget, "DmEventNoPort");
         DelayCommand(1.0, AssignCommand(oTarget, JumpToLocation(GetStartingLocation())));
         EndDlg();
         break;

   }
}

void BuildPage(int nPage) {
   object oPC = GetPcDlgSpeaker();
   object oTarget = GetLocalObject(oPC, TARGET);
   int nAwardCount = GetLocalInt(oPC, PRIZE_COUNT);
   DeleteList(PRIZE_LIST, oPC); // START FRESH PAGE
   switch (nPage) {
      case PAGE_MAIN_MENU:
         SetDlgPrompt("Awarding " + GetName(oTarget) + "\n\n" + IntToString(nAwardCount) + " DEX Bling Medallions.\n\n Would you like to add more?");
         SetMenuOptionInt(IntToString(nAwardCount) + " is enough. Award the prize.", PAGE_DO_PRIZE, oPC);
         SetMenuOptionInt("Add 1", 1, oPC);
         if (nAwardCount>1) SetMenuOptionInt("Reset to 1", 420, oPC);
         break;
      case PAGE_DO_PRIZE:
         string sMsg = "";
            sMsg = "Award " + GetName(oPC) + "\n\n   " + IntToString(nAwardCount) + AddStoString(" Bling Medallion", nAwardCount) + "?";
         SetDlgPrompt(sMsg);
         SetMenuOptionInt("Yes, hook them up"   , OPTION_PRIZE_THEM, oPC);
         SetMenuOptionInt("Go Back"   , PAGE_MAIN_MENU, oPC);
   }
}

void CleanUp() {
    object oPC = GetPcDlgSpeaker();
    DeleteList(PRIZE_LIST, oPC);
    DeleteLocalInt(oPC, CURRENT_PAGE);
}

void main () {
   return;
   object oPC = GetPcDlgSpeaker();
   int iEvent = GetDlgEventType();
   switch(iEvent) {
      case DLG_INIT:
         SetLocalInt(oPC, PRIZE_COUNT, 1);
         SetNextPage(PAGE_MAIN_MENU);
         break;
      case DLG_PAGE_INIT:
         BuildPage(GetNextPage());
         SetShowEndSelection(TRUE);
         SetDlgResponseList(PRIZE_LIST, oPC);
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




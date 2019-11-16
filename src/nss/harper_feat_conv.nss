#include "zdlg_include_i"
#include "_functions"

//////////////////////////////////////////////////////
//
//
//
//////////////////////////////////////////////////////

const int HS_MAIN_MENU        = 10;
const int HS_CONFIRM          = 11;
const int HS_CRAFT_SIGHT      = 12;
const int HS_CRAFT_CUNNING    = 13;
const int HS_CRAFT_RALLYHARP  = 14;
const int HS_CRAFT_WINDHORN   = 15;

const int HS_SHOW_MESSAGE     = 100;
const int HS_END_CONVO        = 101;
const int HS_EXPLAIN          = 102;

void SetMenuOptionInt(string sOptionText, int iOptionValue, object oPC, string sList = "HS_LIST");
void SetMenuOptionString(string sOptionText, string sOptionValue, object oPC, string sList = "HS_LIST");
void SetMenuOptionObject(string sOptionText, object oOptionValue, object oPC, string sList = "HS_LIST");
string JapSendMessage(object oPC, object oMember, string sPCName, string sPCLogin, string sListPlayer, string sFAIDMember, int nLvlMember, int nLvlPC, int nSendMessage = FALSE);
void DoConfirmAction(object oPC);
void SetConfirmAction(object oPC, string sPrompt, int nActionConfirm, string sConfirm="Yes", string sCancel="No", int nActionCancel=HS_END_CONVO);

void SetShowMessage(object oPC, string sPrompt, int nOkAction = HS_END_CONVO);
void DoShowMessage(object oPC);

void SetMenuOptionInt(string sOptionText, int iOptionValue, object oPC, string sList = "HS_LIST") {
    ReplaceIntElement(AddStringElement(GetRGB(15,12,7) + sOptionText, "HS_LIST", oPC)-1, iOptionValue  , sList, oPC);
}
void SetMenuOptionString(string sOptionText, string sOptionValue, object oPC, string sList = "HS_LIST") {
    ReplaceStringElement(AddStringElement(GetRGB(15,12,7) + sOptionText, "HS_LIST", oPC)-1, sOptionValue  , sList, oPC);
}
void SetMenuOptionObject(string sOptionText, object oOptionValue, object oPC, string sList = "HS_LIST"){
    ReplaceObjectElement(AddStringElement(GetRGB(15,12,7) + sOptionText, "HS_LIST", oPC)-1, oOptionValue  , sList, oPC);
}

int GetNextPage(){
    return GetLocalInt(GetPcDlgSpeaker(), "HS_CURRENT_PAGE");
}

void SetNextPage(int nPage){
    SetLocalInt(GetPcDlgSpeaker(), "HS_CURRENT_PAGE", nPage);
}

void SetConfirmAction(object oPC, string sPrompt, int nActionConfirm, string sConfirm="Yes", string sCancel="No", int nActionCancel=HS_END_CONVO) {
    SetLocalString(oPC, "HS_CONFIRM", sPrompt);
    SetLocalInt(oPC, "HS_CONFIRM" + "_Y", nActionConfirm);
    SetLocalInt(oPC, "HS_CONFIRM" + "_N", nActionCancel);
    SetLocalString(oPC, "HS_CONFIRM" + "_Y", sConfirm);
    SetLocalString(oPC, "HS_CONFIRM" + "_N", sCancel);
    SetNextPage(HS_CONFIRM);
}

void DoConfirmAction(object oPC) {
    SetDlgPrompt(GetLocalString(oPC, "HS_CONFIRM"));
    SetMenuOptionInt(GetLocalString(oPC, "HS_CONFIRM" + "_Y"), GetLocalInt(oPC, "HS_CONFIRM" + "_Y"), oPC);
    SetMenuOptionInt(GetLocalString(oPC, "HS_CONFIRM" + "_N"), GetLocalInt(oPC, "HS_CONFIRM" + "_N"), oPC);
}

void SetShowMessage(object oPC, string sPrompt, int nOkAction = HS_END_CONVO) {
   SetLocalString(oPC, "HS_CONFIRM", sPrompt);
   SetLocalInt(oPC, "HS_CONFIRM", nOkAction);
   SetNextPage(HS_SHOW_MESSAGE);
}

void DoShowMessage(object oPC) {
   SetDlgPrompt(GetLocalString(oPC, "HS_CONFIRM"));
   int nOkAction = GetLocalInt(oPC, "HS_CONFIRM");
   DeleteLocalInt(oPC, "HS_CONFIRM");
   if (nOkAction != HS_END_CONVO) SetMenuOptionInt(GetRGB(15,5,1) + "[Ok]", nOkAction, oPC);
}

int GetPageOptionSelected(string sLIST = "HS_LIST"){
    return GetIntElement(GetDlgSelection(), sLIST, GetPcDlgSpeaker());
}

string DisabledText(string sText) {
   return GetRGB(6,6,6) + sText;
}

void HandleSelection(object oPC){
    string sPCName = GetName(oPC);
    int iOptionSelected = GetPageOptionSelected();
    int nCount;
    int nIng1, nIng2, nIng3, nIng4, nIng5;
    object oItem, oCrafted;
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    switch (iOptionSelected) {
    case HS_MAIN_MENU:
    case HS_EXPLAIN:
        SetNextPage(iOptionSelected);
        return;
    case HS_CRAFT_SIGHT:
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
            if (GetTag(oItem) == "it_harperbottle")
            {
                 nCount = GetItemStackSize(oItem);
                 Insured_Destroy(oItem);
                 CreateItemOnObject("it_harpersight", oPC, nCount);
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 break;
            }
            oItem = GetNextItemInInventory(oPC);
        }
        EndDlg();
        return;
    case HS_CRAFT_CUNNING:
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
            if (GetTag(oItem) == "it_harperbottle")
            {
                 nCount = GetItemStackSize(oItem);
                 Insured_Destroy(oItem);
                 CreateItemOnObject("it_harpercunning", oPC, nCount);
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 break;
            }
            oItem = GetNextItemInInventory(oPC);
        }
        EndDlg();
        return;
    case HS_CRAFT_RALLYHARP:
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
            if (GetTag(oItem) == "it_harperbase" && !nIng1)
            {
                 Insured_Destroy(oItem);
                 nIng1 = TRUE;
            }
            else if (GetTag(oItem) == "it_rawharp" && !nIng2)
            {
                 Insured_Destroy(oItem);
                 nIng2 = TRUE;
            }
            if (nIng1 && nIng2)
            {
                oCrafted = CreateItemOnObject("item_rallysong", oPC);
                SetItemCharges(oCrafted, 16 + d4());
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                break;
            }
            else oItem = GetNextItemInInventory(oPC);
        }
        EndDlg();
        return;
    case HS_CRAFT_WINDHORN:
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
            if (GetTag(oItem) == "it_harperbase" && !nIng1)
            {
                 Insured_Destroy(oItem);
                 nIng1 = TRUE;
            }
            else if (GetTag(oItem) == "it_rawhorn" && !nIng2)
            {
                 Insured_Destroy(oItem);
                 nIng2 = TRUE;
            }
            if (nIng1 && nIng2)
            {
                oCrafted = CreateItemOnObject("item_windsong", oPC);
                SetItemCharges(oCrafted, 16 + d4());
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                break;
            }
            else oItem = GetNextItemInInventory(oPC);
        }
        EndDlg();
        return;
    case HS_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC){
    DeleteList("HS_LIST", oPC); // START FRESH PAGE
    string sPCName = GetName(oPC);
    object oItem;
    string sItemTag;
    int nEmptyBottle, nBaseKit, nRawHarp, nRawHorn;
    switch (nPage){
    case HS_MAIN_MENU:
        SetDlgPrompt("A Harper can create a couple useful items, but he need different ingredients. Some can be purchased in the Ridgetown Tavern.");
        DeleteLocalInt(oPC, "HS_CONFIRM");
        //SetMenuOptionInt("How does this all work?", HS_EXPLAIN, oPC);
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
            sItemTag = GetTag(oItem);
            if (sItemTag == "it_harperbottle")
            {
                nEmptyBottle += GetItemStackSize(oItem);
            }
            else if (sItemTag == "it_harperbase")
            {
                nBaseKit += 1;
            }
            else if (sItemTag == "it_rawharp")
            {
                nRawHarp += 1;
            }
            else if (sItemTag == "it_rawhorn")
            {
                nRawHorn += 1;
            }
            // Stop Clycling if everything found else continue next item
            if (nEmptyBottle && nBaseKit && nRawHarp && nRawHorn) break;
            else oItem = GetNextItemInInventory(oPC);
        }
        if (nEmptyBottle)
        {
            SetMenuOptionInt("Craft " + IntToString(nEmptyBottle) + "x Harper Scout's Sight (Potion)", HS_CRAFT_SIGHT, oPC);
            SetMenuOptionInt("Craft " + IntToString(nEmptyBottle) + "x Harper Scout's Cunning (Potion)", HS_CRAFT_CUNNING, oPC);
        }
        if (nRawHarp && nBaseKit)
        {
            SetMenuOptionInt("Craft Harper Scout's Rally Song (Harp)", HS_CRAFT_RALLYHARP, oPC);
        }
        if (nRawHorn && nBaseKit)
        {
            SetMenuOptionInt("Craft Harper Scout's Horn of the Winds (Horn)", HS_CRAFT_WINDHORN, oPC);
        }
        return;
   case HS_EXPLAIN:
        SetDlgPrompt("");
        SetMenuOptionInt("Main Page", HS_MAIN_MENU, oPC);
        return;
   case HS_CONFIRM:
        DoConfirmAction(oPC);
        return;
   case HS_SHOW_MESSAGE:
        DoShowMessage(oPC);
        return;
   }
}

void CleanUp(object oPC){
    DeleteList("HS_LIST", oPC);
    DeleteLocalInt(oPC, "HS_CURRENT_PAGE");
    DeleteLocalInt(oPC, "HS_CONFIRM" + "_Y");
    DeleteLocalInt(oPC, "HS_CONFIRM" + "_N");
    DeleteLocalInt(oPC, "HS_CONFIRM");
    DeleteLocalString(oPC, "HS_CONFIRM");
    DeleteLocalString(oPC, "HS_CONFIRM" + "_Y");
    DeleteLocalString(oPC, "HS_CONFIRM" + "_N");
}

void main (){
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    switch(iEvent) {
    case DLG_INIT:
        SetNextPage(HS_MAIN_MENU);
        break;
    case DLG_PAGE_INIT:
        BuildPage(GetNextPage(), oPC);
        SetShowEndSelection(TRUE);
        SetDlgResponseList("HS_LIST", oPC);
        break;
    case DLG_SELECTION:
        HandleSelection(oPC);
        break;
    case DLG_ABORT:
    case DLG_END:
        CleanUp(oPC);
        break;
    }
}

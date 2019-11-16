#include "zdlg_include_i"
#include "zdialog_inc"
#include "_functions"

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////

void BuildPage(int nPage, object oPC);
void HandleSelection(object oPC);

void LoadSlot(object oLever)
{
    SetLocalObject(GetNearestObjectByTag("SLOT_CASH_IN", oLever), "SLOT_LEVER", oLever);
    SetLocalObject(GetNearestObjectByTag("SLOT_CASH_OUT", oLever), "SLOT_LEVER", oLever);
    SetLocalObject(oLever, "SLOT_PENTAGRAMM", GetNearestObjectByTag("SLOT_PENTAGRAMM", oLever));

    int nRound = 1;
    int nField = 1;
    object oField;
    string sString;
    while (nRound <= 4)
    {
        while (nField <= 4)
        {
            sString = "WP_SLOT_" + IntToString(nRound) + IntToString(nField);
            oField = GetNearestObjectByTag(sString, oLever);
            SetLocalObject(oLever, sString, oField);
            nField++;
        }
        nRound++;
        nField = 1;
    }
    SetLocalObject(oLever, "SLOT_BALL_1", GetNearestObjectByTag("SLOT_BALL_1", oLever));
    SetLocalObject(oLever, "SLOT_BALL_2", GetNearestObjectByTag("SLOT_BALL_2", oLever));
}

int CountGemValue(object oTarget)
{
    int nValue;
    object oItem = GetFirstItemInInventory(oTarget);
    while (GetIsObjectValid(oItem))
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_GEM)
        {
            nValue += GetGoldPieceValue(oItem);
        }
        oItem = GetNextItemInInventory(oTarget);
    }
    return nValue;
}


void HandleSelection(object oPC)
{
    object oHolder = OBJECT_SELF;
    object oObject;
    string sLastPorted;
    object oPCInside;
    int nCredit;
    int nOptionSelected = GetPageOptionSelected(oHolder);
    switch (nOptionSelected){
    case ZDIALOG_MAIN_MENU:
    case 1:
        if (CountGemValue(oPC) < 50000)
        {
            SetShowMessage(oHolder, "You do not carry enough gems with you.");
            return;
        }
        oObject = GetLocalObject(oHolder, "SLOT_LEVER");
        if (!GetIsObjectValid(oObject)) // load game if first time entered
        {
            oObject = GetObjectByTag("SLOT_LEVER");
            AssignCommand(GetArea(oHolder), DelayCommand(1.0, LoadSlot(oObject)));
            SetLocalObject(oHolder, "SLOT_LEVER", oObject);
        }
        sLastPorted = GetLocalString(oHolder, "LAST_PORTED_TO_SLOT"); // check if a playername is stored on speaker

        if (sLastPorted != "")
        {
            SetShowMessage(oHolder, "Sorry, " + sLastPorted + " is still in there.");
            return;
        }
        else
        {
            // search for a pc inside
            oPCInside = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oObject);
            if (GetArea(oPCInside) == GetArea(oObject))
            {
                nCredit = GetLocalInt(oObject, "SLOT_CREDIT"); // get credit stored on the lever
                if (nCredit != GetLocalInt(oHolder, "SLOT_CREDIT")) // check if credit changed (pc is playing)
                {
                    SetLocalInt(oHolder, "SLOT_CREDIT", nCredit); // store new value
                    //SetShowMessage(oHolder, "Sorry, " + GetName(oPCInside) + " is still in there.");
                    SetLocalString(oHolder, "LAST_PORTED_TO_SLOT", GetName(oPCInside));
                    DelayCommand(10.0, DeleteLocalString(oHolder, "LAST_PORTED_TO_SLOT"));
                    //return;
                }
                else // credit not changed, player is maybe afk
                {
                    if (GetLocalInt(oHolder, "KICK_PLAYER_ENABLED")) // kick enabled
                    {
                        DeleteLocalInt(oObject, "SLOT_CREDIT"); // reset credits
                        GiveGoldToCreature(oPCInside, nCredit); // give him gold
                        DelayCommand(1.0, AssignCommand(oPCInside, JumpToObject(GetWaypointByTag("WP_SNIRBLES_TOWER_MAIN")))); // get rid of him
                    }
                    else // kick player - not enabled yet
                    {
                        SetLocalString(oHolder, "LAST_PORTED_TO_SLOT", GetName(oPCInside));
                        DelayCommand(10.0, DeleteLocalString(oHolder, "LAST_PORTED_TO_SLOT"));
                        SetShowMessage(oHolder, "Sorry, " + GetName(oPCInside) + " is still in there.");
                        return;
                    }
                }
            }
        }
        oObject = DefGetObjectByTag("WP_SLOT_ENTRANCE_1", oHolder);
        FadeToBlack(oPC);
        DelayCommand(1.0, AssignCommand(oPC, JumpToObject(oObject)));
        SetLocalString(oHolder, "LAST_PORTED_TO_SLOT", GetName(oPC));

        // disable kick player, give him some time to start the game
        DeleteLocalInt(oHolder, "KICK_PLAYER_ENABLED");
        // enable kicking player after 3 minutes
        DelayCommand(180.0, SetLocalInt(oHolder, "KICK_PLAYER_ENABLED", TRUE));
        DelayCommand(10.0, DeleteLocalString(oHolder, "LAST_PORTED_TO_SLOT"));
        EndDlg();
        return;
    case ZDIALOG_END_CONVO:
        EndDlg();
        return;
    }
}

void BuildPage(int nPage, object oPC)
{
    object oHolder = OBJECT_SELF;
    string sList   = GetCurrentList(oHolder);
    DeleteList(sList, oHolder); // START FRESH PAGE
    switch (nPage){
    case ZDIALOG_MAIN_MENU:
        SetDlgPrompt("Port to the flags game?");
        SetMenuOptionInt("Yes", 1, oHolder);
        return;
   case ZDIALOG_SHOW_MESSAGE:
        DoShowMessage(oHolder);
        return;
   case ZDIALOG_CONFIRM:
        DoConfirmAction(oHolder);
        return;
    }
}

void CleanUp(object oHolder)
{
    CleanUpInc(oHolder);
}

void main ()
{
    object oPC = GetPcDlgSpeaker();
    int iEvent = GetDlgEventType();
    object oHolder = OBJECT_SELF;
    switch(iEvent) {
    case DLG_INIT:
        SetNextPage(oHolder, ZDIALOG_MAIN_MENU);
        break;
    case DLG_PAGE_INIT:
        BuildPage(GetNextPage(oHolder), oPC);
        SetShowEndSelection(TRUE);
        SetDlgResponseList(GetCurrentList(oHolder), oHolder);
        break;
    case DLG_SELECTION:
        HandleSelection(oPC);
        break;
    case DLG_ABORT:
    case DLG_END:
        CleanUp(oHolder);
    break;
    }
}

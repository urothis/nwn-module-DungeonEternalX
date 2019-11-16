#include "x2_inc_switches"
#include "zdlg_include_i"
#include "zdialog_inc"

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    object oItem = GetItemActivated();
    if (!GetIsDM(oPC))
    {
        DestroyObject(oItem);
        SendMessageToPC(oPC, "You are not a DM. Your action has been logged.");
        return;
    }

    if (oTarget == oItem || oTarget == oPC)
    {
        SetCurrentList(oItem, "DM_PRIZE_SETUP_LIST");
        OpenNextDlg(oPC, oItem, "it_prize_setup", TRUE, FALSE);
        return;
    }
    else if (!GetIsPC(oTarget))
    {
        SendMessageToPC(oPC, "Target is not a valid player character");
        return;
    }
    SetLocalObject(oPC, "PRIZE_TARGET", oTarget);
    SetCurrentList(oItem, "DM_PRIZE_DO_LIST");
    OpenNextDlg(oPC, oItem, "it_prize_do", TRUE, FALSE);
}

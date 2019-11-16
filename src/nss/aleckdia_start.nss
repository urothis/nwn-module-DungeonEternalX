#include "zdlg_include_i"
#include "zdialog_inc"
#include "quest_inc"

void main()
{
    object oPC = GetLastSpeaker();
    if (GetIsInCombat(oPC)) return;

    if (Q_GetHasQuest(oPC, "17", FALSE))
    {
        SendMessageToPC(oPC, ",,,,,,");
        ActionStartConversation(oPC, "aleck_questdia", TRUE);
    }
    else
    {
        SetCurrentList(OBJECT_SELF, "ez_classchanges");
        OpenNextDlg(oPC, OBJECT_SELF, "ez_classchanges", TRUE, FALSE);
    }
}

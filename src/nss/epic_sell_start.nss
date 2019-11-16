#include "zdlg_include_i"
#include "zdialog_inc"

void main()
{
    object oPC = GetLastSpeaker();

    if (GetIsInCombat(oPC)) return;
    SetCurrentList(OBJECT_SELF, "EPIC_SELL");
    OpenNextDlg(oPC, OBJECT_SELF, "zdialog_epicsell", TRUE, FALSE);
}

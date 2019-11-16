#include "zdlg_include_i"
#include "zdialog_inc"

void main()
{
    object oPC = GetLastSpeaker();
    if (GetIsInCombat(oPC)) return;

    SetCurrentList(OBJECT_SELF, "zdialog_epicitem");
    OpenNextDlg(oPC, OBJECT_SELF, "zdialog_epicitem", TRUE, FALSE);
}

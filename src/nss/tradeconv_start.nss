#include "zdlg_include_i"
#include "zdialog_inc"

void main()
{
    object oPC = GetLastSpeaker();

    if (GetIsInCombat(oPC)) return;
    SetCurrentList(OBJECT_SELF, "TRADESKILLS");
    OpenNextDlg(oPC, OBJECT_SELF, "tradeskills_conv", TRUE, FALSE);
}

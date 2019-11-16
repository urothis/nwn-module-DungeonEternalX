#include "zdlg_include_i"
#include "zdialog_inc"

void main()
{
    object oPC = GetLastSpeaker();
    if (GetIsInCombat(oPC)) return;

    SetCurrentList(OBJECT_SELF, "maximus_auth");
    OpenNextDlg(oPC, OBJECT_SELF, "maximus_auth", TRUE, FALSE);
}

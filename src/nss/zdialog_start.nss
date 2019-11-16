#include "zdlg_include_i"
#include "zdialog_inc"

void main()
{
    object oPC;

    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE) oPC = GetLastSpeaker();
    else oPC = GetLastUsedBy();

    if (GetIsInCombat(oPC)) return;

    string sTag = GetTag(OBJECT_SELF);

    SetCurrentList(OBJECT_SELF, sTag);
    OpenNextDlg(oPC, OBJECT_SELF, GetStringLowerCase(sTag), TRUE, FALSE);
}

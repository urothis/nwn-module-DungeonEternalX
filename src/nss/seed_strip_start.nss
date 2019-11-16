#include "zdlg_include_i"
#include "arres_inc"

void main()
{
    object oPC        = GetItemActivator();
    object oItem      = GetItemActivated();
    object oTarget    = GetItemActivatedTarget();

    if (!CheckDMItem(oPC, oItem)) return;
    if (GetStringLeft(GetTag(oTarget), 8) == "EPICITEM") return;

    SetLocalObject(oPC, "DM_STRIP", oTarget);
    OpenNextDlg(oPC, GetItemActivated(), "seed_itemedit", TRUE, FALSE);
}

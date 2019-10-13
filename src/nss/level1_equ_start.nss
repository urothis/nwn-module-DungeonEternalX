#include "zdlg_include_i"
void main()
{
    object oPC = GetLastSpeaker();
    if (GetHitDice(oPC) == 1)
    {
        OpenNextDlg(GetLastSpeaker(), OBJECT_SELF, "level1_crafter", TRUE, FALSE);
    }
    else
    {
        SendMessageToPC(oPC, "Sorry, Freebies are only available to 1st level characters.");
    }
}

#include "zdlg_include_i"
#include "inc_traininghall"
#include "db_inc"

void main() {
    object oPC = GetLastSpeaker();
    if (GetIsTestChar(oPC))
    {
        JumpToTraininghalls(oPC);
        return;
    }
    if (!dbCheckDatabase())
    {
        SendMessageToPC(oPC, "Sorry, the bank is closed until Mr. SQL feels better. Apparently, he was too sick to come to work today.");
        return;
    }
    OpenNextDlg(oPC,OBJECT_SELF,"seed_bank",TRUE,FALSE);
}

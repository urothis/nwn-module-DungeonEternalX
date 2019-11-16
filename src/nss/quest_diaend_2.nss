#include "quest_inc"

// dialog end/abort in new quest dialog

void main()
{
    object oPC = GetPCSpeaker();
    Q_CleanupDialogVariables(oPC, TRUE);
}

#include "quest_inc"

// dialog end/abort for NPCs with quests

void main()
{
    object oPC = GetPCSpeaker();
    Q_CleanupDialogVariables(oPC);
}

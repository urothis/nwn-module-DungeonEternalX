#include "seed_faction_inc"
#include "_inc_port"

void main()
{
    object oPC = GetPCSpeaker();
    object oWP = DefGetObjectByTag("WP_FACTION_BASE_" + SDB_GetFAID(oPC), GetWPHolder());
    AssignCommand(oPC, DelayCommand(1.0, JumpToObject(oWP)));
}

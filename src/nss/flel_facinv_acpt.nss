#include "seed_faction_inc"

void main()
{
    object oPC = GetPCSpeaker();
    SDB_FactionAdd(oPC, GetLocalObject(oPC, "FACTION_SPEAKER"));
    DeleteLocalObject(oPC, "FACTION_SPEAKER");
}

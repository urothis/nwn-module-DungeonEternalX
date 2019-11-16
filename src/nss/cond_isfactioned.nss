#include "seed_faction_inc"

int StartingConditional()
{
    if (SDB_FactionIsMember(GetPCSpeaker())) return TRUE;
    return FALSE;
}

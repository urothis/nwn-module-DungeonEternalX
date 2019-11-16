#include "tradeskills_inc"

int StartingConditional()
{
    return TS_GetSkillPoints(TS_GetVariableHolder(), IntToString(dbGetTRUEID(GetPCSpeaker())), "ts_free");
}

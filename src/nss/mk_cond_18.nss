#include "mk_inc_generic"

int StartingConditional()
{
    return MK_GenericDialog_GetCondition(18);
//    return (GetLocalInt(OBJECT_SELF, "MK_CONDITION_18")==1);
}

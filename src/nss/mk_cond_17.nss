#include "mk_inc_generic"

int StartingConditional()
{
    return MK_GenericDialog_GetCondition(17);
//    return (GetLocalInt(OBJECT_SELF, "MK_CONDITION_17")==1);
}

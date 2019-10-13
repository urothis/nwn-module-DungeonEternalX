#include "mk_inc_generic"

int StartingConditional()
{
    return MK_GenericDialog_GetCondition(4);
//    return (GetLocalInt(OBJECT_SELF, "MK_CONDITION_4")==1);
}

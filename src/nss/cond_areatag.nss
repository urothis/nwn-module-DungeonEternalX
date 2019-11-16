#include "nw_i0_plot"

int StartingConditional()
{
    string sString = GetLocalString(OBJECT_SELF, "CHECK_AREA");

    if (GetTag(GetArea(OBJECT_SELF)) == sString) return TRUE;

    return FALSE;
}

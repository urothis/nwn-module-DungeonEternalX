#include "nw_i0_plot"

int StartingConditional()
{
    string sString = GetTag(OBJECT_SELF);

    if (sString == "STONEHEAD") sString = "BAR_OF_SILVER";
    else if (sString == "quest_zelda") sString = "YEENOGHU_IDOL";

    if (HasItem(GetPCSpeaker(), sString)) return TRUE;

    return FALSE;
}

#include "give_custom_exp"
#include "x2_inc_toollib"
void main()
{
    int nCount = GetLocalInt(GetArea(OBJECT_SELF), "TOTALCOUNT");
    SetLocalInt(GetArea(OBJECT_SELF), "TOTALCOUNT", --nCount);
    DEXRewardXP(GetLastKiller(), OBJECT_SELF);
    CreateObject(OBJECT_TYPE_ITEM, "kay_it_arlb_ep01", GetLocation(OBJECT_SELF), FALSE);
    CreateObject(OBJECT_TYPE_ITEM, "nightshade001", GetLocation(OBJECT_SELF), FALSE);
}


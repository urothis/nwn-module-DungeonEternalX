#include "give_custom_exp"
#include "x2_inc_toollib"
void main()
{
    object oArea = GetArea(OBJECT_SELF);
    TLResetAreaGroundTiles(oArea,9,13);
    int nCount = GetLocalInt(GetArea(OBJECT_SELF), "TOTALCOUNT");
    SetLocalInt(GetArea(OBJECT_SELF), "TOTALCOUNT", --nCount);
    DEXRewardXP(GetLastKiller(), OBJECT_SELF);
    CreateObject(OBJECT_TYPE_ITEM, "kay_it_wka_ep01", GetLocation(OBJECT_SELF), FALSE);
    CreateObject(OBJECT_TYPE_ITEM, "darkmedallion", GetLocation(OBJECT_SELF), FALSE);
}


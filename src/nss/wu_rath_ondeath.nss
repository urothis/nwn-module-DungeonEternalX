#include "give_custom_exp"
#include "x2_inc_toollib"
void main()
{
    int nCount = GetLocalInt(GetModule(), "MONSTERCOUNT");
    SetLocalInt(GetModule(), "MONSTERCOUNT", --nCount);
    DEXRewardXP(GetLastKiller(), OBJECT_SELF);
    int i = 0;
    for (;i<3;i++)
        CreateObject(OBJECT_TYPE_ITEM, "shardofshadow", GetLocation(OBJECT_SELF), FALSE);
    for (i=0;i<5;i++)
        CreateObject(OBJECT_TYPE_ITEM, "perfectruby", GetLocation(OBJECT_SELF), FALSE);
}


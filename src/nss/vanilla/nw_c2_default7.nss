//  PW Experience System  v1.4
//  By David Bills
//  Default OnDeath script
#include "give_custom_exp"

void main()
{
    //int nCount = GetLocalInt(GetArea(OBJECT_SELF), "TOTALCOUNT");
    //SetLocalInt(GetArea(OBJECT_SELF), "TOTALCOUNT", --nCount);
    DEXRewardXP(GetLastKiller(), OBJECT_SELF);
}

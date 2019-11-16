#include "x2_inc_craft"

void main()
{
    object oPC = GetPCSpeaker();
    CIUpdateModItemCostDC(oPC, 0, 0);
    CISetDefaultModItemCamera(oPC);
}


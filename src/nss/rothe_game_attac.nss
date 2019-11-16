#include "nw_i0_generic"

void main()
{
    object oPC = GetLastAttacker();
    if (GetIsRangedAttacker(oPC)) return;

    ActionMoveAwayFromObject(oPC, TRUE, 5.0);
}

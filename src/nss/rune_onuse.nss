#include "rune_include"

void main() {
    object oPC = GetLastUsedBy();

    if(GetHitDice(oPC) == 40) {
        FloatingTextStringOnCreature("Level 40s cannot pick up runes!", oPC, FALSE);
    }
    else {
        PickupRune(oPC);
    }
}

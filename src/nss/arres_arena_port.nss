void main() {
    int iCost = 1000;
    object oPC = GetLastSpeaker();

    if(GetGold(oPC) < iCost) {
        FloatingTextStringOnCreature("You cannot afford it!", oPC, FALSE);
    }
    else {
        AssignCommand(oPC, TakeGoldFromCreature(iCost, oPC, TRUE));
        AssignCommand(oPC, JumpToObject(GetObjectByTag("ARENA_ENTRY")));
    }
}

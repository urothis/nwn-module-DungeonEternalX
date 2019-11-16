void main() {
    object oPC = GetLastUsedBy();
    AssignCommand(oPC, JumpToObject(GetObjectByTag("NW_GTFO_TAV")));
}

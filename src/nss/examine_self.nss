void main() {
    object oSelf = OBJECT_SELF;
    object oPC = GetLastUsedBy();

    if(!GetIsObjectValid(oPC)) oPC = GetLastSpeaker();

    AssignCommand(oPC, ActionExamine(oSelf));
}

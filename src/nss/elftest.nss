void main() {
    object oPC   = GetPCSpeaker();
    int nAppearance = GetAppearanceType(oPC);
    SetLocalInt(oPC, "OrigApp", nAppearance);
    SetLocalInt(oPC, "TRANSFORMED", 1);
    SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_ELF);
}


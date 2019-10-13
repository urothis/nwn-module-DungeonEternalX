
void main()
{
    object oPC = GetLastSpeaker();
    if (GetPCPlayerName(oPC) != "Ezramun") return;
    ActionCastSpellAtObject(SPELL_GREASE, oPC, METAMAGIC_ANY, TRUE);
    //AssignCommand(oPC, JumpToObject(GetObjectByTag("WP_SLOT_ENTRANCE_1")));
}

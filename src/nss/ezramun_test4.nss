
void main()
{
    object oPC = GetLastUsedBy();
    if (GetPCPlayerName(oPC) != "Ezramun") return;

    AssignCommand(oPC, JumpToObject(GetObjectByTag("WP_EIBACK")));
}

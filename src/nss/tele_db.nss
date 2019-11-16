void main()
{
    object oWP = GetObjectByTag("wp_db");
    AssignCommand(GetLastUsedBy(), JumpToObject(oWP));
}

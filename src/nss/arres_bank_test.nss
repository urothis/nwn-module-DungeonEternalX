void main()
{
object oPC = GetLastUsedBy();

AssignCommand(oPC, JumpToObject(GetObjectByTag("BANK_TEST")));
}

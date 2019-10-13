void main()
{
object oPC = GetLastUsedBy();
string rNum = IntToString(Random(7)+1);
object oMirror = GetObjectByTag("Mirrorwp"+ rNum);
AssignCommand(oPC,ActionJumpToObject(oMirror,FALSE));
}

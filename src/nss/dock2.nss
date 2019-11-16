void main()
{
object oPC = GetPCSpeaker();
object oJumpTo = GetWaypointByTag("Duvandock");

AssignCommand(oPC,ActionJumpToObject(oJumpTo));
}

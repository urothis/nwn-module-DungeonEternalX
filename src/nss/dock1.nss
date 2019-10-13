void main()
{
object oPC = GetPCSpeaker();

object oJumpTo = GetWaypointByTag("Mythdock");
AssignCommand(oPC,ActionJumpToObject(oJumpTo));
}

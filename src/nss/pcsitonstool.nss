void main()
{
object oPlayer = GetLastUsedBy ();
object oStool;
if (GetIsPC (oPlayer))
{
oStool = GetNearestObjectByTag ("Stool", oPlayer, 0);
if (GetIsObjectValid(oStool) && !GetIsObjectValid (GetSittingCreature (oStool)))
{
AssignCommand (oPlayer, ActionSit (oStool));
}
}
}

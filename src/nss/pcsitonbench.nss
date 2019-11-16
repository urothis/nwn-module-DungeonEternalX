void main()
{
object oPlayer = GetLastUsedBy ();
object oBench;
if (GetIsPC (oPlayer))
{
oBench = GetNearestObjectByTag ("BenchPew", oPlayer, 0);
if (GetIsObjectValid(oBench) && !GetIsObjectValid (GetSittingCreature (oBench)))
{
AssignCommand (oPlayer, ActionSit (oBench));
}
}
}

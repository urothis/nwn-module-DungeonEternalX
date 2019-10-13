void main()
{
object oPlayer = GetLastUsedBy ();
object oThrone;
if (GetIsPC (oPlayer))
{
oThrone = GetNearestObjectByTag ("ThroneEvil", oPlayer, 0);
if (GetIsObjectValid(oThrone) && !GetIsObjectValid (GetSittingCreature (oThrone)))
{
AssignCommand (oPlayer, ActionSit (oThrone));
}
}
}

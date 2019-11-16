void main()
{
   object oPC = GetLastClosedBy();
   location lLoft = GetLocation(GetObjectByTag("TELE_Loftenwood"));
   AssignCommand(oPC, ActionJumpToLocation(lLoft));
}

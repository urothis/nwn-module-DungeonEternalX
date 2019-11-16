void main()
{
    object oPC = GetLastUsedBy();
    if( GetIsPC( oPC ) == TRUE )
    {
        object oDest = GetObjectByTag("LoftVaultPortal");
        location lDest = GetLocation( oDest );
        AssignCommand( oPC, ActionJumpToLocation( lDest ) );
    }
    return;
}

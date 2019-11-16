void main()
{
/*  PC has a 40% chance to get caught and hung out to dry even if they do everything right
*/
    int nFailed = d100();
    if( nFailed <= 50 )
    {
        //Make sure that there is someone in the map, as the on exit
        //script resets everything by first unlocking everything
        if( GetLocalInt( GetModule(), "PlayersOnMap" ) != 0 )
        {
            ExecuteScript( "vlt_fail_ulock", OBJECT_SELF );
        }
    }

}

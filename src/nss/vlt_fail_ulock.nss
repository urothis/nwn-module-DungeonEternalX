void main()
{
    /*ALL HELL SHOULD BREAK LOOSE HERE!!!!
    Give every non-PC in area TTS.
    Send out a shout saying that the PC fudged their bank robbery
    */
    object oPC;
    string sBankRobber;
    int i;
    string sDoorTag;
    object oDoorTemp;
    object oGuard;
    effect eTTS;
    //object oMod;
    //oMod = GetModule;
    oPC = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC );
    sBankRobber =  GetName( oPC );
    ActionSpeakString(sBankRobber +" has set off the bank alarms... YOU FAILED IT!!!", TALKVOLUME_SHOUT);
    eTTS = EffectTrueSeeing();
    //close and lock all 11 doors in the area
    for( i = 1; i < 12; i++ )
    {
        sDoorTag = "VaultDoor" + IntToString( i );
        oDoorTemp = GetObjectByTag( sDoorTag );
        AssignCommand( oDoorTemp, ActionCloseDoor( oDoorTemp ) );
        //see if delaying closing the doors fixes the issue with them locking before they
        //try to close when lag is heavy
        DelayCommand(5.0f, AssignCommand( oDoorTemp, SetLocked( oDoorTemp, TRUE ) ));
    }
    for( i = 1; i < 40; i++ )
    {
        oGuard = GetNearestObjectByTag( "VaultGuard", oPC, i );
        if( oGuard != OBJECT_INVALID )
        {
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eTTS, oGuard );
        }
    }
}

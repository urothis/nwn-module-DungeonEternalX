/* Boss Death */

void main()
{
  //      WriteTimestampedLogEntry("'boss_die' Script Fired");
    if( GetLocalInt( OBJECT_SELF, "AlreadyDyingEXP" ) == 1 )
    {
        DeleteLocalInt(OBJECT_SELF, "AlreadyDyingEXP");
        return;
    }
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_IMP_DEATH) , OBJECT_SELF );
    SetLocalInt( OBJECT_SELF, "AlreadyDyingEXP", 1 );
    DestroyObject ( OBJECT_SELF );
//        WriteTimestampedLogEntry("'boss_die' Script Ended");

}








//:://///////////////////
//:: Created By: Lincoln
//:://///////////////////
void main()
{
    object oPlayer = GetLastUsedBy();
    object oBench = OBJECT_SELF;
    object osit1 = GetLocalObject( OBJECT_SELF, "sit 1" );
    object osit2 = GetLocalObject( OBJECT_SELF, "sit 2" );
    object osit3 = GetLocalObject( OBJECT_SELF, "sit 3" );
    object osit4 = GetLocalObject( OBJECT_SELF, "sit 4" );
    object osit5 = GetLocalObject( OBJECT_SELF, "sit 5" );
   if(!GetIsObjectValid(osit1)) {
        object oArea = GetArea( oBench );
        vector locBench = GetPosition( oBench );
        float fOrient = GetFacing( oBench );
        float fSpace = 0.7;
        float fSpace2 = 1.4;
        location locsit1 = Location( oArea, locBench + AngleToVector( fOrient + 90.0f ) * fSpace, fOrient );
        location locsit2 = Location( oArea, locBench + AngleToVector( fOrient + 90.0f ) * fSpace2, fOrient );
        location locsit3 = Location( oArea, locBench + AngleToVector( fOrient - 90.0f ) * fSpace2, fOrient );
        location locsit4 = Location( oArea, locBench + AngleToVector( fOrient - 90.0f ) * fSpace, fOrient );
        location locsit5 = Location( oArea, locBench, fOrient );

        osit1 = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_invisobj", locsit1 );
        osit2= CreateObject( OBJECT_TYPE_PLACEABLE, "plc_invisobj", locsit2 );
        osit3 = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_invisobj", locsit3 );
        osit4= CreateObject( OBJECT_TYPE_PLACEABLE, "plc_invisobj", locsit4 );
        osit5 = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_invisobj", locsit5 );
        SetLocalObject( OBJECT_SELF, "sit 1", osit1 );
        SetLocalObject( OBJECT_SELF, "sit 2", osit2 );
        SetLocalObject( OBJECT_SELF, "sit 3", osit3 );
        SetLocalObject( OBJECT_SELF, "sit 4", osit4 );
        SetLocalObject( OBJECT_SELF, "sit 5", osit5 );
 }
    int iDistance = 1;
    object osit = GetNearestObjectByTag( "InvisibleObject", oPlayer, iDistance );
    int iCount = 0;
    while( GetIsObjectValid( osit ) || iCount < 5 ) {
        if( osit == osit1 || osit == osit2 || osit == osit3|| osit == osit4|| osit == osit5 ) {
            iCount = iCount + 1 ;
            if( !GetIsObjectValid( GetSittingCreature( osit ) ) ) {
                AssignCommand( oPlayer, ActionSit( osit ) );
                return;
            }
        }
        iDistance = iDistance + 1;
        osit = GetNearestObjectByTag( "InvisibleObject", oPlayer, iDistance );
    }
}

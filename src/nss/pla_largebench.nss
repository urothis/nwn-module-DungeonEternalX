
void main()
{
    // Set some variable for a beter understanding
    object oPlayer = GetLastUsedBy();
    object oBench = OBJECT_SELF;

    // Get a hold on the 3 pillows
    object oPillow1 = GetLocalObject( OBJECT_SELF, "Pillow 1" );
    object oPillow2 = GetLocalObject( OBJECT_SELF, "Pillow 2" );
    object oPillow3 = GetLocalObject( OBJECT_SELF, "Pillow 3" );

    // If "pillow 1" do not exist, create 3 of them and attach them to the bench
    if( !GetIsObjectValid( oPillow1 ) )
    {
        // Set up some variable for understanding
        object oArea = GetArea( oBench );
        vector locBench = GetPosition( oBench );
        float fOrient = GetFacing( oBench );

        // You can change the space between pillows changing this value
        float fSpace = 1.0f;

        // Calculate location of the 3 pillows
        location locPillow1 = Location( oArea, locBench + AngleToVector( fOrient + 90.0f ) * fSpace, fOrient );
        location locPillow2 = Location( oArea, locBench + AngleToVector( fOrient - 90.0f ) * fSpace, fOrient );
        location locPillow3 = Location( oArea, locBench, fOrient );

        // Create the 3 pillows
        oPillow1 = CreateObject( OBJECT_TYPE_PLACEABLE, "invisible", locPillow1 );
        oPillow2 = CreateObject( OBJECT_TYPE_PLACEABLE, "invisible", locPillow2 );
        oPillow3 = CreateObject( OBJECT_TYPE_PLACEABLE, "invisible", locPillow3 );

        // "attach" the pillows to the bench
        SetLocalObject( OBJECT_SELF, "Pillow 1", oPillow1 );
        SetLocalObject( OBJECT_SELF, "Pillow 2", oPillow2 );
        SetLocalObject( OBJECT_SELF, "Pillow 3", oPillow3 );
    }

    // Get a hold on the nearest invisible object, (maybe a pillow)
    int iDistance = 1;
    object oPillow = GetNearestObjectByTag( "InvisibleObject", oPlayer, iDistance );

    // while we find invisible object and that we did not check the 3 linked pillows
    int iCount = 0;
    while( GetIsObjectValid( oPillow ) || iCount < 3 )
    {
        // if it is one of the three pillow linked the the bench
        if( oPillow == oPillow1 || oPillow == oPillow2 || oPillow == oPillow3 )
        {
            iCount = iCount + 1 ;
            // If available
            if( !GetIsObjectValid( GetSittingCreature( oPillow ) ) )
            {
                // Sit and quit the script
                AssignCommand( oPlayer, ActionSit( oPillow ) );
                return;
            }
        }
        // Get the next nearest invisible object
        iDistance = iDistance + 1;
        oPillow = GetNearestObjectByTag( "InvisibleObject", oPlayer, iDistance );
    }
}


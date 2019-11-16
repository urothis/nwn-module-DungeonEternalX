//::///////////////////////////////////////////////
//:: Slot Machine Lever v1.1
//:://////////////////////////////////////////////
/*
     Put this script on the OnUsed event of a floor lever. On each pull of the
     lever, 1g is deducted from the PC's account. Each pull has a chance of
     winning up to 25,000g.
*/
//:://////////////////////////////////////////////
//:: Created By: August 6th, 2002
//:: Created On: Karthal <kar_of_albion@hotmail.com>
//:://////////////////////////////////////////////
// Set "constants"
int ROLL_GARNET  = 100;
int ROLL_TOPAZ   = 148;
int ROLL_SAPHIRE = 160;
int ROLL_DIAMOND = 166;
int ROLL_RUBY    = 170;
int ROLL_EMERALD = 173;
int ROLL_MAX     = 173;
int PAYOUT_GARNET  = 2;
int PAYOUT_TOPAZ   = 5;
int PAYOUT_SAPHIRE = 300;
int PAYOUT_DIAMOND = 2500;
int PAYOUT_RUBY    = 10000;
int PAYOUT_EMERALD = 30000;
int DEBUG = FALSE;
// Declare functions
string GetGem( int iGem );
int GetPayout( string sGem1, int iWager );
// Main
void main()
{
    // Determine the size of the wager
    int iWager = FindSubString( GetTag( OBJECT_SELF ), "_W");
    if ( iWager >= 0 )
        iWager = StringToInt( GetSubString( GetTag( OBJECT_SELF ), iWager + 2, 4 ) );
    else iWager = 1;
    // Run
    object oPC = GetLastUsedBy();
    if ( GetIsPC( oPC ) )
    {
        if ( GetLocalInt( oPC, "sm_SlotGold" ) == 0 )
        {
            SpeakString( "This is a " + IntToString( iWager ) + "g machine. If you wish to wager gold, you must first put some in the Slot Chest." );
        }
        else if ( iWager > GetLocalInt( oPC, "sm_SlotGold" ) )
        {
            SpeakString( "The minimum wager is " + IntToString( iWager ) + ". You must add more gold into the chest." );
        }
        else
        {
            // Animate the lever
            AssignCommand( OBJECT_SELF, ActionPlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
            AssignCommand( OBJECT_SELF, DelayCommand( 1.0, ActionPlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) ) );
            // Decrement wager from the PC's account
            SetLocalInt( oPC, "sm_SlotGold", GetLocalInt( oPC, "sm_SlotGold" ) - iWager );
            // Spin the wheels
            string sGem1 = GetGem( Random( ROLL_MAX ) + 1 );
            string sGem2 = GetGem( Random( ROLL_MAX ) + 1 );
            string sGem3 = GetGem( Random( ROLL_MAX ) + 1 );
            FloatingTextStringOnCreature( sGem1 + " : " + sGem2 + " : " + sGem3, oPC );
            // Check for winner
            if ( sGem1 == sGem2 && sGem1 == sGem3 )
            {
                SetLocalInt( oPC, "sm_SlotGold", GetLocalInt( oPC, "sm_SlotGold" ) + GetPayout( sGem1, iWager ) );
                FloatingTextStringOnCreature( "WE HAVE A WINNER!", oPC );
                PlaySound( "as_cv_shopmetal1");
            }
            // Display gold in account
            FloatingTextStringOnCreature( IntToString( GetLocalInt( oPC, "sm_SlotGold" ) ) + " gold left.", oPC );
        }
    }
}
string GetGem( int iGem )
{
    if ( iGem <= ROLL_GARNET )
        return "Garnet";
    else if ( iGem <= ROLL_TOPAZ )
        return "Topaz";
    else if ( iGem <= ROLL_SAPHIRE )
        return "Saphire";
    else if ( iGem <= ROLL_DIAMOND )
        return "Diamond";
    else if ( iGem <= ROLL_RUBY )
        return "Ruby";
    else if ( iGem <= ROLL_EMERALD )
        return "Emerald";
    return "None";
}
int GetPayout( string sGem1, int iWager )
{
    if ( sGem1 == "Garnet" )
        return iWager * PAYOUT_GARNET;
    else if ( sGem1 == "Topaz" )
        return iWager * PAYOUT_TOPAZ;
    else if ( sGem1 == "Saphire" )
        return iWager * PAYOUT_SAPHIRE;
    else if ( sGem1 == "Diamond" )
        return iWager * PAYOUT_DIAMOND;
    else if ( sGem1 == "Ruby" )
        return iWager * PAYOUT_RUBY;
    else if ( sGem1 == "Emerald" )
        return iWager * PAYOUT_EMERALD;
    return 0;
}


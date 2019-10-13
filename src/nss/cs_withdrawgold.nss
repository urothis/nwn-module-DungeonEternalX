//::///////////////////////////////////////////////
//:: Withdraw Gold
//:://////////////////////////////////////////////
/*
     Withdraw gold from your slot machine "account". Put this on the "OnOpen"
     event of a chest near the lever.
*/
// Main
void main()
{
    object oPC = GetLastOpenedBy();
    if ( !GetIsPC( oPC ) )
        return;

    if ( GetLocalInt( oPC, "sm_SlotGold" ) > 0 )
    {
        CreateItemOnObject( "nw_it_gold001", OBJECT_SELF, GetLocalInt( oPC, "sm_SlotGold" ) );
        SetLocalInt( oPC, "sm_SlotGold", 0 );
    }
    else
    {
        SpeakString( "Place gold you wish to wager into the chest and close it. Do not worry, no other player may take your gold out of the chest." );
    }
}

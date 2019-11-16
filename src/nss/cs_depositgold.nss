//::///////////////////////////////////////////////
//:: Deposit Gold
//:://////////////////////////////////////////////
/*
     Deposit gold into your slot machine "account". Put this on the "OnClose"
     event of a chest near the lever.
*/
// Main
void main()
{
    object oPC = GetLastOpenedBy();
    int iGold = GetGold( OBJECT_SELF );
    if ( !GetIsPC( oPC ) )
        return;

    if ( iGold > 0 )
    {
        SetLocalInt( oPC, "sm_SlotGold", iGold );
        object oGold = GetFirstItemInInventory();
        while( oGold != OBJECT_INVALID )
        {
            if ( GetTag( oGold ) == "NW_IT_GOLD001" )
            {
                DestroyObject( oGold );
                return;
            }
            oGold = GetNextItemInInventory();
        }
    }
}

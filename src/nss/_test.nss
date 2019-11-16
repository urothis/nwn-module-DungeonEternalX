#include "_inc_inventory"

void main()
{
    object oPC            = GetEnteringObject();
    // Destroy Gtr Dispell scolls  LJU
    // continue a loop until all items of sTag Name are destroyed.
    DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602");
    DelayCommand(5.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
    DelayCommand(10.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
    DelayCommand(15.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
    DelayCommand(20.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
}

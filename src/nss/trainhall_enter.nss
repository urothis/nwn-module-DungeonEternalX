#include "inc_traininghall"

void main()
{
    object oPC = GetEnteringObject();
    // See file "inc_traininghall" for more informations
    if (GetIsTestChar(oPC) && GetIsPC(oPC)) DestroyInventory(oPC);
    DeleteLocalInt(oPC, "TRAIN_SESSION");
    ExecuteScript("_mod_areaenter", OBJECT_SELF);
}

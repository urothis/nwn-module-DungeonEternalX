#include "seed_faction_inc"

void main()
{
    object oDoor = OBJECT_SELF;

    if (!GetLocalInt(oDoor, "LASTDAMAGE"))
    {
        object oPC = GetLastDamager();
        string sMsg;

        sMsg = "Someone is attacking the Fort!";

        SetLocalInt(oDoor, "LASTDAMAGE", TRUE);
        DelayCommand(120.0, DeleteLocalInt(oDoor, "LASTDAMAGE"));
        ShoutMsg(sMsg);
    }
}

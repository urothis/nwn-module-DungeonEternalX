#include "seed_faction_inc"

void main()
{
    object oDoor = OBJECT_SELF;

    if (!GetLocalInt(oDoor, "LASTDAMAGE"))
    {
        object oPC = GetLastDamager();
        string sFAID = GetLocalString(GetArea(oDoor), "FAID");
        string sFaction = SDB_FactionGetName(sFAID);
        string sMsg;
        if (GetTag(oDoor) == "FACTION_PORTAL_DOOR")
        {
            sMsg = "Someone is knocking on " + sFaction + "'s Portal door.";
        }
        else // castle door
        {
            sMsg = "Someone is knocking on " + sFaction + "'s Castle door.";
        }
        SetLocalInt(oDoor, "LASTDAMAGE", TRUE);
        DelayCommand(120.0, DeleteLocalInt(oDoor, "LASTDAMAGE"));
        ShoutMsg(sMsg);
    }
}

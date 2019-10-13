#include "x2_inc_switches"
#include "dmg_stones_inc"

void main()
{
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_CONTINUE;

    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC     = GetItemActivator();
        object oTarget = GetItemActivatedTarget();
        string sTag = GetTag(oTarget);

        if (!GetIsObjectValid(oTarget)) return;
        if (oTarget == GetItemActivated()) return;
        if (GetItemPossessor(oTarget) == oPC) DestroyObject(oTarget);

        string sTag5 = GetStringLeft(sTag, 5);
        string sTag8 = GetStringLeft(sTag, 8);

        if (sTag8 == "EPICITEM" || sTag8 == "EPICCRAF")
        {
            NWNX_SQL_ExecuteQuery("update epic_item set ei_status='trashed' where ei_id=" + GetLocalString(oTarget, "ID"));
        }
        else if (sTag5 == "DMGS_")
        {
            DMGS_UpdateStoneDB(oTarget, oTarget);
        }
    }
    SetExecutedScriptReturnValue(nResult);
}

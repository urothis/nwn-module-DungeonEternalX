#include "x2_inc_switches"
#include "_inc_port"

void Onos()
{
}

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

    object oPC = GetItemActivator();

    if (!IsWarpAllowed(oPC)) return;

    object oItem = GetItemActivated();
    location lLoc = GetLocation(oPC);
    string sResRef = GetResRef(oItem);

    // Cory - The Fort port stones
    if (sResRef == "tp_fort")
    {
        string sFAID = GetLocalString(oPC, "FAID");

        int nFAID = StringToInt(sFAID);
        int nPcOwner = dbGetTRUEID(oPC);


        if ((GetLocalInt(GetModule(), "TheFortOwner") == nPcOwner) || (GetLocalInt(GetModule(), "TheFortOwner") == nFAID))
        {
            int nRandom = d2(1); // Randomly choose port location
            string sRandom = IntToString(nRandom);

            sResRef = sResRef + "_" + sRandom;
            SetLocalLocation(oPC, "TP_TARGET", lLoc);
            object oTarget = DefGetObjectByTag(GetStringUpperCase(sResRef), GetWPHolder());
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(472), lLoc);
            SetLocalInt(oPC, "DO_PORT_FX", TRUE);
            AssignCommand(oPC, DelayCommand(1.0, JumpToObject(oTarget)));
        }
        else // Player does not control fort
        {
            SendMessageToPC(oPC, "You do not control the fort.");
        }
        return;
    }

    // old portalstones
    if (!GetItemCharges(oItem))
    {
        if (sResRef == "wp_eiback") sResRef = "wp_eiback"; //temple of adaghar stone
        else if (sResRef == "wp_db") sResRef = "tp_duv";
        else if (sResRef == "wp_loft") sResRef = "tp_loft";
        else if (sResRef == "wp_mene") sResRef = "tp_mene";
        else if (sResRef == "wp_ridge") sResRef = "tp_ridge";
        else if (sResRef == "wp_sands") sResRef = "tp_oasis";
        else if (sResRef == "wp_tangle") sResRef = "tp_tangle";
        else return;
        DestroyObject(oItem);

        if (sResRef != "wp_eiback") // temple stone supposed to work only 1 time
        {
            CreateItemOnObject(sResRef, oPC);
            SendMessageToPC(oPC, "Old stone destroyed and replaced with new one");
        }
    }
    if (sResRef == "tp_duv") // make onos the kobold steal something from pawn
    {
    }

    SetLocalLocation(oPC, "TP_TARGET", lLoc);
    object oTarget = DefGetObjectByTag(GetStringUpperCase(sResRef), GetWPHolder());
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(472), lLoc);
    SetLocalInt(oPC, "DO_PORT_FX", TRUE);
    AssignCommand(oPC, DelayCommand(1.0, JumpToObject(oTarget)));
}

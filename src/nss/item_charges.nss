#include "x2_inc_switches"

void main()
{
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) return;

    object oPC          = GetItemActivator();
    object oTarget      = GetItemActivatedTarget();
    object oCharge      = GetItemActivated();
    string sTagCharge   = GetTag(oCharge);
    string sTagTarget   = GetTag(oTarget);

    int nCharge;
    if (sTagTarget == "PALETTE")
    {
        DestroyObject(oTarget);
        FloatingTextStringOnCreature("Illegal Item Destroyed", oPC);
        return;
    }

    if (sTagCharge == "CHARGE_NUBFIST")
    {
        if (sTagTarget == "FIST_OF_NIBELUNGEN")
        {
            nCharge = GetItemCharges(oTarget);
            SetItemCharges(oTarget, nCharge + 1);
        }
        else FloatingTextStringOnCreature("Invalid Target", oPC);
    }
    else if (sTagCharge == "CHARGE_SHADOW")
    {
        if (sTagTarget == "ITEM_SHADOW")
        {
            nCharge = GetItemCharges(oTarget);
            SetItemCharges(oTarget, nCharge + 1);
        }
        else FloatingTextStringOnCreature("Invalid Target", oPC);
    }
    else if (sTagCharge == "CHARGE_MAGMA")
    {
        if (sTagTarget == "ITEM_MAGMA")
        {
            nCharge = GetItemCharges(oTarget);
            SetItemCharges(oTarget, nCharge + 1);
        }
        else FloatingTextStringOnCreature("Invalid Target", oPC);
    }
    else FloatingTextStringOnCreature("Invalid Charge", oPC);

    effect eVFX = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPC));
}

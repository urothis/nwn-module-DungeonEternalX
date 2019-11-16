#include "x2_inc_switches"
#include "zdialog_inc"
#include "dmg_stones_inc"

void main()
{
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_CONTINUE;

    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC      = GetItemActivator();
        object oWeapon  = GetItemActivatedTarget();
        object oStone   = GetItemActivated();
        string sTag     = GetTag(oWeapon);

        if (GetIsInCombat(oPC))         return;
        if (!GetIsPC(oPC))              return;
        if (GetIsDM(oPC))               return;
        if (GetIsDMPossessed(oPC))      return;

        if (GetItemPossessor(oWeapon) != oPC) return;

        if (GetHitDice(oPC) < 40)
        {
            FloatingTextStringOnCreature("Only for level 40.", oPC);
            return;
        }
        if (!MatchMeleeWeapon(oWeapon))
        {
            FloatingTextStringOnCreature("Use only on melee weapon", oPC);
            return;
        }
        if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != oWeapon)
        {
            if (GetItemInSlot(INVENTORY_SLOT_ARMS, oPC) != oWeapon) // glove
            {
                FloatingTextStringOnCreature("You have to equip the weapon first.", oPC);
                return;
            }
        }
        string sTag7 = GetStringLeft(sTag, 7);
        if (sTag7 != "EPICCRA" && sTag7 != "CRAFTED")
        {
            SendMessageToPC(oPC, "Sorry, this item can not be modified.");
            return;
        }

        IPRemoveAllItemProperties(oWeapon);
        SetCurrentList(oPC, "DMG_STONES");
        SetLocalObject(oPC, "DMGS_WEAPON", oWeapon);
        SetLocalObject(oPC, "DMGS_STONE", oStone);
        OpenNextDlg(oPC, oStone, "dmg_stones_conv", TRUE, FALSE);
        return;
    }
    SetExecutedScriptReturnValue(nResult);
}

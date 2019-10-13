#include "x2_inc_switches"
#include "INC_WEP_AC_BON"
#include "gen_inc_color"
#include "arres_inc"
#include "ness_pvp_db_inc"
#include "db_inc"
#include "x0_i0_match"
#include "no_tumble"
#include "wm_bonus"

void main()
{
    object oItem       = GetPCItemLastEquipped();
    object oPC         = GetPCItemLastEquippedBy();
    string sItemTag    = GetTag(oItem);
    string sItemTag8   = GetStringLeft(sItemTag, 8);
    string sPLID       = IntToString(dbGetPLID(oPC));
    if (sPLID == "0") return; // just logged on

    if (sItemTag8 == "EPICITEM" || sItemTag8 == "EPICCRAF")
    {
        string sOwner = GetLocalString(oItem, "OWNER");
        if (sOwner != sPLID && sOwner != "")
        {
            string sItemName = GetName(oItem);
            SendMessageToPC(oPC, GetRGB(15,1,1) + sItemName + ", is not your item. Your actions has been logged");
            dbLogMsg("EPICITEM non-proprietor equipped " + sItemName,"EPICITEM",dbGetTRUEID(oPC),dbGetDEXID(oPC),dbGetLIID(oPC),dbGetPLID(oPC));
            DelayCommand(0.5, UnequipItem(oPC, oItem));
        }
    }

    if (GetCurrentAction(oPC) == ACTION_CASTSPELL || GetCurrentAction(oPC) == ACTION_COUNTERSPELL)
        DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));

    DelayCommand(0.1, DestroyIllegalItem(oPC, oItem));

    object oRHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oLHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    // NOTHING IN HANDS, RETURN
    if (!GetIsObjectValid(oRHand) && !GetIsObjectValid(oLHand)) return;

    int nBaseItemType  = GetBaseItemType(oItem);
    if (nBaseItemType != BASE_ITEM_CREATUREITEM && nBaseItemType != BASE_ITEM_BULLET && nBaseItemType != BASE_ITEM_ARROW && nBaseItemType != BASE_ITEM_BOLT)
    {
        DelayCommand(0.1, AssignCommand(oPC, ClearAllActions())); // prevent weaponswitch bug
    }

    if (GetCreatureSize(oPC) >= CREATURE_SIZE_LARGE)
    {
        if (oItem == oRHand || oItem == oLHand)
        {
            if (GetIsObjectValid(oLHand) && GetIsObjectValid(oRHand))
            {
                string sWeaponSize = Get2DAString("baseitems", "WeaponSize", GetBaseItemType(oRHand));
                if (sWeaponSize == "4")
                {
                    int nBaseItemTypeL = GetBaseItemType(oLHand);
                    if (nBaseItemTypeL == BASE_ITEM_LARGESHIELD || nBaseItemTypeL == BASE_ITEM_TOWERSHIELD)
                    {
                        SendMessageToPC(oPC, "You can not use large shields when using a large weapon.");
                        DelayCommand(0.5, UnequipItem(oPC, oLHand));
                    }
                }
            }
        }
    }
    else if ((nBaseItemType != BASE_ITEM_TORCH)) //&& MatchMeleeWeapon(oItem))
    {
        WeaponAcBonus(oPC);
        NoTumbleAcBonus(oPC); // Cory - No tumble ac bonus

        //Cory - WM AC re-application
        if ((GetLocalInt(oPC, "HasWmAc")==0) &&GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC)>4)
        {
            int nWM = GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC);
            int nBaseStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
            int nBonus = 1; // Value will be equavalent to wm ab bonus.

            if (nWM >= 13)
            {
                nBonus += (nWM-10)/3;
            }
            else if (nWM < 5)
            {
                nBonus = 0;
            }
            WeaponMasterAC(oPC, nBaseStr, nBonus);
        }
    }
/*    else
    {
        NoTumbleAcBonus(oPC); // Cory - No tumble ac bonus

        //Cory - WM AC re-application
        if (!(GetLocalInt(oPC, "HasWmAc")))
        {
            int nWM = GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC);
            int nBaseStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
            int nBonus = 1; // Value will be equavalent to wm ab bonus.

            if (nWM >= 13)
            {
                nBonus += (nWM-10)/3;
            }
            WeaponMasterAC(oPC, nBaseStr, nBonus);
        }
    }
*/

// -----------------------------------------------------------------------------
// MONK GLOVES
// -----------------------------------------------------------------------------
    // Can not use gloves with weapon in hands (including mage staff and ranged weapon)
    if (nBaseItemType == BASE_ITEM_GLOVES) // Equipped Item Monk gloves?
    {   // Something in right hand?
        if (GetIsObjectValid(oRHand))
        {   // unequip monkgloves
            DelayCommand(0.5, UnequipItem(oPC, oItem));
            FloatingTextStringOnCreature("You can not use gloves with weapon in hands", oPC);
        }
    } // equipped some weapon?
    else if (!MatchShield(oItem) && nBaseItemType != BASE_ITEM_TORCH) // only if it wasnt a shield or torch
    { // equipped item wasnt monk gloves and not shield, check if player is already using gloves
        object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
        if (GetBaseItemType(oArms) == BASE_ITEM_GLOVES)
        {   // unequip monkgloves
            DelayCommand(0.5, UnequipItem(oPC, oItem));
            FloatingTextStringOnCreature("You can not use gloves with weapon in hands", oPC);
        }
    }
}



#include "inc_traininghall"
#include "_inc_port"
#include "_functions"
#include "seed_faction_inc"
#include "arres_inc"
#include "sfsubr_functs"
#include "quest_inc"

void DoEnterMessages(object oPC)
{
    DelayCommand(5.0, ActionSendMessageToPC(oPC, "Welcome to Dungeon Eternal X"));
    DelayCommand(6.0, ActionSendMessageToPC(oPC, "Please read all journal entries!"));
    DelayCommand(10.0, ActionSendMessageToPC(oPC, GetRGB(13,9,13) + "Check the sign on the right for Discord information!"));
}

void CheckMonkGloves(object oPC)
{
    object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    if (GetBaseItemType(oArms) == BASE_ITEM_GLOVES)
    {
        if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))
        {
            DelayCommand(0.5, UnequipItem(oPC, oArms));
            FloatingTextStringOnCreature("You can not use gloves with weapon in hands", oPC);
        }
    }
}

void CheckLargeCreatureShield(object oPC)
{
    if (GetCreatureSize(oPC) >= CREATURE_SIZE_LARGE)
    {
        object oRHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        object oLHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if (GetIsObjectValid(oRHand) && GetIsObjectValid(oLHand))
        {
            int nType = GetBaseItemType(oLHand);
            if (nType == BASE_ITEM_LARGESHIELD || nType == BASE_ITEM_TOWERSHIELD)
            {
                string sWeaponSize = Get2DAString("baseitems", "WeaponSize", GetBaseItemType(oRHand));
                if (sWeaponSize == "4")
                {
                    SendMessageToPC(oPC, "You can not use large shields when using a large weapon.");
                    DelayCommand(0.5, UnequipItem(oPC, oLHand));
                }
            }
        }
    }
}


void main()
{
    object oPC = GetEnteringObject();

    if (!GetIsPC(oPC))  return;
    if (GetIsDM(oPC))   return;

    if (GetLocalInt(oPC, "DO_TAVERN_ENTER"))
    {
        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectHaste()), oPC));
        if (!GetIsDM(oPC) && !GetIsDMPossessed(oPC))
        {
            if (!SF_SubraceOnEnter(oPC))
            {
                SDB_FactionOnClientEnter(oPC);
                CheckAllItems(oPC);
                CheckMonkGloves(oPC);
                CheckLargeCreatureShield(oPC);
                SetDescription(oPC, dbPCtoString(oPC));
                SetLocalInt(oPC, "i_TI_LastRest", 0);
                DelayCommand(0.1, SDB_LoadDiplomacy(oPC, TRUE, TRUE));

                if (GetIsTestChar(oPC)) DelayCommand(1.0, JumpToTraininghalls(oPC));
                else if (GetLocalInt(oPC, "JAILED"))
                {
                    object oJail = GetWaypointByTag ("WP_JAIL");
                    AssignCommand(oPC, DelayCommand(1.0, JumpToObject(oJail)));
                }
                else DelayCommand(0.1, Q_OnTavernEnter(oPC));
            }
        }

        DoEnterMessages(oPC);
        DeleteLocalInt(oPC, "DO_TAVERN_ENTER");
    }
    ExecuteScript("_mod_areaenter", OBJECT_SELF);
}

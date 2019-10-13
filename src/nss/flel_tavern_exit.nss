#include "seed_strip_ill"
#include "quest_inc"

int SkipStrip(object oItem)
{
    string sWhich = GetTag(oItem);
    string sWhich5 = GetStringLeft(sWhich, 5);
    if (sWhich=="SEED_VALIDATED" || sWhich=="COO_AASSDARTS")
    {
        //sWhich = GetName(oItem) + " was bypassed by the stripper script (VALIDATED).";
        //SendMessageToPC(GetItemPossessor(oItem), sWhich);
        WriteTimestampedLogEntry(GetName(GetItemPossessor(oItem)) + ": " + sWhich);
        return TRUE;
    }
    else if (GetStringLeft(sWhich, 8) == "EPICITEM")
    {
        return TRUE;
    }
    else if (sWhich5 == "QUEST" || sWhich5 == "onhit")
    {
        return TRUE;
    }
    return FALSE;
}

void vCreateItemOnObject(string sWhich, object oPC)
{
    SetIdentified(CreateItemOnObject(sWhich, oPC), TRUE);
}

int DestroyAndRefundItem(object oPC, object oItem)
{
    string oItemResRef = GetResRef(oItem);
    if (oItemResRef == "fi_mail"
     || oItemResRef == "fi_robe"
     || oItemResRef == "fi_boots_str"
     || oItemResRef == "fi_boots_dex"
     || oItemResRef == "fi_bracers"
     || oItemResRef == "fi_helm"
     || oItemResRef == "fi_leather"
     || oItemResRef == "sacredarmor"
     || oItemResRef == "rangerbelt2"
     || oItemResRef == "fi_mail2"
     || oItemResRef == "fi_leather2"
     || oItemResRef == "fi_robe2")
     {
        //GiveGoldToCreature(oPC, 4 * GetGoldPieceValue(oItem));
        DestroyObject(oItem);  // OUT WITH THE OLD
        return TRUE;
    }
    return FALSE;
}

// Check items for illegal properties and get rid of them -- Flel
void PlayerCheckupLoop(object oPC)
{
    object oItem;

    if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;
    if (GetLocalInt(oPC, "STRIPDONE")) return;
    SetLocalInt(oPC, "STRIPDONE", 1);

    SetLocalInt(oPC, "ITEMS_VALID", 0);
    // Compensate(oPC); disabled by Ezramun, totally useless

    // Equipment
    int iSlot;
    for(iSlot = 0; iSlot < NUM_INVENTORY_SLOTS; iSlot++)
    {
        oItem = GetItemInSlot(iSlot, oPC);
        if (GetIsObjectValid(oItem))
        {
            if (DestroyAndRefundItem(oPC, oItem))
            {
                FloatingTextStringOnCreature("Item " + GetName(oItem)+ " destroyed.", oPC, FALSE);
            }
            else if (SkipStrip(oItem))
            {
                // WORK DONE IN FUNCTION
            }
            else
            {
                DelayCommand(0.0f, StripIllegalProps(oItem));
            }
        }
    }

    // Inventory
    oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        string sTag = GetTag(oItem);
        string sName = GetName(oItem);
        if (DestroyAndRefundItem(oPC, oItem))
        {
            FloatingTextStringOnCreature("Item " + GetName(oItem)+ " destroyed.", oPC, FALSE);
        }
        else if (SkipStrip(oItem))
        {
            // WORK DONE IN FUNCTION
        }
        else
        {
            DelayCommand(0.0f, StripIllegalProps(oItem));
        }
        oItem = GetNextItemInInventory(oPC);
    }
    // DelayCommand(15.0f, Compensate(oPC)); // disabled by Ezramun, totally useless
}

void main()
{
   object oPC = GetExitingObject();
   if (!GetIsDM(oPC))    PlayerCheckupLoop(oPC); // Check items on entering players
   ExecuteScript("_mod_areaexit", OBJECT_SELF);
}

#include "_functions"

void main()
{
    object oPC = GetLastDisturbed();
    object oItem = GetInventoryDisturbItem();
    if (!GetIsPC(oPC)) return;
    string sTag = GetTag(oItem);
    string sTag8 = GetStringLeft(sTag, 8);;

    if (sTag == "NW_IT_GOLD001")
    {
        FloatingTextStringOnCreature("*Gold cannot be stored!*", oPC, FALSE);
        CopyItem(oItem, oPC);
        Insured_Destroy(oItem);
        return;
    }
    if (sTag8 == "EPICITEM" || sTag8 == "EPICCRAF")
    {
        FloatingTextStringOnCreature("*Epic items cannot be stored!*", oPC, FALSE);
        CopyItem(oItem, oPC, TRUE);
        Insured_Destroy(oItem);
        return;
    }

    int nCount;
    object oCount = GetFirstItemInInventory();
    while (GetIsObjectValid(oCount))
    {
        nCount++;
        oCount = GetNextItemInInventory();
    }

    if (nCount > 50)
    {
        CopyItem(oItem, oPC, TRUE);
        Insured_Destroy(oItem);
        FloatingTextStringOnCreature("*You cannot exceed " + IntToString(50) + " items in storage!*", oPC);
        nCount = 50;
    }

    string sCheck = IntToString(nCount);
    SendMessageToPC(oPC, "You have " + sCheck + " items stored.");
}

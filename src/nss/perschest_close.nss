#include "_functions"
#include "_inc_inventory"

void main()
{
    object oPC = GetLastClosedBy();
    object oChest   = OBJECT_SELF;
    location lLoc   = GetLocation(oPC);
    string sChestID = GetLocalString(oChest, "CHEST_ID");
    string sDBName  = "PERSISTENT_CHEST";

    SetLocked(oChest, TRUE);

    object oStorer = CreateObject(OBJECT_TYPE_CREATURE, "perschest_npc", lLoc, FALSE, sChestID);

    int nCount;
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        if (!GetIsObjectValid(oStorer))
        {
            DeleteLocalString(oChest, "CHEST_ID");
            FloatingTextStringOnCreature("<cø>[ERROR] Items can not be stored</c>", oPC);
            SetLocked(oChest, FALSE);
            return;
        }
        CopyItem(oItem, oStorer, TRUE);
        Insured_Destroy(oItem);
        nCount++;
        oItem = GetNextItemInInventory(oChest);
    }

    if (StoreCampaignObject(sDBName, "DATABASE_ITEM" + sChestID, oStorer))
    {
        DelayCommand(2.0, ActionFloatingTextStringOnCreature("<cø>You have " + IntToString(nCount) + " items stored.</c>", oPC));
        DeleteLocalString(oChest, "CHEST_ID");
    }
    else // Failed to store, copy all items back to chest
    {
        object oItem = GetFirstItemInInventory(oStorer);
        while (GetIsObjectValid(oItem))
        {
            CopyItem(oItem, oChest, TRUE);
            Insured_Destroy(oItem);
            oItem = GetNextItemInInventory(oStorer);
        }
        DelayCommand(2.0, ActionFloatingTextStringOnCreature("<cø>[ERROR] Items are not stored</c>", oPC));
    }
    Insured_Destroy(oStorer);


    //ExportSingleCharacter(oPC);
    DelayCommand(5.0, SetLocked(oChest, FALSE));

    // Destroy Gtr Dispell scolls  LJU
    DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602");
    DelayCommand(5.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
    DelayCommand(10.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
    DelayCommand(15.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
    DelayCommand(20.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR602"));
    // Destroy Gtr Mantle scolls  LJU
    DelayCommand(25.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
    DelayCommand(30.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
    DelayCommand(35.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
    DelayCommand(40.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
    DelayCommand(45.0, DestroyAllSpecificInvItems(oPC, "NW_IT_SPARSCR912"));
    // Destroy Gtr Undeaths Eternal Foe  LJU
    DelayCommand(50.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));
    DelayCommand(55.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));
    DelayCommand(60.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));
    DelayCommand(65.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));
    DelayCommand(70.0, DestroyAllSpecificInvItems(oPC, "X1_IT_SPDVSCR901"));
}

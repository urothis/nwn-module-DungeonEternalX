#include "_functions"
#include "db_inc"

void main()
{
    object oPC = GetLastOpenedBy();

    if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC) || GetIsPossessedFamiliar(oPC)) return;

    object oChest = OBJECT_SELF;
    location lLoc   = GetLocation(oPC);
    string sID      = IntToString(dbGetTRUEID(oPC));
    string sChestID = GetLocalString(oChest, "CHEST_ID");
    string sDBName  = "PERSISTENT_CHEST";

    if (sChestID != "" && sChestID != sID) return;

    SetLocalString(oChest, "CHEST_ID", sID);

    object oStorer = RetrieveCampaignObject(sDBName, "DATABASE_ITEM" + sID, lLoc);
    DeleteCampaignVariable(sDBName, "DATABASE_ITEM" + sID);

    object oItem = GetFirstItemInInventory(oStorer);
    while (GetIsObjectValid(oItem))
    {
        CopyItem(oItem, oChest, TRUE);
        Insured_Destroy(oItem);
        oItem = GetNextItemInInventory(oStorer);
    }
    Insured_Destroy(oStorer);
}

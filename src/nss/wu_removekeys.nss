// Script by SecUnder //

void main()
{
   ExecuteScript("_mod_areaexit", OBJECT_SELF);
    object oPC= GetExitingObject();
    object oItem;
    oItem=GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
       if(oItem == GetObjectByTag("nightshade001") || oItem == GetObjectByTag("shardofshadow") || oItem == GetObjectByTag("darkmedallion"))
        {
        DestroyObject(oItem);
        oItem=GetNextItemInInventory(oPC);
        }
        oItem=GetNextItemInInventory(oPC);
    }
}


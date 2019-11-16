//Module onUnequip Event Code

int isCursed(object oItem)
{
    if (!GetIsObjectValid(oItem))
    { return FALSE; }
    if (GetLocalInt(oItem,"ImmediateUncursed"))
    { return FALSE; }
    else if (GetLocalInt(oItem,"Cursed"))
    { return TRUE; }
    else if (GetStringRight(GetTag(oItem),6) == "Cursed")
    { return TRUE; }
    else
    { return FALSE; }
}

//Code by CelestialRyan
void main()
{
    object oItem = GetPCItemLastUnequipped();
    object oPC = GetPCItemLastUnequippedBy();
    if (isCursed(oItem))
    {

        object oCopy = CopyItem(oItem,oPC,TRUE);
        int nSlot = GetLocalInt(oItem,"InventorySlot");
        if (nSlot != -1)
        {
            if (nSlot == INVENTORY_SLOT_RIGHTHAND)
            {
                object oRightHand = GetItemInSlot(nSlot,oPC);
                object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
                if (isCursed(oRightHand))
                {
                    if (isCursed(oLeftHand))
                    {
                        SetLocalInt(oRightHand,"ImmediateUncursed",1);
                        DelayCommand(0.05,AssignCommand(oPC,ActionEquipItem(oCopy,INVENTORY_SLOT_RIGHTHAND)));
                        DelayCommand(0.1,SetLocalInt(oRightHand,"ImmediateUncursed",0));
                    }
                    else
                    {
                        DelayCommand(0.05,AssignCommand(oPC,ActionEquipItem(oCopy,INVENTORY_SLOT_LEFTHAND)));
                    }
                }
                else
                {
                    DelayCommand(0.05,AssignCommand(oPC,ActionEquipItem(oCopy,nSlot)));
                }
            }
            else
            {
                object oCurrent = GetItemInSlot(nSlot,oPC);
                if (isCursed(oCurrent))
                {
                    SetLocalInt(oCurrent,"ImmediateUncursed",1);
                    DelayCommand(0.1,SetLocalInt(oCurrent,"ImmediateUncursed",0));
                }
                DelayCommand(0.05,AssignCommand(oPC,ActionEquipItem(oCopy,nSlot)));
            }
        }
         DestroyObject(oItem,0.01);
    }
}


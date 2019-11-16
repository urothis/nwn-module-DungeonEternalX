//Module onEquip Event

//Code by CelestialRyan
void main()
{
    object oItem = GetPCItemLastEquipped();
    object oPC = GetPCItemLastEquippedBy();
    //AssignCommand(oPC,SpeakString("Item Equipped!",TALKVOLUME_SILENT_SHOUT));
    if ((GetLocalInt(oItem,"Cursed") == 1) || (GetStringRight(GetTag(oItem),6) == "Cursed"))
    {
        effect eCurse = EffectCurse(2,2,2,2,4,2);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eCurse,oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,SupernaturalEffect(EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY)),oPC);
        int nSlot = 0;
        int nSlotEquipped = -1;
        while ((nSlot < 18) && (nSlotEquipped == -1))
        {
            if (GetItemInSlot(nSlot,oPC) == oItem)
            {
                nSlotEquipped = nSlot;
            }
            nSlot++;
        }
        SetLocalInt(oItem,"InventorySlot",nSlotEquipped);
        FloatingTextStringOnCreature(GetName(oPC) + " equipped a cursed item.",oPC);
    }
}


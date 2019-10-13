void main()
{
    object oItem = GetFirstItemInInventory(OBJECT_SELF);
    while(GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(OBJECT_SELF);
    }
    SpeakString("As you close the chest, you heard a *click* and you notice the chest is magically locked again");
    SetLocked(OBJECT_SELF, TRUE);
}

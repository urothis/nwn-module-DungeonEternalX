void main()
{
    if (GetFirstItemInInventory(OBJECT_SELF) == OBJECT_INVALID)
    {
        DestroyObject(OBJECT_SELF, 20.0);
    }
}

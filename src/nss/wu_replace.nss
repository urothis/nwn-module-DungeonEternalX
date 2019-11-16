void Props(object oCreated, object oOld)
{
itemproperty iProp = GetFirstItemProperty(oOld);
while (GetIsItemPropertyValid(iProp))
    {
    AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oCreated);
    iProp = GetNextItemProperty(oOld);
    }
    DestroyObject(oOld);
}

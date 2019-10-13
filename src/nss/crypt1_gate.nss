void main()
{
    if (GetIsPC(GetEnteringObject())==TRUE)
    {
        object oDoor = GetNearestObjectByTag("CRYPT1_GATE");
        ActionOpenDoor(oDoor);
    }
}

void main()
{
    int nTime = GetLocalInt(OBJECT_SELF, "CLOSE_DOOR_TIMER");
    if (!nTime) nTime = 300;
    DelayCommand(IntToFloat(nTime), ActionCloseDoor(OBJECT_SELF));
    if (GetLockLockable(OBJECT_SELF) || GetLockKeyRequired(OBJECT_SELF)) SetLocked(OBJECT_SELF, 1);
}


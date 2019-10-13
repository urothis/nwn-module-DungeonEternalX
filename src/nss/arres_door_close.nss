void main()
{
    DelayCommand(300.0, ActionCloseDoor(OBJECT_SELF));
    if (GetLockLockable(OBJECT_SELF) || GetLockKeyRequired(OBJECT_SELF)) SetLocked(OBJECT_SELF, 1);
}


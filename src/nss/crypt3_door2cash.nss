void main()
{

DelayCommand(30.0,ActionCloseDoor(OBJECT_SELF));
DelayCommand(30.1,SetLocked(OBJECT_SELF,TRUE));
DelayCommand(30.2,PlaySound("as_dr_metmedcl2"));

}

void main()
{
object oR1 = GetObjectByTag("Roulette1");
object oR2 = GetObjectByTag("Roulette2");
object oR3 = GetObjectByTag("Roulette3");
ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
SetLocalInt (oR1,"jump",1);
SetLocalInt (oR2,"jump",1);
SetLocalInt (oR3,"jump",1);
DelayCommand(60.0,SetLocalInt (oR1,"jump",0));
DelayCommand(60.0,SetLocalInt (oR2,"jump",0));
DelayCommand(60.0,SetLocalInt (oR3,"jump",0));
DelayCommand(60.0,ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
}

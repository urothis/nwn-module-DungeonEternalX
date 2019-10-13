void main()
{
    object oPC = GetEnteringObject();
    BlackScreen(oPC);
    DelayCommand(1.0, FadeFromBlack(oPC, FADE_SPEED_SLOW));
    ExecuteScript("_mod_areaenter", OBJECT_SELF);
}

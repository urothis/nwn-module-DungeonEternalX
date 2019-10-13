void main()
{
   ExecuteScript("_mod_areaexit", OBJECT_SELF);
   object oPC = GetExitingObject();
   if(GetIsPC(oPC))
   {
      DeleteLocalInt(oPC, "PORTS_DEACTIVATE");
   }
}

void main() {
   object oPC = GetLastUsedBy();
   string sTag = GetTag(OBJECT_SELF);

   if (GetLocked(OBJECT_SELF))
   {
        FloatingTextStringOnCreature("*Locked*", oPC, TRUE);
        PlaySound("as_dr_locked3");
        return;
   }

   ApplyEffectToObject (DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_DUR_DEATH_ARMOR), oPC);
   if      (sTag=="LEGION_PLANEPORT") sTag = "LEGION_PLANE_WP";
   else if (sTag=="ORDER_PLANEPORT")  sTag = "ORDER_PLANE_WP";
   else if (sTag=="SOLE_PLANEPORT")   sTag = "SOLE_PLANE_WP";
   else if (sTag=="GOD_PLANEPORT")    sTag = "GOD_PLANE_WP";
   else if (sTag=="KB_PLANEPORT")     sTag = "KB_PLANE_WP";
   else if (sTag=="POD_PLANEPORT")    sTag = "POD_PLANE_WP";
   else if (sTag=="DV_PLANEPORT")     sTag = "DV_PLANE_WP";

   location lTarget = GetLocation(GetObjectByTag(sTag));
   DelayCommand(0.5f, AssignCommand(oPC, JumpToLocation(lTarget)));
}

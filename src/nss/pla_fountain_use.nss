void main() 
{
    object oUser = GetLastUsedBy();

     /////////////// START SEED
     SetLocalInt (oUser, "i_TI_LastRest", 0);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE), oUser);
     FloatingTextStringOnCreature("You can now rest again!",oUser,FALSE);
     /////////////// END SEED
}

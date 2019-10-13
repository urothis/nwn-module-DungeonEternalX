void main()
{
object oPC = GetLastPerceived();
object oWP = GetObjectByTag("towerwp");
ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0,3.0);
ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), oPC);
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(9000, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oPC));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), oPC));
DelayCommand(2.0,AssignCommand(oPC,ActionJumpToObject(oWP,FALSE)));
}

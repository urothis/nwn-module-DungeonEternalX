void main()
{
object oPC = GetLastPerceived();
object oWP = GetObjectByTag("towerwp");
ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0,3.0);
GiveGoldToCreature(oPC, 5000000);
DelayCommand(2.0,AssignCommand(oPC,ClearAllActions()));
DelayCommand(2.5,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), oPC));
DelayCommand(3.0,AssignCommand(oPC,ActionJumpToObject(oWP,FALSE)));
}

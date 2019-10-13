void main()
{
object oPC = GetLastUsedBy();
AssignCommand(oPC,ActionMoveToObject(GetObjectByTag("ten4"),FALSE, 0.1));
DelayCommand(0.8,ActionCloseDoor(OBJECT_SELF));
DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_DEATH_ARMOR),oPC));
DelayCommand(2.3,AssignCommand(oPC,ActionJumpToObject(GetObjectByTag("ten1"),FALSE)));
}

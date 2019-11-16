void main()
{
if(GetTag(OBJECT_SELF)=="ValmirBossV" && GetLastSpellCaster()!=OBJECT_SELF)
{
effect eVFX = EffectVisualEffect(VFX_IMP_UNSUMMON);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
DelayCommand(1.0, DestroyObject(OBJECT_SELF));
}
}

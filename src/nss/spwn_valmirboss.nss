void main()
{
SetAILevel(OBJECT_SELF, AI_LEVEL_NORMAL);
if(GetTag(OBJECT_SELF)=="ValmirBossV")
{
effect eVFX = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, OBJECT_SELF);
eVFX = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, OBJECT_SELF);
effect eDarknessInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDarknessInvis, OBJECT_SELF);
effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDarknessInvis, OBJECT_SELF);
}

if(GetTag(OBJECT_SELF)=="ValmirBoss")
{
effect eDarknessInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDarknessInvis, OBJECT_SELF);
effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDarknessInvis, OBJECT_SELF);
}
}

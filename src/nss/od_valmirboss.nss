void main()
{
if(GetTag(OBJECT_SELF)=="ValmirBossV")
{
effect eVFX = EffectVisualEffect(VFX_IMP_UNSUMMON);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
DelayCommand(1.0, DestroyObject(OBJECT_SELF));
}



// ***************************************************************** NEAR DEATH CONTINGENCY **************************************************************************************************
if(GetIsInCombat() && (GetCurrentHitPoints(OBJECT_SELF)<=(GetMaxHitPoints(OBJECT_SELF)/8)) && GetLocalInt(OBJECT_SELF, "NEAR_DEATH_CONTINGENCY")!=1 && GetTag(OBJECT_SELF)=="ValmirBoss")
{
effect eSwing = ExtraordinaryEffect(EffectModifyAttacks(5));
effect eVFX = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_AURA_RED));
effect eLink = EffectLinkEffects(eLink, eSwing);
       eLink = EffectLinkEffects(eLink, eVFX);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 90.00);

eVFX = EffectVisualEffect(VFX_IMP_HASTE);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF));
DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF));
DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF));
eVFX = EffectVisualEffect(VFX_DUR_STONEHOLD);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, OBJECT_SELF, 3.0);

SetLocalInt(OBJECT_SELF, "NEAR_DEATH_CONTINGENCY", 1);
DelayCommand(90.0, SetLocalInt(OBJECT_SELF, "NEAR_DEATH_CONTINGENCY", 0));
}
// ***************************************************************** NEAR DEATH CONTINGENCY **************************************************************************************************
}

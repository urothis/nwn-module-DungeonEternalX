#include "_functions"
#include "string_inc"


void main()
{
   object oTarget = GetEnteringObject();
   if (GetIsPC(oTarget))
   {
      int nDamage = d4(6);
      if(nDamage > 0)
      {
         effect eFire = EffectDamage(nDamage+d6(), DAMAGE_TYPE_FIRE);
         effect eMagic = EffectDamage(nDamage+d6(), DAMAGE_TYPE_MAGICAL);
         effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
         DelayCommand(0.15f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         DelayCommand(0.25f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
         DelayCommand(0.50f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, oTarget));
      }
      FloatingTextStringOnCreature(PickOne("Yeow!","Ouch","Hot Foot!","Sizzle"), oTarget, TRUE);
      ApplyEffectToObject (DURATION_TYPE_TEMPORARY, EffectVisualEffect (VFX_DUR_GHOST_SMOKE), oTarget, RoundsToSeconds(1));
   }
}


//::///////////////////////////////////////////////
//:: OnHit Firedamage
//:: x2_s3_flamgind
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
   OnHit Castspell Fire Damage property for the
   flaming weapon spell (x2_s0_flmeweap).

   We need to use this property because we can not
   add random elemental damage to a weapon in any
   other way and implementation should be as close
   as possible to the book.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-17
//:://////////////////////////////////////////////

void main()
{
  object oTarget = GetSpellTargetObject();

  if (GetIsObjectValid(oTarget))
  {
        // Get Caster Level
        int nLevel = GetCasterLevel(OBJECT_SELF);
        // Assume minimum caster level if variable is not found
        if (nLevel < 1) nLevel = 1;

        int nDmg = d4() + nLevel;

        effect eDmg;
        if      (nDmg < 10) eDmg = EffectVisualEffect(VFX_IMP_FLAME_S);
        else if (nDmg < 20) eDmg = EffectVisualEffect(VFX_IMP_FLAME_M);
        else                eDmg = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);

        eDmg = EffectLinkEffects(eDmg, EffectDamage(nDmg,DAMAGE_TYPE_FIRE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
    }
}

//::///////////////////////////////////////////////
//:: Greater Magic Fang
//:: x0_s0_gmagicfang.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +1 enhancement bonus to attack and damage rolls.
 Also applys damage reduction +1; this allows the creature
 to strike creatures with +1 damage reduction.

 Checks to see if a valid summoned monster or animal companion
 exists to apply the effects to. If none exists, then
 the spell is wasted.

*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   int nCasterLevel = nPureLevel;
   int nPower = GetMin(5 + nPureBonus, (nCasterLevel + 1) / 3);

   if (GetSpellId()==SPELL_MAGIC_FANG) {
      nPower = GetMin(1 + nPureBonus, (nCasterLevel + 1) / 6);
   }

   int nDamagePower = DAMAGE_POWER_PLUS_FIVE;
   switch (nPower) {
      case 1: nDamagePower = DAMAGE_POWER_PLUS_ONE; break;
      case 2: nDamagePower = DAMAGE_POWER_PLUS_TWO; break;
      case 3: nDamagePower = DAMAGE_POWER_PLUS_THREE; break;
      case 4: nDamagePower = DAMAGE_POWER_PLUS_FOUR; break;
      case 5: nDamagePower = DAMAGE_POWER_PLUS_FIVE; break;
   }
   DoMagicFang(nPower, nDamagePower);
}

//::///////////////////////////////////////////////
//:: Greater Magic Weapon
//:: X2_S0_GrMagWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 enhancement bonus per 3 caster levels
  (maximum of +5).
  lasts 1 hour per level
*/

#include "nw_i0_spells"
#include "x2_i0_spells"

void  AddGreaterEnhancementEffectToWeapon(object oMyWeapon, float fDuration, int nBonus) {
   IPSafeAddItemProperty(oMyWeapon, ItemPropertyEnhancementBonus(nBonus), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
}

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
   int nDuration = GetMax(10, nPureLevel);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   int nAmount = GetMin(5, nPureLevel / 3);

   if (GetTag(OBJECT_SELF)=="GEM_GREEN") // Baba Yaga
   {
      nDuration = 30;
      nAmount = 5;
   }

   object oMyWeapon = IPGetTargetedOrEquippedMeleeWeapon();
   object oTarget = GetItemPossessor(oMyWeapon);

   if (GetIsObjectValid(oMyWeapon)) {
     SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
      if (nDuration>0) {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         if (GetMaster(oTarget)==OBJECT_SELF) nAmount += nPureBonus/2;
         AddGreaterEnhancementEffectToWeapon(oMyWeapon, HoursToSeconds(nDuration), nAmount);
      }
   } else {
      FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
   }
}

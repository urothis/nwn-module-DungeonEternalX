//::///////////////////////////////////////////////
//:: Blackstaff
//:: X2_S0_Blckstff
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Adds +4 enhancement bonus, On Hit: Dispel.
*/

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "pure_caster_inc"

void AddBlackStaffEffectOnWeapon (object oTarget, float fDuration, int nPureBonus) {
   int nAttack = 4 + nPureBonus;
   if (oTarget==OBJECT_SELF) {
      int nDC = IP_CONST_ONHIT_SAVEDC_16 + nPureBonus/2;
      IPSafeAddItemProperty(oTarget, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISPELMAGIC, nDC), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   } else {
      nAttack /= 2;
   }
   IPSafeAddItemProperty(oTarget, ItemPropertyEnhancementBonus(nAttack), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE, TRUE);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
   return;
}

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
   int nDuration = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   object oMyWeapon = IPGetTargetedOrEquippedMeleeWeapon();
   if(GetIsObjectValid(oMyWeapon) ) {
      SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
      if (GetBaseItemType(oMyWeapon)==BASE_ITEM_QUARTERSTAFF) {
         if (nDuration>0) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            AddBlackStaffEffectOnWeapon(oMyWeapon, RoundsToSeconds(nDuration),  nPureBonus);
         }
      } else {
         FloatingTextStrRefOnCreature(83620, OBJECT_SELF);  // not a qstaff
      }
   } else {
      FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
   }
}

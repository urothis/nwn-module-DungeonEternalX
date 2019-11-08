//::///////////////////////////////////////////////
//:: Flame Weapon
//:: X2_S0_FlmeWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Gives a melee weapon 1d4 fire damage +1 per caster
  level to a maximum of +10.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System


#include "nw_i0_spells"
#include "x2_i0_spells"
#include "pure_caster_inc"

void AddFlamingEffectToWeapon(object oTarget, float fDuration, int nCasterLevel) {
   // If the spell is cast again, any previous itemproperties matching are removed.
   IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_FIREDAMAGE, nCasterLevel), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
   return;
}

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

    object oMyWeapon = IPGetTargetedOrEquippedMeleeWeapon();
    if (GetStringLeft(GetTag(oMyWeapon), 18) == "EPICITEM_ICESHAPER")
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
    }

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
   int nDuration = 2 * nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   int nCasterLvl = nPureLevel;
   if (nCasterLvl > 10 + nPureBonus) nCasterLvl = 10 + nPureBonus;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   if (GetIsObjectValid(oMyWeapon)) {
      SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
      // haaaack: store caster level on item for the on hit spell to work properly
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
      AddFlamingEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration), nCasterLvl);
   } else {
      FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
   }
}

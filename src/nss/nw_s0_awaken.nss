//::///////////////////////////////////////////////
//:: Awaken
//:: NW_S0_Awaken
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   This spell makes an animal ally more
   powerful, intelligent and robust for the
   duration of the spell.  Requires the caster to
   make a Will save to succeed.
*/
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nInt = d10();
   int nDuration = 24;
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_MAXIMIZE) nInt = 10;
   if (nMetaMagic == METAMAGIC_EMPOWER) nInt += (nInt/2); //Damage/Healing is +50%
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   nInt = GetMin(12, nInt + nPureBonus);
   effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4 + nPureBonus);
   effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4 + nPureBonus);
   effect eInt = EffectAbilityIncrease(ABILITY_WISDOM, nInt + nPureBonus);
   effect eAttack = EffectAttackIncrease(2 + nPureBonus);
   effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

   effect eLink = EffectLinkEffects(eStr, eCon);
   eLink = EffectLinkEffects(eLink, eInt);
   eLink = EffectLinkEffects(eLink, eAttack);
   eLink = SupernaturalEffect(eLink);

   if (GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget) {
      if (!GetHasSpellEffect(SPELL_AWAKEN)) {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_AWAKEN, FALSE));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
      }
   }
}

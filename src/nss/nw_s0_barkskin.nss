//::///////////////////////////////////////////////
//:: [Barkskin]
//:: [NW_S0_BarkSkin.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Enhances the casters Natural AC by an amount
   dependant on the caster's level.
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
   int nCasterLevel = nPureLevel;
   int nBonus;
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = nCasterLevel;

   if(GetHasSpellEffect(SPELL_BARKSKIN, oTarget)) {
       FloatingTextStringOnCreature("Target already has Barkskin!", OBJECT_SELF, FALSE);
       return;
   }

   effect eVis = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
   effect eHead = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
   effect eAC;
   //Signal spell cast at event
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BARKSKIN, FALSE));
   //Enter Metamagic conditions
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   //Determine AC Bonus based Level.
   if (nCasterLevel <= 6) nBonus = 3;
   else if (nCasterLevel <= 12) nBonus = 4;
   else nBonus = 5;
   if (oTarget==OBJECT_SELF || GetMaster(oTarget)==OBJECT_SELF)
      nBonus += nPureBonus;
   else
      nBonus += nPureBonus / 2;

   //Make sure the Armor Bonus is of type Natural
   eAC = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
   effect eLink = EffectLinkEffects(eVis, eAC);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eHead, oTarget);
}

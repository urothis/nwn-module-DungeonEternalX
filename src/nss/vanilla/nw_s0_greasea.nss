//::///////////////////////////////////////////////
//:: Grease: On Enter
//:: NW_S0_GreaseA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creatures entering the zone of grease must make
   a reflex save or fall down.  Those that make
   their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "pure_caster_inc"

void main() {

   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetEnteringObject();
   int nMetaMagic = GetMetaMagicFeat();
   effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
   effect eSlow = EffectMovementSpeedDecrease(GetSlowRate(oTarget));
   effect eLink = EffectLinkEffects(eVis, eSlow);
   float fDelay = GetRandomDelay(1.0, 2.2);
   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
   {
      if (!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) && GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL)!= TRUE)
      {
         //Fire cast spell at event for the target
         SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_GREASE));
         //Spell resistance check
         if(!MyResistSpell(oCaster, oTarget))
         {
            if (NoMonkSpeed(oTarget)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
         }
      }
   }
}

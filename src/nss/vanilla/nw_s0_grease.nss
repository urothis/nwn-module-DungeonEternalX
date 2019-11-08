//::///////////////////////////////////////////////
//:: Grease
//:: NW_S0_Grease.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creatures entering the zone of grease must make
   a reflex save or fall down.  Those that make
   their save have their movement reduced by 1/2.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;
   object oCaster = OBJECT_SELF;
   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables including Area of Effect Object
   effect eAOE = EffectAreaOfEffect(AOE_PER_GREASE);
   location lTarget = GetSpellTargetLocation();
   effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

   int nDuration = 1+GetMin(9, nPureLevel/3);

   object oTrigger = GetNearestObject(OBJECT_TYPE_TRIGGER);
   if (GetIsObjectValid(oTrigger))
   {
      if (GetDistanceBetween(oTrigger, oCaster) < 15.0) nDuration = 1;
   }
   else
   {
      int nMetaMagic = GetMetaMagicFeat();
      if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
   }
   //Create an instance of the AOE Object using the Apply Effect function
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}


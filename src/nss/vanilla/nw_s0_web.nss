//::///////////////////////////////////////////////
//:: Web
//:: NW_S0_Web.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a mass of sticky webs that cling to
    and entangle target who fail a Reflex Save
    Those caught can make a new save every
    round.  Movement in the web is 1/6 normal.
    The higher the creatures Strength the faster
    they move out of the web.
*/
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;
   object oCaster = OBJECT_SELF;
   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eAOE = EffectAreaOfEffect(AOE_PER_WEB);
   location lTarget = GetSpellTargetLocation();
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
   //Apply the AOE object to the specified location
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

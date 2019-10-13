//::///////////////////////////////////////////////
//:: Mass Camoflage
//:: x0_s0_masscamo.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
   +10 hide bonus to all allies in area
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 24, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   // * now setup benefits for allies
   //Apply Impact
   effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
   location lTarget = GetSpellTargetLocation();
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

   effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
   int nMetaMagic = GetMetaMagicFeat();
   effect eHide = EffectSkillIncrease(SKILL_HIDE, 10 + nPureBonus * 2);
   int nDuration = nPureLevel;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

   //Get the first target in the radius around the caster
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
   while(GetIsObjectValid(oTarget)) {
      if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget)) {

         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHide, OBJECT_SELF, TurnsToSeconds(nDuration));

      }
      //Get the next target in the specified area around the caster
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
   }
}










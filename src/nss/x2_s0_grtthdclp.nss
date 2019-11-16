//::///////////////////////////////////////////////
//:: Great Thunderclap
//:: X2_S0_GrtThdclp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a loud noise equivalent to a peal of
// thunder and its acommpanying shock wave. The
// spell has three effects. First, all creatures
// in the area must make Will saves to avoid being
// stunned for 1 round. Second, the creatures must
// make Fortitude saves or be deafened for 1 minute.
// Third, they must make Reflex saves or fall prone.
*/

#include "nw_i0_spells"
#include "x0_i0_spells"

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nDamage = 0;

   float fDelay;
   effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
   effect eStrike = EffectVisualEffect(VFX_IMP_LIGHTNING_M);

   effect eVis  = EffectVisualEffect(VFX_IMP_SONIC);
   effect eVis2 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
   effect eVis3 = EffectVisualEffect(VFX_IMP_STUN);
   effect eDeaf = EffectDeaf();
   effect eKnock = EffectKnockdown();
   effect eStun = EffectDazed(); //EffectStunned();
   effect eShake = EffectVisualEffect(356);
   effect eDam;

   location lTarget = GetSpellTargetLocation();
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, lTarget);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, 2.0f);
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF) {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
         if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_SONIC))
            {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(10)));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_SONIC))
            {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0f));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
            if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_SONIC))
            {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0f));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis3, oTarget, 4.0f));
            }
            if (nPureBonus) {
               nDamage = d6(nPureBonus);
               //nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_SONIC);
               if (nDamage) {
                  eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
               }
               nDamage = d6(nPureBonus);
               //nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_ELECTRICITY);
               if (nDamage) {
                  eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
               }
            }
         }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
   }
}


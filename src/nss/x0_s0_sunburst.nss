//::///////////////////////////////////////////////
//:: Sunburst
//:: X0_S0_Sunburst
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Brilliant globe of heat
// All creatures in the globe are blinded and
// take 6d6 damage
// Undead creatures take 1d6 damage (max 25d6)
// The blindness is permanent unless cast to remove it
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 23 2002
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
float nSize =  RADIUS_SIZE_COLOSSAL;

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oCaster = OBJECT_SELF;
   int nCasterLvl = nPureLevel;
   if (nCasterLvl > 25 + nPureBonus) nCasterLvl = 25 + nPureBonus;

   int nMetaMagic = GetMetaMagicFeat();
   int nDamage = 0;
   float fDelay;
   effect eExplode = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
   effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
   effect eHitVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
   effect eLOS = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
   effect eDam;
   //Get the spell target location as opposed to the spell target.
   location lTarget = GetSpellTargetLocation();

   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eLOS, GetSpellTargetLocation());
   int bDoNotDoDamage = FALSE;

   //Declare the spell shape, size and the location.  Capture the first target object in the shape.
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
   //Cycle through the targets within the spell shape until an invalid object is captured.
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF)) {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUNBURST));
         //This visual effect is applied to the target object not the location as above.  This visual effect
         //represents the flame that erupts on the target not on the ground.
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eHitVis, oTarget);

         if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
            if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) {
               nDamage = MaximizeOrEmpower(6, nCasterLvl, nMetaMagic);
            } else {
               nDamage = MaximizeOrEmpower(6, nCasterLvl/2, nMetaMagic);
            }
            // * if a vampire then destroy it
            if (GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_MALE || GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_FEMALE || GetStringLowerCase(GetSubRace(oTarget)) == "vampire" ) {
               // * if reflex saving throw fails no blindness
               if (!ReflexSave(oTarget, nPureDC, SAVING_THROW_TYPE_SPELL)) {
                  effect eDead = EffectDamage(GetCurrentHitPoints(oTarget));
                  //Apply epicenter explosion on caster
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oTarget);
                  DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDead, oTarget));
                  bDoNotDoDamage = TRUE;
               }
            }
            if (!bDoNotDoDamage) nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_SPELL);
            // * Do damage
            if (nDamage  && !bDoNotDoDamage) {
               eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
               DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
               if (!ReflexSave(oTarget, nPureDC, SAVING_THROW_TYPE_SPELL)) {
                  effect eBlindness = EffectBlindness();
                  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlindness, oTarget);
               }
            }
         }
         bDoNotDoDamage = FALSE;
      }
      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
   }
}

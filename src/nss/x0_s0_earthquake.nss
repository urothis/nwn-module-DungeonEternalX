//::///////////////////////////////////////////////
//:: Earthquake
//:: X0_S0_Earthquake
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: Horn Formula and Effect changed
//:: Level/2 + 1d20
//:: Caped at 16. If Pure Druid, cap is 20
//:: Immobilize Effect, 25% Spellfailure for 2 Rounds

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oCaster = OBJECT_SELF;

   // Is Pure Druid?
   int nIsPureDruid = 0;
   if (GetLevelByClass(CLASS_TYPE_DRUID) && GetIsPureCaster(oCaster))
       nIsPureDruid = 1;

   //Declare major variables

   int nCasterLvl = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   float fDelay;
   float nSize =  RADIUS_SIZE_COLOSSAL;
   effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
   effect eVis = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
   effect eDam;
   effect eShake = EffectVisualEffect(356);
   location lTarget = GetSpellTargetLocation(); //Get the spell target location as opposed to the spell target.

   if (nCasterLvl > 20 + nPureBonus) nCasterLvl = 20 + nPureBonus; //Limit Caster level for the purposes of damage
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, RoundsToSeconds(6));

   //Declare the spell shape, size and the location.  Capture the first target object in the shape.
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE);
   //Cycle through the targets within the spell shape until an invalid object is captured.
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         if (oTarget != oCaster) {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EARTHQUAKE));
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            nDamage = MaximizeOrEmpower(6, nCasterLvl,  GetMetaMagicFeat());
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_ALL);
            if (nDamage > 0) {
               eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
            // Horn Part
            // No Horn if Target has allready Horn or Earthquake effect.
            if (!MyResistSpell(OBJECT_SELF, oTarget, 0.5)
             && !GetHasSpellEffect(SPELL_EARTHQUAKE, oTarget)
             && !GetHasSpellEffect(SPELL_BALAGARNSIRONHORN, oTarget)
             &&  GetObjectType(oTarget) == OBJECT_TYPE_CREATURE){

               int nCasterRoll  = d20();
               int nTargetRoll  = d20();
               int nTargetRanks = GetAbilityScore(oTarget, ABILITY_STRENGTH);
               int nTargetDEX   = GetAbilityScore(oTarget, ABILITY_DEXTERITY);

               if (!GetHasFeat(FEAT_MONK_ENDURANCE, oTarget) && GetLevelByClass(CLASS_TYPE_PALEMASTER, oTarget) < 10){
                  if (GetHasFeat(FEAT_WEAPON_FINESSE, oTarget)){
                     if (nTargetDEX > nTargetRanks) nTargetRanks = nTargetDEX;
                  }
               }

               int nRankCap = (nIsPureDruid == 1) ? 20 : 16;// CasterRank is max 20 if Pure Druid, 16 if not
               int nSpellRanks = GetMin(nRankCap, nPureLevel/2);
               string sMessage = "Ability: " + IntToString(nTargetRanks) + " + " + IntToString(nTargetRoll) + " vs Spell: "
                                 + IntToString(nSpellRanks) + " + " + IntToString(nCasterRoll);
               if (nTargetRanks + nTargetRoll <= nSpellRanks + nCasterRoll) {

                  // Link and Apply Effects
                  int nHornDur = 2; // Disable Effect, Duration in Rounds
                  effect eLink = EffectLinkEffects(EffectCutsceneImmobilize(), EffectSpellFailure(25));
                  eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ENTANGLE));

                  DelayCommand(fDelay+0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW), oTarget));
                  DelayCommand(fDelay+0.5+RoundsToSeconds(nHornDur), ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HASTE), oTarget));
                  DelayCommand(fDelay+0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nHornDur)));

                  sMessage = "Shaken! " + sMessage;
               }
               SendMessageToPC(OBJECT_SELF, sMessage);
               SendMessageToPC(oTarget, sMessage);
            }
         }
      }
      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE);
   }
}

//::///////////////////////////////////////////////
//:: Gedlee's Electric Loop
//:: X2_S0_ElecLoop
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   You create a small stroke of lightning that
   cycles through all creatures in the area of effect.
   The spell deals 1d6 points of damage per 2 caster
   levels (maximum 5d6). Those who fail their Reflex
   saves must succeed at a Will save or be stunned
   for 1 round.

   Spell is standard hostile, so if you use it
   in hardcore mode, it will zap yourself!

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 19 2003
//:://////////////////////////////////////////////


#include "x2_I0_SPELLS"
#include "pure_caster_inc"

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   location lTarget = GetSpellTargetLocation();
   effect   eStrike = EffectVisualEffect(VFX_IMP_LIGHTNING_S);

   int bHasNekrosis;

   if (nPureBonus && HasNekrosis(OBJECT_SELF)) bHasNekrosis = TRUE;

   if (bHasNekrosis) eStrike = EffectVisualEffect(VFX_IMP_DOOM);

   int      nMetaMagic = GetMetaMagicFeat();
   float    fDelay;
   effect   eBeam;
   int      nDamage;
   int      nPotential;
   effect   eDam;
   object   oLastValid;
   effect   eStun = EffectLinkEffects(EffectVisualEffect(VFX_IMP_STUN),EffectStunned());
   int nBlockNegDmg;
   int nNegDmg;
   //--------------------------------------------------------------------------
   // Calculate Damage Dice. 1d per 2 caster levels, max 5d
   //--------------------------------------------------------------------------
   int nNumDice = GetMax(1, nPureLevel/2);
   if (nNumDice > 5 + nPureBonus) nNumDice = 5 + nPureBonus;
   //--------------------------------------------------------------------------
   // Loop through all targets
   //--------------------------------------------------------------------------
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
         if (GetIsObjectValid(oLastValid)) {
            fDelay += 0.2f;
            fDelay += GetDistanceBetweenLocations(GetLocation(oLastValid), GetLocation(oTarget))/20;
         } else {
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
         }
         //------------------------------------------------------------------
         // If there was a previous target, draw a lightning beam between us
         // and iterate delay so it appears that the beam is jumping from
         // target to target
         //------------------------------------------------------------------
         if (GetIsObjectValid(oLastValid)) {
             eBeam = EffectBeam(VFX_BEAM_LIGHTNING, oLastValid, BODY_NODE_CHEST);
             DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam,oTarget,1.5f));
         }
         if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
            nPotential = MaximizeOrEmpower(6, nNumDice, nMetaMagic);
            if (bHasNekrosis) nDamage = GetReflexAdjustedDamage(nPotential, oTarget, nPureDC, SAVING_THROW_TYPE_NEGATIVE);
            else nDamage = GetReflexAdjustedDamage(nPotential, oTarget, nPureDC, SAVING_THROW_TYPE_ELECTRICITY);
            //--------------------------------------------------------------
            // If we failed the reflex save, we save vs will or are stunned for one round
            if (nPotential == nDamage || (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget) &&  nDamage == (nPotential/2))) {
               if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay)) {
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1)));
               }
            }
            if (nDamage > 0)
            {
               eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
               if (bHasNekrosis)
               {
                  if (BlockNegativeDamage(oTarget)) nNegDmg = 0;
                  else nNegDmg = nDamage/2;
                  eDam = EffectLinkEffects(EffectDamage(nNegDmg, DAMAGE_TYPE_NEGATIVE), EffectDamage(nDamage/2, DAMAGE_TYPE_ELECTRICAL));
               }
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eStrike, oTarget));
             }
         }
         //------------------------------------------------------------------
         // Store Target to make it appear that the lightning bolt is jumping from target to target
         oLastValid = oTarget;
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE );
   }
}


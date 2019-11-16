//::///////////////////////////////////////////////
//:: Natures Balance
//:: NW_S0_NatureBal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Reduces the SR of all enemies by 1d4 per 5 caster
   levels for 1 round per 3 caster levels. Also heals
   all friends for 3d8 + Caster Level
   Radius is 15 feet from the caster.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;
   int nDruid    = GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF);

   //Declare major variables
   effect eHeal;
   effect eVis = EffectVisualEffect(VFX_IMP_HEALING_L);
   effect eSR;
   effect eVis2 = EffectVisualEffect(VFX_IMP_BREACH);
   effect eNature = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);

   int nRand;
   int nCasterLevel = nPureLevel;
   int nDuration = nCasterLevel/3;
   int nMetaMagic = GetMetaMagicFeat();
   float fDelay;
   //Set off fire and forget visual
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eNature, GetLocation(OBJECT_SELF));
   //Declare the spell shape, size and the location.  Capture the first target object in the shape.
   if (nMetaMagic == METAMAGIC_EXTEND)  nDuration *= 2;   //Duration is +100%
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE);
   //Cycle through the targets within the spell shape until an invalid object is captured.
   while(GetIsObjectValid(oTarget)) {
      fDelay = GetRandomDelay();
      //Check to see how the caster feels about the targeted object
      if (GetIsFriend(oTarget)) {
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NATURES_BALANCE, FALSE));
           nRand = d8(3 + nPureBonus) + nCasterLevel;
           //Enter Metamagic conditions
           if (nMetaMagic==METAMAGIC_MAXIMIZE) nRand = 8 * (3 + nPureBonus) + nCasterLevel;//Damage is at max
           if (nMetaMagic==METAMAGIC_EMPOWER) nRand += nRand/2; //Damage/Healing is +50%
           eHeal = EffectHeal(nRand);
           //Apply heal effects
           DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
           DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
      } else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NATURES_BALANCE));
         if (!GetIsReactionTypeFriendly(oTarget)) {
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC)) {
                 nCasterLevel /= 5;
                 nRand = d4(nCasterLevel);
                 //Enter Metamagic conditions
                 if (nMetaMagic == METAMAGIC_MAXIMIZE) nRand = 4 * nCasterLevel;//Damage is at max
                 if (nMetaMagic == METAMAGIC_EMPOWER) nRand += (nRand/2); //Damage/Healing is +50%
                 eSR = EffectSpellResistanceDecrease(nRand + nPureBonus);
                 //Apply reduce SR effects
                 DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSR, oTarget, RoundsToSeconds(nDuration)));
                 DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
         }
      }
      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE);
   }
   if (nDruid>10)
   {
      int nDisc = (4*nPureBonus)+2;
      int nConceal = 20 + (5*nPureBonus);

      effect eDisc = EffectSkillIncrease(SKILL_DISCIPLINE, nDisc);
      effect eConc = EffectConcealment( nConceal, MISS_CHANCE_TYPE_NORMAL);

      eDisc = ExtraordinaryEffect(eDisc);
      eConc = ExtraordinaryEffect(eConc);

      float fDur = IntToFloat(nDruid*6);

      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDisc, OBJECT_SELF, fDur);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConc, OBJECT_SELF, fDur);
   }

}


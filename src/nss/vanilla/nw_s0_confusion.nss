//::///////////////////////////////////////////////
//:: [Confusion]
//:: [NW_S0_Confusion.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures within a 15 foot radius must
//:: save or be confused for a number of rounds
//:: equal to the casters level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30 , 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   if (HasVaasa(OBJECT_SELF)) nPureBonus = 8;
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = GetMax(1 + nPureLevel/8, nPureBonus);
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;

   //Declare major variables
   object oTarget;
   effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
   effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
   effect eConfuse = EffectConfused();
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
   float fDelay;
   //Link duration VFX and confusion effects
   effect eLink = EffectLinkEffects(eMind, eConfuse);

   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

   //Search through target area
   oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONFUSION));
         fDelay = GetRandomDelay();
         //Make SR Check and faction check
         if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
            //Make Will Save
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay)) {
               //Apply linked effect and VFX Impact
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
         }
      }
      //Get next target in the shape
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
   }
}


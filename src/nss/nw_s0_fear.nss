//::///////////////////////////////////////////////
//:: [Fear]
//:: [NW_S0_Fear.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes an area of fear that reduces Will Saves
//:: and applies the frightened effect.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 23, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //float fDuration = RoundsToSeconds(1+nPureLevel/10) + nPureBonus;
   int nDuration = 1+GetMin(9, nPureLevel/3);
   int nDamage;
   effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
   effect eFear = EffectFrightened();
   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
   effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
   float fDelay;
   //Link the fear and mind effects
   effect eLink = EffectLinkEffects(eFear, eMind);

   object oTarget;
   //Check for metamagic extend
   if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2;
   //Apply Impact
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
   //Get first target in the spell cone
   oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
   while(GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget!=OBJECT_SELF) {
         fDelay = GetRandomDelay();
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
         //Make SR Check
         if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
            //Make a will save
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay)) {
               //Apply the linked effects and the VFX impact
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
            }
         }
      }
      //Get next target in the spell cone
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
   }
}


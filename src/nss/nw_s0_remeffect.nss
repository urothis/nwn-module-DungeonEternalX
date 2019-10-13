//::///////////////////////////////////////////////
//:: Remove Effects
//:: NW_S0_RemEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Takes the place of
      Remove Disease
      Neutralize Poison
      Remove Paralysis
      Remove Curse
      Remove Blindness / Deafness
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////

// Note by Ness - I don't believe this script is even used by this module anymore.
// ez: it is

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   //Declare major variables
   int nSpellID = GetSpellId();
   object oTarget = GetSpellTargetObject();
   int nEffect1;
   int nEffect2;
   int nEffect3;
   int bAreaOfEffect = FALSE;
   int nSchool;
   float fRadius;

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));

   effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

   //Check for which removal spell is being cast.
   if (nSpellID == SPELL_REMOVE_BLINDNESS_AND_DEAFNESS)
   {
      nEffect1 = EFFECT_TYPE_BLINDNESS;
      nEffect2 = EFFECT_TYPE_DEAF;
      bAreaOfEffect = TRUE;
      fRadius = RADIUS_SIZE_MEDIUM;
      nSchool = SPELL_SCHOOL_DIVINATION;
   }
   else if (nSpellID == SPELL_REMOVE_CURSE)
   {
      nEffect1 = EFFECT_TYPE_CURSE;
      nSchool = SPELL_SCHOOL_ABJURATION;
   }
   else if (nSpellID == SPELL_REMOVE_DISEASE)
   {
      nEffect1 = EFFECT_TYPE_DISEASE;
      nEffect2 = EFFECT_TYPE_ABILITY_DECREASE;
      nSchool = SPELL_SCHOOL_CONJURATION;
   }
   else if (nSpellID == SPELLABILITY_REMOVE_DISEASE)
   {
      SendMessageToPC(OBJECT_SELF, IntToString(nSpellID));
      if (HasVirtueHelm(OBJECT_SELF))
      {
         ExecuteScript("nw_s0_grrestore", OBJECT_SELF);
         return;
      }
      nEffect1 = EFFECT_TYPE_DISEASE;
      nEffect2 = EFFECT_TYPE_ABILITY_DECREASE;
      nSchool = SPELL_SCHOOL_EVOCATION;
   }
   else if (nSpellID == SPELL_NEUTRALIZE_POISON)
   {
      nEffect1 = EFFECT_TYPE_DISEASE;
      nEffect2 = EFFECT_TYPE_ABILITY_DECREASE;
      nEffect3 = EFFECT_TYPE_POISON;
      nSchool = SPELL_SCHOOL_CONJURATION;
   }

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, nSchool);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, nSchool) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   fRadius += IntToFloat(nPureBonus);
   if (nPureBonus > 4) bAreaOfEffect = TRUE;

   if (bAreaOfEffect)
   {
      effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
      effect eLink;
      spellsGenericAreaOfEffect(OBJECT_SELF, GetSpellTargetLocation(), SHAPE_SPHERE, fRadius,
         nSpellID, eImpact, eLink, eVis, DURATION_TYPE_INSTANT, 0.0, SPELL_TARGET_ALLALLIES, FALSE, TRUE, nEffect1, nEffect2, nEffect3);
      return;
   }

   //Remove effects
   RemoveSpecificEffect(nEffect1, oTarget);
   if(nEffect2 != 0)
   {
      RemoveSpecificEffect(nEffect2, oTarget);
   }
   if(nEffect3 != 0)
   {
      RemoveSpecificEffect(nEffect3, oTarget);
   }
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   DelayCommand(0.1, ReapplyPermaHaste(oTarget));
}



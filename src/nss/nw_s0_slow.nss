//::///////////////////////////////////////////////
//:: Slow
//:: NW_S0_Slow.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Character can take only one partial action
   per round.
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget;
   effect eSlow = EffectSlow();

   effect eVis    = EffectVisualEffect(VFX_IMP_SLOW);
   effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
   int nMetaMagic = GetMetaMagicFeat();

   //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
   int nDuration   = nPureLevel;
   int nLevel      = nDuration;
   int nCount      = 0;
   location lSpell = GetSpellTargetLocation();

   //Metamagic check for extend
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%

   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

   //Declare the spell shape, size and the location.  Capture the first target object in the shape.
   oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);

   //Cycle through the targets within the spell shape until an invalid object is captured or the number of
   //targets affected is equal to the caster level.
   float fDuration = RoundsToSeconds(nDuration);
   while(GetIsObjectValid(oTarget) && nCount < nLevel)
   {
      if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
      {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLOW));
         if (!MyResistSpell(OBJECT_SELF, oTarget))
         {
             if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC))
             {
                 if (NoMonkSpeed(oTarget))
                 {
                     DelayCommand(0.1, ReapplyPermaHaste(oTarget, fDuration + 0.5));
                     //Apply the slow effect and VFX impact
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, fDuration);
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     //Count the number of creatures affected
                     nCount++;
                 }
             }
         }
      }
      //Select the next target within the spell shape.
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
   }
}


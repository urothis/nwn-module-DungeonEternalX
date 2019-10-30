//::///////////////////////////////////////////////
//:: Sleep
//:: NW_S0_Sleep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Goes through the area and sleeps the lowest 2d4
   HD of creatures first.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget;
   object oLowest;
   effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
   effect eSleep  =  EffectSleep();
   effect eMind   = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
   effect eVis    = EffectVisualEffect(VFX_IMP_SLEEP);

   effect eLink = EffectLinkEffects(eSleep, eMind);

    // * Moved the linking for the ZZZZs into the later code
    // * so that they won't appear if creature immune

   int bContinueLoop;
   int nHD = 4 + d4(1 + nPureBonus);
   int nMetaMagic = GetMetaMagicFeat();
   int nCurrentHD;
   int bAlreadyAffected;
   int nMax = 9 + nPureBonus;// maximun hd creature affected
   int nLow;
   int nDuration = GetMax(1 + nPureLevel/4, nPureBonus);

   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
   string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);

   //Enter Metamagic conditions
   if (nMetaMagic == METAMAGIC_MAXIMIZE) nHD = 4 + 4 * (1 + nPureBonus);
   if (nMetaMagic == METAMAGIC_EMPOWER) nHD += (nHD/2);
   else if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%

   //Get the first target in the spell area
   oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());

   //If no valid targets exists ignore the loop
   if (GetIsObjectValid(oTarget)) bContinueLoop = TRUE;

   // The above checks to see if there is at least one valid target.
   while ((nHD > 0) && (bContinueLoop))
   {
      nLow = nMax;
      bContinueLoop = FALSE;
      //Get the first creature in the spell area
      oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
      while (GetIsObjectValid(oTarget))
      {
         //Make faction check to ignore allies
         if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
            && GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
         {
            //Get the local variable off the target and determined if the spell has already checked them.
            bAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
            if (!bAlreadyAffected)
            {
               //Get the current HD of the target creature
               nCurrentHD = GetHitDice(oTarget);
               //Check to see if the HD are lower than the current Lowest HD stored and that the
               //HD of the monster are lower than the number of HD left to use up.
               if (nCurrentHD < nLow && nCurrentHD <= nHD && nCurrentHD < 6)
               {
                  nLow = nCurrentHD;
                  oLowest = oTarget;
                  bContinueLoop = TRUE;
               }
            }
         }
         //Get the next target in the shape
         oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
      }
      //Check to see if oLowest returned a valid object
      if(oLowest != OBJECT_INVALID)
      {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLEEP));

         //Make SR check
         if (!MyResistSpell(OBJECT_SELF, oLowest))
         {
            //Make Fort save
            if(!MySavingThrow(SAVING_THROW_WILL, oLowest, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
               //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest);
               if (GetIsImmune(oLowest, IMMUNITY_TYPE_SLEEP) == FALSE)
               {
                  effect eLink2 = EffectLinkEffects(eLink, eVis);
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oLowest, RoundsToSeconds(nDuration));
               }
               else   // * even though I am immune apply just the sleep effect for the immunity message
               {
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oLowest, RoundsToSeconds(nDuration));
               }

            }
         }
      }
      //Set a local int to make sure the creature is not used twice in the pass.  Destroy that variable in 0.5 seconds to remove it from the creature
      SetLocalInt(oLowest, sSpellLocal, TRUE);
      DelayCommand(0.5, SetLocalInt(oLowest, sSpellLocal, FALSE));
      DelayCommand(0.5, DeleteLocalInt(oLowest, sSpellLocal));
      //Remove the HD of the creature from the total
      nHD = nHD - GetHitDice(oLowest);
      oLowest = OBJECT_INVALID;
   }
}

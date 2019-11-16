//::///////////////////////////////////////////////
//:: Power Word, Kill
//:: NW_S0_PWKill
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// When power word, kill is uttered, you can either
// target a single creature or let the spell affect a
// group.
// If power word, kill is targeted at a single creature,
// that creature dies if it has 100 or fewer hit points.
// If the power word, kill is cast as an area spell, it
// kills creatures in a 15-foot-radius sphere. It only
// kills creatures that have 20 or fewer hit points, and
// only up to a total of 200 hit points of such
// creatures. The spell affects creatures with the lowest.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget = GetSpellTargetObject();
   int nDamageDealt = 0;
   int nHitpoints;
   int nMin;
   int nMaxHP = 100 + nPureBonus * 10;

   object oWeakest;
   effect eDeath  = EffectDeath();
   effect eVis    = EffectVisualEffect(VFX_IMP_DEATH);
   effect eWord   = EffectVisualEffect(VFX_FNF_PWKILL);
   float fDelay;
   int bKill;

   //Apply the VFX impact
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWord, GetSpellTargetLocation());

   //Check for the single creature or area targeting of the spell
   if (GetIsObjectValid(oTarget))
   {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
      {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POWER_WORD_KILL));
         if (GetCurrentHitPoints(oTarget) <= nMaxHP)
         {
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
               //Apply the death effect and the VFX impact
               ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
         }
      }
   }
   else
   {
      nMaxHP *= 2;
      while (nDamageDealt < nMaxHP)
      {
         //Set nMin higher than the highest HP amount allowed
         nMin = 25 + nPureBonus * 5;
         oWeakest = OBJECT_INVALID;
         //Get the first target in the spell area
         oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
         while (GetIsObjectValid(oTarget))
         {
            //Make sure the target avoids all allies.
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
               bKill = GetLocalInt(oTarget, "NW_SPELL_PW_KILL_" + GetTag(OBJECT_SELF));

               //Get the HP of the current target
               nHitpoints = GetCurrentHitPoints(oTarget);

               //Check if the currently selected target is lower in HP than the weakest stored creature
               if ((nHitpoints < nMin) && ((nHitpoints > 0) && (nHitpoints <= (20 + nPureBonus * 5))) && bKill == FALSE)
               {
                  nMin = nHitpoints;
                  oWeakest = oTarget;
               }
            }
            //Get next target in the spell area
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
         }
         //If no weak targets are available then break out of the loop
         if (!GetIsObjectValid(oWeakest))
         {
           nDamageDealt = nMaxHP;
         }
         else
         {
            fDelay = GetRandomDelay(0.75, 2.0);
            SetLocalInt(oWeakest, "NW_SPELL_PW_KILL_" + GetTag(OBJECT_SELF), TRUE);

            //Fire cast spell at event for the specified target
            SignalEvent(oWeakest, EventSpellCastAt(OBJECT_SELF, SPELL_POWER_WORD_KILL));

            //SR Check
            if (!MyResistSpell(OBJECT_SELF, oWeakest))
            {
               //Apply the VFX impact and death effect
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oWeakest));
               if (!GetIsImmune(oWeakest, IMMUNITY_TYPE_DEATH))
               {
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oWeakest));
               }
               //Add the creatures HP to the total
               nDamageDealt = nDamageDealt + nMin;
               string sTag = "NW_SPELL_PW_KILL_" + GetTag(OBJECT_SELF);
               DelayCommand(fDelay + 0.25, DeleteLocalInt(oWeakest, sTag));
            }
         }
      }
   }
}

/* This script must be named nw_s0_timestop it is case
sensitive */

//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Modified Time Stop
//:://////////////////////////////////////////////
/*
All within 50m of caster have to make a willsave
or be paralyzed (sans animation) for 6 seconds.

Modified with nPureBonus + will save.  Time stop cannot
be stopped by Mind Immunity. Now makes SR checks.

--Arres
*/
#include "nw_i0_spells"
#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void DoTimeStop (object oTarget, float fDuration)
{
   effect eParalyze = EffectCutsceneParalyze();
   effect eFreeze = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
   eFreeze = EffectLinkEffects(eFreeze, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED));
   effect eLink = EffectLinkEffects(eParalyze, eFreeze);
   eParalyze = SupernaturalEffect(eLink);

   ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eParalyze, oTarget, fDuration );
}

void RemoveTimeStopTimeout(object oCaster)
{
   SetLocalInt(oCaster, "TIME_STAMP_TIMEOUT", 0);
   FloatingTextStringOnCreature("Time Stop ok", oCaster);
}

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC = GetSpellSaveDC() + nPureBonus;
   float fPureBonus = IntToFloat(nPureBonus);

   if (GetLocalInt(OBJECT_SELF, "TIME_STAMP_TIMEOUT"))
   {
      FloatingTextStringOnCreature("Time Stop energy spent...", OBJECT_SELF);
      return;
   }

   SetLocalInt(OBJECT_SELF, "TIME_STAMP_TIMEOUT", 1);
   float fNextCast = 60.0;

   AssignCommand(OBJECT_SELF, DelayCommand(fNextCast, RemoveTimeStopTimeout(OBJECT_SELF)));

   string sMyString;
   location lLocation = GetSpellTargetLocation();
   float fDuration = 6.0;
   float fRadius = 40.0;// before 20
   object oTarget;
   effect eVis;

   eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
   oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocation, FALSE, OBJECT_TYPE_CREATURE );

   while (GetIsObjectValid(oTarget))
   {
      if (oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
      {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));
         if (!MyResistSpell(OBJECT_SELF, oTarget))
         {
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_NONE))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP));
                DoTimeStop(oTarget, fDuration);
            }
         }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocation, TRUE, OBJECT_TYPE_CREATURE);
   }
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
}

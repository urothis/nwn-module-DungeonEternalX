//::///////////////////////////////////////////////
//:: Stinking Cloud On Enter
//:: NW_S0_StinkCldA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Those within the area of effect must make a
   fortitude save or be dazed.
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"

void main()
{

   //Declare major variables
   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eStink = EffectDazed();
   effect eMind  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
   effect eLink  = EffectLinkEffects(eMind, eStink);

   effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
   object oTarget;
   float fDelay;

   //Get the first object in the persistant area
   oTarget = GetEnteringObject();
   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
   {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STINKING_CLOUD));
      //Make a SR check
      if (!MyResistSpell(oCaster, oTarget))
      {
         if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_POISON, oCaster))
         {
            fDelay = GetRandomDelay(0.75, 1.75);
            if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
            {
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
            }
         }
      }
   }
}

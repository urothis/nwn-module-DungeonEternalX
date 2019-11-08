//::///////////////////////////////////////////////
//:: Stinking Cloud
//:: NW_S0_StinkCldC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Those within the area of effect must make a
   fortitude save or be dazed.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"

void main()
{

   object oCaster = GetAreaOfEffectCreator();

   if (!GetIsObjectValid(oCaster))  // CASTER GONE, KILL AOE
   {
      DestroyObject(OBJECT_SELF);
      return;
   }

   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eStink = EffectDazed();
   effect eMind  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
   effect eLink  = EffectLinkEffects(eMind, eStink);

   effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
   effect eFind;
   object oTarget;
   float fDelay;

   oTarget = GetFirstInPersistentObject();
   while (GetIsObjectValid(oTarget))
   {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
      {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STINKING_CLOUD));
         if (!MyResistSpell(oCaster, oTarget))
         {
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_POISON, oCaster))
            {
               fDelay = GetRandomDelay(0.75, 1.75);
               if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE) {
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
               }
            }
            else   //If the Fort save was successful remove the Dazed effect
            {
               eFind = GetFirstEffect(oTarget);
               while (GetIsEffectValid(eFind))
               {
                  if (eFind==EffectDazed() && GetEffectCreator(eFind)==oCaster) RemoveEffect(oTarget, eFind);
                  eFind = GetNextEffect(oTarget);
               }
            }
         }
      }
      oTarget = GetNextInPersistentObject();
   }
}

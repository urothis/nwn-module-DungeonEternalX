//::///////////////////////////////////////////////
//:: Phantasmal Killer
//:: NW_S0_PhantKill
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Target of the spell must make 2 saves or die.
*/

#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

int MySavingThrow2(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);


void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nDice      = 3 + nPureBonus/2;
   int nDamage    = d6(nDice);
   int nMetaMagic = GetMetaMagicFeat();

   object oTarget = GetSpellTargetObject();

   effect eDam;
   effect eVis  = EffectVisualEffect(VFX_IMP_DEATH);
   effect eVis2 = EffectVisualEffect(VFX_IMP_SONIC);

   if (!GetIsReactionTypeFriendly(oTarget))
   {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PHANTASMAL_KILLER));
      if (!MyResistSpell(OBJECT_SELF, oTarget))
      {
         if (!MySavingThrow2(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS))
         {
            // Immunity to fear, makes you immune to Phantasmal Killer.
            if (!GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR))
            {
               //Make a Fort save
               if (MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_DEATH))
               {
                  //Check for metamagic
                  if (nMetaMagic==METAMAGIC_MAXIMIZE) nDamage = 6 * nDice;
                  if (nMetaMagic==METAMAGIC_EMPOWER) nDamage += nDamage/2;
                  eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
               }
               else
               {
                  // Immunity to death magic, should not make you immune to Phantasmal Killer So we make the effect supernatural.
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);
               }
            }
         }
      }
   }
}

int MySavingThrow2(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
   nDC = GetMax(1, GetMin(255, nDC));
   effect eVis;
   int bValid = FALSE;
   int nSpellID;

   if (nSavingThrow == SAVING_THROW_FORT)
   {
      bValid = FortitudeSave(oTarget, nDC, nSaveType, oSaveVersus);
      if (bValid == 1) eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
   }
   else if (nSavingThrow == SAVING_THROW_REFLEX)
   {
      bValid = ReflexSave(oTarget, nDC, nSaveType, oSaveVersus);
      if (bValid == 1) eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
   }
   else if (nSavingThrow == SAVING_THROW_WILL)
   {
      bValid = WillSave(oTarget, nDC, nSaveType, oSaveVersus);
      if (bValid == 1) eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
   }
   nSpellID = GetSpellId();
   /*
      return 0 = FAILED SAVE
      return 1 = SAVE SUCCESSFUL
      return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
   */
   if (bValid == 0)
   {
      if ((nSaveType==SAVING_THROW_TYPE_DEATH || nSpellID==SPELL_WEIRD || nSpellID==SPELL_FINGER_OF_DEATH) && nSpellID!=SPELL_HORRID_WILTING)
      {
         eVis = EffectVisualEffect(VFX_IMP_DEATH);
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
      }
   }
   if(bValid == 1 || bValid == 2)
   {
      if (bValid == 2) eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
   }
   return bValid;
}

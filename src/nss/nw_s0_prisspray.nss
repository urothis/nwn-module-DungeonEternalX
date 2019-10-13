//::///////////////////////////////////////////////
//:: Prismatic Spray
//:: [NW_S0_PrisSpray.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Sends out a prismatic cone that has a random
//:: effect for each target struck.
//:://////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//  ApplyPrismaticEffect
///////////////////////////////////////////////////////////////////////////////
/*  Given a reference integer and a target, this function will apply the effect
   of corresponding prismatic cone to the target.  To have any effect the
   reference integer (nEffect) must be from 1 to 7.*/
///////////////////////////////////////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

int ApplyPrismaticEffect(int nEffect, object oTarget, int nPureDC, int nPureBonus)
{
   int nDamage;
   effect ePrism;
   effect eVis;
   effect eLink;
   int nVis;
   float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
   //Based on the random number passed in, apply the appropriate effect and set the visual to
   //the correct constant
   switch (nEffect) {
      case 1://fire
         nDamage = nPureDC;
         nVis = VFX_IMP_FLAME_S;
         nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE);
         ePrism = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
         break;
      case 2: //Acid
         nDamage = nPureDC * 2;
         nVis = VFX_IMP_ACID_L;
         nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_ACID);
         ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
         break;
      case 3: //Electricity
         nDamage = nPureDC * 3;
         nVis = VFX_IMP_LIGHTNING_S;
         nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_ELECTRICITY);
         ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
         break;
      case 4: //Poison
         {
         effect ePoison = EffectPoison(POISON_BEBILITH_VENOM);
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget));
         }
         break;
      case 5: //Paralyze
         {
            effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
            if(MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC)==0)
            {
               ePrism = EffectParalyze();
               eLink = EffectLinkEffects(eDur2, ePrism);
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4+nPureBonus)));
            }
         }
         break;
      case 6: //Confusion
         {
             effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
             ePrism = EffectConfused();
             eLink = EffectLinkEffects(eMind, ePrism);
             if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
             {
                nVis = VFX_IMP_CONFUSION_S;
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4+nPureBonus)));
             }
         }
         break;
      case 7: //Death
         if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
         {
            ePrism = EffectDeath();
         }
         else
         {
            nVis = VFX_FNF_GAS_EXPLOSION_EVIL;
            int nDam;
            if (!BlockNegativeDamage(oTarget)) nDam = nPureDC;

            ePrism = EffectDamage(nDam, DAMAGE_TYPE_NEGATIVE);
         }
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
         break;
   }
   return nVis;
}


void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget;
   int nCasterLevel = nPureLevel;
   int nMetaMagic = GetMetaMagicFeat();
   int nRandom;
   int nHD;
   int nVisual;
   effect eVisual;
   int bTwoEffects;

   //Set the delay to apply to effects based on the distance to the target
   float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;

   //Get first target in the spell area
   oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, GetSpellTargetLocation());
   while (GetIsObjectValid(oTarget))
   {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
      {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRISMATIC_SPRAY));

         //Make an SR check
         if (!MyResistSpell(OBJECT_SELF, oTarget))
         {
            if (oTarget != OBJECT_SELF)
            {
               //Blind the target if they are less than 9 HD
               nHD = GetHitDice(oTarget);
               if (nHD <= 8 + nPureBonus) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(nCasterLevel));

               //Determine if 1 or 2 effects are going to be applied
               nRandom = d8() + nPureBonus / 4;
               if(nRandom > 7)
               {
                  nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget, nPureDC, nPureBonus);
                  nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget, nPureDC, nPureBonus);
               }
               else
               {
                  //Get the visual effect
                   nVisual = ApplyPrismaticEffect(nRandom, oTarget, nPureDC, nPureBonus);
               }
               //Set the visual effect
               if(nVisual != 0)
               {
                  eVisual = EffectVisualEffect(nVisual);
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
               }
            }
         }
      }
      //Get next target in the spell area
      oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, GetSpellTargetLocation());
   }
}


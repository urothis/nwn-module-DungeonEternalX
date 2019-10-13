//::///////////////////////////////////////////////
//:: Weird
//:: NW_S0_Weird
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All enemies in LOS of the spell must make 2 saves or die.
   Even IF the fortitude save is succesful, they will still take
   3d6 damage.
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget;
   effect eDam;
   effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
   effect eVis2 = EffectVisualEffect(VFX_IMP_DEATH);
   effect eWeird = EffectVisualEffect(VFX_FNF_WEIRD);
   effect eAbyss = EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10);
   int nCasterLvl = GetCasterLevel(OBJECT_SELF);
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   int nDice = 3 + nPureBonus;
   float fDelay;

   //Apply the FNF VFX impact
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWeird, GetSpellTargetLocation());

   //Get the first target in the spell area
   oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);

   while (GetIsObjectValid(oTarget))
   {
      //Make a faction check
      if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
      {
         fDelay = GetRandomDelay(3.0, 4.0);
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WEIRD));
         if (!MyResistSpell(OBJECT_SELF, oTarget))
         {
            //if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS,OBJECT_SELF) && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR,OBJECT_SELF))
            //{
               if (GetCurrentHitPoints(oTarget) >= 100 + (nPureBonus*10))
               {
                  if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                  {
                     if (MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                     {
                        nDamage = d6(nDice);
                        if (nMetaMagic==METAMAGIC_MAXIMIZE) nDamage = 6 * nDice;
                        if (nMetaMagic==METAMAGIC_EMPOWER) nDamage += nDamage/2;
                        eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                     }
                     else
                     {
                        // * I failed BOTH saving throws. Now I die.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget));
                     }
                  }
               }
               else
               {
                   // * I have less than the hitpoint threshold, I die.
                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget));
               }
            //}
         }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);
   }
}

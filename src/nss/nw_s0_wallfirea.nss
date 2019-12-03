//::///////////////////////////////////////////////
//:: Wall of Fire: On Enter
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Person within the AoE take 4d6 fire damage
   per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "pure_caster_inc"

void main()
{

   //Declare major variables
   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   int nDamage;
   effect eDam;
   object oTarget;

   //Declare and assign personal impact visual effect.
   effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

   //Capture the first target object in the shape.
   oTarget = GetEnteringObject();
   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
   {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));
      //Make SR check, and appropriate saving throw(s).
      if (!MyResistSpell(oCaster, oTarget))
      {
         //Roll damage.
         nDamage = d6(4 + nPureBonus);
         //Enter Metamagic conditions
         if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * (4 + nPureBonus);//Damage is at max
         if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
         nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nPureDC, SAVING_THROW_TYPE_FIRE);
         if(nDamage > 0)
         {
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         }
      }
   }
}
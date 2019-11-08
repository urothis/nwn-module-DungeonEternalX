//::///////////////////////////////////////////////
//:: Vampiric Touch
//:: NW_S0_VampTch
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   drain 1d6
   HP per 2 caster levels from the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

#include "x0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_NECROMANCY) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   int nMetaMagic = GetMetaMagicFeat();

   int nDDice     = GetMin(10, GetMax(1, nPureLevel/2));
   int nDamage    = d6(nDDice + nPureBonus/2);
   int nDuration  = nPureLevel/2;

   if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * (nDDice + nPureBonus/2);
   if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2);
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

   //--------------------------------------------------------------------------
   //Limit damage to max hp + 10
   //--------------------------------------------------------------------------
   nDamage = GetMin(GetCurrentHitPoints(oTarget) + 10, nDamage);
   if (BlockNegativeDamage(oTarget)) nDamage = 0;
   effect eHeal = EffectTemporaryHitpoints(nDamage);

   effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
   effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
   effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
   if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
   {
      if (!GetIsReactionTypeFriendly(oTarget) && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
         !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
      {
         SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, FALSE));
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VAMPIRIC_TOUCH, TRUE));
         if (TouchAttackMelee(oTarget,GetSpellCastItem() == OBJECT_INVALID)>0)
         {
            if(MyResistSpell(OBJECT_SELF, oTarget) == 0)
            {
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, OBJECT_SELF);
               RemoveTempHitPoints();
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, OBJECT_SELF, HoursToSeconds(nDuration));
             }
         }
      }
   }
}

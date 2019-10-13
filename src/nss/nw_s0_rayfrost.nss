//::///////////////////////////////////////////////
//:: Ray of Frost
//:: [NW_S0_RayFrost.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   If the caster succeeds at a ranged touch attack
   the target takes 1d4 damage.
*/

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   object oTarget   = GetSpellTargetObject();
   int nMetaMagic   = GetMetaMagicFeat();
   int nCasterLevel = nPureLevel;
   int nDam         = d4(1 + nPureBonus) + 1;

   if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 4 * (1 + nPureBonus) + 1;
   if (nMetaMagic == METAMAGIC_EMPOWER) nDam += nDam/2; //Damage/Healing is +50%
   effect eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);

   if (!GetIsReactionTypeFriendly(oTarget))
   {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));
      eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
      if (!MyResistSpell(OBJECT_SELF, oTarget))
      {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_COLD), oTarget);
      }
   }
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}

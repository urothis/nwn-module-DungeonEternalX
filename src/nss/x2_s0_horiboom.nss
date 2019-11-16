//::///////////////////////////////////////////////
//:: Horizikaul's Boom
//:: X2_S0_HoriBoom
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You blast the target with loud and high-pitched
// sounds. The target takes 1d4 points of sonic
// damage per two caster levels (maximum 5d4) and
// must make a Will save or be deafened for 1d4
// rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 22, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();
   int nCasterLvl = nPureLevel;
   if (nCasterLvl > 5 + nPureBonus) nCasterLvl = 5 + nPureBonus;

   int nRounds = GetMax(d4(1), nPureBonus/2);
   int nMetaMagic = GetMetaMagicFeat();
   effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
   effect eDeaf = EffectDeaf();

   if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))  {
      if (!MyResistSpell(OBJECT_SELF, oTarget)) {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
         //Roll damage
         int nDam = d4(nCasterLvl);
         //Enter Metamagic conditions
         if (nMetaMagic == METAMAGIC_MAXIMIZE) nDam = 4 * nCasterLvl; //Damage is at max
         if (nMetaMagic == METAMAGIC_EMPOWER) nDam += nDam/2; //Damage/Healing is +50%
         //Set damage effect
         effect eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);
         //Apply the MIRV and damage effect
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

         if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(nRounds));
         }
      }
   }
}

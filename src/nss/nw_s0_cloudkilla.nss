//::///////////////////////////////////////////////
//:: Cloudkill: On Enter
//:: NW_S0_CloudKillA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   All creatures with 3 or less HD die, those with
   4 to 6 HD must make a save Fortitude Save or die.
   Those with more than 6 HD take 1d10 Poison damage
   every round.
*/

#include "X0_I0_SPELLS"
#include "pure_caster_inc"

void main() {

   //Declare major variables
   object oCaster = GetAreaOfEffectCreator();
   int nPureBonus = GetPureCasterBonus(oCaster, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(oCaster, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetEnteringObject();
   if (GetIsDM(oTarget)) return; // cutscene affect DMs
   effect eImmobilize = EffectCutsceneImmobilize();
   effect eNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
   effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);
   effect eLink = EffectLinkEffects(eHand, eImmobilize);

   int nDamage = d8(4 + nPureLevel/8 + nPureBonus);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 8 * (4 + nPureLevel/8 + nPureBonus);//Damage is at max
   if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2); //Damage/Healing is +50%
   effect eDam;
   if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , oCaster)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));
      //Make SR Check
      if(!MyResistSpell(oCaster, oTarget) && oTarget != oCaster) {
         float fDelay = GetRandomDelay();
         if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_ACID, oCaster, fDelay)) {
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);
                if (MySavingThrow(SAVING_THROW_FORT, oTarget, nPureDC, SAVING_THROW_TYPE_ACID, oCaster, fDelay) != 1)
                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
         }
         else {
         eDam = EffectDamage(nDamage/2, DAMAGE_TYPE_ACID);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);
         }
      }
   }
}

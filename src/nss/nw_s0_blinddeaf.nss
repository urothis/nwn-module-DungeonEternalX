//::///////////////////////////////////////////////
//:: Blindness and Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ENCHANTMENT) + nPureBonus;


    int nSavingThrow = SAVING_THROW_FORT;
    if (HasVaasa(OBJECT_SELF))
    {
        nPureBonus = 8;
        nSavingThrow = SAVING_THROW_WILL;
    }

    int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major varibles
   object oTarget = GetSpellTargetObject();
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = nPureLevel;
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;

   effect eBlind =  EffectBlindness();
   effect eDeaf = EffectDeaf();
   effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

   effect eLink = EffectLinkEffects(eBlind, eDeaf);
   if(!GetIsReactionTypeFriendly(oTarget))
   {
      //Fire cast spell at event
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDNESS_AND_DEAFNESS));
      //Do SR check
      if (!MyResistSpell(OBJECT_SELF, oTarget))
      {
         // Make Fortitude save to negate
         if (!MySavingThrow(nSavingThrow, oTarget, nPureDC))
         {
            //Metamagic check for duration
            //Apply visual and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         }
      }
   }
}

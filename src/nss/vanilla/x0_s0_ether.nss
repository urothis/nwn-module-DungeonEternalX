//::///////////////////////////////////////////////
//:: Etherealness
//:: x0_s0_ether.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Like sanctuary except almost always guaranteed
   to work.
   Lasts one turn per level.
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   /*
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_TRANSMUTATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   effect eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
   //effect eSanc = EffectEthereal();
   effect eSanc = EffectSanctuary(nPureDC);

   effect eLink = EffectLinkEffects(eVis, eSanc);

   int nDuration = 1+GetMin(9, nPureLevel/3);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREALNESS, FALSE));
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
   */
   object oPC = GetSpellTargetObject();
   SendMessageToPC(oPC, "Disabled spell");

}




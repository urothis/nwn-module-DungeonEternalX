//::///////////////////////////////////////////////
//:: True Seeing
//:: NW_S0_TrueSee.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The creature can seen all invisible, sanctuared,
   or hidden opponents.
*/

#include "x0_i0_spells"
#include "nw_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   object oTarget = GetSpellTargetObject();

   // Fix: Player was able to remove TTS with casting TS on enemy
   if (GetIsEnemy(OBJECT_SELF, oTarget)) return;

   int nListen = GetSkillRank(SKILL_LISTEN, oTarget);
   int nSpot   = GetSkillRank(SKILL_SPOT, oTarget);
   int nTTS    = FALSE;

   if (nListen >= 65 || nSpot >= 65)
   {
      nTTS = TRUE;
   }
   else if (nPureBonus > 2 && oTarget == OBJECT_SELF)
   {
      nTTS = TRUE;
   }

   effect eSight;
   effect eUV  = ExtraordinaryEffect(EffectUltravision());
   effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);

   if (nTTS) eSight = EffectTrueSeeing();
   else eSight = EffectSeeInvisible();

   eSight = EffectLinkEffects(eVis, eSight);

   //Fire cast spell at event for the specified target
   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TRUE_SEEING, FALSE));
   int nDuration = nPureLevel;
   if (GetMetaMagicFeat()==METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

   RemoveEffectsFromSpell(oTarget, SPELL_TRUE_SEEING);
   RemoveEffectsFromSpell(oTarget, SPELL_SEE_INVISIBILITY);
   RemoveEffectsFromSpell(oTarget, SPELL_DARKVISION);
   // RemoveEffectsFromSpell(oTarget, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE);
   // RemoveEffectsFromSpell(oTarget, SPELL_AMPLIFY);
   RemoveEffectsFromSpell(oTarget, SPELL_DARKNESS);

   //Apply the VFX impact and effects
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSight, oTarget, TurnsToSeconds(nDuration));
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUV, oTarget, TurnsToSeconds(nDuration));
}


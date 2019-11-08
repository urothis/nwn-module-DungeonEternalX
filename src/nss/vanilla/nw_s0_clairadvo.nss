//::///////////////////////////////////////////////
//:: Clairaudience / Clairvoyance
//:: NW_S0_ClairAdVo.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Grants the target creature a bonus of +10 to
   spot and listen checks
*/

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_DIVINATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_DIVINATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   int nSpot      = 10;
   int nListen    = 10;
   int nDur       = 3; // Turns
   object oTarget = GetSpellTargetObject();
   object oItem   = GetSpellCastItem();

    if (GetLevelByClass(CLASS_TYPE_HARPER, oTarget) > 4)
    { // Increase Spot if Harper use pot
        if (GetBaseItemType(oItem) == BASE_ITEM_POTIONS)
        {
            nSpot   += 20;
            nDur    *= 2;
        }
    }

   effect eSpot   = EffectSkillIncrease(SKILL_SPOT, nSpot + nPureBonus) ;
   effect eListen = EffectSkillIncrease(SKILL_LISTEN, nListen + nPureBonus) ;
   effect eLink   = EffectLinkEffects(eSpot, eListen);

   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDur *= 2;

   if (!GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, oTarget)) {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, FALSE));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDur));
   }
}


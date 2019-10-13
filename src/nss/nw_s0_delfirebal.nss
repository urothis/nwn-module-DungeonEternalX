//::///////////////////////////////////////////////
//:: Delayed Blast Fireball
//:: NW_S0_DelFirebal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The caster creates a trapped area which detects
   the entrance of enemy creatures into 3 m area
   around the spell location.  When tripped it
   causes a fiery explosion that does 1d6 per
   caster level up to a max of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables including Area of Effect Object
   effect eAOE = EffectAreaOfEffect(AOE_PER_DELAY_BLAST_FIREBALL);
   location lTarget = GetSpellTargetLocation();
   int nDuration = GetMin(1, nPureLevel / 2);
   int nMetaMagic = GetMetaMagicFeat();
   //Check Extend metamagic feat.
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;//Duration is +100%
   //Create an instance of the AOE Object using the Apply Effect function
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}



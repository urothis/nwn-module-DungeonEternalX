//::///////////////////////////////////////////////
//:: Creeping Doom
//:: NW_S0_CrpDoom
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The druid calls forth a mass of churning insects
   and scorpians that bite and sting all those within
   a 20ft square.  The total spell effects does
   1000 damage to all withiin the area of effect
   until all damage is dealt.
*/

//Needed would require an entry into the VFX_Persistant.2DA and a new AOE constant

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables including Area of Effect Object
   effect eAOE = EffectAreaOfEffect(AOE_PER_CREEPING_DOOM);
   location lTarget = GetSpellTargetLocation();

   int nDuration = 1+GetMin(9, nPureLevel/3);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%

   //Create an instance of the AOE Object using the Apply Effect function
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

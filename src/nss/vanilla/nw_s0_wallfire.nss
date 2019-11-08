//::///////////////////////////////////////////////
//:: Wall of Fire
//:: NW_S0_WallFire.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Creates a wall of fire that burns any creature
   entering the area around the wall.  Those moving
   through the AOE are burned for 4d6 fire damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 17, 2001
//:://////////////////////////////////////////////

#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare Area of Effect object using the appropriate constant
   effect eAOE = EffectAreaOfEffect(AOE_PER_WALLFIRE);
   //Get the location where the wall is to be placed.
   location lTarget = GetSpellTargetLocation();

   int nDuration = 1+GetMin(9, nPureLevel/3);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%

   //Create the Area of Effect Object declared above.
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

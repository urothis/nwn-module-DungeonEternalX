//::///////////////////////////////////////////////
//:: Sunbeam
//:: s_Sunbeam.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures in the beam are struck blind and suffer 4d6 points of damage. (A successful
//:: Reflex save negates the blindness and reduces the damage by half.) Creatures to whom sunlight
//:: is harmful or unnatural suffer double damage.
//::
//:: Undead creatures caught within the ray are dealt 1d6 points of damage per caster level
//:: (maximum 20d6), or half damage if a Reflex save is successful. In addition, the ray results in
//:: the total destruction of undead creatures specifically affected by sunlight if they fail their saves.

#include "X0_I0_SPELLS"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main()
{
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   effect eVis    = EffectVisualEffect(VFX_IMP_DEATH);
   effect eVis2   = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
   effect eStrike = EffectVisualEffect(VFX_FNF_SUNBEAM);
   effect eDam;
   effect eBlind  = EffectBlindness();

   int nCasterLevel = nPureLevel;
   if (nCasterLevel > 20 + nPureBonus) nCasterLevel = 20 + nPureBonus;

   int nDamage;
   float fDelay;
   int nBlindLength = GetMax(3, nPureBonus);

   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, GetSpellTargetLocation());
   //Get the first target in the spell area
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
   while(GetIsObjectValid(oTarget))
   {
      // Make a faction check
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
      {
         fDelay = GetRandomDelay(1.0, 2.0);
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUNBEAM));
         //Make an SR check
         if (!MyResistSpell(OBJECT_SELF, oTarget))
         {
            //Check if the target is an undead
            if (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
            {
               nCasterLevel /=2;
            }
            nDamage = d6(nCasterLevel);
            //Do metamagic checks
            if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLevel;
            if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage/2);

            //Check that a reflex save was made.
            if (MySavingThrow(SAVING_THROW_REFLEX, oTarget, nPureDC, SAVING_THROW_TYPE_DIVINE, OBJECT_SELF, 1.0) == 0)
            {
               DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nBlindLength)));
            }
            else
            {
               nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 0, SAVING_THROW_TYPE_DIVINE);
            }
            //Set damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
            if (nDamage > 0)
            {
               //Apply the damage effect and VFX impact
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            }
         }
      }
      //Get the next target in the spell area
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
   }
}

//::///////////////////////////////////////////////
//:: Color Spray
//:: NW_S0_ColSpray.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   A cone of sparkling lights flashes out in a cone
   from the casters hands affecting all those within
   the Area of Effect.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_ILLUSION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_ILLUSION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   int nHD;
   int nDuration;
   float fDelay;

   effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

   effect eSleep = EffectSleep();
   eSleep = EffectLinkEffects(eSleep, eMind);

   effect eStun;
   if (nPureBonus >= 4) eStun = EffectStunned();
   else eStun = EffectDazed();
   eStun = EffectLinkEffects(eStun, eMind);

   effect eBlind = EffectBlindness();
   eBlind = EffectLinkEffects(eBlind, eMind);

   object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE);
   while (GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COLOR_SPRAY));
         fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/30;
         if(!MyResistSpell(OBJECT_SELF, oTarget) && oTarget != OBJECT_SELF) {
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay)) {
               nDuration = 3 + d4();
               if (nMetaMagic == METAMAGIC_MAXIMIZE) nDuration = 7;//Damage is at max
               else if (nMetaMagic == METAMAGIC_EMPOWER) nDuration += (nDuration/2); //Damage/Healing is +50%
               else if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2; //Duration is +100%

               nHD = GetHitDice(oTarget) - nPureBonus;
               if (nHD <= 2) {
                  nDuration += nPureBonus;
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLEEP), oTarget));
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oTarget, RoundsToSeconds(nDuration)));
               } else if (nHD <= 5) {
                  nDuration += (nPureBonus - 1);
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M), oTarget));
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nDuration)));
               } else {
                  nDuration = GetMax(nDuration-2, nPureBonus/2);
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget));
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nDuration)));
               }
            }
         }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE);
   }
}

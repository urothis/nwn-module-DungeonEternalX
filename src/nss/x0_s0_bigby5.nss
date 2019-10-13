//::///////////////////////////////////////////////
//:: Bigby's Crushing Hand
//:: [x0_s0_bigby5]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Similar to Bigby's Grasping Hand.
    If Grapple succesful then will hold the opponent and do 2d6 + 12 points
    of damage EACH round for 1 round/level


   // Mark B's famous advice:
   // Note:  if the target is dead during one of these second-long heartbeats,
   // the DelayCommand doesn't get run again, and the whole package goes away.
   // Do NOT attempt to put more than two parameters on the delay command.  They
   // may all end up on the stack, and that's all bad.  60 x 2 = 120.

*/

/*
   Bigby Nerf
    -Bigby's Interposing Hand (x0_s0_bigby1)
    -Bigby's Forceful Hand (x0_s0_bigby2)
    -Bigby's Grasping Hand (x0_s0_bigby3)
    -Bigby's Clenched Fist (x0_s0_bigby4)
    -Bigby's Crushing Hand (x0_s0_bigby5)

    - Based on discipline check.
    - DC = Caster Level + Spell Level - 15 + Caster Ability Modifier + Spell Focus Bonus + Size Modifier (vs. Large Size) + d20.
    - Arcane Defense lowers the DC by 2.
    - The duration of all bigby hands have been changed to 2 rounds + 1/3 levels to a maximum of 15 rounds (10 rounds on Forceful Hand).
    - The damage from Clenched Fist and Crushing Hand is 2x to compensate for the reduced duration.
*/

#include "x0_i0_spells"
#include "pure_caster_inc"
#include "x2_i0_spells"

int nSpellID = 463;
void RunHandImpact(object oTarget, object oCaster, int nMeta, int nPureBonus) {
   //--------------------------------------------------------------------------
   // Check if the spell has expired (check also removes effects)
   //--------------------------------------------------------------------------
   if (GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster)) return;
   int nDam = d8(2)+ 20;
   effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
   effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
   DelayCommand(6.0f, RunHandImpact(oTarget, oCaster, nMeta, nPureBonus));
}

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_EVOCATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_EVOCATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(462,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

   int nDuration = GetMin(10, 2 + nPureLevel/5);
   int nMetaMagic = GetMetaMagicFeat();
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

   if (!GetIsReactionTypeFriendly(oTarget)) {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BIGBYS_CRUSHING_HAND, TRUE));

        //SR
      if (!MyResistSpell(OBJECT_SELF, oTarget))
      {
         int nCasterRoll = GetMin(20, d20()+nPureBonus);
         int nCasterLvl = GetCasterLevel(OBJECT_SELF);
         int nBaseDC = GetCasterAbilityModifier(OBJECT_SELF)-6;
         if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION)) nBaseDC += 6;
         else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION)) nBaseDC += 4;
         else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION)) nBaseDC += 2;
         int nFinalDC = nCasterRoll + nCasterLvl + nBaseDC;

         int nTargetRanks = GetSkillRank(SKILL_DISCIPLINE,oTarget);
         int nTargetRoll = d20();
         if (GetHasFeat(FEAT_ARCANE_DEFENSE_EVOCATION,oTarget)) nTargetRanks += 2;
         int nFinalRoll = nTargetRanks + nTargetRoll;

         string sMessage = "";
         // * bullrush succesful, knockdown target for duration of spell
         if (nFinalDC > nFinalRoll)
         {
            effect eKnockdown = EffectParalyze();
            // creatures immune to paralzation are still prevented from moving
            if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) || GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)) eKnockdown = EffectCutsceneImmobilize();

            effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);
            effect eLink = EffectLinkEffects(eKnockdown, eHand);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

            RunHandImpact(oTarget, OBJECT_SELF, nMetaMagic, nPureBonus);
            sMessage = "Bullrush Success! " + IntToString(nTargetRanks) + " + " + IntToString(nTargetRoll) + " vs DC: " + IntToString(nCasterLvl) + " + " + IntToString(nBaseDC) + " + " + IntToString(nCasterRoll) + " = " + IntToString(nFinalDC);
            FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
         } else {
            sMessage = "Bullrush Failed. " + IntToString(nTargetRanks) + " + " + IntToString(nTargetRoll) + " vs DC: " + IntToString(nCasterLvl) + " + " + IntToString(nBaseDC) + " + " + IntToString(nCasterRoll) + " = " + IntToString(nFinalDC);
            FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
         }
         SendMessageToPC(OBJECT_SELF, sMessage);
         SendMessageToPC(oTarget, sMessage);
      }
   }
}



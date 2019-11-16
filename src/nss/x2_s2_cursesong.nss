//::///////////////////////////////////////////////
//:: Curse Song
//:: X2_S2_CurseSong
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   This spells applies penalties to all of the
   bard's enemies within 30ft for a set duration of
   10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: May 16, 2003
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 20, 2003
#include "pure_caster_inc"
#include "x2_i0_spells"

void main() {
   if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF)) {
      FloatingTextStrRefOnCreature(85587,OBJECT_SELF); // no more bardsong uses left
      return;
   }
   if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF)) {
      FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
      return;
   }

   //Declare major variables
   int nLevel = GetLevelByClass(CLASS_TYPE_BARD);
   int nRanks = GetSkillRank(SKILL_PERFORM);
   int nPerform = nRanks;
   int nDuration = 10; //+ nChr;

   effect eAttack;
   effect eDamage;
   effect eWill;
   effect eFort;
   effect eReflex;
   effect eHP;
   effect eAC;
   effect eSkill;

   int nAttack;
   int nDamage;
   int nWill;
   int nFort;
   int nReflex;
   int nHP;
   int nAC;
   int nSkill;
   //Check to see if the caster has Lasting Impression and increase duration.
   if (GetHasFeat(FEAT_EPIC_LASTING_INSPIRATION)) nDuration *= 2; // changed from 10 to 2. 2*10 rounds is 2 minutes which is long enough [RedACE]

   if (GetHasFeat(FEAT_LINGERING_SONG)) nDuration += 10; // lingering song

   if(nPerform >= 100 && nLevel >= 30)
    {
        nAttack = 2;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 48;
        nAC = 4;
        nSkill = 4;
    }
    else if(nPerform >= 95 && nLevel >= 29)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 46;
        nAC = 3;
        nSkill = 3;
    }
    else if(nPerform >= 90 && nLevel >= 28)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 44;
        nAC = 3;
        nSkill = 3;
    }
    else if(nPerform >= 85 && nLevel >= 27)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 42;
        nAC = 3;
        nSkill = 3;
    }
    else if(nPerform >= 80 && nLevel >= 26)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 40;
        nAC = 3;
        nSkill = 3;
    }
    else if(nPerform >= 75 && nLevel >= 25)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 38;
        nAC = 3;
        nSkill = 3;
    }
    else if(nPerform >= 70 && nLevel >= 24)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 36;
        nAC = 2;
        nSkill = 2;
    }
    else if(nPerform >= 65 && nLevel >= 23)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 34;
        nAC = 2;
        nSkill = 2;
    }
    else if(nPerform >= 60 && nLevel >= 22)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 32;
        nAC = 2;
        nSkill = 2;
    }
    else if(nPerform >= 55 && nLevel >= 21)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 30;
        nAC = 2;
        nSkill = 2;
    }
    else if(nPerform >= 50 && nLevel >= 20)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 28;
        nAC = 2;
        nSkill = 2;
    }
    else if(nPerform >= 45 && nLevel >= 19)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 26;
        nAC = 2;
        nSkill = 2;
    }
    else if(nPerform >= 40 && nLevel >= 18)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 24;
        nAC = 2;
        nSkill = 2;
    }
    else if(nPerform >= 35 && nLevel >= 17)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 22;
        nAC = 2;
        nSkill = 2;
    }
    else if(nPerform >= 30 && nLevel >= 16)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 3;
        nFort = 2;
        nReflex = 2;
        nHP = 20;
        nAC = 2;
        nSkill = 2;
    }
    else if(nPerform >= 24 && nLevel >= 15)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 2;
        nFort = 2;
        nReflex = 2;
        nHP = 16;
        nAC = 1;
        nSkill = 1;
    }
    else if(nPerform >= 21 && nLevel >= 14)
    {
        nAttack = 1;
        nDamage = 3;
        nWill = 1;
        nFort = 1;
        nReflex = 1;
        nHP = 16;
        nAC = 1;
        nSkill = 1;
    }
    else if(nPerform >= 18 && nLevel >= 11)
    {
        nAttack = 1;
        nDamage = 2;
        nWill = 1;
        nFort = 1;
        nReflex = 1;
        nHP = 8;
        nAC = 1;
        nSkill = 1;
    }
    else if(nPerform >= 15 && nLevel >= 8)
    {
        nAttack = 1;
        nDamage = 2;
        nWill = 1;
        nFort = 1;
        nReflex = 1;
        nHP = 8;
        nAC = 0;
        nSkill = 1;
    }
    else if(nPerform >= 12 && nLevel >= 6)
    {
        nAttack = 1;
        nDamage = 2;
        nWill = 1;
        nFort = 1;
        nReflex = 1;
        nHP = 0;
        nAC = 0;
        nSkill = 1;
    }
    else if(nPerform >= 9 && nLevel >= 3)
    {
        nAttack = 1;
        nDamage = 2;
        nWill = 1;
        nFort = 1;
        nReflex = 0;
        nHP = 0;
        nAC = 0;
        nSkill = 0;
    }
    else if(nPerform >= 6 && nLevel >= 2)
    {
        nAttack = 1;
        nDamage = 1;
        nWill = 1;
        nFort = 0;
        nReflex = 0;
        nHP = 0;
        nAC = 0;
        nSkill = 0;
    }
    else if(nPerform >= 3 && nLevel >= 1)
    {
        nAttack = 1;
        nDamage = 1;
        nWill = 0;
        nFort = 0;
        nReflex = 0;
        nHP = 0;
        nAC = 0;
        nSkill = 0;
    }
   if (HasVaasa(OBJECT_SELF)) nHP += GetAbilityScore(OBJECT_SELF, ABILITY_CHARISMA);
   effect eVis = EffectVisualEffect(VFX_IMP_DOOM);

   eAttack = EffectAttackDecrease(nAttack);
   eDamage = EffectDamageDecrease(nDamage, DAMAGE_TYPE_SLASHING);
   effect eLink = EffectLinkEffects(eAttack, eDamage);

   if (nWill > 0) {
      eWill = EffectSavingThrowDecrease(SAVING_THROW_WILL, nWill);
      eLink = EffectLinkEffects(eLink, eWill);
   }
   if (nFort > 0) {
      eFort = EffectSavingThrowDecrease(SAVING_THROW_FORT, nFort);
      eLink = EffectLinkEffects(eLink, eFort);
   }
   if (nReflex > 0) {
      eReflex = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, nReflex);
      eLink = EffectLinkEffects(eLink, eReflex);
   }
   if (nHP > 0) {
      eHP = EffectDamage(nHP, DAMAGE_TYPE_SONIC, DAMAGE_POWER_NORMAL);
//      eLink = EffectLinkEffects(eLink, eHP);
   }
   if (nAC > 0) {
      eAC = EffectACDecrease(nAC, AC_DODGE_BONUS);
      eLink = EffectLinkEffects(eLink, eAC);
   }
   if (nSkill > 0) {
      eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, nSkill);
      eLink = EffectLinkEffects(eLink, eSkill);
   }
   effect eDur2 = EffectVisualEffect(507);

   effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
   effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

   eHP = ExtraordinaryEffect(eHP);
   eLink = ExtraordinaryEffect(eLink);

   if (!GetHasFeatEffect(871, oTarget)&& !GetHasSpellEffect(GetSpellId(),oTarget)) {
      //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur2, OBJECT_SELF, RoundsToSeconds(nDuration));
   }
   float fDelay;
   while(GetIsObjectValid(oTarget)) {
      if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF)) {
         // * GZ Oct 2003: If we are deaf, we do not have negative effects from curse song
         if (!GetHasEffect(EFFECT_TYPE_DEAF,oTarget) || !GetHasEffect(EFFECT_TYPE_SILENCE,oTarget)) {
            if (!GetHasFeatEffect(871, oTarget)&& !GetHasSpellEffect(GetSpellId(),oTarget)) {
               if (nHP > 0) {
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget);
                  DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHP, oTarget));
               }
               if (!GetIsDead(oTarget)) {
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                  DelayCommand(GetRandomDelay(0.1,0.5),ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
               }
            }
         } else {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
         }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, 9.144, GetLocation(OBJECT_SELF)); // 30 feet is 9.144 m, not 10 m [RedACE]
   }
   DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}

//::///////////////////////////////////////////////
//:: Barbarian Rage
//:: NW_S1_BarbRage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The Str and Con of the Barbarian increases,
   Will Save are +2, AC -2.
   Greater Rage starts at level 15.
*/

/*

ALL RAGES:
* LevelModifier: 1= +2, 10= +3, 20= +4, 30= +5, 40= +6
* Duration: (LevelModifier * CON mod) Duration

Barbarian Rage / Greater Rage
* -2 AC <15, -1 AC <40, -0 AC =40
* +2 AB <15, +4 AB <40, +6 AB =40
* +(ConstitionModifier/2) Discipline
* +(LevelModifier * 2) STR/CON
* +3+LevelModifier Will Saves

Thundering Rage Add-On:
* 2d6, 2d8, 2d10 or 2d12 Sonic damage (LevelMod 3,4,5,6)
* 3+LevelModifier Reflex Saves
* Main weapon gains On Hit Deafness DC 14 + LevelModifier * 2 (18 min, max 26)

Terrifying Rage Add-On:
* Terrifying Rage Pulse every 4 rounds for Duration of Rage
* DC = BarbLevel + IntimidateSkill/4
* On Failed Will Save
 -- Duration of Effect = LevelModifier-2 (2-4 rounds)
 -- if Level<=BarbarianLevels = Fear (Duration-1) rounds (1-3 rounds), % chance of Fear Paralysis
 -- if Level<=(BarbarianLevels*2) = AC/Saves Decreased by 2 for 2-4 rounds

- - -

Mighty Rage:
* Weapons gain 2d8, 2d10 or 2d12 Massive Criticals damage (LevelMod 4, 5, 6)
* +(BarbLevel*BarbLevel)/8 Temporary Hitpoints (50-200)
* +(LevelModifier-2) AB (2-4)
* +LevelModifier Fort Saves (4-6)
* +LevelModifier Taunt (4-6)
* 1+LevelModifier Elemental Resistance (5-7)
- - -


*/

#include "x2_i0_spells"
#include "inc_draw"

void ThunderWeapon(int nSlot, int nLevelMod,  int nRounds, int bAddClang = FALSE) {
   object oWeapon = GetItemInSlot(nSlot);
   if (GetIsObjectValid(oWeapon)) {
      IPSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
      if (bAddClang) {
         IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitProps(IP_CONST_ONHIT_DEAFNESS, IP_CONST_ONHIT_SAVEDC_14 + nLevelMod, IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
      }
   }
}

void FearPulse(object oBarb) {
   //Declare major variables
   if (!GetIsObjectValid(oBarb)) return;
   int nPulses   = GetLocalInt(oBarb, "TERRIFYPULSE");
   if (nPulses < 1) return;
   SetLocalInt(oBarb, "TERRIFYPULSE", nPulses - 1);
   AssignCommand(oBarb, DelayCommand(RoundsToSeconds(4), FearPulse(oBarb))); // Fire Every 4 Rounds

   int nBarbLvl  = GetLevelByClass(CLASS_TYPE_BARBARIAN, oBarb);
   int nLevelMod   = 2 + nBarbLvl/10;
   int nHDBarb   = GetHitDice(oBarb);
   int nDC       = GetSkillRank(SKILL_INTIMIDATE, oBarb, TRUE);
   if (GetHasFeat(FEAT_SKILL_FOCUS_INTIMIDATE, oBarb)) nDC += 10;
   if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_INTIMIDATE, oBarb)) nDC += 3;
   nDC = nBarbLvl + nDC/4;

   int nDuration = 2;
   if(nHDBarb == 40) nDuration = 1 + d3();

   float fRadius = RADIUS_SIZE_LARGE + nLevelMod/2;
   effect eLink;

   int nSpeak = d6();
   if      (nSpeak==1) nSpeak = VOICE_CHAT_BATTLECRY1;
   else if (nSpeak==2) nSpeak = VOICE_CHAT_BATTLECRY2;
   else if (nSpeak==3) nSpeak = VOICE_CHAT_BATTLECRY3;
   else if (nSpeak==4) nSpeak = VOICE_CHAT_TAUNT;
   else if (nSpeak==5) nSpeak = VOICE_CHAT_LAUGH;
   else if (nSpeak==6) nSpeak = VOICE_CHAT_THREATEN;
   PlayVoiceChat(nSpeak, oBarb);

   effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
   DrawCircle(DURATION_TYPE_TEMPORARY, VFX_DUR_MIND_AFFECTING_FEAR, GetLocation(oBarb), fRadius/2, 0.1, 6, 1.0, 0.0f);
   DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oBarb));
   DelayCommand(0.3, DrawCircle(DURATION_TYPE_TEMPORARY, VFX_DUR_MIND_AFFECTING_FEAR, GetLocation(oBarb), fRadius, 0.1, 12, 1.0, 0.0f));

   int nHDTarget;
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oBarb));
   while(GetIsObjectValid(oTarget)) {
      if (GetIsEnemy(oTarget, oBarb)) {
         SignalEvent(oTarget, EventSpellCastAt(oBarb, SPELLABILITY_BARBARIAN_RAGE));
         if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR)) {
            nHDTarget = GetHitDice(oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FEAR_S), oTarget);
            if (nHDTarget < nHDBarb || nHDTarget == nBarbLvl) { // Hit dice below barb.... run like hell!
               eLink = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
               if (d100()< nLevelMod && !GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS)) {
                  eLink = EffectLinkEffects(eLink, EffectParalyze());
                  PlayVoiceChat(VOICE_CHAT_HELP, oTarget);
                  FloatingTextStringOnCreature("Terrified!", oTarget, TRUE);
                  object oPee = CreateObject (OBJECT_TYPE_PLACEABLE, "nw_plc_puddle2", GetLocation (oTarget), FALSE);
                  DestroyObject(oPee, RoundsToSeconds(nDuration-1));

               } else {
                  PlayVoiceChat(VOICE_CHAT_FLEE, oTarget);
               }
               eLink = EffectLinkEffects(eLink, EffectFrightened());
               eLink = ExtraordinaryEffect(eLink);
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration-1));
            }
            if (nHDTarget < nBarbLvl * 2) {
               eLink = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
               eLink = EffectLinkEffects(eLink, EffectACDecrease(2));
               eLink = ExtraordinaryEffect(eLink);
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
               FloatingTextStrRefOnCreature(83583, oTarget);
            }
         }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oBarb));
   }
}

void main() {
   if (GetHasSpellEffect(SPELL_BLADE_THIRST, OBJECT_SELF)){
        FloatingTextStringOnCreature("Rage does not stack with Blade Thirst", OBJECT_SELF);
        return;
    }

   if (!GetHasFeatEffect(FEAT_BARBARIAN_RAGE)) {

      int nCon        = GetAbilityModifier(ABILITY_CONSTITUTION);
      if (nCon < 0) nCon = 0;
      int nLevel      = GetLevelByClass(CLASS_TYPE_BARBARIAN);
      int nLevelMod   = 2 + nLevel/10;
      int nDuration   = 1 + nCon * nLevelMod;
      int nACDecrease = 2;
      int nAttack     = 2;                      // AB increase
      int nStats      = 2 * nLevelMod;          // Con/str increase 4-12
      int nSave       = 3 + nLevelMod;          // Will increase 5-9
      int nSkill      = nCon / 2;               // skill increase

      if (nLevel==40) {
         nACDecrease = 0;
         nAttack     = 6;
      } else if (nLevel>14) {
         nACDecrease = 1;
         nAttack     = 4;
      }

      PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
      SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BARBARIAN_RAGE, FALSE));

      effect eLink;
      eLink = EffectAbilityIncrease(ABILITY_STRENGTH, nStats);
      eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, nStats));
      eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave));
      eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_DISCIPLINE, nSkill));
      eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nAttack));
      if (nACDecrease > 0 && !GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER))
      {
         eLink = EffectLinkEffects(eLink, EffectACDecrease(nACDecrease, AC_DODGE_BONUS));
      }
      if (GetHasFeat(FEAT_EPIC_THUNDERING_RAGE, OBJECT_SELF)) { // ADD REFLEX SAVE & SONIC DAMAGE IN IF THUNDERING
         int nBonus     = 3 + nLevelMod * 2; // 11,13,15 = DAMAGE_BONUS_2d8, 2d10, 2d12
         if (nBonus == 9) nBonus = 10; //DAMAGE_BONUS_2d6
         eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nBonus, DAMAGE_TYPE_SONIC));
         eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nSave));
         ThunderWeapon(INVENTORY_SLOT_RIGHTHAND, nLevelMod, nDuration, TRUE);
         ThunderWeapon(INVENTORY_SLOT_LEFTHAND,  nLevelMod, nDuration, FALSE);
      }
      eLink = ExtraordinaryEffect(eLink); // Make effect extraordinary
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));

      if (GetHasFeat(FEAT_EPIC_TERRIFYING_RAGE, OBJECT_SELF)) {
         //effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR, "terrifyrage", "", "");
         //eAOE = ExtraordinaryEffect(eAOE);
         //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds(nDuration));
         SetLocalInt(OBJECT_SELF, "TERRIFYPULSE", nDuration/4); // CLEAR THIS ON DEATH, REST
         DelayCommand(0.2, FearPulse(OBJECT_SELF)); // Start Pulsing...
      }

      effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

   }
}

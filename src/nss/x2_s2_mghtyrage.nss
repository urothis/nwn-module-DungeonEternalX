//::///////////////////////////////////////////////
//:: Mighty Rage
//:: X2_S2_MghtyRage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

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

void MightyWeapon(int nSlot, int nBonus,  int nRounds) {
   object oWeapon = GetItemInSlot(nSlot);
   if (GetIsObjectValid(oWeapon)) {
      IPSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(nBonus), RoundsToSeconds(nRounds), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, FALSE);
   }
}


void main() {
   if (GetHasSpellEffect(SPELL_BLADE_THIRST, OBJECT_SELF))
   {
      FloatingTextStringOnCreature("Rage does not stack with Blade Thirst", OBJECT_SELF);
      return;
   }
   if (!GetHasFeatEffect(FEAT_MIGHTY_RAGE)) {

      int nDD = GetLevelByClass(CLASS_TYPE_BARBARIAN, OBJECT_SELF);
      int nCon        = GetAbilityModifier(ABILITY_CONSTITUTION);
      int nLevel      = GetLevelByClass(CLASS_TYPE_BARBARIAN);
      int nLevelMod   = 2 + nLevel/10;         // 4-6 (min level of Mighty Rage is 20)
      int nDuration   = 10 + nCon * nLevelMod;  //
      int nAttack     = nLevelMod - 2;         // AB increase 2-4
      int nSave       = nLevelMod;             // Fort increase 2-6
      int nSkill      = nLevelMod;             // skill increase
      int nBonus      = 3 + nLevelMod * 2;     // 11,13,15 = DAMAGE_BONUS_2d8, 2d10, 2d12
      int nResist     = 1 + nLevelMod;         // Elemental resistance 5-7

      if (nDD)
      {
         nAttack += 1;
         nResist += 2;
      }

      PlayVoiceChat(VOICE_CHAT_BATTLECRY2);
      SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

      MightyWeapon(INVENTORY_SLOT_RIGHTHAND, nBonus, nDuration);
      MightyWeapon(INVENTORY_SLOT_LEFTHAND,  nBonus, nDuration);

      effect eHP = ExtraordinaryEffect(EffectTemporaryHitpoints((nLevel * nLevel)/8));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration));

      effect eLink;
      eLink = EffectAttackIncrease(nAttack);
      eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT, nSave));
      eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_TAUNT, nSkill));
      eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID,       nResist));
      eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD,       nResist));
      eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist));
      eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE,       nResist));
      eLink = ExtraordinaryEffect(eLink); // Make effect extraordinary
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));

      effect eVis    = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

   }
}

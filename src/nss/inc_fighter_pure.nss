#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "_functions"
#include "arres_inc"



/*void GivePureFighterBonus(object oPC, object oItem) {
   string sResRef  = GetResRef(oItem);
   if (sResRef!="fi_mail2" && sResRef!="fi_leather2" && sResRef!="fi_robe2") {
      return; // NOT WARLORD ITEM
   }

   int nUses = GetLocalInt(oItem, "PFUSESLEFT");
   if (nUses < 1) nUses = 1;
   if (nUses > 20)
   {
      FloatingTextStringOnCreature("Total uses of this item is exceeded", oPC, FALSE);
      AssignCommand(oPC, ClearAllActions(TRUE));
      Insured_Destroy_Delay(oItem, 1.0);
      return;
   }
   SetLocalInt(oItem, "PFUSESLEFT", nUses+1);

   if (!GetIsPureFighter(oPC)) {
      AssignCommand(oPC, ClearAllActions(TRUE));
      AssignCommand(oPC, ActionUnequipItem(oItem));
//      DestroyObject(oItem);
      SendMessageToPC(oPC, "Eeeeek! You must be a Warlord to use this item.");
      return;
   }
   if (GetLocalInt(oPC, "FRENZY")) {
      SendMessageToPC(oPC, "Warlord's Frenzy does not stack.");
      return;
   }

    if (GetLocalInt(oPC, "RangerDodgeActive")) {
      SendMessageToPC(oPC, "Warlord's Frenzy does not stack with Ranger Dodge.");
      return;
   }

   float fDuration = RoundsToSeconds(GetHitDice(oPC));
   int nRangerLvl = GetLevelByClass(CLASS_TYPE_RANGER, oPC);

   SetLocalInt(oPC, "FRENZY", 1);

   DelayCommand(fDuration, DeleteLocalInt(oPC, "FRENZY"));

   int nParry = GetSkillRank(SKILL_PARRY, oPC, TRUE) / 7;
   if (GetHasFeat(FEAT_SKILL_FOCUS_PARRY, oPC)) nParry++;
   if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_PARRY, oPC)) nParry++;
   nParry += nRangerLvl / 10;
   nParry = GetMax(1, nParry);

   int nConcent = GetSkillRank(SKILL_CONCENTRATION, oPC, TRUE) / 7;
   if (GetHasFeat(FEAT_SKILL_FOCUS_CONCENTRATION, oPC)) nConcent++;
   if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_CONCENTRATION, oPC)) nConcent++;
   nConcent += nRangerLvl / 10;
   nConcent = GetMax(1, nConcent);

   int nTaunt = GetSkillRank(SKILL_TAUNT, oPC, TRUE);
   int nDiscipline = 0;
   if (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) >= GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE)) { // DEXER
      nDiscipline = nConcent;
      nConcent /= 2;
   }

   effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
   effect eAB = EffectAttackIncrease(nParry, EFFECT_TYPE_ATTACK_INCREASE);
   effect eAC = EffectACIncrease(5 + nConcent, AC_DEFLECTION_BONUS);
   effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, nRangerLvl / 5);
   effect eQuick = EffectMovementSpeedIncrease(99);
   effect eLink = EffectLinkEffects(eAB, eAC);
   eLink = EffectLinkEffects(eLink, eSaves);
   eLink = EffectLinkEffects(eLink, eQuick);
   eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_AURA_PULSE_YELLOW_BLACK)); // KILLER BEE LOOK
   if (nTaunt) {
      effect eTaunt = EffectSkillIncrease(SKILL_TAUNT, nTaunt);
      eLink = EffectLinkEffects(eLink, eTaunt);
   }
   if (nDiscipline) {
      effect eDiscipline = EffectSkillIncrease(SKILL_DISCIPLINE, nDiscipline);
      eLink = EffectLinkEffects(eLink, eDiscipline);
   }
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oPC, fDuration);
   FloatingTextStringOnCreature("Pure Fighters will be removed soon. The bank is set to 100% for PFs at level 40.", oPC, FALSE);
   DelayCommand(2.0, ActionFloatingTextStringOnCreature("Total uses left: " + IntToString(20-nUses), oPC, FALSE));
} */

//void main(){}

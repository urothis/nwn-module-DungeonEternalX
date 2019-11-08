//::///////////////////////////////////////////////
//:: Black Blade of Disaster
//:: X2_S0_BlckBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a greatsword to battle for the caster
*/

#include "x2_i0_spells"
#include "pure_caster_inc"

void spellsCreateItemForSummoned(object oCaster, float fDuration, int nPureBonus) {
   //Declare major variables
   int nStat = GetMin(20, GetMax(1, GetCasterModifier(oCaster) / 2) + nPureBonus);
   if (!GetHasSpellSchool(OBJECT_SELF, SPELL_SCHOOL_CONJURATION))
        if (nStat > 5) nStat = 5; //Ezramun: Only +5 Enhancement if not conj schooled
   if (GetSpellCastItem()!=OBJECT_INVALID) nStat = 5;

   object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
   object oWeapon;
   if (GetIsObjectValid(oSummon)) {
      //Create item on the creature, epuip it and add properties.
      string sResRef = "x0_wswmls002"; // longsword
      // if      (nPureBonus>=6) sResRef = "x0_wdbmsw002";
      // else if (nPureBonus>=4) sResRef = "x0_wswmgs002";
      // else if (nPureBonus>=2) sResRef = "nw_wswbs001";
      oWeapon = CreateItemOnObject(sResRef, oSummon);
      SetDroppableFlag(oWeapon, FALSE);
      AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
      effect eConceal = EffectConcealment(50, MISS_CHANCE_TYPE_NORMAL);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eConceal), oSummon);

      SetLocalInt(oSummon,"X2_L_CREATURE_NEEDS_CONCENTRATION",TRUE);
      SetPlotFlag (oSummon,TRUE);

      if (nStat) {
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(nStat), oWeapon);
         if      (nPureBonus==1) nPureBonus = DAMAGE_BONUS_1;
         else if (nPureBonus==2) nPureBonus = DAMAGE_BONUS_2;
         else if (nPureBonus==3) nPureBonus = DAMAGE_BONUS_3;
         else if (nPureBonus==4) nPureBonus = DAMAGE_BONUS_4;
         else if (nPureBonus==5) nPureBonus = DAMAGE_BONUS_5;
         else if (nPureBonus==6) nPureBonus = DAMAGE_BONUS_6;
         else if (nPureBonus==7) nPureBonus = DAMAGE_BONUS_7;
         else if (nPureBonus==8) nPureBonus = DAMAGE_BONUS_8;
         if (nPureBonus) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, nPureBonus), oWeapon);
         AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), oWeapon);
      }
      if (nPureBonus) {
         effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4 + nPureBonus);
         effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 4 + nPureBonus);
         effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4 + nPureBonus);
         effect eLink = EffectLinkEffects(eStr, eDex);
         eLink = EffectLinkEffects(eLink, eCon);
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oSummon, fDuration);
      }
   }
}


#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC    = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = 1+GetMin(9, nPureLevel/3);
   GetCasterLevel(OBJECT_SELF);
   effect eSummon = EffectSummonCreature("blackblade");
   effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
   //Make metamagic check for extend
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%
   //Apply the VFX impact and summon effect
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
   object oSelf = OBJECT_SELF;
   DelayCommand(1.5, spellsCreateItemForSummoned(oSelf, TurnsToSeconds(nDuration), nPureBonus));
}

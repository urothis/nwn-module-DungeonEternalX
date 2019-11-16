#include "pure_caster_inc"
#include "x2_inc_itemprop"
#include "x2_i0_spells"

int BuffUndeadItem(object oSum, int nSlot, int nBonus, int nDamBonus) {
   object oItem = GetItemInSlot(nSlot, oSum); // ENCHANT THE CLAWS
   if (oItem!=OBJECT_INVALID) {
      IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(nBonus+1));
      if (nDamBonus){
         if (nBonus > 5) ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectModifyAttacks(1)), oSum);
         IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, nDamBonus));
      } else {
      }
      return TRUE;
   }
   return FALSE;
}

void BoostUndeadSummon(object oMaster, object oSum = OBJECT_INVALID) {
   if (oSum==OBJECT_INVALID) oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster);

   int nPureBonus = GetPureCasterBonus(oMaster, SPELL_SCHOOL_NECROMANCY);
   int nPureLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER, oMaster) + nPureBonus; // MAX 38 / PM 40
   if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oMaster)) nPureLevel+=2; // MAX 39 / PM 41
   if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oMaster)) nPureLevel+=3; // MAX 40 / PM 42

   int nBonus = nPureLevel / 5; // MAX 8
   if (!nBonus) return;

   // Skill bonus max of 8 for Maxed out Necro Feats
   int nDamBonus = 0;
   if      (nBonus==1) nDamBonus = DAMAGE_BONUS_1d4;
   else if (nBonus==2) nDamBonus = DAMAGE_BONUS_1d6;
   else if (nBonus==3) nDamBonus = DAMAGE_BONUS_1d8;
   else if (nBonus==4) nDamBonus = DAMAGE_BONUS_1d10;
   else if (nBonus==5) nDamBonus = DAMAGE_BONUS_2d6;
   else if (nBonus==6) nDamBonus = DAMAGE_BONUS_2d8;
   else if (nBonus==7) nDamBonus = DAMAGE_BONUS_2d10;
   else if (nBonus>=8) nDamBonus = DAMAGE_BONUS_2d12;

   FloatingTextStringOnCreature("Undead Boost Level " + IntToString(nBonus), oMaster, FALSE);
   if (BuffUndeadItem(oSum, INVENTORY_SLOT_CWEAPON_R, nBonus, nDamBonus)) BuffUndeadItem(oSum, INVENTORY_SLOT_CWEAPON_L, nBonus, nDamBonus);
   else if (BuffUndeadItem(oSum, INVENTORY_SLOT_RIGHTHAND, nBonus, nDamBonus)) BuffUndeadItem(oSum, INVENTORY_SLOT_LEFTHAND, nBonus, nDamBonus);
   if (MatchMeleeWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oSum)))  // Summon has a weapon - Apply damage to it
   {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageIncrease(nDamBonus, DAMAGE_TYPE_NEGATIVE)), oSum);
   }
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectHaste()), oSum);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nBonus)), oSum);
}

int CountUndead(object oMaster) {
   int nCnt = 0;
   if (GetAssociate(ASSOCIATE_TYPE_DOMINATED, oMaster)==OBJECT_INVALID) return 0;
   object oMinion = GetFirstObjectInArea(GetArea(oMaster));
   while (GetIsObjectValid(oMinion)) {
      if (GetObjectType(oMinion)==OBJECT_TYPE_CREATURE) {
         if (GetMaster(oMinion)==oMaster && GetRacialType(oMinion)==RACIAL_TYPE_UNDEAD) {
            nCnt++;
         }
      }
      oMinion = GetNextObjectInArea(GetArea(oMaster));
   }
   return nCnt;
}

void CreateUndead(string sResRef, location lLocation, int nMaxDom = 1) {
   int nCount = CountUndead(OBJECT_SELF);
   SetLocalInt(OBJECT_SELF, "UNDEADCOUNT", nCount);
   if (CountUndead(OBJECT_SELF) >= nMaxDom) {
      FloatingTextStringOnCreature("Too many Undead in your service...", OBJECT_SELF, FALSE);
      return;
   }
   object oMinion = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLocation, FALSE);
   SetLocalObject(oMinion, "DOMINATED", OBJECT_SELF);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneDominated(), oMinion, HoursToSeconds(24));
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD), lLocation);
   BoostUndeadSummon(OBJECT_SELF, oMinion);
   int nDistance = NW_ASC_DISTANCE_6_METERS;
   if (nCount==0) nDistance = NW_ASC_DISTANCE_2_METERS;
   if (nCount==1) nDistance = NW_ASC_DISTANCE_4_METERS;
   if (nCount==2) nDistance = NW_ASC_DISTANCE_6_METERS;
   SetAssociateState(nDistance, TRUE, oMinion);
}



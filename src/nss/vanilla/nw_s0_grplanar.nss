//::///////////////////////////////////////////////
//:: Greater Planar Binding
//:: NW_S0_GrPlanar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Summons an outsider dependant on alignment, or
   holds an outsider if the creature fails a save.
*/

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "pure_caster_inc"

int BoostItem(object oSum, int nSlot, int nPureBonus, int nDamBonus, int nDamType) {
   object oItem = GetItemInSlot(nSlot, oSum);
   if (oItem!=OBJECT_INVALID) {
      if (nPureBonus) IPSetWeaponEnhancementBonus(oItem, nPureBonus);
      if (nDamBonus) IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, nDamBonus));
      return TRUE;
   }
   return FALSE;
}

void BoostSummon(object oCaster, int nPureBonus, int nDamType) {
   object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
   int nStat = 1 + (nPureBonus + GetCasterModifier(oCaster)) / 2;
   if (GetSpellCastItem()!=OBJECT_INVALID) nStat = 5;
   int nDamBonus = 0;
   if (nPureBonus==1) nDamBonus = DAMAGE_BONUS_1d4;
   if (nPureBonus==2) nDamBonus = DAMAGE_BONUS_1d6;
   if (nPureBonus==3) nDamBonus = DAMAGE_BONUS_1d8;
   if (nPureBonus==4) nDamBonus = DAMAGE_BONUS_1d10;
   if (nPureBonus==5) nDamBonus = DAMAGE_BONUS_2d6;
   if (nPureBonus==6) nDamBonus = DAMAGE_BONUS_2d8;
   if (nPureBonus==7) nDamBonus = DAMAGE_BONUS_2d10;
   if (nPureBonus==8) nDamBonus = DAMAGE_BONUS_2d12;
   if      (BoostItem(oSummon, INVENTORY_SLOT_CWEAPON_R, nPureBonus, nDamBonus, nDamType)) BoostItem(oSummon, INVENTORY_SLOT_CWEAPON_L, nPureBonus, nDamBonus, nDamType);
   else if (BoostItem(oSummon, INVENTORY_SLOT_RIGHTHAND, nPureBonus, nDamBonus, nDamType)) BoostItem(oSummon, INVENTORY_SLOT_LEFTHAND, nPureBonus, nDamBonus, nDamType);
   if (nPureBonus>0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(nPureBonus), oSummon);
   // int nIamSeed = GetLocalInt(oCaster, "IAMSEED");
   // if (nIamSeed) FloatingTextStringOnCreature("Caster Summon Bonus " + IntToString(nStat), oCaster, FALSE);
}

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   //Declare major variables
   int nMetaMagic = GetMetaMagicFeat();
   int nDuration = nPureLevel;
   effect eSummon;
   effect eGate;
   effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
   effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

   effect eLink = EffectLinkEffects(eDur, EffectParalyze());
   eLink = EffectLinkEffects(eLink, eDur2);

   object oTarget = GetSpellTargetObject();
   int nRacial = GetRacialType(oTarget);
   //Check for metamagic extend
   if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;   //Duration is +100%

   //Check to see if a valid target has been chosen
   if (GetIsObjectValid(oTarget)) {
      if (!GetIsReactionTypeFriendly(oTarget)) {
         //Fire cast spell at event for the specified target
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
         //Check for racial type
         if (nRacial == RACIAL_TYPE_OUTSIDER) {
            if (GetSpellId()==SPELL_GREATER_PLANAR_BINDING) nPureDC += 5;
            if (GetSpellId()==SPELL_PLANAR_BINDING)         nPureDC += 2;
            //Allow will save to negate hold effect
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nPureDC)) {
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration/2));
            }
         }
      }
   } else {
      int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
      int nGreater = (GetSpellId()==SPELL_GREATER_PLANAR_BINDING);
      int nLesser = (GetSpellId()==SPELL_LESSER_PLANAR_BINDING);
      float fDelay = 3.0;
      string sResRef = "";
      int nSumEff;
      int nDamType;
      switch (nAlign) {
         case ALIGNMENT_EVIL:
            sResRef = (nLesser)  ? "NW_S_IMP" : "NW_S_SUCCUBUS";
            sResRef = (nGreater) ? "NW_S_VROCK" : sResRef;
            nSumEff = VFX_FNF_SUMMON_GATE;
            nDamType = IP_CONST_DAMAGETYPE_NEGATIVE;
            break;
         case ALIGNMENT_GOOD:
            sResRef = (nLesser)  ? "NW_S_CLANTERN" : "NW_S_CHOUND";
            sResRef = (nGreater) ? "NW_S_CTRUMPET" : sResRef;
            nSumEff = VFX_FNF_SUMMON_CELESTIAL;
            nDamType = IP_CONST_DAMAGETYPE_POSITIVE;
            break;
         case ALIGNMENT_NEUTRAL:
            sResRef = (nLesser)  ? "NW_S_SLAADRED" : "NW_S_SLAADGRN";
            sResRef = (nGreater) ? "NW_S_SLAADDETH" : sResRef;
            nSumEff = VFX_FNF_SUMMON_MONSTER_3;
            nDamType = IP_CONST_DAMAGETYPE_MAGICAL;
            fDelay = 1.0;
            break;
      }
      eSummon = EffectSummonCreature(sResRef, nSumEff, fDelay);
      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
      DelayCommand(fDelay+1.5, BoostSummon(OBJECT_SELF, nPureBonus, nDamType));
   }
}


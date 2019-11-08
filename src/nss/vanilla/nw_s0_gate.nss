//::///////////////////////////////////////////////
//:: Gate
//:: NW_S0_Gate.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Summons a Balor to fight for the caster.

#include "pure_caster_inc"

void ApplyHaste(object oPC)
{
    object oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectHaste()), oSum);
}

void UnSummonBalor(object oBalor) {
   effect eUnSum = EffectVisualEffect(VFX_IMP_UNSUMMON);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eUnSum, GetLocation(oBalor));
   DestroyObject(oBalor);
}

void CreateBalor(object oCaster) {
   effect eBalorRocks;
   object oBalor = CreateObject(OBJECT_TYPE_CREATURE, "NW_S_BALOR_EVIL", GetLocation(oCaster));
   eBalorRocks = EffectDamageIncrease(DAMAGE_BONUS_20, DAMAGE_TYPE_DIVINE);
   eBalorRocks = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_20, DAMAGE_TYPE_MAGICAL), eBalorRocks);
   eBalorRocks = EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_20, DAMAGE_TYPE_POSITIVE), eBalorRocks);
   eBalorRocks = EffectLinkEffects(EffectAttackIncrease(20, ATTACK_BONUS_MISC), eBalorRocks);
   eBalorRocks = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 40), eBalorRocks);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBalorRocks, oBalor, 10.0);
   AssignCommand(oBalor, ActionAttack(oCaster));
   DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oCaster, 6.0));
   DelayCommand(10.0, UnSummonBalor(oBalor));
}

string ExtendGate(int nPureLevel) {
   int lvl = 1;
   nPureLevel -= 17;
   if (nPureLevel > 0) lvl += nPureLevel / 7; // ie 24=2, 31=3, 38=4, 45=5

   if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION)) lvl++;
   if (GetHasFeat(FEAT_EVIL_DOMAIN_POWER)) lvl++; //WITH THE EVIL/OUTSIDER DOMAIN
   if (GetHasSpellSchool(OBJECT_SELF, SPELL_SCHOOL_CONJURATION)) lvl = lvl + 1;

   if (lvl==1) return "SU_BALOR1";
   if (lvl==2) return "SU_BALOR2";
   if (lvl==3) return "SU_BALOR3";
   if (lvl==4) return "SU_BALOR4";
   if (lvl==5) return "SU_BALOR5";
   if (lvl>=6) return "SU_BALOR6";
   return "SU_BALOR1";
}

#include "x2_inc_spellhook"

void main() {
   if (!X2PreSpellCastCode()) return;

   int nPureBonus = GetPureCasterBonus(OBJECT_SELF, SPELL_SCHOOL_CONJURATION);
   int nPureLevel = GetPureCasterLevel(OBJECT_SELF, SPELL_SCHOOL_CONJURATION) + nPureBonus;
   int nPureDC   = GetSpellSaveDC() + nPureBonus;

   /*if (GetLocalInt(GetArea(OBJECT_SELF), "NO_PVP")) {
      FloatingTextStringOnCreature("Summoning Balors is not allowed in NO PVP areas", OBJECT_SELF);
      return;
   }*/
    //Declare major variables
   int nCasterLevel = nPureLevel;
   int nDuration = nPureLevel*2;

   effect eSummon;
   effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);

   if (GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL)
    || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL)
    || GetHasSpellEffect(SPELL_HOLY_AURA)
    || !GetIsPC(OBJECT_SELF)) {
      eSummon = EffectSummonCreature(ExtendGate(nPureLevel), VFX_FNF_SUMMON_GATE, 3.0);
      location oLoc = GetSpellTargetLocation();
      DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, oLoc, RoundsToSeconds(nDuration)));
      DelayCommand(4.0, ApplyHaste(OBJECT_SELF));

      // SetLocalObject(OBJECT_SELF, "Balor", GetObjectByTag(ExtendGate(nPureLevel)));
      // DelayCommand(RoundsToSeconds(nDuration), DeleteLocalObject(OBJECT_SELF, "Balor"));
   } else {
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(OBJECT_SELF));
      DelayCommand(3.0, CreateBalor(OBJECT_SELF));
   }
}
